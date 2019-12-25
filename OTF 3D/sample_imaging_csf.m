function csf = sample_imaging_csf(p,kx,ky,kz,w)


% Calculate the max transverse frequency
transFreqCutOffIllum = p.imagingNA/p.lightWavelength;


% Truncate kz to fit inside NA
kzTrunc = kz.*((kx.^2+ky.^2) < transFreqCutOffIllum^2);
kzNotZero = kzTrunc>0;

% Make the sampled point locations of the imaging CSF
csf = [kx(kzNotZero) ky(kzNotZero) kz(kzNotZero) w(kzNotZero)];


