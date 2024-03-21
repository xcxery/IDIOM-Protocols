clc 
clear all 
close all 

% The function creates the thickness map of a stratifying thin film 

% Input the parameters 
fs = 1700; % The frame index of the target video frame 
refframe = 2674; % The first frame index of the target video frames in which the background is visualized 

wavelengths = [600,546,470]; % The wavelengths of red, green and blue lights [nm] 
n = 1.33; % The relative refractive index [1] 

thres_f = 0.37; % The threshold value for detecting the thin film 
ratio_f = 0.93; % The multiplicative ratio used for adjusting the film radius 

colorlim = [10,100]; % The thickness range in which the thickness map displays [nm] 

[file,path] = uigetfile({'*.mraw'},'Select the video'); 
filename = horzcat(path,file(1:end-5)); % The file name of the video 

% Obtain the thickness map 
propvf_f = FilmFinder1(filename,fs,thres_f); 
thmaps = ThicknessMap(filename,fs,refframe,wavelengths,n,propvf_f,ratio_f); 

% thmaps: The thickness map [nm] 

% Plot the thickness map 
for fi = 1:length(fs) 
    
    thmap = (thmaps(:,:,fi))'; 
    fig = ColorMapPlotter(thmap,colorlim,[1,512],[1,512],[-50,120],'off',[1,1,0.5],5,[90,45]); 
%     pause(0.01); 
    
end 
