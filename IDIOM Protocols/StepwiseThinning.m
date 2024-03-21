clc 
clear all 
close all 

% The function creates the average thickness vs. time plot of a square
% sample region on a stratifying thin film 

% Input the parameters 
wavelengths = [600,546,470]; % The wavelengths of red, green and blue lights [nm] 
n = 1.33; % The relative refractive index [1] 

center_smp = [512,512]; % The center of the sample region [pixels] 
size_smp = 25; % The size (side length) of the sample region [pixels] 

[file,path] = uigetfile({'*.mraw'},'Select the video'); 
filename = horzcat(path,file(1:end-5)); % The file name of the video 

% Obtain the average thickness vs. time plot 
[Is_smp,Imax,Imin] = ImaxImin(filename,'input',center_smp,size_smp); 
[hvf_smp,havgvf_smp,hvt_smp,havgvt_smp,ftzero] = AverThicknEvol(filename,wavelengths,n,Is_smp,Imax,Imin); 

% hvf_smp: The average thickness vs. frame plot, for three RGB channels 
% havgvf_smp: The average thickness vs. frame plot, averaging through three RGB channels 
% hvt_smp: The average thickness vs. time plot, for three RGB channels 
% havgvt_smp: The average thickness vs. time plot, averaging through three RGB channels 
% ftzero: The frame index of the video frame which corresponds to the onset time 

% Demonstrate the average thickness vs. time plot 
ax = axes('Parent',figure,'YGrid','on',...
    'YTick',[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120]); 
ylim([0,125]); 

xlabel('Frame'); 
ylabel('Thickness, h [nm]'); 
title('Average thickness vs. frame plot, for three RGB channels'); 

box(ax,'on'); 
hold(ax,'on'); 

plot(hvf_smp(:,1),hvf_smp(:,4),'b'); 
hold on; 
plot(hvf_smp(:,1),hvf_smp(:,3),'g'); 
plot(hvf_smp(:,1),hvf_smp(:,2),'r'); 
hold off; 
