% Script de calcul de la courbue analytique de profils obtenus sous
% ImageJ/Fiji avec les E-snake

% Pour faire tourner le script il faut :
% 1- le fichier Dataset.txt qui donne les nom des multiples fichiers avec
% les profils (ici leur nom est Ch2-X.txt)
% 2- le fichier Coordinates.txt qui donne pour chaque goutte les coordon�es
% de son centre de gravit�
% 3- Les fichiers de donn�es

clear all;
close all;


%% Importation de la liste des donn�es et des coordon�es des barycentres
path='./Image_18-4_ROI_Coordinates/';
Dataset=importfile2(strcat(path,'Datasets.txt'));
xy_0=importparameter2(strcat(path,'Coordinates.txt'));

%% D�finition des variables
theta_ref=[0:0.001:2*pi]';
ca = [0 35];

%% Routine de traitement des donn�es
for i=1:1:length(Dataset)
    i
    clearvars x y xs ys xy xy2 T M I II;
    filename=char(Dataset(i));
    data=importdata2(strcat(path,filename));
    %Soustration de l'origine et correction optique en z
    x=data(:,1)-xy_0(i,1);%-xy_0(length(xy_0),1);
    y=data(:,2)-xy_0(i,2);%-xy_0(length(xy_0),2); %*(1.33/1.51); %Corection inutile si en xy;

    %% Lissage de la gourbe par un filtre fft
    xf=fft(x);
    yf=fft(y);
    p = 11; % Fr�quence � partir de laquelle on supprimer les harmoniques

    xf(p:end-(p-1)) = 0; %original : xf(11:end-10)
    yf(p:end-(p-1)) = 0; %original : yf(11:end-10)
    xs=real(ifft(xf));
    ys=real(ifft(yf));

    %% Changement de coordonn�es par rapport au barycentre de la derni�re goutte
    %A utiliser dans le cas ou il y a du mouvement
    xy(:,1)=xs;
    xy(:,2)=ys;

    %% Coordon�es polaires : permutation circulaire pour avoir \theta=0
    %prend comme d�but le point x=0 et y<0 qui correspond � theta=-pi/2
    a = find(xy(:,1)>=0);
    [M,I] = min(abs(xy(a,2)));
    xy2=circshift(xy,-a(I)+1);

%     for p=1:300:length(xy2)
%         hold on
%         plot(xy2(p,1),xy2(p,2),'r*')
%         hold off
%     end


    %% Calcul de la courbure
    % Probl�me aux extr�mit�s � cause de l'utilisation des gradients.
    % R�gler le probl�me en cr�ant une matrice interm�diaire et en la
    % d�coupant
    dx = gradient(xy2(:,1));%gradient(xs);
    dy = gradient(xy2(:,2));%gradient(ys);
    ddx = gradient(dx);
    ddy = gradient(dy);
    %Calcul de la courbure en coordon�es cart�siennes
    k = (ddy.*dx - ddx.*dy) ./ ((dx.^2 + dy.^2).^(3/2));
    %Courbure normalis�e
        %kn=(ddy.*dx - ddx.*dy) ./ ((dx.^2 + dy.^2).^(3/2)) *sum((dx.^2 + dy.^2).^(1/2));
    %Calcul du rayon de courbure
    R = 1./k;

    %% Conversion en coordonn�e polaires
    [theta,r] = cart2pol(xy2(:,1),xy2(:,2));



    theta(theta<=0)=theta(theta<=0)+2*pi;
    if theta(1)>1
        theta(1)=0;
    end
    theta180=180*theta/pi;


    %% Calcul des valeurs interpol�es sur une abscisse angulaire commune theta_ref
    r_i=spline(theta,r,theta_ref);
    k_i=spline(theta,k,theta_ref);
    R_i=spline(theta,R,theta_ref);



    figure(i);
    title(strcat('Timeframe',num2str(i)));
    subplot(2,2,1);
        plot(x,y,'r-')
        hold on
        scatter(xy2(:,1),xy2(:,2),20,R);
        %plot(xy2(:,1),xy2(:,2),'k-');
        hold off
        %title(strcat('Timeframe',num2str(i)));
        xlabel('x (um)');
        ylabel('y (um)');
        axis equal
        caxis(ca);
        c = colorbar;
        colormap jet;
        c.Label.String = 'Rayon Courbure (\mu m)';
        c.Label.FontSize = 12;
        %set(c,'YScale','log')

    subplot(2,2,2);
        polar(theta,r);
        hold on
        polar(theta_ref,r_i);
        hold off
        %title(strcat('Timeframe',num2str(i)));
        xlabel('theta (degree)');
        ylabel('r (um)');
        axis equal;

    subplot(2,2,3);
        plot(theta_ref,R_i);
        xlabel('theta (rad)');
        ylabel('R (um)');
        ax = gca;
        ax.XTick = [0,pi/2,pi,3*pi/2,2*pi];
        ax.XLim = [0 2*pi];
        ax.XTickLabel = {'0','\pi/2','\pi','3\pi /2','2\pi'};
        ylim auto

    subplot(2,2,4);
        plot(theta_ref,k_i);
        xlabel('theta (rad)');
        ylabel('\kappa (um^-1)');
        ax = gca;
        ax.XTick = [0,pi/2,pi,3*pi/2,2*pi];
        ax.XLim = [0 2*pi];
        ax.XTickLabel = {'0','\pi/2','\pi','3\pi /2','2\pi'};
        ylim auto

    %% Sauvegarde des donn�es
    fileName = strcat(path,'Timeframe',num2str(i),'.txt');   % file to create/write to
    fid = fopen(fileName,'w+');           % open file for writing
    fprintf(fid,'angle (rad)\tr (microns)\tCourbure (um^-1)\t Rayon de courbure (um)\r\n');    % add headings
    fclose(fid);            % ALWAYS CLOSE THE FILE!
    dlmwrite(fileName,[theta_ref r_i k_i R_i],'-append','delimiter','\t');

end
