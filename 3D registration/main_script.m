%% Setup
% Add the support code
addpath ../foundation/

% Load parameters for this simulation. 
% Parameters will show up in structure called "p"
load_parameters

% Set up domains & pinhole function
% Structure "d" contains domain-related variables, like indices of positions, spatial frequencies, etc.
d = set_up_domains(p); 


%% Load 3D Images
% Form filename, and load the interleaved stack
saveDirAndName = [cd filesep 'stacks.tif'];
interleavedStack = load_tiff_stack(saveDirAndName);

% Deinterleave and convert to floating point
imgs = single(reshape(interleavedStack,[size(interleavedStack,1),size(interleavedStack,2),numel(p.focalPlanes),p.obj.numStacks]));

% Add extra noise
imgs = imgs + 6*randn(size(imgs));

% Select focal planes
imgs = imgs(:,:,find(p.focalPlanes == p.regFocalPlanes(1)):find(p.focalPlanes == p.regFocalPlanes(end)),:);

%% 3D registration & auto-mosiacing

% Remove background & zero pad
bg = 128;
imgsPadded = padarray(imgs - bg,[size(imgs,1),size(imgs,2),size(imgs,3)]/2,0,'both');

% Compute 3D Fourier Transform of each image stack
spectra = fft3(imgsPadded);

% Generate filtering function from the phase OTF
% Make new spatial frequency index
dSf = single(2*d.maxSf/(2*p.numLatPix));
cropSfIdx = -d.maxSf:dSf:(d.maxSf-dSf);
% Extrapolate extra focal planes for padding
bottomExtraPlanes = mean(diff(p.regFocalPlanes))*(-numel(p.regFocalPlanes)/2:1:-1) + p.regFocalPlanes(1);
topExtraPlanes = mean(diff(p.regFocalPlanes))*(1:numel(p.regFocalPlanes)/2) + p.regFocalPlanes(end);
registeredFocalPlanes = [bottomExtraPlanes p.regFocalPlanes topExtraPlanes];
OTF3DFilter = generate_3D_OTF_filter(p.sfCutoff,p.sfCutoffi,p.k,registeredFocalPlanes,cropSfIdx,p.filterThreshold);

% Initialize the summing stack with the first frame
sumStack = imgsPadded(:,:,:,1);

% Also track how many samples averaged at each data point, initialize with
% just the data at first stack location
onesStack = ones(size(imgs(:,:,:,1)),'single');
onesStack = padarray(onesStack,[size(imgs,1),size(imgs,2),size(imgs,3)]/2,0,'both');
numAveragedSamplesStack = onesStack;

% Cross correlate average stack with each subsequent frame
for tIdx = 2:size(imgs,4)
    % Calculate the new "average" stack
    avgStack = sumStack./(numAveragedSamplesStack+eps);
    
    % Perform frequency-domain cross correlation and upsample 
    xPowSpec = fft3(avgStack).*conj(spectra(:,:,:,tIdx));
    xPowSpecNorm = xPowSpec./(abs(xPowSpec) + eps('single'));
    xPowSpecFilteredPadded = zero_pad_3D_fft(xPowSpecNorm.*OTF3DFilter,p.upSampFact);
    xCorr = fftshift3(real(ifft3(xPowSpecFilteredPadded)));    
    
    % Collect maximum subscripts in xCorr
    [maxVal,maxIdx] = max(xCorr(:));
    [y,x,z] = ind2sub(size(xCorr),maxIdx);
    
    % Shift the stack and sum into sumStack
    shiftAmounts = [y,x,z] - [size(sumStack,1)/2+1,size(sumStack,2)/2+1,size(sumStack,3)/2+1];
    sumStack = sumStack + circshift(imgsPadded(:,:,:,tIdx),-shiftAmounts);
    
    % Shift the onesStack and add to numAveragedStack
    numAveragedSamplesStack = numAveragedSamplesStack + circshift(onesStack,-shiftAmounts);
    
    imagesc(avgStack(:,:,4));axis equal;colormap gray
    drawnow
    pause(.05)
    
end

% Calculate one last average stack
avgStack = sumStack./(numAveragedSamplesStack+eps);

