% Parameters
p.sampDens = 0.1;   % microns
p.numPoints = 256;  % number
p.zRange = 30;      % microns, plus or minus from in-focus


% Illumination
%p.NAi = 0.24;           % dimensionless
p.wli = 0.561;          % microns
p.zOffseti = 0;         % microns axial displacement
p.waisti = .2;          % fraction of full pupil

% Detection
p.NAd = 0.95;            % dimensionless
p.wld = 0.610;          % microns
p.pinholeDiam = 1.4;   % microns in sample, don't do exactly 0 for small pinhole
p.zOffsetd = 5.5;         % microns axial displacement


% Calculated
p.ki = single(1000/p.wli);
p.kd = single(1000/p.wld);

%p.sfCuti = single(p.NAi*p.ki); 
p.sfCutd = single(p.NAd*p.kd); % spatial frequency cutoffs
p.waistiFWHM = p.waisti*2*p.sfCutd;

p.z = permute(-p.zRange:p.sampDens:p.zRange,[3 1 2]);
