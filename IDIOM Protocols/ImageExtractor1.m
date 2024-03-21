function colorimg = ImageExtractor1(filename,frame) 

% The function extracts a selected video frame from a video as an RGB image
% directly, without white balancing 

% filename: The file name of the video 
% frame: The frame index of the selected video frame 

% colorimg: The RGB image [(M/2)*(M/2)*3 matrix] 

fileID = fopen(sprintf('%s.mraw',filename),'r'); 
info = HeaderReader(filename); 
shape = [info.width,info.height]; 

fseek(fileID,frame*info.size*2,'bof'); 
shuttle = fread(fileID,info.size,'ubit16'); 
img = double(reshape(shuttle,shape))'./4095; 
colorimg(:,:,1) = img(2:2:end,2:2:end); 
colorimg(:,:,2) = (img(2:2:end,1:2:end)+img(1:2:end,2:2:end))./2; 
colorimg(:,:,3) = img(1:2:end,1:2:end); 

fclose(fileID); 

end 
