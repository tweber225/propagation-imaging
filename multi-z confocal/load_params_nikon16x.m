% User Input Parameters
p.overSampling = 8;
p.realPixSize = 1.151;  % True size of microscope pixels.
p.simulationPixSize = p.realPixSize/p.overSampling;    % microns
p.numLatPix = 64*p.overSampling;       % number pixels per lateral dimension
p.zSpacing = p.realPixSize;
p.numZPix = 256;
p.n = 1.332;                % refractive index of object medium
p.NA = 0.8;            % dimensionless
p.exBeamFWHM = 0.18;     % FRACTION of pupil for INTENSITY FWHM
p.wl_ex = 0.561;        % excitation wavelength
p.wl_em = 0.610;        % emission (center) wavelength
p.focalPlanes = -(16*p.zSpacing):p.zSpacing:(16*p.zSpacing);   %microns
p.pinholeDiam = 1.296;  % microns

% Calculated Domains and Parameters
p.numFocalPlanes = numel(p.focalPlanes);
p.k_ex = single(p.n/p.wl_ex);
p.k_em = single(p.n/p.wl_em);  
p.sfCutoff_ex = single(p.NA/p.wl_ex);
p.sfCutoff_em = single(p.NA/p.wl_em);
