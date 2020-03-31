clear all
close all
% calcul du signal mesuré en FACS

    
    
    
%     [FSC,SSC]=textread('pmma.txt'); 
%     [FSH,SSH,FL,Rayon] = textread('soja_theory.txt');
%     FSC=FSC*0.85;
%     FL2=FL2/9;
%     SSC=SSC*0.68; % *1.9;
    

    [FSC,SSC,FL2]=textread('manipe.txt');
    [FSH,SSH,Rayon] = textread('manipe_theory.txt');
    FSC=FSC*1.17;
    SSC=SSC*1.02; % *1.9;
    %FL2=1.35*FL2;

    

%     figure
%     subplot(1,2,1)
%     plot(SSC,FL2,'r+', 'markersize',1)
%     hold on
%     plot(SSH,FL,'-')
%     hold off
%     subplot(1,2,2)
%     plot(FSC,FL2,'r+', 'markersize',1)
%     hold on
%     plot(FSH,FL,'-')
%     hold off
%    
    figure
    plot(FSC,SSC,'r+', 'markersize',1)
    hold on
    plot(FSH,SSH,'-')
    xlabel('Forward')
    ylabel('Side')
    hold off
    
    
