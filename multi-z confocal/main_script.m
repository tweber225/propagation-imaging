% Add the support code
addpath ../foundation/

% Load parameters for this simulation
load_params_nikon16x

% Set up domains & pinhole function
d = set_up_domains(p);
d.pinhole = make_pinhole(d.posIdx,p.pinholeDiam/2);

% Calculate elongated Gaussian illumination PSF
illumPSF = incoherent_PSF_Gaussian(d.sfIdx,p.sfCutoff_ex,p.excitationBeamGaussianFWHM,p.k_ex,d.ZPosIdx);

% Calculate effective detection PSF from diffraction-limited version and
% then convolution with pinhole spatial function
detectDiffLimPSF = incoherent_PSF(d.sfIdx,p.sfCutoff_em,p.k_em,d.ZPosIdx);
detectPSF = convn(detectDiffLimPSF,d.pinhole,'same');