function OTF3DFilter = generate_3D_OTF_filter(sfCutoff,sfCutoffi,k,focalPlanes,sfIdx,filterThreshold);

% Shift the focal planes so they are in FFT-style ordering (DC in vector
% position #1)
shiftedFocalPlanes = ifftshift(focalPlanes);

% Compute the (2D) phase OTF as basis
OTFFocalPlanes = OTFp(sfCutoff,sfCutoffi,k,shiftedFocalPlanes,sfIdx,'asym');

% FT in 3rd dimension to make this a full 3D OTF
OTF3D = fft(OTFFocalPlanes,size(OTFFocalPlanes,3),3);

% Threshold the magnitude to generate binary 3D filter
OTF3DFilter = abs(OTF3D) > filterThreshold;


