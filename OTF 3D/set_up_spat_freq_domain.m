function [kx,ky,kz,w,kIdx] = set_up_spat_freq_domain(p)

% Calculate Nyquist (maxSpFreq), array size, and sp freq. cycles per pixel
maxSpFreq = 1/(2*p.pixelSize);
arraySize = p.objectSize/p.pixelSize;
spFreqPix = maxSpFreq/(arraySize/2);

% Make k_transverse index
k1 = 0:spFreqPix:maxSpFreq;
kIdx = single([-k1(end:-1:2) k1(1:(end-1))]);

% Make transverse k meshgrid
[kx,ky] = meshgrid(kIdx,kIdx);

% Make kz from kxy
k = 1/p.lightWavelength;
kz = real(sqrt(k^2 - kx.^2 - ky.^2));

% Make weights
w = k./kz;