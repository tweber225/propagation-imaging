function [coords,amps] = sample_illumination_csf(p,kx,ky,kz,w)



% Calculate the max transverse frequency for illumination
transFreqCutOffIllum = p.illuminationNA/p.lightWavelength;

% Truncate kz to fit inside NA
kzTrunc = kz.*((kx.^2+ky.^2) < transFreqCutOffIllum^2);

% Asymmetric illumination
if p.asymIllum 
    kzTrunc = kzTrunc.*(kx<=0);
    w(kx==0) = 0.5*w(kx==0);
end
    
% Find points that aren't zero 
kzNotZero = kzTrunc>0;

% Make the sampled point locations of the illumination CSF
coords = [kx(kzNotZero) ky(kzNotZero) kz(kzNotZero)];
amps = w(kzNotZero);


