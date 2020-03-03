# Emulsion droplets fluorescence and size analysis with Fiji/ImageJ and R/Python

Fiji/ImageJ and R macros used for the analysis of the emulsion size distribution and surface fluorescence quantitation.
In this directory, you have several files : 
* DropletsFluorescenceSize.ijm : Fiji/ImageJ macro
* DataAnalysisWithR.r : R script for the size and fluorescence analysis
* TestSample.tif : A TIFF stack of fluorescent droplets
* TestSample.txt : A txt file with the features and measurements obtained using the macro DropletsFluorescenceSize.ijm

Instructions of use : 

## Fiji/ImageJ for Image Analysis

1. Gather all your TIFF stacks in the same folder. The folder should not contain any .tif or .txt file before using the procedure.
2. Open Fiji/ImageJ
3. Drag and Drop the file DropletsFluorescenceSize.ijm on the Fiji/ImageJ taskbar
4. Press run
5. Choose the directory containing the TIFF stacks
6. The macro will process all the files one by one, in batch mode for efficiency and speed. If you want to see what the macro is doing, please replace "setBatchMode(true);" by "setBatchMode(False);" in the .ijm file.
7. For each TIFF stack, a .txt file with the extracted features is generated. The measurements are the following : 
- area
- mean 
- standard 
- min 
- fit ellipse
- feret's diameter
- integrated density

## Data analysis with R

0. Prior to the analysis, please make sure that RStudio is installed on your computer, with the packages visible in the header of the script installed.
1. Modify and run the script DataAnalysisWithR.r
