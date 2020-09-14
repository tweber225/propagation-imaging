%% RUN_SIMULATION
% Main script to call a series of functions which simulate 3D imaging of a
% weak absorption or phase object with a widefield transmission microscope.
% Degree of coherence is adjustable.
% 
% Timothy Weber
% Biomicroscopy Lab, BU
% April 2020


%% Set up: load the parameters, add subfolders to path
% Open "load_params" file to review all settings
load_params
addpath('utilities')


%% Generate OTF
% Determine spatial frequency range (variables correspond to Streibl's)
[mu_x,mu_y,eta] = set_spatial_freq_range(p);

% Generate transfer functions
[ptf,atf] = generate_TF_paraxial(p,mu_x,mu_y,eta);

% Pad the transfer functions to correct size
[ptf,atf] = pad_TFs(ptf,atf,p);


%% Filter object
object = make_3d_object(p);

% Filter with phase and absorption TFs
objectSpectrum = fftn(object);
objSpecFiltPhase = objectSpectrum.*ifftshift(ptf);
objFilteredPhase = real(1i*ifftn(objSpecFiltPhase));
objSpecFiltAbsorption = objectSpectrum.*ifftshift(atf);
objFilteredAbsorption = real(ifftn(objSpecFiltAbsorption));

% Add noise
imgPhase = objFilteredPhase + randn(size(objFilteredPhase)).*p.noiseLevel;
imgAbsorption = objFilteredAbsorption + randn(size(objFilteredAbsorption)).*p.noiseLevel;


%% Show simulated images
% Make composite through focus (axial sweep) images for display
compositeImgPhase = thru_focus_axial_slice(imgPhase,p.crop,p.frameThruFocusStartEnd,p.frameThruFocusdz);
compositeImgAbsorption = thru_focus_axial_slice(-imgAbsorption,p.crop,p.frameThruFocusStartEnd,p.frameThruFocusdz);

subplot(2,1,1)
imshow(compositeImgPhase)
title(['Phase: ' label_maker(p)])
subplot(2,1,2)
imshow(compositeImgAbsorption)
title(['Absorption: ' label_maker(p)])

