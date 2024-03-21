function img2 = ImageRefiller(img1,ele,model,para1,para2) 

% The function assigns a particular value to the image pixels outside a
% specified region 

% img1: The original image 
% ele: The assigned value 
% model: The string specifying the shape of the region, including 'circle' and 'rectangle' 
% para1 & para2: The parameters specifying the size of the region 

% img2: The processed image 

img2 = img1; 

if strcmp(model,'circle') 
    
    % For the model 'circle', para1 should be the center of the circle and
    % para2 should be the radius of the circle 
    
    if length(para1) ~= 2 || length(para2) ~= 1 
        error('The input of geometric parameters is not proper. '); 
    end 
    
    cx = para1(1); 
    cy = para1(2); 
    cr = para2; 
    
    for xi = 1:size(img2,2) 
        for yi = 1:size(img2,1) 
            if (xi-cx)^2+(yi-cy)^2 >= cr^2 
                for ci = 1:size(img2,3) 
                    img2(yi,xi,ci) = ele; 
                end 
            end 
        end 
    end 
    
elseif strcmp(model,'rectangle') 
    
    % For the model 'rectangle', para1 and para2 should be two diagonal
    % vertices of the rectangle 
    
    if length(para1) ~= 2 || length(para2) ~= 2 
        error('The input of geometric parameters is not proper. '); 
    end 
    
    x1 = para1(1); y1 = para1(2); 
    x2 = para2(1); y2 = para2(2); 
    xs = [x1,x2]; xs = sort(xs); 
    ys = [y1,y2]; ys = sort(ys); 
    x1 = xs(1); x2 = xs(2); 
    y1 = ys(1); y2 = ys(2); 
    
    for xi = 1:size(img2,2) 
        for yi = 1:size(img2,1) 
            if xi < x1 || xi > x2 || yi < y1 || yi > y2 
                for ci = 1:size(img2,3) 
                    img2(yi,xi,ci) = ele; 
                end 
            end 
        end 
    end 
    
else 
    
    error('No model matches. '); 
    
end 

end 
