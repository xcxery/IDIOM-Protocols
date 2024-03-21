function [refimg,refI] = ReferenceExtractor(filename,refframe) 

% The function is used to obtain the RGB image which will be used as a
% reference to remove the background noise and the mean intensity of
% background; The image is extracted with white balancing 

% filename: The file name of the video 
% refframe: The first frame index of the target video frames in which the background is visualized 

% refimg: The RGB image of the background, obtained by averaging through the target video frames [(M/2)*(M/2)*3 matrix] 
% refI: The mean intensity of a sample square region in the background, obtained by averaging through the target video frames 

N = 5; % The frame number of the target video frames 
smpcenter = [256,256]; % The center of the sample square region 
smpsize = 12; % The side length of the sample square region 

fileID = fopen(sprintf('%s.mraw',filename),'r'); 
info = HeaderReader(filename); 
shape = [info.width,info.height]; 
wbmask = WhiteBalanceMask(info.height,info.width,info.whitebalance,'bggr'); 

fseek(fileID,refframe*info.size*2,'bof'); 
shuttle = fread(fileID,info.size,'ubit16'); 
img = double(reshape(shuttle,shape))'./4095; 
img = img.*wbmask; 
colorimg(:,:,1) = img(2:2:end,2:2:end); 
colorimg(:,:,2) = (img(2:2:end,1:2:end)+img(1:2:end,2:2:end))./2; 
colorimg(:,:,3) = img(1:2:end,1:2:end); 
refimg = zeros(size(colorimg)); 
refI = zeros(1,3); 

fseek(fileID,refframe*info.size*2,'bof'); 

for i = 1:N 
    
    shuttle = fread(fileID,info.size,'ubit16'); 
    img = double(reshape(shuttle,shape))'./4095; 
    img = img.*wbmask; 
    colorimg(:,:,1) = img(2:2:end,2:2:end); 
    colorimg(:,:,2) = (img(2:2:end,1:2:end)+img(1:2:end,2:2:end))./2; 
    colorimg(:,:,3) = img(1:2:end,1:2:end); 
    
    refimg = refimg+colorimg; 
    
    trefI(1:3) = mean(mean(colorimg(smpcenter(2)-smpsize/2:smpcenter(2)+smpsize/2,smpcenter(1)-smpsize/2:smpcenter(1)+smpsize/2,:))).*255; 
    
    refI = refI+trefI; 
    
end 

refimg = refimg/N; 
refI = refI/N; 

fclose(fileID); 

end 
