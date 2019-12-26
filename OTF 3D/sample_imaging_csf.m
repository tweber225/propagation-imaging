function [coords,amps] = sample_imaging_csf(p,kx,ky,kz,w)


% Calculate the max transverse frequency
transFreqCutOffIllum = p.imagingNA/p.lightWavelength;


% Truncate kz to fit inside NA
kzTrunc = kz.*((kx.^2+ky.^2) < transFreqCutOffIllum^2);
kzNotZero = kzTrunc>0;


% Add pupil phase
p = sqrt(kx.^2+ky.^2);
p = p/max(p(kzNotZero));
%w = w.*exp(-2i*pi*(2*p.^2-1));
%w = w.*exp(-2i*pi*.2*(6*p.^4-6*p.^2+1));
%w = w.*exp(2i*pi*.35*randn(size(w)));

% Make the sampled point locations of the imaging CSF
coords = [kx(kzNotZero) ky(kzNotZero) kz(kzNotZero)];
amps = w(kzNotZero);




