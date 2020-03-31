clear all
close all
clc

lambda=488;
mr=1.475;
mi=0.0;
h2o=1.32;
m=(mr+mi*i)/h2o;   
k=2.0*pi*h2o/lambda;



%class=[0:1:1024];
absci=[270:20:2650]; 
absci2=[250:40:2610];
sa=size(absci);

mesure=textread('manipe.txt');
theory=textread('manipe_theory.txt');

    theory(:,1)=theory(:,1)*1;  %FSH 0.8
    theory(:,2)=theory(:,2)*0.97;  %SSH 0.80
    theory(:,3)=theory(:,3)*6.9; %FL 6.1
  
sm=size(mesure);

[fs_fit,S_fs,mu_fs]=polyfit(theory(:,4),theory(:,1),14);
fs_interp=polyval(fs_fit,absci,[],mu_fs);

[ss_fit,S_ss,mu_ss]=polyfit(theory(:,4),theory(:,2),3);
ss_interp=polyval(ss_fit,absci,[],mu_ss);

    figure
    plot(mesure(:,3),mesure(:,1),'g*','markersize',1)
    hold on
    plot(theory(:,3),theory(:,1),'r-')
    xlabel('FS')
    ylabel('FL')
    hold off



    figure
    plot(mesure(:,3),mesure(:,1),'g*','markersize',1)
    hold on
    plot(theory(:,3),fs_interp,'r-')
    xlabel('FS')
    ylabel('FL')
    plot(theory(:,3),theory(:,1),'-','markersize',5)
    hold off
    
    
    
%creation des vecteurs de calcul
%creation de la matrice de calcul : lignes : mesure / colonne : interpolation
%on calcule la distance entre chaque point de mesure et les points de l'interpolation

Xunity_m=ones(1,sa(2));
Xm=mesure(:,1); %mesure(1:10,1);

Xmes=Xm*Xunity_m;

Xunity_f=ones(sm(1),1); %ones(10,1);
Xf=fs_interp;

Xfit=Xunity_f*Xf;

DX=Xmes-Xfit;


Yunity_m=ones(1,sa(2));
Ym=mesure(:,2); %mesure(1:10,2);

Ymes=Ym*Yunity_m;

Yunity_f=ones(sm(1),1); %ones(10,1);
Yf=ss_interp;

Yfit=Yunity_f*Yf;

DY=Ymes-Yfit;


d=((DX).^2+(DY).^2).^0.5;
dmin=d.';
[A,I]=min(dmin);

%Construction de la nouvelle courbe
alpha=3.78e-7;
rayons=absci.';

fid=fopen('lisse2.txt','w+');

for i=1:sm(1)
    lisse(i,1)=fs_interp(I(i));
    lisse(i,2)=ss_interp(I(i));
    lisse(i,3)=rayons(I(i));
    lisse(i,4)=alpha*rayons(I(i))^3;
    fprintf(fid,'%g\t %g\t  %g\t %g\r',lisse(i,1),lisse(i,2),lisse(i,3),lisse(i,4));
end

fclose(fid);


figure
    plot(mesure(:,3),mesure(:,1),'g*','markersize',1)
    hold on
    %plot(theory(:,3),fs_interp,'r-')
    xlabel('FL')
    ylabel('FS')
    %plot(theory(:,3),theory(:,1),'-','markersize',5)
    plot(lisse(:,4),lisse(:,1),'m+','markersize',3)
    hold off
%figure
%plot(mesure(:,2),mesure(:,1),'b.','markersize',1)
%hold on
%plot(lisse(:,2),lisse(:,1),'r+','markersize',2)
%hold off

figure

subplot(2,1,1)
hist(lisse(:,3),50);
title('Histogramme des tailles ajusté')

ray_f=(mesure(:,3)/alpha).^(1/3);

subplot(2,1,2)
hist(ray_f,50);
title('Histogramme des tailles réel')
