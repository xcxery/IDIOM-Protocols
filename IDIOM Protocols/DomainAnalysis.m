clc 
clear all 
close all 

% The function determines the location and size of an isolated domain on a
% stratifying thin film varying with time 

% Input the parameters 
pixels = 225/2; % The pixel number of 100 micronmeters [pixel] 
lengthscale = 100/pixels; % The length scale of the video [micronmeter/pixel] 

fs = 1536:1806; % The frame indices of the target video frames 
refframe = 2674; % The first frame index of the target video frames in which the background is visualized 
ftzero = 1535; % The frame index of the video frame which corresponds to the onset time of domain nucleation 

thres_f = 0.37; % The threshold value for detecting the thin film 
ratio_f = 0.93; % The multiplicative ratio used for adjusting the film radius 
thres_dom = 0.16; % The threshold value for detecting the domain 

[file,path] = uigetfile({'*.mraw'},'Select the video'); 
filename = horzcat(path,file(1:end-5)); % The file name of the video 

info = HeaderReader(filename); 

% Obtain the location and size vs. time of the domain 
propvf_f = FilmFinder1(filename,fs,thres_f); 
propvf_dom = DomainFinder(filename,fs,refframe,thres_dom,propvf_f,ratio_f); 

ts = ((fs-ftzero)./info.framerate)'; 
propvt_dom = propvf_dom; propvt_dom(:,1) = ts; 

rvt_dom = [propvt_dom(:,1),propvt_dom(:,7)]; 
Rvt_dom = [propvt_dom(:,1),propvt_dom(:,7).*lengthscale]; 

% propvf_dom: The location and size vs. frame of the domain 
% propvt_dom: The location and size vs. time of the domain 
% rvt_dom: The domain radius vs. time plot [pixels vs. s] 
% Rvt_dom: The domain radius vs. time plot [micrometer vs. s] 

% Demonstrate the domain radius vs. time plot 
plot(Rvt_dom(:,1),Rvt_dom(:,2),'bo'); 

xlabel('Time, t [s]'); 
ylabel('Domain Radius, R_d [\mum]'); 
title('Domain radius vs. time plot'); 
box on; 
