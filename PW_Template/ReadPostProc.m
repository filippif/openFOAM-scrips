close all
clear all
clc

curdir=pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prepare the array of data to be read %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
listing=dir(strcat(curdir,'\postProcessing\surfaces\'));
for i=1:length(listing)
    listing(i).time = str2num(listing(i).name);
end
i = 1;
while i <= length(listing)
    if isempty(listing(i).time)
        listing(i)=[];
    else 
        i = i+1;
    end
end
T = struct2table(listing); % convert the struct array to a table
sortedT = sortrows(T, 'time'); % sort the table
listing = table2struct(sortedT); % change it back to struct array if necessary


%%%%%%%%%%%%%%%%
% analyse data %
%%%%%%%%%%%%%%%%
[filepath,name,ext] = fileparts(pwd);
filename=['.\postProcessing\', name, '_surf.gif'];

for i=1:length(listing)
    [x,y,z,p]=importRawfile(strcat(curdir,'\postProcessing\surfaces\',listing(i).name,'\p_surf1.raw'));
    [~,~,~,T]=importRawfile(strcat(curdir,'\postProcessing\surfaces\',listing(i).name,'\T_surf1.raw'));
    k=figure(i);
    n0=10^(17).*p./(1.38.*T); % 1.38E-23 is the Boltzmann constant
                              % n0 is in cm-3
    
%     % scatter plot
%     scatter(x*1E3,y*1E3,5,n0,'fill')
%     drawnow
%     set(gca,'clim',[1e16 1.5e17])
%     colorbar
%     title([listing(i).name,' s']);
%     xlabel('mm')
%     ylabel('mm')  
%     xlim([-10, 10]);
%     axis equal

    [xq,yq] = meshgrid(min(x):.00005:max(x), 12E-3:.00005:max(y));
    vq = griddata(x, y , n0, xq, yq);
    surf(xq*1E3,yq*1E3,vq, 'LineStyle', 'none')
    drawnow
    colorbar
    title([listing(i).name,' s']);
    xlabel('mm')
    ylabel('mm')  
    xlim([-10, 10]);
    ylim([12, 32]);
%     set(gca,'clim',[1e16 0.5e17])
    set(gca,'View', [0, 90])
    
    %do animation
    frame = getframe(k);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1
        imwrite(imind,cm, filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
    close(k);
end

% interpolate latest time plot
surf_dens_fig = figure();
[xq,yq] = meshgrid(min(x):.00005:max(x), min(y):.00005:max(y));
vq = griddata(x, y , n0, xq, yq);
surf(xq*1E3,yq*1E3,vq, 'LineStyle', 'none')
drawnow
colorbar
title([listing(i).name,' s']);
xlabel('mm')
ylabel('mm')  
xlim([-10, 10]);
ylim([12, 32]);
set(gca,'clim',[1e16 1.5e17])
set(gca,'View', [0, 90])

saveas(surf_dens_fig,'./postProcessing/last_density_surf.png')
saveas(surf_dens_fig,'./postProcessing/last_density_surf.fig')

