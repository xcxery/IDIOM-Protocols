function [hvf_smp,havgvf_smp,hvt_smp,havgvt_smp,ftzero] = AverThicknEvol(filename,wavelengths,n,Is_smp,Imax,Imin) 

% The function is used to obtain the average thickness of a square sample
% region selected in a video 

% filename: The file name of the video 
% wavelengths: % The wavelengths of red, green and blue lights [nm] 
% n: The relative refractive index [1] 
% Is_smp: The average intensity within the sample region, for three RGB channels 
% Imax: The maximum value of the average intensity, for three RGB channels 
% Imin: The minimum value of the average intensity, for three RGB channels 

% hvf_smp: The average thickness vs. frame plot, for three RGB channels 
% havgvf_smp: The average thickness vs. frame plot, averaging through three RGB channels 
% hvt_smp: The average thickness vs. time plot, for three RGB channels 
% havgvt_smp: The average thickness vs. time plot, averaging through three RGB channels 
% ftzero: The frame index of the video frame which corresponds to the onset time 

% Obtain the average thickness vs. frame plot 
fileID1 = fopen(sprintf('%s.cih',filename),'r'); 
fileID2 = fopen(sprintf('%s.mraw',filename),'r'); 
info = HeaderReader(filename); 

if fileID1 < 1 || fileID2 < 1 
    error('The file is incomplete. '); 
end 

hvf_smp = zeros(size(Is_smp,1),4); 
havgvf_smp = zeros(size(Is_smp,1),2); 

for i = 1:size(Is_smp,1) 
    
    hvf_smp(i,1) = double(i); 
    hvf_smp(i,2) = smooth(real(ThinFilmInterf(Is_smp(i,1),Imax(1),Imin(1),wavelengths(1),n))); % The thickness obtained from the red channel [nm] 
    hvf_smp(i,3) = smooth(real(ThinFilmInterf(Is_smp(i,2),Imax(2),Imin(2),wavelengths(2),n))); % The thickness obtained from the green channel [nm] 
    hvf_smp(i,4) = smooth(real(ThinFilmInterf(Is_smp(i,3),Imax(3),Imin(3),wavelengths(3),n))); % The thickness obtained from the blue channel [nm] 
    havgvf_smp(i,1) = double(i); 
    havgvf_smp(i,2) = (hvf_smp(i,2)+hvf_smp(i,3)+hvf_smp(i,4))/3; % The thickness obtained by averaging through three channels [nm] 
    
end 

% Obtain the frame index of the video frame which corresponds to the onset time 
fhbmax = hvf_smp(hvf_smp(:,4) == max(hvf_smp(:,4)),1); ftzero = fhbmax; 
fhrmax = hvf_smp(hvf_smp(:,2) == max(hvf_smp(:,2)),1); 
N = fhbmax-fhrmax+1; 

if N >= 10 
    fhrmax = round(fhrmax-N/10); 
else 
    fhrmax = fhrmax-1; 
end 

if fhrmax < 1 
    fhrmax = hvf_smp(hvf_smp(:,2) == max(hvf_smp(:,2)),1); 
end 

% Obtain the average thickness vs. time plot 
hvt_smp = hvf_smp; 
havgvt_smp = havgvf_smp; 

for i = 1:size(Is_smp,1) 
    hvt_smp(i,1) = (double(i)-fhbmax)/info.framerate; % [s] 
    havgvt_smp(i,1) = (double(i)-fhbmax)/info.framerate; % [s] 
end 

for i = 1:fhrmax 
    hvt_smp(1,:) = []; 
    havgvt_smp(1,:) = []; 
end 

fclose(fileID1); 
fclose(fileID2); 

end 
