
function improve_printing(gcf,width,height)
%Improve the printing of graphs according to the parameters definitions below
%Values are given as default parameters
%width = 6;     % Width in inches
%height = 3;    % Height in inches
% Here we preserve the size of the image when we save it.
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
end