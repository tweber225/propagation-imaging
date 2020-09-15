% Parameters
p.sampDens = 0.1;   % microns
p.numPoints = 256;  % number
p.zRange = 30;      % microns, plus or minus from in-focus


% Illumination
p.NAi = 0.12;        % dimensionless
p.wli = 0.561;      % microns

% Detection
p.NAd = 0.5;            % dimensionless
p.wld = 0.610;          % microns
p.pinholeDiam = 2.88;   % microns in sample, don't do exactly 0 for small pinhole


% Calculated
p.ki = single(1000/p.wli);
p.kd = single(1000/p.wld);

p.sfCuti = single(p.NAi*p.ki); % spatial frequency cutoffs
p.sfCutd = single(p.NAd*p.kd);

p.z = permute(-p.zRange:p.sampDens:p.zRange,[3 1 2]);
