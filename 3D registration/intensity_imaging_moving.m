function imgIntensity = intensity_imaging_moving(object,pixSize,OTF,focalPlaneLocations,noiseLevel)

numRealFocalPlanes = size(focalPlaneLocations,2); % The number of real frames per stack
numTimesPerFrame = size(focalPlaneLocations,1); % Oversampling to approximate motion blur, the extra frames are summed into a single frame
numFramesPerStack = numRealFocalPlanes*numTimesPerFrame;
numStacks = size(object,4)/(numTimesPerFrame*numRealFocalPlanes); % number of actual acquired stacks

% 2D Fourier transform object
objSpec= fft2(single(object));

% Allocate space for the set of stacks (captured 3D image sets)
imgIntensitySpectrumStack = 

% Create each stack
for stackIdx = 1:numStacks
    stackStartTimeIdx = (stackIdx-1)*numFramesPerStack;
    
    % Create each sub-focal plane intensity image
    for focalPlaneIdx = 1:numRealFocalPlanes
        focalPlaneOffsets = focalPlaneLocations(:,focalPlaneIdx);
        zPixelShift = focalPlaneOffsets./pixSize;

        % Move object in Z
        timeSelection = stackStartTimeIdx + (focalPlaneIdx-1)*numTimesPerFrame + 1:numTimesPerFrame;
        shiftedObjectSpectrum = circshift(objSpec(:,:,:,timeSelection),zPixelShift,3);

        % Multiply shifted object spectrum by depth-dependent OTF, and
        % integrate along z
        imgIntensitySpectrum = sum(shiftedObjectSpectrum.*OTF,3);
        
        % Inverse FT to make real images and sum in (sub-frame) time
        imgIntensity(:,:,focalPlaneIdx,

    end

end

% Compute images from spectra
imgIntensity = real(fft2(imgIntensitySpectrumStack));

% Blur frames

% Add some Gaussian noise
signalRange = max(imgIntensity(:)) - min(imgIntensity(:));
imgIntensity = imgIntensity + randn(size(imgIntensity))*signalRange*noiseLevel;

