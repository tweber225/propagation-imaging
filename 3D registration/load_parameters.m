% User Parameters
p.pixSize = 0.5;    % microns
p.numLatPix = 128;       % number pixels per lateral dimension
p.zPixSize = p.pixSize; % for simplicity keep the same z spacing size as lateral pixels
p.numZPix = 128;
p.n = 1;                % refractive index of object medium
p.NA = 0.4;            % dimensionless
p.NAi = 0.4;
p.wl = 0.850;          % microns
p.focalPlanes = -15:5:20;   %microns
p.noiseLevel = 1/10;   % inverse SNR;
p.cropFraction = 1;
p.upSampFact = 2;
p.filterThreshold = 10;

% Object Parameters
p.obj.particleCount = 16;
p.obj.r = 1.51;
p.obj.dn = 0.05;
%p.obj.centerStartPos = [-10; 0.123; -3];
p.obj.numTimePoints = 256; % absolute time doesn't really matter
p.obj.velocity = [0*2.2546; 0; -4.1254]/numel(p.focalPlanes);

% Calculated Parameters
p.k = single(p.n/p.wl);  
p.sfCutoff = single(p.NA/p.wl);
p.sfCutoffi = single(p.NAi/p.wl); 