function propvf_f = FilmFinder1(filename,fs,thres_f) 

% The function is used to obtain the location and size of a circular thin
% film selected in a video 

% filename: The file name of the video 
% fs: The frame indices of the target video frames 
% thres_f: The threshold value used for identifying the thin film 

% propvf_f: The location and size of the thin film 

fN = length(fs); 

propvf_f = zeros(fN,4); 

for fi = 1:fN 
    
    frame = fs(fi); 
    
    colorimg = ImageExtractor(filename,frame); 
    bwmask_f = not(im2bw(colorimg,thres_f)); 
    mdmask_f = bwareaopen(bwmask_f,50); 
    lmask_f = bwlabeln(mdmask_f); 
    
    if fi == 1 
        figure('Name','Click randomly to continue','NumberTitle','off'); 
        imshow(mdmask_f); 
        title('Binary image of the thin film boundary after thresholding'); 
        [~,~] = ginput(1); close gcf; 
    end 
    
    label1 = lmask_f(1,1); 
    label2 = lmask_f(1,end); 
    label3 = lmask_f(end,1); 
    label4 = lmask_f(end,end); 
    
    [yN,xN] = size(lmask_f); 
    for xi = 1:xN 
        for yi = 1:yN 
            label = lmask_f(yi,xi); 
            if label ~= label1 && label ~= label2 && label ~= label3 && label ~= label4 
                lmask_f(yi,xi) = -1; 
            end 
        end 
    end 
    lmask_f(lmask_f ~= -1) = 0; 
    lmask_f(lmask_f == -1) = 1; 
    mask_f = lmask_f; 
    
    bmask_f = edge(mask_f,'canny'); 
    boundary_f = []; 
    [boundary_f(:,1),boundary_f(:,2)] = find(bmask_f); 
    
    [cx_f,cy_f,cr_f] = CircleFitter(boundary_f(:,2),boundary_f(:,1)); 
    
    propvf_f(fi,1) = frame; 
    propvf_f(fi,2) = cx_f; % The center (x) of the thin film [pixels] 
    propvf_f(fi,3) = cy_f; % The center (y) of the thin film [pixels] 
    propvf_f(fi,4) = cr_f; % The radius of the thin film [pixels] 
    
end 

end 
