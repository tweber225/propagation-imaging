function imgIntensityStack = intensity_imaging_moving(object,OTF,dn,focalPlaneLocations,noiseLevel)

numRealFocalPlanes = size(focalPlaneLocations,2); % The number of real frames per stack

% Reshape the object to match OTF
object = reshape(object,size(OTF));

% 2D Fourier transform object
objSpec= fft2(dn*single(object));

% Multiply shifted object spectrum by depth-dependent OTF, and
% integrate along z
imgIntensitySpectrum = sum(objSpec.*OTF,3); % dim 3 = Z

% Inverse FT to make real images and sum in (sub-frame) time
imgIntensity = sum(ifft2(imgIntensitySpectrum),5); % dim 5 = sub-frame time
imgIntensity = reshape(imgIntensity,[size(object,1),size(object,2),numRealFocalPlanes]);

% Add noise and cast to 8 bit
imgIntensityStack = uint8(128 + imgIntensity + noiseLevel*randn(size(imgIntensity)));





