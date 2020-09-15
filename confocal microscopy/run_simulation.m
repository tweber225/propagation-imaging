
% range of Z (defocus)

load_params

d = set_up_domains(p);

PSF = generate_PSF(p,d);

% View XZ projection
imagesc(squeeze(sum(PSF,2))')
axis equal tight
colormap gray