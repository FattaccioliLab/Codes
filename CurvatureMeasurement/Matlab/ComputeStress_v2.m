clear all;
close all;

%% Définition des dimensions utilisées pour améliorer l'aspect des figures
% affichées et sauvegardées
width = 6;     % Width in inches
height = 3;    % Height in inches
alw = 2;    % AxesLineWidth
fsz = 18;      % Fontsize
lw = 2;      % LineWidth
msz = 8;       % MarkerSize

%%Demande si les figures produites seront sauvegardées
prompt = 'Voulez-vous sauvegarder les figures? Y/N [N]: ';
str = input(prompt,'s');
if isempty(str)
    str = 'N';
end

%% Importation de la liste des données et des coordonées des barycentres
path='./Image_18-4_ROI_Coordinates/';
a=strcat(path,'Timeframe1.txt')
Resting=importdata(strcat(path,'Timeframe1.txt'),'\t',1);
Deformed=importdata(strcat(path,'Timeframe3.txt'),'\t',1);

%% Suppression des bords
lengt=size(Resting.data,1);
Resting.data(1,:)=Resting.data(2,:);
Resting.data(lengt,:)=Resting.data(lengt-1,:);
Deformed.data(1,:)=Deformed.data(2,:);
Deformed.data(lengt,:)=Deformed.data(lengt-1,:);

%% Tension interfaciale (N/m)
g=0.008; %N/m

%% Calcul du stress
Cr=Resting.data(:,3)*1e6;
Rr=Resting.data(:,4);
Cd=Deformed.data(:,3)*1e6;
Rd=Deformed.data(:,4);
sigma=g*(Cd-Cr);%En Pa = N/m^2
sigma_red=sigma*1e9/1e12; %pN/um^2

%Calcul de la barre des graphes de courbure
ca = [0 30];
cb = [-1 1];
cd=[-1000 1000];

%Représnetation du stress
thetad=Deformed.data(:,1);
rd=Deformed.data(:,2);
[Xd,Yd] = pol2cart(thetad,rd);
Ydmin=abs(min(Yd));

thetar=Resting.data(:,1);
rr=Resting.data(:,2);
[Xr,Yr] = pol2cart(thetar,rr);
Yrmin=abs(min(Yr));

%% Tracé des figures

%Tracé du profil de la goutte au repos. Intensité =  rayon de courbure
figure(1);
scatter(Xr,Yr,20,Rr);
%scatter(Xr,Yr+Yrmin,20,Rr);
xlabel('x (\mu m)');
ylabel('y (\mu m)');
ylim(gca,[-10 10]);
title('Resting Droplet - Radius of curvature');
caxis(ca);
cc = colorbar;
colormap jet;
cc.Label.String = 'Radius of Curvature (\mu m)';
cc.Label.FontSize = 24;
improve_display(gcf,gca,width,height,alw,fsz,lw,msz)
if str=='Y'
    improve_printing(gcf,width,height)
    print('ShapeResting-Polar','-dpng','-r300');
    print('ShapeResting-Polar','-depsc');
else
end

%Tracé du profil de la goutte sous contrainte. Intensité =  rayon de courbure
figure(2);
scatter(Xd,Yd,20,Rd);
%scatter(Xd,Yd+Ydmin,20,Rd);
xlabel('x (um)');
ylabel('y (um)');
ylim(gca,[-10 10]);
title('Deformed Droplet');
caxis(ca);
cc = colorbar;
colormap jet;
cc.Label.String = 'Radius of Curvature (\mu m)';
cc.Label.FontSize = 24;
improve_display(gcf,gca,width,height,alw,fsz,lw,msz)
if str=='Y'
    improve_printing(gcf,2*width,height)
    print('ShapeConstrained-Polar','-dpng','-r300');
    print('ShapeConstrained-Polar','-depsc');
else
end


