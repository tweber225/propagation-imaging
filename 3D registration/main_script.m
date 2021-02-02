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

% Smooth the object a tad
movingObject = convn(movingObject,ones(3,3,3),'same');

% Create 3D asymmetric phase OTF
OTF = OTFp(p,d,'asym');

% Perform 3D imaging + noise
imgs = intensity_imaging(movingObject,p.zPixSize,OTF,p.focalPlanes,p.noiseLevel);



%% Attempt to 3D register
spectra = fft3(imgs,[size(imgs,1) size(imgs,1) size(imgs,1)]);

% Cross correlate first stack with each subsequent
for tIdx = 2:size(imgs,4)
    xPowSpec = spectra(:,:,:,1).*conj(spectra(:,:,:,tIdx));
    xCorr = fftshift3(real(ifft2(xPowSpec./abs(xPowSpec))));
    
    

    
    % Report Peak
    [~,maxIdx] = max(xCorr(:));
    [y,x,z] = ind2sub(size(xCorr),maxIdx);
    disp(z)
    
end

