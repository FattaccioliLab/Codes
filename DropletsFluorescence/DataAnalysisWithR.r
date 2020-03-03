rm(list=ls(all=TRUE))

#1------------------------------------
#Chargement des librairies
#Pour une raison que j'ignore, la plupart sont à cocher manuellemenent dans "Packages"
library(ggplot2)
library(scales) 
library(cowplot)
library(rstudioapi)
library(MASS) 
library(plyr)
library(sm)

#Définition d'un thème graphique
theme_jacques<-theme(
  plot.title=element_text(size=13, 
                          face="bold", 
                          family="Arial",
                          hjust=0.5,
                          lineheight=1.2),
  panel.grid.major = element_blank(), 
  panel.grid.minor = element_blank(), 
  panel.border = element_blank(),
  panel.background = element_blank(),
  axis.text.x=element_text(size=12, color='black'),
  axis.text.y=element_text(size=12, color='black'),
  axis.title.x=element_text(size=12), 
  axis.title.y=element_text(size=12),
  axis.line = element_line(color="black", size = 0.75), 
  legend.position = c(0.2, 0.8),
  legend.title=element_blank()
)

#Définition des fonctions locales
#################################

#Entrer des valeurs min et max pour enlever les extrema
cutoff_lo <-  3
cutoff_hi <-  8

#Normalisation des colonnes d'intensité par rapport à une exposition de 100 ms
Normalise <- function (data, liste_colonnes, exposure) { 
  for (colonne in liste_colonnes){
    data[, colonne] <- 100*data[, colonne]/data[, "ExposureTime"]
  }
  return(data)
}

#Récupère le chemin d'accès
path <- rstudioapi::getActiveDocumentContext()$path
Encoding(path) <- "UTF-8"
setwd(dirname(path))

#Crée une liste avec tous les fichiers .txt exportés par ImageJ
file_list <- as.vector(t(read.table("FileList.txt", header=F, sep="\n")));


#Liste des conditions expérimentales : equivalents, etc.
#L'ordre dans la liste doit être mis en accord avec file_list car
#rien ne dit que l'OS classe dans le bon ordre les fichiers txt
conditions <- c("10","5","2.5","2")
exposure <-c(100, 100, 100, 100)
colonnes <- c("Mean", "Min", "Max", "IntDen", "Median", "RawIntDen", "SurfaceDensity")

#Crée un dataframe à partir de tous les fichiers .txt
#Rajouter une colonne avec la condition expérimentale
for (file in file_list){

  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.table(file, header=TRUE, sep="\t")
    index <- match(file, file_list)
    dataset$SurfaceDensity=dataset$IntDen/dataset$Area
    dataset$Condition=conditions[index]
    dataset$ExposureTime=exposure[index]
    dataset=Normalise(dataset, colonnes)
    
  }
  
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.table(file, header=TRUE, sep="\t")
    index <- match(file, file_list)
    temp_dataset$SurfaceDensity=temp_dataset$IntDen/temp_dataset$Area
    temp_dataset$Condition=conditions[index]
    temp_dataset$ExposureTime=exposure[index]
    temp_dataset=Normalise(temp_dataset, colonnes)
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
}

#Normalise les colonnes par rapport à leur valeur maximale
#2------------------------------------




dataset = subset(dataset, dataset$Feret>cutoff_lo & dataset$Feret<cutoff_hi)

#Comparaison des distributions de taille (Feret) pour chaque condition expérimental
#Calcul de la moyenne, de l'écart-type et de la SD (en nombre)
#Dans le futur, un test statistique pourrait être implémenté pour quantifier l'ecart ou
#la proximité entre les distributions


ggplot(dataset, aes(Feret, fill = Condition)) + 
  geom_histogram(alpha = 0.5, aes(y = ..density..), position = 'identity') +
  theme_jacques +
  labs(x = "Density", y = "Feret diameter (µm)")

ggsave("Comparaison_SizeDistribution.png", width = 8, height = 6, units = "cm")

#Sauvegarde des données sur la distribution de taille par condition
dataset_stats<-ddply(dataset, .(Condition), summarize, mean=mean(Feret), sd=sd(Feret), cv=sd(Feret)/mean(Feret)*100, N=length(Feret))
dataset_stats <- sapply( dataset_stats, as.numeric )
write.table(dataset_stats, "SizeDistribution.csv", sep="\t", col.names = NA)

#Binning des données et construction d'une nouvelle matrice avec comme dernière colonne le numéro de binning
dataset$Condition=sapply(dataset$Condition, as.numeric)
dataset <- transform(dataset, bin = cut(dataset$Feret, 10, labels=F))

#3------------------------------------

