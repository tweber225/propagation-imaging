% Add the support code
addpath ../foundation/

% Load parameters for this simulation. 
% Parameters will show up in structure called "p"
load_params_nikon16x
%load_params_olympus20x

% Set up domains & pinhole function
% Structure "d" contains domain-related variables, like indices of positions, spatial frequencies, etc.
d = set_up_domains(p); 
d.pinhole = make_pinhole(d.posIdx,p.pinholeDiam/2);

% Calculate elongated Gaussian illumination PSF
illumPSF = incoherent_PSF_Gaussian(d.sfIdx,p.sfCutoff_ex,p.excitationBeamGaussianFWHM,p.k_ex,d.zPosIdx);

% Calculate occluded detection PSFs (first pinhole not occluded)
detectPSF = create_occluded_PSF(d.pinhole,p.pinholeSeparation,d.posIdx,d.emZPosIdx,d.sfIdx,p.k_em,p.sfCutoff_em);

% Compute full confocal PSF (illumination PSF x detection PSF)
fullPSF = illumPSF.*detectPSF;



% Save projection results
projImage = permute(squeeze(sum(fullPSF)),[2 1 3]); % after the projection & dim squeeze, pinhole # is dim 3
saveastiff(projImage,'multi-z_shadowed_PSFs.tif')
