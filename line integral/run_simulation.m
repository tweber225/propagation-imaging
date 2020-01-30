
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

objSpecFilt = fftn(object).*ifftshift(ptf);
objFiltered = ifftn(objSpecFilt);


% Add noise
img = objFiltered + randn(size(objFiltered)).*1i*p.noiseLevel;

% Show object
toShow = thru_focus_axial_slice(imag(img),30,-24:6:24);
imshow(toShow)