% User Parameters
p.pixSize = 0.5;    % microns
p.numLatPix = 128;       % number pixels per lateral dimension
p.zPixSize = p.pixSize; % for simplicity keep the same z spacing size as lateral pixels
p.numZPix = 128;
p.n = 1;                % refractive index of object medium
p.NA = 0.4;            % dimensionless
p.NAi = 0.4;
p.wl = 0.850;          % microns
%p.focalPlanes = -15:5:20;   %microns
numPlanes = 8;
p.focalPlanes = -15*cos(pi*linspace(0,1,numPlanes));
p.regFocalPlanes = p.focalPlanes(2:end-1);
p.noiseLevel = 1.81;
p.upSampFact = 1; % For sub-voxel registration
p.filterThreshold = 10;

% Object Parameters
p.obj.particleCount = 128;
p.obj.r = 1.5264;
p.obj.dn = 0.01; % This doesn't really mean anything in terms of absolute refractive index
p.obj.timeStart = 0;
p.obj.timeEnd = 1;
p.obj.numStacks = 128;
p.obj.velocity = [0.143; -22.21; -10.21]; % Constant added velocity
p.obj.movementAmplitude = [-7.44; 0; 6];
p.obj.movementPeriod = 1;
p.obj.numTimesPerFrame = 5; % Approximation of intra-frame blurring, should be odd number

% Calculated Parameters
p.k = single(p.n/p.wl);  
p.sfCutoff = single(p.NA/p.wl);
p.sfCutoffi = single(p.NAi/p.wl); 

% Compute the sub-focal plane planes
%fp = [p.focalPlanes,2*p.focalPlanes(end)-p.focalPlanes(end-1)]; % extrapolate one more real focal plane location
%extraFocalPlanes = (1:p.obj.numTimesPerFrame-1)'.*diff(fp)/p.obj.numTimesPerFrame;
%p.subFrameFocalPlanes = [fp(1:end-1);fp(1:end-1) + extraFocalPlanes]; % All the planes to image at in order to include motion blur
p.subFrameFocalPlanes = -15*cos(pi*linspace(0,1,numPlanes) + pi*floor(p.obj.numTimesPerFrame/2)/((numPlanes-1)*p.obj.numTimesPerFrame)*linspace(-1,1,5)');
clear extraFocalPlanes fp






