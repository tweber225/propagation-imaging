% Parameters
p.sampDens = 0.1;   % microns
p.numPoints = 128;  % number
p.zRange = 15;      % microns, plus or minus from in-focus
p.n = 1.333;        % refractive index of object medium


% Illumination
p.NAi = 0.95;           % aperture limiting aperture for illumination
p.wli = 0.561;          % microns
p.zOffseti = 0;         % microns axial displacement
p.waisti = .2;          % fraction of full pupil

% Detection
p.NAd = 0.95;            % dimensionless
p.wld = 0.610;          % microns
p.pinholeDiam = 1.41;   % microns in sample, don't do exactly 0 for small pinhole
p.zOffsetd = 0;         % microns axial displacement
p.upPin = true;
p.upPinOffset = 5.97;    % microns


% Calculated
p.ki = single(1000*p.n/p.wli);  % now in inverse mm
p.kd = single(1000*p.n/p.wld);  

p.sfCuti = single(1000*p.NAi/p.wli); % inverse mm
p.sfCutd = single(1000*p.NAd/p.wld); % spatial frequency cutoffs
p.waistiFWHM = p.waisti*2*p.sfCutd;

p.z = permute(-p.zRange:p.sampDens:p.zRange,[3 1 2]);
