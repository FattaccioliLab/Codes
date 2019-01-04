import os, skimage
import matplotlib as matplt
import numpy as np
import matplotlib.pyplot as plt
 

from skimage import io
from scipy import ndimage
from scipy import misc
from numpy import *


##Importer les images

os.getcwd () # Donne le répertoire de travail
os.chdir("/Users/ClotildeVie/Documents/Images") # charge le répertoire # Ne pas oublier les guillemets


#Ouvrir une image en noir et blanc
image = io.imread('image.png', 'L')
plt.imshow(goutte5, cmap='gray')
plt.show()


#Ouvrir une image en couleur
image = io.imread('image.png')
plt.imshow(goutte0[: ,: ,:])
plt.show()

## Expérience 1

g11 = io.imread('g11.png', 'L')
g22 = io.imread('g22.png', 'L')
g33 = io.imread('g33.png', 'L')
g44 = io.imread('g44.png', 'L')
g55 = io.imread('g55.png', 'L')
g66 = io.imread('g66.png', 'L')
g77 = io.imread('g77.png', 'L')
g88 = io.imread('g88.png', 'L')


lg1=[g11, g22, g33, g44, g55, g66, g77, g88]


##Expérience 2

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


##Expérience 3

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



##Expérience 4

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


##Expérience 5

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


## Calcul de la luminance


def luminancecouleur(image):
    (u,v,w)=image.shape
    S=0
    m=0
    for p in range(0,u):
        for q in range(0,v):
            if image[p,q]!= 0.0 :
                m+=(image[p,q][0]+image[p,q][1]+image[p,q][2])/3
                S+=1
    return m/S
    
    


def luminance(image):
    (u,v)=image.shape
    S=u*v
    l=0
    for p in range (0,u):
        for q in range(0,v):
            if image[p,q]!=0.0 :
                l+=image[p,q]
    return l/S



def listeluminance(liste):
    h=[]
    for p in range (0,len(liste)):
        h.append(luminance(liste[p])*255)  
    return h



def absorbance(liste):
    h=[]
    i0=140
    for p in range (0,len(liste)):
        h.append(10*log10(i0/liste[p]))  
    return h


## Correction de l'erreur

    
def luminancebis(image):
    (u,v)=image.shape
    S=0
    l=0
    for p in range (0,u):
        for q in range(0,v):
            if image[p,q]!=0.0 :
                l+=image[p,q]
                S+=1
    return l/S
    
    
def listeluminance(liste):
    h=[]
    for p in range (0,len(liste)):
        h.append(luminancebis(liste[p])*255)  
    return h

    
def absorbancebis(liste):
    h=[]
    i0=190
    for p in range (0,len(liste)):
        h.append(10*log10(i0/liste[p]))  
    return h
   


## Tracé des courbes

temps=[]


plt.plot(tps,A, label="ordre0")

plt.plot(tps,log(A), label="ordre1")

plt.plot(tps,o2(A), label="ordre2")

plt.legend()
plt.show()
