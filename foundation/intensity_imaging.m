function imgIntensity = intensity_imaging(object,pixSize,OTF,focalPlaneLocations,noiseLevel)

numFocalPlanes = numel(focalPlaneLocations);

% 2D Fourier transform object
objSpec= fft2(object);

% Allocate some space for the imaged spectra
imgIntensitySpectrumStack = complex(zeros(size(object,1),size(object,2),numFocalPlanes,size(object,4),'single'));

% Create each focal plane intensity image
for focalPlaneIdx = 1:numFocalPlanes
    focalPlaneOffset = focalPlaneLocations(focalPlaneIdx);
    zPixelShift = focalPlaneOffset./pixSize;
    
    % Move object in Z
    shiftedObjectSpectrum = circshift(objSpec,zPixelShift,3);
    
    % Multiply shifted object spectrum by depth-dependent OTF, and
    % integrate along z
    imgIntensitySpectrumStack(:,:,focalPlaneIdx,:) = sum(shiftedObjectSpectrum.*OTF,3);
    
end

% Compute images from spectra
imgIntensity = imag(fft2(imgIntensitySpectrumStack));

% Add some Gaussian noise
signalRange = max(imgIntensity(:)) - min(imgIntensity(:));
imgIntensity = imgIntensity + randn(size(imgIntensity))*signalRange*noiseLevel;

