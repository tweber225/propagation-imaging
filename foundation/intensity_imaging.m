function imgIntensity = intensity_imaging(object,pixSize,OTF,numFocalPlanes,planeLocations)


% Check that object and OTF have same dimensions
if sum(size(object) ~= size(OTF))
    error('Object and OTF must be same size in all 3 dimensions')
end

% 2D Fourier transform object
objSpec= fft2(object);

% Create each focal plane intensity image
imgIntensitySpectrumStack = complex(zeros(size(OTF,1),size(OTF,2),numFocalPlanes,'single'));
for focalPlaneIdx = 1:numFocalPlanes
    focalPlaneOffset = planeLocations(focalPlaneIdx);
    zPixelShift = focalPlaneOffset./pixSize;
    
    % Move object in Z
    shiftedObjectSpectrum = circshift(objSpec,zPixelShift,3);
    
    % Multiply shifted object spectrum by depth-dependent OTF, and
    % integrate along z
    imgIntensitySpectrumStack(:,:,focalPlaneIdx) = sum(shiftedObjectSpectrum.*OTF,3);
    
end


% Compute images from spectra
imgIntensity = real(fft2(imgIntensitySpectrumStack));
