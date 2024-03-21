function info = HeaderReader(filename) 

% The function is used to obtain the information of a RAW format video,
% including the size, the duration, the frame rate, and the white balance
% setting of the video 

% filename: The file name of the video 

% info: The information of the video, including: 
% info.length: The duration of the video 
% info.framerate: The frame rate of the video 
% info.whitebalance: The vector used for white balancing 
% info.width: The width of the images in the video 
% info.height: The height of the images in the video 
% info.size: The size of the images in the video 

fileID = fopen(sprintf('%s.cih',filename),'r'); 
header = textscan(fileID,'%s','delimiter',':'); 

info.length = str2double(cell2mat(header{1}(50))); 

if isnan(info.length) == 1 
    info.length = str2double(cell2mat(header{1}(49))); 
    info.width = str2double(cell2mat(header{1}(57))); 
    info.height = str2double(cell2mat(header{1}(59))); 
    info.framerate = str2double(cell2mat(header{1}(29))); 
    info.whitebalance = [str2double(cell2mat(header{1}(37))),str2double(cell2mat(header{1}(39))),str2double(cell2mat(header{1}(41)))]; 
else 
    info.width = str2double(cell2mat(header{1}(58))); 
    info.height = str2double(cell2mat(header{1}(60))); 
    info.framerate = str2double(cell2mat(header{1}(30))); 
    info.whitebalance = [str2double(cell2mat(header{1}(38))),str2double(cell2mat(header{1}(40))),str2double(cell2mat(header{1}(42)))]; 
end 

info.whitebalance = info.whitebalance./info.whitebalance(2); 
info.size = info.width*info.height; 

fclose(fileID); 

end 
