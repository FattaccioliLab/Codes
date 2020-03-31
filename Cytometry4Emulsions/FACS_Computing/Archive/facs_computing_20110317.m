%Ce code programme le signal exact de Mie dans un FACS
%Pour une distribution normale (moyenne,ecart-type)
%et rajoute un bruit en racine de la valeur obtenue


clear all
close all
clear global all
clc


global m xint
%close all


% calcul du signal mesur? en FACS

lambda=488;
mr=1.468; %1.47
mi=0.0;
h2o=1.337;
m=(mr+mi*i)/h2o;   
concentr=1; %en fluorophores dans l'huile



%Definition de la distribution
nombre_total=6000
%nombre_total=660;


NB=[1:10:nombre_total];
rayon=NB;%*5;
k=2.0*pi*h2o/lambda;
x=k*rayon;

for j=1:length(NB)

%printf("%f\n", rayon(j));
 

xint=x(j);
%100*(j/length(NB))

% ici calcul vers l'avant
%------------------------

    a_min=0.5;%0.716;
    a_max=13;%3.954;
    dcone=(a_max-a_min)/30; %Originellement : 50
    cone=[a_min:dcone:a_max];
    ss=size(cone);
    theta=pi*cone/180.0;
    dtheta=pi*dcone/180.0;


	
    for i=1:ss(1,2);
        u(i)=cos(theta(i));
        b=Mie_S12(m,x(j),u(i));
        C(i)=2*pi*dtheta*(abs(b(1))^2+abs(b(2))^2)/2.*sin(theta(i));
    end
	
    Cfor(j)=sum(C);
    b=Mie(m,x(j));
    Cscat(j)=b(2)*pi*rayon(j)^2*k^2;

% ici calcul a 90?
%-----------------
	thangle=13;%52.3802;
	thmin=pi/2. - thangle /180*pi;
	thmax=pi/2. + thangle /180*pi;
	inccone90=(thmax-thmin)/100.;
	cone90=[thmin:inccone90:thmax];
	s90=size(cone90);


	omega=cone90;
	domega=inccone90;


        
	for q=1:s90(1,2)
		v(q)=cos(omega(q));
		b=Mie_S12(m,x(j),v(q));          
		phi(q)= abs(asin(sin(thmax)/sin(omega(q)))-pi/2);
		% attention ici pour verif si thangle =90?            
		%            phi(q)= pi/2.;
		cos2=phi(q)-sin(phi(q)).*cos(phi(q));
		sin2=phi(q)+sin(phi(q)).*cos(phi(q));
		cos4=3/4*phi(q)-sin(2*phi(q))/2+sin(4*phi(q))/16;
		sin4=3/4*phi(q)+sin(2*phi(q))/2+sin(4*phi(q))/16;
		cos2sin2=phi(q)/4-sin(4*phi(q))/16;
		dble_prod=(b(2)*conj(b(1))+b(1)*conj(b(2))).*cos2sin2.*cos(omega(q));
		C90elema(q)=domega*(abs(1.0)^2.*sin2+abs(1.0)^2.*cos2).*sin(omega(q));
		C90elem(q)=domega*(abs(b(1))^2.*sin2+abs(b(2))^2.*cos2).*sin(omega(q));
		C90elemx(q)=domega*(abs(b(1))^2.*sin4+abs(b(2))^2.*cos4.*cos(omega(q)).^2+dble_prod).*sin(omega(q));
		C90elemy(q)=domega*(abs(b(1))^2.*cos2sin2+abs(b(2))^2.*cos2sin2.*cos(omega(q)).^2-dble_prod).*sin(omega(q));
		C90elemz(q)=domega*(abs(b(2))^2.*cos2.*sin(omega(q)).^2).*sin(omega(q));
	end
	
	C90aire(j)=sum(C90elema);
	C90(j)=sum(C90elem);
	C90x(j)=sum(C90elemx);
	C90y(j)=sum(C90elemy);
	C90z(j)=sum(C90elemz);
	b=Mie_S12(m,x(j),0);      
	C90num(j)=2*pi*(1-cos(thmax-pi/2))*b(1)^2;
	
	NB(j)
end


%conversion entre 0 et 1024
Cfor_f=round((Cfor/max(Cfor))*1023);
C90_f=round((C90x/max(C90x))*1023);


fid = fopen('manipe_theory_fullrange_20110317.txt','w+');
fprintf(fid,'FSH(1024)\t SSH(1024)\t Rayon\t FSH\t SSH\r');


for j=1:length(NB)
    fprintf(fid,'%g\t %g\t %g\t %g\t %g\r',Cfor_f(j),C90_f(j),rayon(j),Cfor(j),C90x(j));
end


fclose(fid);




%Representation du dotplot SSH/FSH
%----------------------------------
%graphics_toolkit gnuplot     # backend gnuplot
%setenv('GNUTERM','wx') 

figure(1);
% set (gcf,'defaultaxesfontname', 'Arial')
% set (gcf,'defaultaxesfontsize', 8)
% set (gcf,'paperunits','inches');
% set (gcf,'papersize',[3 3])
% set (gcf,'paperposition', [0,0,[3 3]])
% set (gcf,'defaultaxesposition', [0.20, 0.15, 0.70, 0.75])

subplot(1,2,1)
plot(rayon,Cfor_f,'-ks', rayon,C90_f,':kd', 'MarkerSize',4);
legend('Forward Scattering','Side Scattering',1);
xlabel('Radius (\mu m)');
ylabel('Normalized Diffusion Intensity');
title('FS and SS vs. Radius')
%axis equal;
axis([0 rayon(length(NB)) 0 1024]);
%set(gca,'LineWidth',2,'Box','off');
%set(gca,'DataAspectRatio',[1 1 1])

% set (gcf,'defaultaxesfontname', 'Arial')
% set (gcf,'defaultaxesfontsize', 8)
% set (gcf,'paperunits','inches');
% set (gcf,'papersize',[3 3])
% set (gcf,'paperposition', [0,0,[3 3]])
% set (gcf,'defaultaxesposition', [0.20, 0.15, 0.70, 0.75])

subplot(1,2,2)

plot(Cfor_f,C90_f,'-ko', 'MarkerSize',4);
xlabel('Forward Scattering Intensity')
ylabel('Side Scattering Intensity')
axis([0 1024 0 1024]);
%axis equal;
title('Normalized Scattering Diagram')
% set(gca,'LineWidth',2,'Box','off')
% set(gca,'DataAspectRatio',[1 1 1])

% set (gcf,'defaultaxesfontname', 'Arial')
% set (gcf,'defaultaxesfontsize', 8)
% set (gcf,'paperunits','inches');
% set (gcf,'papersize',[3 3])
% set (gcf,'paperposition', [0,0,[3 3]])
% set (gcf,'defaultaxesposition', [0.15, 0.15, 0.75, 0.75])
