function colorimg = ImageAdjuster(colorimg,refimg,refI) 

% The function removes the background noise of an RGB image by using a
% referenced RGB image and the mean intensity of the background 

% colorimg: The original RGB image 
% refimg: The referenced RGB image of the background 
% refI: The mean intensity of the background 

% colorimg: The processed RGB image 

img = zeros(size(colorimg)); 

for ci = 1:3 
    img(:,:,ci) = colorimg(:,:,ci)-refimg(:,:,ci)+refI(ci)./255; 
end 

colorimg = img; 

end 