figure(3);
plot(thetad,Rr,thetad,Rd,'LineWidth',1.5)
ax = gca;
% xlim(gca,[0,pi]);
% ax.XTick = [0,pi/4,pi/2,3*pi/4,pi];
% ax.XTickLabel = {'0','\pi/4','\pi/2','3\pi/4','\pi'};
xlim(gca,[0,2*pi]);
ax.XTick = [0,pi/2,pi,3*pi/2,2*pi];
ax.XTickLabel = {'0','\pi/2','\pi','3\pi /2','2\pi'};
%title('Rayon de courbure');
xlabel('\theta (rad)');
ylabel('Radius of curvature (\mu m)');
legend('Resting','Under constraint');
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gcf, 'Color', [1 1 1]);
set(gca,'XMinorTick','on','YMinorTick','on', 'TickLength',[0.0150 0.030]);
set(gca, 'FontSize', fsz, 'LineWidth', alw);

if str=='Y'
    improve_printing(gcf,width,height)
    print('RadiusCurvature-Polar','-dpng','-r300');
    print('RadiusCurvature-Polar','-depsc');
else
end

figure(4);
semilogy(thetad,Cr*1e-6,thetad,Cd*1e-6,'LineWidth',1.5)
ax = gca;
% xlim(gca,[0,pi]);
% ax.XTick = [0,pi/4,pi/2,3*pi/4,pi];
% ax.XTickLabel = {'0','\pi/4','\pi/2','3\pi/4','\pi'};
xlim(gca,[0,2*pi]);
ax.XTick = [0,pi/2,pi,3*pi/2,2*pi];
ax.XTickLabel = {'0','\pi/2','\pi','3\pi /2','2\pi'};
%title('Courbure');
xlabel('\theta (rad)');
ylabel('Curvature (\mu m-1)');
legend('Resting','Under constraint');
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gcf, 'Color', [1 1 1]);
set(gca,'XMinorTick','on','YMinorTick','on', 'TickLength',[0.0150 0.030]);
set(gca, 'FontSize', fsz, 'LineWidth', alw);
if str=='Y'
    improve_printing(gcf,width,height)
    print('Curvature-Polar','-dpng','-r300');
    print('Curvature-Polar','-depsc');
else
end


figure(5);
plot(thetad,sigma,'LineWidth',1.5)
ax = gca;
% xlim(gca,[0,pi]);
% ax.XTick = [0,pi/4,pi/2,3*pi/4,pi];
% ax.XTickLabel = {'0','\pi/4','\pi/2','3\pi/4','\pi'};
xlim(gca,[0,2*pi]);
ax.XTick = [0,pi/2,pi,3*pi/2,2*pi];
ax.XTickLabel = {'0','\pi/2','\pi','3\pi /2','2\pi'};
%title('Rayon de courbure');
xlabel('\theta (rad)');
ylabel('Stress (Pa ou pN.\mu m^{-2})');
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gcf, 'Color', [1 1 1]);
set(gca,'XMinorTick','on','YMinorTick','on', 'TickLength',[0.0150 0.030]);
set(gca, 'FontSize', fsz, 'LineWidth', alw);

if str=='Y'
    improve_printing(gcf,width,height)
    print('RadiusCurvature-Polar','-dpng','-r300');
    print('RadiusCurvature-Polar','-depsc');
else
end

figure(6);
scatter(Xd,Yd,20,sigma);
%scatter(Xd,Yd+Ydmin,20,Rd);
xlabel('x (um)');
ylabel('y (um)');
ylim(gca,[-10 10]);
%title('Deformed Droplet');
caxis(cd);
cc = colorbar;
colormap jet;
cc.Label.String = 'Stress (Pa)';
cc.Label.FontSize = 24;
improve_display(gcf,gca,width,height,alw,fsz,lw,msz)
if str=='Y'
    improve_printing(gcf,width,height)
    print('ShapeConstrained-Polar','-dpng','-r300');
    print('ShapeConstrained-Polar','-depsc');
else
end

%% Calcul de la courbure et du stress avec les barres d'erreur à partir d'une selection sur la dernière figure
% Calcul la moyenne et la représente avec l'ecart-type
% h = imrect;
% posi=getPosition(h)
% A=(thetad>posi(1)) & (thetad<posi(1)+posi(3));
% ss=mean(sigma(A));
% str=strcat('Stress : ', num2str(ss), ' pN/m2');
% msgbox(str)
% 


