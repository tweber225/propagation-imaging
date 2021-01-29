% User Parameters
p.pixSize = 0.5;    % microns
p.numLatPix = 64;       % number pixels per lateral dimension
p.zPixSize = p.pixSize; % for simplicity keep the same z spacing size as lateral pixels
p.numZPix = 128;
p.n = 1;                % refractive index of object medium
p.NA = 0.4;            % dimensionless
p.NAi = 0.4;
p.wl = 0.850;          % microns
p.focalPlanes = -20:5:20;   %microns

% Object Parameters
p.r = 1.51;
p.dn = 0.05;
p.centerStartPos = [.1, .234, 0];
p.numTimePoints = 128; % absolute time doesn't really matter
p.objVelocity = [.001,.03,.1];

% Calculated Parameters
p.numFocalPlanes = numel(p.focalPlanes);
p.k = single(p.n/p.wl);  
p.sfCutoff = single(p.NA/p.wl);
p.sfCutoffi = single(p.NAi/p.wl); 