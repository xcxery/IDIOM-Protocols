function [mask,bmask,boundary] = ImageObjectTracer1(filename,frame,thresmodel,thres,xy,propvf_f,ratio_f,noisesize) 

% The function is used to obtain the binary image and the boundary of a
% selected object inside a circular film 

% filename: The file name of the video 
% frame: The frame index of the target video frame 
% thresmodel: The string indicating whether the object is brighter or darker contrast to the surrounding 
% thres: The threshold value used for identifying the object 
% xy: The coordinates indicating the location of the object 
% propvf_f: The location and size (the center and the original radius) of the circular film 
% ratio_f: The multiplicative ratio used for adjusting the film radius 
% noisesize: The minimum pixel number of small objects that will not be
%            removed by the function 'bwareaopen' (default value is 10) 

% mask: The binary image of the object 
% bmask: The binary image of the object boundary 
% boundary: The coordinates of the object boundary 

if nargin == 7 
    noisesize = 10; 
end 

img = ImageExtractor(filename,frame); 

cx_f = propvf_f(1,2); cy_f = propvf_f(1,3); cr_f = propvf_f(1,4); 

if strcmp(thresmodel,'convex') 
    
    % For the model 'convex', the lighter object will be detected 
    
    img = ImageRefiller(img,0,'circle',[cx_f,cy_f],cr_f*ratio_f); 
    bwmask = not(im2bw(img,thres)); 
    
elseif strcmp(thresmodel,'concave') 
    
    % For the model 'concave', the darker object will be detected 
    
    img = ImageRefiller(img,1,'circle',[cx_f,cy_f],cr_f*ratio_f); 
    bwmask = im2bw(img,thres); 
    
end 

mdmask = bwareaopen(bwmask,noisesize); 
lmask = bwlabeln(not(mdmask)); 

label = lmask(round(xy(2)),round(xy(1))); 
lmask(lmask == label) = -1; 
lmask(lmask ~= -1) = 0; 
lmask(lmask == -1) = 1; 
mask = lmask; 

bmask = edge(mask,'canny'); 
boundary = []; 
[boundary(:,1), boundary(:,2)] = find(bmask); 

end 
