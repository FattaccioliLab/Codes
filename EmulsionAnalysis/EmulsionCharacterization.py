#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 29 22:09:10 2020

@author: jacques

"""

import math
import time
from pprint import pprint

import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy.stats as stat

# Loading packages to run the code
import skimage.io as skio
import skimage.measure as skmeas
from skimage import data
from skimage.color import label2rgb
from skimage.filters import threshold_otsu
from skimage.measure import label, regionprops
from skimage.morphology import closing, square
from skimage.segmentation import clear_border
from tifffile import TiffFile

# Sample parameters
filename = "Dataset_Fluorescence.tif"
thresh_area = 100
thresh_eccentricity = 0.3
measurements = pd.DataFrame()


def open_tiff(filename):
    # image_stack : nd.array
    image_stack = skio.imread(filename)  # , plugin="tifffile")
    # dimensions : tuple
    dimensions = (image_stack.shape[1], image_stack.shape[2])
    frames = image_stack.shape[0]

    return image_stack, dimensions, frames


def open_tiff_tags(filename):
    with TiffFile(filename) as tif:
        # Build a list of nparrays (1 np array = 1 frame)
        image_stack = [p.asarray() for p in tif.pages]
        frames = len(image_stack)
        # Extract the metadata embedded in the tiff file
        metadata = [p.tags for p in tif.pages]

        # Print the metadata dictionnary (optional : uncomment if needed)
        # for p_tagset in metadata:
        #     pprint({k: v.value for k,v in p_tagset.items()})
    return image_stack, metadata, frames


def analyse_single(image, metadata, min_area, max_eccentricity):
    """This function is doing the following steps :
    1. Perform Otsu thresholding
    2. Binarize the image according to the threshold value
    3. Close the holes in the particles
    4. Get rid of particles located on the edge of the image
    5. Labels the particles and measure their properties
    6. Show the results and export them in a panda dataframe"""

    # apply threshold (Otsu)
    threshold = threshold_otsu(image)

    # Closing the holes in the binarized particles
    binary = closing(image > threshold, square(3))

    # Remove artifacts connected to image border
    cleared = clear_border(binary)

    # label image regions
    label_image = label(cleared)

    # Export dataframe and sort on area and eccentricity thresholds
    props = skmeas.regionprops_table(
        label_image, image, properties=["label", "area", "eccentricity"]
    )
    data = pd.DataFrame(props)
    data = data[(data["area"] > min_area) & (data["eccentricity"] < max_eccentricity)]

    # Extract the pixel/um value from the metadata
    scalebar = metadata["XResolution"].value[0] / metadata["XResolution"].value[1]

    # Calculate the diameter and the volume, and add 2 columns to data
    data["diameter"] = np.sqrt(4 * data["area"] / math.pi) / scalebar

    return data, threshold, binary, cleared, props, label_image


def analysis(filename, min_area=100, max_eccentricity=0.2):
    plt.close("all")
    image_stack, metadata, frames = open_tiff_tags(filename)
    final_data = pd.DataFrame()

    display = (
        input(
            "Do you want to show the processed images \n [y] yes or [n] (Default : [n] \n"
        )
        or "n"
    )

    if display == "y":

        fig, axes = plt.subplots(
            ncols=2, nrows=3, figsize=(7, 10)
        )
        ax = axes.ravel()
        fig.tight_layout()
        fig.subplots_adjust(wspace = 0.5,bottom = 0.1, top = 0.85)
        # plt.imshow(binary[1], cmap='gray')
        # plt.tight_layout()

        for frame in range(frames):

            ax[0] = plt.subplot(3, 2, 1)
            ax[1] = plt.subplot(3, 2, 2)
            ax[2] = plt.subplot(3, 2, 3)
            ax[3] = plt.subplot(3, 2, 4)
            ax[4] = plt.subplot(3, 2, 5)
            ax[5] = plt.subplot(3, 2, 6)
            
            data, threshold, binary, cleared, props, label_image = analyse_single(
                image_stack[frame], metadata[frame], min_area, max_eccentricity
            )
            

            plt.draw()
            
            #Add a column to the dataframe, with the frame number in the stack
            data["frame"] = frame

            final_data = pd.concat([final_data, data])
            # Show : original image, intensity histogram and Otsu threshold, binary image, original + selected objects.
            ax[0].imshow(image_stack[frame], cmap="gray")
            ax[0].set_title("Original")
            ax[0].axis("off")

            ax[1].hist(image_stack[frame].ravel(), bins=256, density=1)
            ax[1].set_title("Histogram")
            ax[1].axvline(threshold, color="r")
            ax[1].set_ylabel("Density")
            ax[1].set_xlabel("Intensity (a.u.)")

            ax[2].imshow(cleared, cmap="gray")
            ax[2].set_title("Thresholded")
            ax[2].axis("off")


            ax[3].imshow(image_stack[frame], cmap="gray")

            for region in regionprops(label_image):
                # take regions with large enough areas
                if region.area >= min_area and region.eccentricity < max_eccentricity:
                    # draw rectangle around segmented coins
                    minr, minc, maxr, maxc = region.bbox
                    rect = mpatches.Rectangle(
                        (minc, minr),
                        maxc - minc,
                        maxr - minr,
                        fill=False,
                        edgecolor="red",
                        linewidth=2,
                    )
                    ax[3].add_patch(rect)

            ax[3].set_axis_off()


            data.hist(column="diameter", ax=ax[4], density=1)
            data["diameter"].plot.kde(ax=ax[4])
            ax[4].set_ylabel("Density")
            ax[4].set_xlabel("Diameter (um)")
            
            ax[5].set_axis_off()

            plt.pause(0.02)
            print(frame, frames)
            if frame < (frames - 1):
                fig.clear()

        mean, var = stat.distributions.norm.fit(final_data["diameter"])
        x = np.linspace(0, max(final_data["diameter"]), 1000)
        fitted_data = stat.distributions.norm.pdf(x, mean, var)
        # Plot histogram with all data
        final_data.hist(column="diameter", density=1, bins=20)
        # final_data['area'].plot.kde()
        plt.plot(x, fitted_data, "r-")
        plt.ylabel("Density")
        plt.xlabel("Diameter (um)")
        title = (
        "Size distribution : <d> = "
        + str(round(mean, 2))
        + "$\mu$m - CV = "
        + str(round(100 * math.sqrt(var) / mean, 2))
        + "%"
        )
        plt.title(title)
        plt.grid(False)
        plt.axvline(mean, color="r")
        plt.savefig("SizeDistribution.jpg")
        plt.savefig("SizeDistribution.pdf")

    elif display == "n":
        fig = plt.figure()

        for frame in range(frames):

            data, threshold, binary, cleared, props, label_image = analyse_single(
                image_stack[frame], metadata[frame], min_area, max_eccentricity
            )
            data["frame"] = frame
            final_data = pd.concat([final_data, data])

            print(frame, frames)
            if frame < (frames - 1):
                fig.clear()

        mean, var = stat.distributions.norm.fit(final_data["diameter"])
        x = np.linspace(0, max(final_data["diameter"]), 1000)
        fitted_data = stat.distributions.norm.pdf(x, mean, var)
        # Plot histogram with all data
        final_data.hist(column="diameter", density=1, bins=20)
        # final_data['area'].plot.kde()
        plt.plot(x, fitted_data, "r-")
        plt.ylabel("Density")
        plt.xlabel("Diameter (um)")

        title = (
            "Size distribution : <d> = "
            + str(round(mean, 2))
            + "$\mu$m - CV = "
            + str(round(100 * math.sqrt(var) / mean, 2))
            + "%"
        )
        plt.title(title)
        plt.grid(b=None)
        plt.axvline(mean, color="r")
        plt.savefig("SizeDistribution.jpg")
        plt.savefig("SizeDistribution.pdf")

    else:
        print("Please re-evaluate the function and choose y or no")

    return final_data, mean, var


df, mean, var = analysis(filename)
