function h = ThinFilmInterf(I,Imax,Imin,wavelength,n) 

% The function calculates the thickness of an ultrathin film from the
% reflected light intensity based on the principle of thin film
% inteference, by following Scheludko in 1967 (1) 

% I: The reflected light intensity 
% Imax: The maximum value of the reflected light intensity 
% Imin: The minimum value of the reflected light intensity 
% wavelength: The light wavelength [nm] 
% n: The relative refractive index [1] 

% h: The thickness of the ultrathin film [nm] 

del = (I-Imin)./(Imax-Imin); % The normalized light intensity [1] 
R = (n-1)^2/(n+1)^2; % The Fresnel coefficient [1] 
h = wavelength./(2.*pi.*n).*asin(sqrt(del./(1+4.*R.*(1-del)./(1-R).^2))); 

% (1): A. Scheludko, Adv Colloid Interface Sci, 1967 

end 
