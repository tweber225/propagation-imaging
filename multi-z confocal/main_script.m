% Add the support code
addpath ../foundation/

% Load parameters for this simulation
load_params_nikon16x

% Set up domains & pinhole function
d = set_up_domains(p);
d.pinhole = make_pinhole(d.posX(:,:,1),d.posY(:,:,1),p.pinholeDiam/2);

% Calculate elongated Gaussian illumination PSF
illumPSF = incoherent_PSF_Gaussian(d.sfX,d.sfY,p.sfCutoff_ex,p.exBeamFWHM,p.k_ex,d.posZ);

% Calculate effective detection PSF from diffraction-limited version and
% then convolution with pinhole spatial function
detectDiffLimPSF = incoherent_PSF(d.sfX,d.sfY,p.sfCutoff_em,p.k_em,d.posZ);
detectPSF = convn(detectDiffLimPSF,d.pinhole,'same');