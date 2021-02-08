%% Setup
% Add the support code
addpath ../foundation/

% Load parameters for this simulation. 
% Parameters will show up in structure called "p"
load_parameters

% Set up domains & pinhole function
% Structure "d" contains domain-related variables, like indices of positions, spatial frequencies, etc.
d = set_up_domains(p); 


%% Generate 3D Images
% Create the object 
movingObject = create_spherical_moving_object(d.posIdx,d.zPosIdx,p.obj);

% Create 3D asymmetric phase OTF
OTF = OTFp(p.sfCutoff,p.sfCutoffi,p.k,d.zPosIdx,d.sfIdx,'asym');

% Perform 3D imaging + noise
imgs = intensity_imaging_moving(movingObject,p.zPixSize,OTF,p.blurFocalPlanes,p.noiseLevel);

% Crop laterally
imgs = crop_images(imgs,p.cropFraction);



%% Attempt to 3D register

% Compute 3D Fourier Transform of each image stack
spectra = fft3(imgs);

% Generate filtering function from the phase OTF
cropSfIdx = d.sfIdx(1:1/p.cropFraction:end);
OTF3DFilter = generate_3D_OTF_filter(p.sfCutoff,p.sfCutoffi,p.k,p.focalPlanes,cropSfIdx,p.filterThreshold);


% Cross correlate first stack with each subsequent
clear xList yList zList
for tIdx = 2:size(imgs,4)
    % Perform frequency-domain cross correlation and upsample 
    xPowSpec = spectra(:,:,:,1).*conj(spectra(:,:,:,tIdx));
    xPowSpecNorm = xPowSpec./abs(xPowSpec);
    xPowSpecFilteredPadded = zero_pad_3D_fft(xPowSpecNorm.*OTF3DFilter,p.upSampFact);
    xCorr = fftshift3(real(ifft3(xPowSpecFilteredPadded)));    
    
    imagesc(squeeze(xCorr(end/2+1,:,:))');
    axis equal; drawnow
    pause(.01)
    
    % Collect maximum subscripts in xCorr
    [~,maxIdx] = max(xCorr(:));
    [y,x,z] = ind2sub(size(xCorr),maxIdx);
    xList(tIdx) = x;
    yList(tIdx) = y;
    zList(tIdx) = z;
    
end

