%Ce code programme le signal exact de Mie dans un FACS
%Pour une distribution normale (moyenne,ecart-type)
%et rajoute un bruit en racine de la valeur obtenue


clear all
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


nombre_total=30000;
%nombre_total=660;


NB=[0:10:nombre_total];
rayon=NB;%*5;


k=2.0*pi*h2o/lambda;


x=k*rayon; 
tic

for j=1:length(NB)
xint=x(j);
100*(j/length(NB))
%rayon(j)

% ici calcul vers l'avant
%------------------------

    a_min=0.716;
    a_max=3.954;
    dcone=(a_max-a_min)/50;
    cone=[a_min:dcone:a_max];
%    cone=[0:dcone:180];
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
%    Cnum(j)=quad(@myfun,0./180*pi,180/180*pi);


% ici calcul a 90?
%-----------------


        thangle=52.3802;
%       thangle=90-0.0000001;
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
%        C90num(j)=quad(@myfun,(90-4.4)/180*pi,(90+4.4)/180*pi);
      



%ici calcul de la fluorescence
%-----------------------------


%fluo(j)=concentr*(4/3)*pi*rayon(j)^3;


end




%conversion entre 0 et 1024
Cfor_f=round((Cfor/max(Cfor))*1023);
C90_f=round((C90x/max(C90x))*1023);
%fluo_f=round((fluo/max(fluo)*9999));


toc
fid = fopen('manipe_theory_fullrange_20090109.txt','w+');
fprintf(fid,'FSH(1024)\t SSH(1024)\t Rayon\t FSH\t SSH\r');


for j=1:length(NB)
    %fprintf(fid,'%g\t %g\t  %g\t %g\r',Cfor_f(j),C90_f(j),fluo_f(j),rayon(j));
    fprintf(fid,'%g\t %g\t %g\t %g\t %g\r',Cfor_f(j),C90_f(j),rayon(j),Cfor(j),C90x(j));
end


fclose(fid);




%Representation du dotplot SSH/FSH
%----------------------------------


figure(1)
plot(Cfor_f,C90_f,'k*','MarkerSize',5)
xlabel('Forward Scattering Intensity')
ylabel('Side Scatering Intensity')
axis([0 1024 0 1024]);
%title('Normalized Scattering Diagram')
text(100,150, 'Droplets with 0<r<6000nm', 'FontSize',16)
text(100,50, 'n_{oil}=1.468; af_{min}=0.716; af_{max}=3.954; as=52.3802;','FontSize',16)
set(gca,'FontSize',18)
set(gca,'LineWidth',1,'Box','off')
set(gca,'OuterPosition',[0 0 1 1])


figure(2)
plot(rayon,Cfor_f,'k*',rayon,C90_f,'-ko','MarkerSize',5)
legend('Forward Scattering','Side Scattering',2)
xlabel('rayon')
ylabel('Normalized Diffusion Intensity')
axis([0 rayon(length(NB)) 0 1024]);
title('Forward and Side Scattering Normalized Intensities')
title('Normalized Scattering Diagram')
set(gca,'FontSize',18)
set(gca,'LineWidth',1,'Box','off')
set(gca,'OuterPosition',[0 0 1 1])

% subplot(2,2,2)
% %plot(rayon,C90,'-b+',rayon,C90num,'-r+','MarkerSize',2)
% C90num=C90x+C90y+C90z;
% plot(rayon,C90_f,'-b+',rayon,C90num,'-r+','MarkerSize',2)
% legend('C90','C90num',2)
% xlabel('rayon')
% ylabel('forward')
% title('Side vs rayon')
% 
% 
% subplot(2,2,3)
% %plot(rayon,Cfor,'-bo',rayon,Cscat,'-k+',rayon,Cnum,'-r+','MarkerSize',2)
% plot(rayon,Cfor,'-bo',rayon,Cscat,'-k+','MarkerSize',2)
% legend('Cfor','Cscat','Cnum',2)
% xlabel('rayon')
% ylabel('forward')
% title('Forward vs rayon')

% % figure(3)
% % semilogy(rayon,Cfor,'-bo',rayon,Cscat,'-k+',rayon,Cnum,'-r+','MarkerSize',2)
% % legend('Cfor','Cscat','Cnum',2)
% % 
%  figure(4)
%  plot(rayon,100*abs(2*C90-Cscat)./Cscat,'-bo',rayon,100*abs(2*C90num-Cscat)./Cscat,'-r+',rayon,100*abs(2*C90x-Cscat)./Cscat,'-b*','MarkerSize',2)
%  legend('C90','C90(x+y+z)','C90x',2)
%  
%  figure(5)
%  plot(rayon,C90num,'-ko',rayon,C90,'-b+',rayon,C90x,'-r+',rayon,C90y,'-g+',rayon,C90z,'-k+',rayon,Cscat/2,'-mo','MarkerSize',2)
%  legend('C90(x+y+z)','C90','C90x','C90y','C90z','Cscat/2',2)
%  
%  figure(8)
%  plot(C90,fluo,'-b+',C90x,fluo,'-r+',C90y,fluo,'-g+',C90z,fluo,'-k+','MarkerSize',2)
%  legend('C90','C90x','C90y','C90z',2) 