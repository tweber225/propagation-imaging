%% Setup
% Add the support code
addpath ../foundation/

% Load parameters for this simulation. 
% Parameters will show up in structure called "p"
load_parameters

% Set up domains & pinhole function
% Structure "d" contains domain-related variables, like indices of positions, spatial frequencies, etc.
d = set_up_domains(p); 


%% Create 3D asymmetric phase OTF

% First set up an array of exact focal plane locations to evaluate 3D OTF
% (1st and 2nd dimensions are reserved for object X, axes)
zPosToEvaluate = permute(d.zPosIdx, [1 3 2]); % 3rd dimension = Z postion (in object)
% (4th dim is reserved for time), 5th dim = sub-frame Z positions, 6th = (acquired) real focal plane
zPosToEvaluate = zPosToEvaluate + permute(p.subFrameFocalPlanes, [6,5,4,3,1,2]); 

% Make OTFs
OTF = OTFp(p.sfCutoff,p.sfCutoffi,p.k,zPosToEvaluate,d.sfIdx,'asym');


%% Set up object
% Make random center starting positions (I sincerely apologize about how
% ridiculous the indexing is getting here). Dim7 = particle index
p.obj.centerStartPos = [2*(rand(1,1,1,1,1,1,p.obj.particleCount)-.5)*(d.posIdx(end)-d.posIdx(1)); ...
    2*(rand(1,1,1,1,1,1,p.obj.particleCount)-.5)*(d.posIdx(end)-d.posIdx(1)); ...
    2*(rand(1,1,1,1,1,1,p.obj.particleCount)-.5)*(d.zPosIdx(end)-d.zPosIdx(1))];

%% Generate intensity images

imgs = zeros(p.numLatPix,p.numLatPix,numel(p.focalPlanes),p.obj.numStacks,'uint8');
% Loop for each stack 
for stackIdx = 1:p.obj.numStacks
    % Display status
    disp(['Generating stack ' num2str(stackIdx) ' of ' num2str(p.obj.numStacks)])
    
    % Create the object 
    movingObject = create_spherical_moving_object(d.posIdx,d.zPosIdx,stackIdx,p.obj,p.subFrameFocalPlanes);

    % Perform 3D imaging + noise
    imgs(:,:,:,stackIdx) = intensity_imaging_moving(movingObject,OTF,p.obj.dn,p.subFrameFocalPlanes,p.noiseLevel);
end


%% Save as tiff stack
saveDirAndName = [cd filesep 'stacks.tif'];

% Interleave the 3D stack
imgsInterleaved = reshape(imgs,[size(imgs,1),size(imgs,2),size(imgs,3)*size(imgs,4)]);
save_tiff_stack(saveDirAndName,imgsInterleaved)

