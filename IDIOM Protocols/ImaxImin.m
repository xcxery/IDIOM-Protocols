function [Is_smp,Imax,Imin] = ImaxImin(filename,model,para1,para2) 

% The function is used to obtain the average intenisty of a square sample
% region selected in a video 

% filename: The file name of the video 
% model: The string indicating how to determine the center and the size
%        (side length) of the sample region, including 'image' and 'input' 
% para1 & para2: The parameters specifying the center and the size (side
%                length) of the sample region 

% Is_smp: The average intensity within the sample region, for three RGB channels 
% Imax: The maximum value of the average intensity, for three RGB channels 
% Imin: The minimum value of the average intensity, for three RGB channels 

% Determine the center and the size (side length) of the sample region 
if strcmp(model,'image') 
    
    % For the model 'image', para1 should be the frame index of an example
    % video frame used to determine the center of the sample region, and
    % para2 should be the size (side length) of the sample region (default
    % value is 25) 
    
    if nargin == 4 
        if length(para1) ~= 1 || length(para2) ~= 1 
            error('The input of parameters is wrong. '); 
        end 
        empframe = para1; 
        size_smp = para2; 
    elseif nargin == 3 
        if length(para1) ~= 1 
            error('The input of parameters is wrong. '); 
        end 
        empframe = para1; 
        size_smp = 25; 
    end 
    
    colorimg = ImageExtractor0(filename,empframe); 
    imshow(colorimg); [x,y] = ginput(1); close gcf; 
    center_smp = [round(x),round(y)]; 
    
elseif strcmp(model,'input') 
    
    % For the model 'input', para1 should be the center of the sample
    % region (default value is [512,512]), and para2 should be the size
    % (side length) of the sample region (default value is 25) 
    
    if nargin == 4 
        if length(para1) ~= 2 || length(para2) ~= 1 
            error('The input of parameters is wrong. '); 
        end 
        center_smp = para1; 
        size_smp = para2; 
    elseif nargin == 3 
        if length(para1) ~= 1 && length(para1) ~= 2 
            error('The input of parameters is wrong. '); 
        end 
        if length(para1) == 2 
            center_smp = para1; 
            size_smp = 25; 
        end 
        if length(para1) == 1 
            center_smp = [512,512]; 
            size_smp = para1; 
        end 
    elseif nargin == 2 
        center_smp = [512,512]; 
        size_smp = 25; 
    end 
    
else 
    
    error('No method matches. '); 
    
end 

% Obtain the average intensity within the sample region 
fileID1 = fopen(sprintf('%s.cih',filename),'r'); 
fileID2 = fopen(sprintf('%s.mraw',filename),'r'); 
info = HeaderReader(filename); 

if fileID1 < 1 || fileID2 < 1 
    error('The file is incomplete. '); 
end 

mask_smp = zeros(info.height,info.width); 
mask_smp(round(center_smp(2)-size_smp/2):round(center_smp(2)+size_smp/2),round(center_smp(1)-size_smp/2):round(center_smp(1)+size_smp/2)) = 1; 

colormask_smp = ones(info.height,info.width).*2; 
colormask_smp(2:2:end,2:2:end) = 1; 
colormask_smp(1:2:end,1:2:end) = 3; 
colormask_smp(mask_smp == 0) = 0; 

maskshuttle_smp = reshape(colormask_smp',[],1); 
fstpoint_smp = find(maskshuttle_smp,1); 
skip_smp = info.width-size_smp-1; 
maskshuttle_smp(maskshuttle_smp == 0) = []; 

Is_smp = zeros(info.length,3); 

for i = 1:1:info.length 
    
    fseek(fileID2,(fstpoint_smp+(i-1)*info.size-1)*2,'bof'); 
    shuttle = fread(fileID2,size(maskshuttle_smp),[num2str(size_smp+1),'*uint16'],skip_smp*2); 
    
    for j = 1:3 
        Is_smp(i,j) = mean(shuttle(maskshuttle_smp == j))/4095*255; 
    end 
    
end 

Imax = max(Is_smp); 
Imin = mean(Is_smp(end-50:end,:)); 

fclose(fileID1); 
frewind(fileID2); 
fclose(fileID2); 

end 
