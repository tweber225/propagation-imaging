% User Input Parameters
p.overSampling = 8;
p.realPixSize = 1.15;  % True size of microscope pixels.
p.simulationPixSize = p.realPixSize/p.overSampling;    % microns
p.numLatPix = 64*p.overSampling;       % number pixels per lateral dimension
p.numZPix = 256;
p.n = 1.332;                % refractive index of object medium
p.NA_em = 0.8;            % dimensionless
p.NA_ex = 0.19;
p.excitationBeamGaussianFWHM = 1000; % enter high number for plane wave.
p.wl_ex = 0.561;        % excitation wavelength
p.wl_em = 0.610;        % emission (center) wavelength
p.pinholeDiam = 1.8;  % microns

% Calculated Domains and Parameters
p.k_ex = single(p.n/p.wl_ex);
p.k_em = single(p.n/p.wl_em);
p.sfCutoff_ex = single(p.NA_ex/p.wl_ex);
p.sfCutoff_em = single(p.NA_em/p.wl_em);