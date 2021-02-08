function imgIntensity = intensity_imaging_moving(object,pixSize,OTF,focalPlaneLocations,numTimesPerFrame,noiseLevel)

numFocalPlanes = numel(focalPlaneLocations);

% 2D Fourier transform object
objSpec= fft2(single(object));

% Allocate some space for the imaged spectra
imgIntensitySpectrumStack = complex(zeros(size(object,1),size(object,2),numFocalPlanes,size(object,4)/numFocalPlanes,'single'));

% Create each focal plane intensity image
for focalPlaneIdx = 1:numFocalPlanes
    focalPlaneOffset = focalPlaneLocations(focalPlaneIdx);
    zPixelShift = focalPlaneOffset./pixSize;
    
    % Move object in Z
    shiftedObjectSpectrum = circshift(objSpec(:,:,:,focalPlaneIdx:numFocalPlanes:end),zPixelShift,3);
    
    % Multiply shifted object spectrum by depth-dependent OTF, and
    % integrate along z
    imgIntensitySpectrumStack(:,:,focalPlaneIdx,:) = sum(shiftedObjectSpectrum.*OTF,3);
    
end

% Compute images from spectra
imgIntensity = real(fft2(imgIntensitySpectrumStack));

% Blur frames

% Add some Gaussian noise
signalRange = max(imgIntensity(:)) - min(imgIntensity(:));
imgIntensity = imgIntensity + randn(size(imgIntensity))*signalRange*noiseLevel;

