
% Load the parameters for the simulation
load_params

% Add subfolder to make all the utility files visible
addpath('utilities')

% Make 3d object
object = make_3d_object(p);

% Determine spatial frequency range
[mu_x,mu_y,eta] = set_spatial_freq_range(p);

% Generate transfer functions
[ptf,atf] = generate_TF_paraxial(p,mu_x,mu_y,eta);

% Pad the transfer functions to the right sizes
[ptf,atf] = pad_TFs(ptf,atf,p);