function colorimg = ImageExtractor0(filename,frame) 

% The function extracts a selected video frame from a video as an RGB image
% by using gradient-corrected linear interpolation method, with white
% balancing 

% filename: The file name of the video 
% frame: The frame index of the selected video frame 

% colorimg: The RGB image [M*M*3 matrix] 

fileID = fopen(sprintf('%s.mraw',filename),'r'); 
info = HeaderReader(filename); 
shape = [info.width,info.height]; 
wbmask = WhiteBalanceMask(info.height,info.width,info.whitebalance,'bggr'); 

fseek(fileID,frame*info.size*2,'bof'); 
shuttle = fread(fileID,info.size,'ubit16'); 
img = double(reshape(shuttle,shape))'./4095; 
img = img.*wbmask; 
temp = uint16(img*2^16); 
colorimg(:,:,:) = double(demosaic(temp,'bggr'))/2^16; 

fclose(fileID); 

end 
