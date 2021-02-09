% User Parameters
p.pixSize = 0.5;    % microns
p.numLatPix = 256;       % number pixels per lateral dimension
p.zPixSize = p.pixSize; % for simplicity keep the same z spacing size as lateral pixels
p.numZPix = 128;
p.n = 1;                % refractive index of object medium
p.NA = 0.4;            % dimensionless
p.NAi = 0.4;
p.wl = 0.850;          % microns
p.focalPlanes = -15:5:20;   %microns
p.noiseLevel = 1.81;
p.upSampFact = 1; % For sub-voxel registration
p.filterThreshold = 10;

% Object Parameters
p.obj.particleCount = 512;
p.obj.r = 1.51;
p.obj.dn = 0.01; % This doesn't really mean anything in terms of absolute refractive index
p.obj.timeStart = 0;
p.obj.timeEnd = 1;
p.obj.numStacks = 64;
p.obj.velocity = [0.743; -22.21; -10.21]; % Constant added velocity
p.obj.movementAmplitude = [-9.44; 0; 6];
p.obj.movementPeriod = 1;
p.obj.numTimesPerFrame = 4; % Approximation of intra-frame blurring

% Calculated Parameters
p.k = single(p.n/p.wl);  
p.sfCutoff = single(p.NA/p.wl);
p.sfCutoffi = single(p.NAi/p.wl); 

% Compute the sub-focal plane planes
fp = [p.focalPlanes,2*p.focalPlanes(end)-p.focalPlanes(end-1)]; % extrapolate one more real focal plane location
extraFocalPlanes = (1:p.obj.numTimesPerFrame-1)'.*diff(fp)/p.obj.numTimesPerFrame;
p.subFrameFocalPlanes = [fp(1:end-1);fp(1:end-1) + extraFocalPlanes]; % All the planes to image at in order to include motion blur
clear extraFocalPlanes fp






