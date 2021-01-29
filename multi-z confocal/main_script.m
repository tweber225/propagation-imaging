% Add the support code
addpath ../foundation/

% Load parameters for this simulation. 
% Parameters will show up in structure called "p"
load_params_nikon16x

% Set up domains & pinhole function
% Structure "d" contains domain-related variables, like indices of positions, spatial frequencies, etc.
d = set_up_domains(p); 
d.pinhole = make_pinhole(d.posIdx,p.pinholeDiam/2);

% Calculate elongated Gaussian illumination PSF
illumPSF = incoherent_PSF_Gaussian(d.sfIdx,p.sfCutoff_ex,p.excitationBeamGaussianFWHM,p.k_ex,d.ZPosIdx);

% Calculate detection PSF from diffraction-limited version convolved with pinhole spatial function
detectDiffLimPSF = incoherent_PSF(d.sfIdx,p.sfCutoff_em,p.k_em,d.emZPosIdx);
detectPSF = convn(detectDiffLimPSF,d.pinhole,'same');
fullPSF = illumPSF.*detectPSF;

% Save projection results
projImage = permute(squeeze(sum(fullPSF)),[2 1 3]); % after the projection & dim squeeze, pinhole # is dim 3
saveastiff(projImage,'multi-z_PSFs.tif')
