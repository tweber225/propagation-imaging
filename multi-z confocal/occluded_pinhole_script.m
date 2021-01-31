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

% Calculate occluded detection PSF:
% Propagate image of pinhole spots to upstream blocking pinhole
pinholeSpots = make_pinhole_spots(d.pinhole);
pinholeImg = fftshift2(fft2(pinholeSpots)).*H(d.sfIdx,p.sfCutoff_em);
pinholeProp = pinholeImg.*D(d.sfIdx,p.k_em,p.pinholeSeparation);
% Apply blocking mask (inverse of pinhole)
pinholeBlocked = convn(pinholeProp,fftshift(fft2(~d.pinhole)),'same');
% Propagate back to original plane
pinholePropBack = pinholeBlocked.*D(d.sfIdx,p.k_em,-p.pinholeSeparation);
% Use 3D CTF
CTF = create_circular_CTF(d.sfIdx,p.sfCutoff_em,p.k_em,d.zPosIdx);
detect3D = ifft2(ifftshift2(pinholePropBack.*CTF));
detectPSF = sum(detect3D.*conj(detect3D),4); % Integrate all the pinhole spots (incoherently)


fullPSF = illumPSF.*detectPSF;



% Save projection results
%projImage = permute(squeeze(sum(fullPSF)),[2 1 3]); % after the projection & dim squeeze, pinhole # is dim 3
%saveastiff(projImage,'multi-z_shadowed_PSFs.tif')
