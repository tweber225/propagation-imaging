
% Load the parameters for the simulation
load_params

% Add subfolder to make all the utility files visible
addpath('utilities')



%% Generate OTF
% Determine spatial frequency range
[mu_x,mu_y,eta] = set_spatial_freq_range(p);

% Generate transfer functions
[ptf,atf] = generate_TF_paraxial(p,mu_x,mu_y,eta);

% Pad the transfer functions to the right sizes
[ptf,atf] = pad_TFs(ptf,atf,p);

% Set NaNs to 0
ptf(isnan(ptf)) = 0;

%% Filter object

% Make 3d object
object = make_3d_object(p);

% Filter with phase and absorption TFs
objSpecFiltPhase = fftn(object).*ifftshift(ptf);
objFilteredPhase = real(1i*ifftn(objSpecFiltPhase));
objSpecFiltAbsorption = fftn(object).*ifftshift(atf);
objFilteredAbsorption = real(ifftn(objSpecFiltAbsorption));

% Add noise
imgPhase = objFilteredPhase + randn(size(objFilteredPhase)).*p.noiseLevel;
imgAbsorption = objFilteredAbsorption + randn(size(objFilteredAbsorption)).*p.noiseLevel;

%% Show object phase image
crop = 24;
toShowPhase = thru_focus_axial_slice(imgPhase,crop,-30:6:30);

imshow(toShowPhase(:,1:(end-2*crop)))
figure
imshow(toShowPhase(:,(end-2*crop+1):end))



