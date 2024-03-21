function thmaps = ThicknessMap(filename,fs,refframe,wavelengths,n,propvf_f,ratio_f,sthN) 

% The function constructs the thickness map of a circular thin film, by
% converting pixel-wise intensity to thickness 

% filename: The file name of the video 
% fs: The frame indices of the target video frames 
% refframe: The first frame index of the target video frames in which the background is visualized 
% wavelengths: % The wavelengths of red, green and blue lights [nm] 
% n: The relative refractive index [1] 
% propvf_f: The location and size (the center and the original radius) of the circular thin film 
% ratio_f: The multiplicative ratio used for adjusting the film radius 
% sthN: The size of a 2D averaging filter used for smoothing the thickness map (default value is 5) 

% thmaps: The thickness map of the thin film [(M/2)*(M/2)*fN matrix] 

if nargin == 7 
    sthN = 5; 
end 

fN = length(fs); 

[~,Imax,Imin] = ImaxImin(filename,'input',[512,512],25); 
[refimg,refI] = ReferenceExtractor1(filename,refframe); 

colorimg = ImageExtractor1(filename,fs(1)); 
thmapsize = size(not(im2bw(colorimg))); 
thmaps = zeros(thmapsize(1),thmapsize(2),fN); 

for fi = 1:fN 
    
    frame = fs(fi); 
    
    cx_f = propvf_f(fi,2); cy_f = propvf_f(fi,3); cr_f = propvf_f(fi,4); 
    
    thmap = zeros(thmapsize(1),thmapsize(2)); 
    
    colorimg = ImageExtractor1(filename,frame); 
    
    for ci = 1:3 
        thmap = thmap+real(ThinFilmInterf((colorimg(:,:,ci)-refimg(:,:,ci)).*255+refI(ci),Imax(ci),Imin(ci),wavelengths(ci),n)); 
    end 
    
    thmap = thmap/3; 
    
    H = fspecial('average',sthN); 
    thmap = filter2(H,thmap); 
    
    thmap = ImageRefiller(thmap,NaN,'circle',[cx_f,cy_f],cr_f*ratio_f); 
    
    thmaps(:,:,fi) = thmap; 
    
end 

end 
