function [cx,cy,cR] = CircleFitter(xs,ys) 

% The function fits a circle to a set of points located on the boundary of
% an object 

% xs: The x-coordinates of the points on the boundary 
% ys: The y-coordinates of the points on the boundary 

% cx: The center (x) of the fitted circle 
% cy: The center (y) of the fitted circle 
% cR: The radius of the fitted circle 

xs = xs(:); 
ys = ys(:); 

% (x-cx).^2+(y-cy).^2 = cR^2; 
% x.^2-2*cx.*x+cx^2+y.^2-2*cy.*y+cy^2 = cR^2; 
% -2*cx.*x-2*cy.*y+cx^2+cy^2-cR^2 = -(x.^2+y.^2); 

c = [xs,ys,ones(size(xs))]\(-(xs.^2+ys.^2)); 

% c(1) = -2*cx; 
% c(2) = -2*cy; 
% c(3) = cx^2+cy^2-cR^2; 

cx = -0.5*c(1); 
cy = -0.5*c(2); 
cR = sqrt((c(1)^2+c(2)^2)/4-c(3)); 

end 
