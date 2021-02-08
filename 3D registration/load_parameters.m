% User Parameters
p.pixSize = 0.5;    % microns
p.numLatPix = 128;       % number pixels per lateral dimension
p.zPixSize = p.pixSize; % for simplicity keep the same z spacing size as lateral pixels
p.numZPix = 64;
p.n = 1;                % refractive index of object medium
p.NA = 0.4;            % dimensionless
p.NAi = 0.4;
p.wl = 0.850;          % microns
p.focalPlanes = -15:5:15;   %microns
p.noiseLevel = 1/10;   % inverse SNR;
p.cropFraction = 1;
p.upSampFact = 2;
p.filterThreshold = 10;

% Object Parameters
p.obj.particleCount = 4;
p.obj.r = 1.51;
p.obj.dn = 0.05;
p.obj.timeStart = 0;
p.obj.timeEnd = 1;
p.obj.numStacks = 32;
p.obj.velocity = [0.05; 0; .1]; 
p.obj.movementAmplitude = [-5; 0; 10];
p.obj.movementPeriod = 1;
p.obj.numTimesPerFrame = 2; % Approximation of intra-frame blurring

% Calculated Parameters
p.obj.numTimes = p.obj.numStacks*numel(p.focalPlanes)*p.obj.numTimesPerFrame; % Number of unique times
p.k = single(p.n/p.wl);  
p.sfCutoff = single(p.NA/p.wl);
p.sfCutoffi = single(p.NAi/p.wl); 

% Compute the sub-focal plane planes
fp = [p.focalPlanes,2*p.focalPlanes(end)-p.focalPlanes(end-1)];
p.blurFocalPlanes = [fp(1:end-1);fp(1:end-1)+diff(fp)/p.obj.numTimesPerFrame]; % All the planes to image at to include motion blur