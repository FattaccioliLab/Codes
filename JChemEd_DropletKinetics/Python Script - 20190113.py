### IMPORTATION OF THE LIBRARIES ###

import os, skimage
import matplotlib as matplt
import numpy as np
import matplotlib.pyplot as plt
 

from skimage import io
from scipy import ndimage
from scipy import misc
from numpy import *





### PICTURES IMPORTATION ###

os.getcwd ()
os.chdir("/Users/ClotildeVie/Documents/Images")



## Experience 1 : pictures importation

g11 = io.imread('g11.png', 'L')              # get each picture of droplets from the working directory
g22 = io.imread('g22.png', 'L')
g33 = io.imread('g33.png', 'L')
g44 = io.imread('g44.png', 'L')
g55 = io.imread('g55.png', 'L')
g66 = io.imread('g66.png', 'L')
g77 = io.imread('g77.png', 'L')
g88 = io.imread('g88.png', 'L')

lg1=[g11, g22, g33, g44, g55, g66, g77, g88]  # create a list with all the pictures of droplets from the first experience

                                              # do the same for the other experiences


## Experience 2 : pictures importation

g111 = io.imread('g111.png', 'L')
g222 = io.imread('g222.png', 'L')
g333 = io.imread('g333.png', 'L')
g444 = io.imread('g444.png', 'L')
g555 = io.imread('g555.png', 'L')
g666 = io.imread('g666.png', 'L')
g777 = io.imread('g777.png', 'L')
g888 = io.imread('g888.png', 'L')
g999 = io.imread('g999.png', 'L')

lg2=[g111, g222, g333, g444, g555, g666, g777, g888, g999]



## Experience 3 : pictures importation

g1111 = io.imread('g1111.png', 'L')
g2222 = io.imread('g2222.png', 'L')
g3333 = io.imread('g3333.png', 'L')
g4444 = io.imread('g4444.png', 'L')
g5555 = io.imread('g5555.png', 'L')
g6666 = io.imread('g6666.png', 'L')
g7777 = io.imread('g7777.png', 'L')
g8888 = io.imread('g8888.png', 'L')
g9999 = io.imread('g9999.png', 'L')

lg3=[g1111, g2222, g3333, g5555, g7777, g8888, g9999]



## Experience 4 : pictures importation

gg1 = io.imread('gg1.png', 'L')
gg2 = io.imread('gg2.png', 'L')
gg3 = io.imread('gg3.png', 'L')
gg4 = io.imread('gg4.png', 'L')
gg5 = io.imread('gg5.png', 'L')
gg6 = io.imread('gg6.png', 'L')
gg7 = io.imread('gg7.png', 'L')
gg8 = io.imread('gg8.png', 'L')
gg9 = io.imread('gg9.png', 'L')

lg4=[gg1, gg2, gg3, gg4, gg5, gg6, gg7, gg8, gg9]



## Experience 5 : pictures importation

gg11 = io.imread('gg11.png', 'L')
gg22 = io.imread('gg22.png', 'L')
gg33 = io.imread('gg33.png', 'L')
gg44 = io.imread('gg44.png', 'L')
gg55 = io.imread('gg55.png', 'L')
gg66 = io.imread('gg66.png', 'L')
gg77 = io.imread('gg77.png', 'L')
gg88 = io.imread('gg88.png', 'L')
gg99 = io.imread('gg99.png', 'L')

lg5=[gg11, gg22, gg33, gg44, gg55, gg66, gg77, gg88, gg99]





### CALCULATION OF THE LUMINANCE ###

    
def luminance(image):                 # Calculation of the luminance for a picture of droplet
    (u,v)=image.shape                 # Size of the image
    S=0                               # meter
    l=0                               # empty list
    for p in range (0,u):             # Get through the whole image :
        for q in range(0,v):          # if the pixel is not black, add +1 to the meter S and the value of the pixel to the list l
            if image[p,q]!=0.0 :
                l+=image[p,q]
                S+=1
    return l/S                        # return l/S, that is to say, the average of the pixel values assimilated to the luminance of the droplet



    
def listeluminance(liste):                      # Calculation of the luminance of each droplet for an experience
    h=[]                                        
    for p in range (0,len(liste)):              # for an experience, go through the list of droplets 
        h.append(luminance(liste[p])*255)       # and add to the list h, the value of the luminance of each droplet
    return h



    
def absorbance(liste):                          # Calculation of the absorbance of each droplet for an experience : 
    h=[]                                        
    i0=190                                      # Initialization of i0 (initialized using the value of a white pixel taken on the picture corresponding to the experience.)
    for p in range (0,len(liste)):              # Get through the liste of luminance 
        h.append(10*log10(i0/liste[p]))         # and calculate the absorbance which correspond (by analogy to the Beer-Lambert law.) 
    return h
   






### CURVES DRAWING ###


time=[]                                     # Create a list for time : X axis
for i in range (30,450,60):                 # have a picture of a droplet every minute for 7 to 8 minutes (depending on the experience)
    time.append(i)


plt.plot(time,A, label="order0")            # Draw the curves for each order : 0, 1 and 2.
                                            # A would be the list of absorbance for an certain experience
plt.plot(time,log(A), label="order1")

plt.plot(time,square(A), label="order2")    # the fonction square is writen below

plt.legend()
plt.show()




def square(liste) :                         # fonction to get the square of the values of a list.
    l=[]
    for i in range (0,len(liste)):
        l.append(liste[i]*liste[i])
    return l
        

