% User Parameters
p.pixSize = 0.5;    % microns
p.numLatPix = 64;       % number pixels per lateral dimension
p.zPixSize = p.pixSize; % for simplicity keep the same z spacing size as lateral pixels
p.numZPix = 128;
p.n = 1;                % refractive index of object medium
p.NA = 0.4;            % dimensionless
p.NAi = 0.4;
p.wl = 0.850;          % microns
p.focalPlanes = -28:4:28;   %microns
p.noiseLevel = 0/100;   % inverse SNR;

% Object Parameters
p.obj.r = 2.51;
p.obj.dn = 0.05;
p.obj.centerStartPos = [.1; .234; 0];
p.obj.numTimePoints = 128; % absolute time doesn't really matter
p.obj.velocity = [0; 0; .2];

% Calculated Parameters
p.k = single(p.n/p.wl);  
p.sfCutoff = single(p.NA/p.wl);
p.sfCutoffi = single(p.NAi/p.wl); 