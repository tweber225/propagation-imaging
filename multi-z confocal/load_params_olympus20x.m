% User Input Parameters
p.overSampling = 10;
p.realPixSize = 1.15;  % True size of microscope pixels.
p.simulationPixSize = p.realPixSize/p.overSampling;    % microns
p.numLatPix = 14*p.overSampling;       % number pixels per lateral dimension
p.numZPix = 500;
p.n = 1.332;                % refractive index of object medium
p.NA_em = 1;            % dimensionless
p.NA_ex = 0.2;
p.excitationBeamGaussianFWHM = 1000; % enter high number for plane wave.
p.wl_ex = 0.561;        % excitation wavelength
p.wl_em = 0.610;        % emission (center) wavelength

p.pinholeDiam = 1.296;  % microns
p.numPinholes = 4;
p.pinholeSeparation = 5.97;
p.firstPinholeDepth = -5.97;

% Calculated Domains and Parameters
p.k_ex = single(p.n/p.wl_ex);
p.k_em = single(p.n/p.wl_em);
p.sfCutoff_ex = single(p.NA_ex/p.wl_ex);
p.sfCutoff_em = single(p.NA_em/p.wl_em);
