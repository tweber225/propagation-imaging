% Parameters
p.NA = 0.5;         % dimensionless
p.wl = 0.561;       % microns
p.sampDens = 0.1;   % microns
p.numPoints = 256;  % number
p.zRange = 20;      % microns, plus or minus from in-focus


% Calculated
p.k = single(1000/p.wl);
p.spatFreqCut = single(p.NA*p.k);
p.z = permute(-p.zRange:p.sampDens:p.zRange,[3 1 2]);
