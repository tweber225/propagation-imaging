
% Load the parameters for the simulation
load_params

% Add subfolder to make all the utility files visible
addpath('utilities')



%% Generate OTF
% Determine spatial frequency range
[mu_x,mu_y,eta] = set_spatial_freq_range(p);

% Generate transfer functions
[ptf,atf] = generate_TF_exact(p,mu_x,mu_y,eta);

% Pad the transfer functions to the right sizes
[ptf,atf] = pad_TFs(ptf,atf,p);


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

% Show object
toShowPhase = thru_focus_axial_slice(imgPhase,20,-20:4:20);
toShowAbsorption = thru_focus_axial_slice(imgAbsorption,20,-20:4:20);
subplot(2,1,1)
imshow(toShowPhase)
subplot(2,1,2)
imshow(toShowAbsorption)