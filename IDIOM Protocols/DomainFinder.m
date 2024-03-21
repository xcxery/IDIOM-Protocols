function propvf_dom = DomainFinder(filename,fs,refframe,thres_dom,propvf_f,ratio_f) 

% The function is used to obtain the location and size of a circular domain
% selected in a video 

% filename: The file name of the video 
% fs: The frame indices of the target video frames 
% refframe: The first frame index of the target video frames in which the background is visualized 
% thres_dom: The threshold value used for identifying the domain 
% propvf_f: The location and size (the center and the original radius) of the circular thin film 
% ratio_f: The multiplicative ratio used for adjusting the film radius 

% propvf_dom: The location and size of the domain 

% Obtain the RGB image and the mean intensity of the background 
[refimg,refI] = ReferenceExtractor(filename,refframe); 

% Obtain the location and size of the domain for the first video frame 
fN = length(fs); 
propvf_dom = zeros(fN,8); 

colorimg = ImageExtractor(filename,fs(1)); 
colorimg = ImageAdjuster(colorimg,refimg,refI); 
bwmask_dom = im2bw(colorimg,thres_dom); mdmask_dom = bwareaopen(bwmask_dom,10); 
figure('Name','Click to select the target domain','NumberTitle','off'); 
imshow(mdmask_dom); 
title('Binary image of domains after thresholding'); 
[x,y] = ginput(1); x = round(x); y = round(y); close gcf; 

[mask_dom,bmask_dom,boundary_dom] = ImageObjectTracer1(filename,fs(1),'concave',thres_dom,[x,y],propvf_f(1,:),ratio_f); 

[ys_dom,xs_dom] = find(mask_dom == 1); 
mx_dom = mean(xs_dom); 
my_dom = mean(ys_dom); 
mr_dom = sqrt(max(size(ys_dom))/3.14); 

propvf_dom(1,1) = fs(1); 
propvf_dom(1,2) = mx_dom; % The center (x) of the domain [pixels] 
propvf_dom(1,3) = my_dom; % The center (y) of the domain [pixels] 
propvf_dom(1,4) = mr_dom; % The radius of the domain [pixels] 
propvf_dom(1,8) = max(size(ys_dom)); % The area of the domain [pixels^2] 

[cx_dom,cy_dom,cr_dom] = CircleFitter(boundary_dom(:,2),boundary_dom(:,1)); 

propvf_dom(1,5) = cx_dom; % The center (x) of the circle fitted the domain [pixels] 
propvf_dom(1,6) = cy_dom; % The center (y) of the circle fitted the domain [pixels] 
propvf_dom(1,7) = cr_dom; % The radius of the circle fitted the domain [pixels] 

imshow(bmask_dom); 

% Obtain the location and size of the domain for the rest video frames 
for fi = 2:fN 
    
    frame = fs(fi); 
    
    [mask_dom,bmask_dom,boundary_dom] = ImageObjectTracer1(filename,frame,'concave',thres_dom,[mx_dom,my_dom],propvf_f(fi,:),ratio_f); 
    
    [ys_dom,xs_dom] = find(mask_dom == 1); 
    mx_dom = mean(xs_dom); 
    my_dom = mean(ys_dom); 
    mr_dom = sqrt(max(size(ys_dom))/3.14); 
    
    propvf_dom(fi,1) = frame; 
    propvf_dom(fi,2) = mx_dom; % The center (x) of the domain [pixels] 
    propvf_dom(fi,3) = my_dom; % The center (y) of the domain [pixels] 
    propvf_dom(fi,4) = mr_dom; % The radius of the domain [pixels] 
    propvf_dom(fi,8) = max(size(ys_dom)); % The area of the domain [pixels^2] 
    
    [cx_dom,cy_dom,cr_dom] = CircleFitter(boundary_dom(:,2),boundary_dom(:,1)); 
    
    propvf_dom(fi,5) = cx_dom; % The center (x) of the circle fitted the domain [pixels] 
    propvf_dom(fi,6) = cy_dom; % The center (y) of the circle fitted the domain [pixels] 
    propvf_dom(fi,7) = cr_dom; % The radius of the circle fitted the domain [pixels] 
    
    imshow(bmask_dom); 
    
end 

close gcf; 

end 
