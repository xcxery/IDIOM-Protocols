function wbmask = WhiteBalanceMask(height,width,whitebalance,align) 

% The function is used to obtain a multiplicative mask used for white
% balancing a video 

% height: The height of the images in the video 
% width: The width of the images in the video 
% whitebalance: The vector used for white balancing 
% align: The string indicating the RGB Bayer pattern, including 'rggb', 'gbrg', 'grbg', 'bggr' 

% wbmask: The multiplicative mask used for white balancing [M*M matrix] 

wbmask = whitebalance(2)*ones(height,width); 

switch align 
case 'rggb' 
wbmask(1:2:end,1:2:end) = whitebalance(1); % Label red channels 
wbmask(2:2:end,2:2:end) = whitebalance(3); % Label blue channels 
case 'bggr' 
wbmask(2:2:end,2:2:end) = whitebalance(1); % Label red channels 
wbmask(1:2:end,1:2:end) = whitebalance(3); % Label blue channels 
case 'grbg' 
wbmask(1:2:end,2:2:end) = whitebalance(1); % Label red channels 
wbmask(2:2:end,1:2:end) = whitebalance(3); % Label blue channels 
case 'gbrg' 
wbmask(2:2:end,1:2:end) = whitebalance(1); % Label red channels 
wbmask(1:2:end,2:2:end) = whitebalance(3); % Label blue channels 
end 

end 
