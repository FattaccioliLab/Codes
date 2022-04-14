# -*- coding: utf-8 -*-

from math import *
from scipy import *
from pylab import *
from scipy.interpolate import interp1d
from scipy import interpolate
import pandas as pd

import scipy
import scipy.ndimage
import matplotlib.pyplot as plt
import numpy as np


pi=np.pi
#Importer les fichiers .txt. Il faut que les fichiers soient dans le même dossier que le .py
#coordinates=np.loadtxt('/Users/Lea/Desktop/Image19-3-Coordinates/Coordinates_simple.txt')
coordinates=np.loadtxt('/Users/Lea/Documents/Expériences Thèse/18-06-05 Videomicroscope ROUND #1/Olivier-Lignees-molles/Films-Gouttes molles-Lignées/Deformation Sans rotation et echelle/Coordinates.txt')
data = np.arange(0,26)

files = list()
for n in data :
    #np.loadtxt('/Users/Lea/Documents/Expériences Thèse/19-02-06 Confocal Lorraine - M:D:B/Meeting B cells-Droplets/Série007-Suite série006/Test007-zstack/Série007-Droplets-ROI'+str(i)+'.txt')
    files.append(np.loadtxt('/Users/Lea/Documents/Expériences Thèse/18-06-05 Videomicroscope ROUND #1/Olivier-Lignees-molles/Films-Gouttes molles-Lignées/Deformation Sans rotation et echelle/Slice'+str(n)+'.txt'))
    

#Définitions des paramètres
theta_ref = np.arange(0,2*pi,0.001)

#Routine de traitement des données

for i in data :
    #Coordonnées centrées autour du centroïde
    x=files[i][:,0]-coordinates[i,1]
    y=-(files[i][:,1]-coordinates[i,2])
    
    #Lissage de la gourbe par un filtre fft
    xf = np.fft.fft(x)
    yf= np.fft.fft(y)
    p = 11; # Fréquence ‡ partir de laquelle on supprimer les harmoniques
    
    # Enlever les hautes Fréquences en remplacant les données entre
    # p et 2500-p par 0 = filtre passe-bas
    data2 = np.arange(p,len(xf)-p)
    xf[data2] = 0 
    yf[data2] = 0

    #Faire une FFT inverse et réelle
    xs=real(np.fft.ifft(xf))
    ys=real(np.fft.ifft(yf))
    
    plt.figure()
    plt.plot(xs, ys, 'ro', x, y, 'k+')
    plt.axis('equal')
    plt.show()
    
    #Création d'un tableau alliant xs et ys
    xy = np.append([xs], [ys], axis=0)
    xy = xy.transpose()
    
    #Coordonnées polaires : permutation circulaire pour avoir \theta=0 - Prend comme début le point x=0 et y<0 qui correspond à theta=-pi/2
    # -> Création d'un nouveau tableau dans lequel on enlève toutes les valeurs de xs négatives
    condlist =[xy[:,0]>0]
    choicelist = [xy[:,0]]
    xy2 = np.select(condlist, choicelist)
    xy2 = np.append([xy2], [ys], axis=0)
    xy2 = xy2.transpose()
    xy2 = xy2[np.all(xy2 != 0, axis=1)]
    # -> Trouver les coordonnées du point ayant le ys minimum
    ysmin = min(abs(xy2[:,1])) #ou np.amin(xy2[:,1])
    
    #Vérifier que ysmin est positif ou négatif
    if ysmin in xy:
        Y=ysmin
    else:
        Y=-ysmin
        print(Y)
        
    index = (xy[:,1]==Y).nonzero()
    conversion=int(index[0][0])

    #Faire un shift circulaire
    xyshift = np.roll(xy, -conversion-1,  axis=0)
    
    #Calcul de la courbure
    #Problème aux extrémités à cause de l'utilisation des gradients
    dx = np.gradient(xyshift[:,0])
    dy = np.gradient(xyshift[:,1])
    ddx = np.gradient(dx)
    ddy = np.gradient(dy)
    
    #Calcul de la courbure en coordonnées cartésiennes
    k = (ddy * dx - ddx * dy) / ((dx**2 + dy**2)**(3/2))
    #Calcul de la courbure en coordonnées normalisées
    kn=(ddy * dx - ddx * dy) / ((dx**2 + dy**2)**(3/2)) * sum((dx**2 + dy**2)**(1/2))
    #Calcul du rayon de courbure
    R = 1/k
    
    #Conversion en coordonnées polaires
    xs,ys = xyshift[:,0], xyshift[:,1]
    theta = np.arctan2(ys, xs)    
    theta[theta <= 0]=theta[theta <= 0]+2*np.pi
    r = np.sqrt(xs**2 + ys**2)
    print(theta)
    print(r)
    
    #Calcul des valeurs interpolées sur une abscisse angulaire commune theta_ref
    #Cubique
    r_i=interp1d(theta,r, kind='cubic', bounds_error=False)
    k_i=interp1d(theta,k, kind='cubic', bounds_error=False)
    R_i=interp1d(theta,R, kind='cubic', bounds_error=False)
    
    R_2=-R_i(theta_ref)
    r_2=r_i(theta_ref)
    k_2=-k_i(theta_ref)
    
    #Les plots !
    plt.figure(figsize=(10, 6))
    plt.subplots_adjust(hspace=0.5, wspace=0.5)
    
    plt.subplot(221)
    plt.plot(x, y, 'r')
    plt.axis('equal')
    plt.title('Coordonnées de la goutte')
    
    #Interpolation du rayon de courbure en heat map
    plt.subplot(222, projection='polar')
    plt.scatter(theta_ref, r_2, s=1, c=R_2, cmap='jet')
    cmb = plt.colorbar(fraction=0.05, pad=0.1)
    cmb.set_label("Rayon de courbure (µm)")
    plt.xlabel('x (µm)')
    plt.clim(6,9)
    #plt.text(0.5, 1.3, 'Interpolation des coordonées de la goutte',
         #horizontalalignment='center', #or ha
         #fontsize=10,
         #transform = plt.subplot(222).transAxes)
    plt.text(-0.25, 0.5, 'y (µm)',
             horizontalalignment='center',
         verticalalignment='center', #or va
         rotation='vertical',
         fontsize=10,
         transform = plt.subplot(222).transAxes)
    
    plt.subplot(223)
    plt.plot(theta_ref, R_2)
    plt.xticks([0, pi/2, pi, 3*pi/2, 2*pi],
           [r'$0$', r'$\pi/2$', r'$\pi$', r'$3\pi/2$', r'$2\pi$'])
    plt.ylabel('Rayon de courbure (µm)')

    plt.subplot(224)
    plt.plot(theta_ref, k_2)
    plt.xticks([0, pi/2, pi, 3*pi/2, 2*pi],
           [r'$0$', r'$\pi/2$', r'$\pi$', r'$3\pi/2$', r'$2\pi$'])
    plt.ylabel('Courbure (µm-1)')
    
    plt.tight_layout()
    
    #Sauvegarde des données
    plt.savefig('Data'+str(i)+'.png')
    
    max(R_2)

