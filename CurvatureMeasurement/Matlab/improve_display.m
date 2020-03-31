function improve_display(gcf,gca,width,height,alw,fsz,lw,msz)
%Improve the display of graphs according to the parameters definitions below
%Values are given as default parameters
%width = 6;     % Width in inches
%height = 3;    % Height in inches
%alw = 2;    % AxesLineWidth
%fsz = 18;      % Fontsize
%lw = 2;      % LineWidth
%msz = 8;       % MarkerSize

pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gcf, 'Color', [1 1 1]);
set(gca,'DataAspectRatio', [1 1 1],'XMinorTick','on','YMinorTick','on', 'TickLength',[0.0150 0.030]);
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
% Set Tick Marks
% set(gca,'XTick',-3:3);
% set(gca,'YTick',0:10);
end


