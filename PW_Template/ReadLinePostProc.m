close all 
clear all
curdir=pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prepare the array of data to be read %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
listing = dir(strcat(curdir,'\postProcessing\sample\'));
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
 % suppose 's' is the struct array. 
T = struct2table(listing); % convert the struct array to a table
sortedT = sortrows(T, 'time'); % sort the table
listing = table2struct(sortedT); % change it back to struct array if necessary

%%%%%%%%%%%%%%%%
% analyse data %
%%%%%%%%%%%%%%%%
timeStab = 0; 
maxDens = 0;
max_dens_fig = figure;

[filepath,name,ext] = fileparts(pwd);
filename=[name, '_linedensity.gif'];

for i=1:length(listing)
    A=dlmread(strcat(curdir,'\postProcessing\sample\',listing(i).name,'\line_p_T.xy'));
    x=A(:,1);
    y=A(:,2);
    z=A(:,3);
    p=A(:,4);
    T=A(:,5);
    n0=10^(17).*p./(1.38.*T);
    
    % density above gasjet exit
    k = figure;
    plot(y*1e3, n0)
    xlabel('mm');
    ylabel('cm^{-3}');
    title([listing(i).name, ' s']);
    %xlim([0, 32]);
    %ylim([0, 1.E18]);
    %do animation
    frame = getframe(k);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
    close(k);
    
    % maximum density above gasjet exit
    figure(max_dens_fig)
    hold on
    y_abovegj = y>0.012; % take into account only values above gasjet
    maxDensTemp = max(n0(y_abovegj));
    plot(listing(i).time*1E6, maxDensTemp, '.b', 'MarkerSize', 15)
    if (maxDensTemp-maxDens)/maxDens < 0.10 
        if timeStab == 0
            timeStab = listing(i).time*1E6;
        end
    else
        timeStab = 0;
    end
    maxDens = maxDensTemp;
    xlabel('\mu s');
    ylabel('cm^{-3}');
    title('max density evolution');
end

%%%
% save plots
saveas(max_dens_fig,'./postProcessing/max_density_evolution.png')
saveas(max_dens_fig,'./postProcessing/max_density_evolution.fig')
k = figure;
plot(y*1e3-12, n0)
xlabel('mm');
ylabel('cm^{-3}');
title([listing(i).name, ' s']);
xlim([0, 32]);
saveas(max_dens_fig,'./postProcessing/la.png')
saveas(max_dens_fig,'./postProcessing/max_density_evolution.fig')

disp('Time before stabilization in 10% variation')
disp(timeStab)


filename_as=['.\postProcessing\', name, '_linedensity_after_stab.gif'];
for i=1:length(listing)
    if listing(i).time <= 50e-6
        continue
    end
    A=dlmread(strcat(curdir,'\postProcessing\sample\',listing(i).name,'\line_p_T.xy'));
    x=A(:,1);
    y=A(:,2);
    z=A(:,3);
    p=A(:,4);
    T=A(:,5);
    n0=10^(17).*p./(1.38.*T);
    
    % density above gasjet exit
    k = figure;
    plot(y*1e3, n0)
    xlabel('mm');
    ylabel('cm^{-3}');
    title([listing(i).name, ' s']);
    xlim([0, 32]);
    %ylim([0, 1.E18]);
    ylim([1E16 4E17])
    %do animation
    frame = getframe(k);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if ~exist(filename_as)
        imwrite(imind,cm,filename_as,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename_as,'gif','WriteMode','append');
    end
    close(k);
end