#Tracé des courbes IntDen=f(Area) et IntDen=f(Feret)
p1 <- ggplot(data=dataset, aes(dataset$Area, dataset$IntDen)) +
  geom_point(alpha = 0.5, aes(color=factor(Condition))) + theme_jacques +
  scale_x_continuous (limits = c(0, 60)) +
  scale_y_continuous (limits = c(0, 3e5)) +
  labs(x = "Area (µm2)", y = "Integrated Fluorescence (a.u.)")

p2 <- ggplot(data=dataset, aes(dataset$Feret, dataset$IntDen)) +
  geom_point(alpha = 0.5, aes(color=factor(Condition))) + theme_jacques +
  scale_x_continuous (limits = c(0, 10)) +
  scale_y_continuous (limits = c(0, 3e5)) +
  labs(x = "Feret diameter (µm)", y = "Integrated Fluorescence (a.u.)")

plot_grid(p1, p2, labels = c("A", "B"))
ggsave("Comparaison_AreaDiameter.png", width = 16, height = 6, units = "cm")


#4------------------------------------
#Tracé des mêmes courbes que ci-dessus, mais avec les valeurs moyennes et sd
red_dataset=ddply(dataset, .(Condition, bin), summarize, mSize=mean(Feret), sdSize=sd(Feret), mFluo=mean(IntDen), sdFluo=sd(IntDen), mMax=mean(Max), sdMax=sd(Max))

#Tracé des courbes MaxInt=f(Area) et MaxInt=f(Feret)
p1 <- ggplot(data=red_dataset, aes(red_dataset$mSize, red_dataset$mFluo)) +
  geom_point(alpha = 0.5, aes(color=factor(Condition))) + theme_jacques +
  scale_x_continuous (limits = c(0, 10)) +
  scale_y_continuous (limits = c(0, 3e5)) +
  geom_smooth(method="nls", 
              formula=y~a*(x-b)^2, # this is an nls argument
              method.args = list(start=c(a=1000,b=1)), # this too
              se=FALSE, inherit.aes = TRUE, fullrange = TRUE) +
  labs(x = "Diameter (m)", y = "Integrated Fluorescence (a.u.)")

p2 <- ggplot(data=red_dataset, aes(red_dataset$mSize, red_dataset$mMax)) +
  geom_point(alpha = 0.5, aes(color=factor(Condition))) + theme_jacques +
  scale_x_continuous (limits = c(0, 10)) +
  scale_y_continuous (limits = c(0, 7000)) +
  geom_smooth(method="nls", 
              formula=y~a*sqrt(x)+b, # this is an nls argument
              method.args = list(start=c(a=1,b=1000)), # this too
              se=FALSE, inherit.aes = TRUE, fullrange = TRUE) +
  labs(x = "Diameter (µm)", y = "Maximum Fluorescence (a.u.)")

plot_grid(p1, p2, labels = c("A", "B"))
ggsave("Comparaison_AreaDiameter.png", width = 16, height = 6, units = "cm")
write.table(red_dataset, "ValeursMoyennes.csv", sep="\t", col.names = NA)

#5------------------------------------

#Choix de la population la plus proche de la moyenne en taille
#Le choix est manuel ! Il faut regarder dans la variable "dataset" quel bin prendre !
#Calcul de la moyenne/sd de la taille et la fluorescence pour chaque condition
sub_dataset = subset(dataset, bin==4)
sub_dataset_stats=ddply(sub_dataset, .(Condition), summarize, meanSize=mean(Feret), sdSize=sd(Feret), meanFluo=mean(IntDen), sdFluo=sd(IntDen), meanDensity=mean(SurfaceDensity), sdDensity=sd(SurfaceDensity))


p3 <- ggplot(data=sub_dataset_stats, aes(sub_dataset_stats$Condition, sub_dataset_stats$meanDensity)) +
  geom_point() + 
  geom_errorbar(aes(ymin=sub_dataset_stats$meanDensity-sub_dataset_stats$sdDensity, ymax=sub_dataset_stats$meanDensity+sub_dataset_stats$sdDensity), width=.2, position=position_dodge(.9)) +
  geom_smooth(method="nls", 
             formula=y~Vmax*(1-exp(-x/tau)), # this is an nls argument
             method.args = list(start=c(tau=1,Vmax=1000)), # this too
             se=FALSE, inherit.aes = TRUE, fullrange = TRUE) +
  theme_jacques +
  scale_x_continuous (limits = c(0, 12)) +
  labs(x = "DMSO Volumic ratio (%)", y = " Fluorescence (a.u.)")
plot(p3)
ggsave("VariationDMSO.png", width = 8, height = 6, units = "cm")
write.table(sub_dataset_stats, "DMSO_Summary.csv", sep="\t", col.names = NA)







