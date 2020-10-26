
% range of Z (defocus)

load_params

d = set_up_domains(p);

[PSFi,PSFd,PSF] = generate_PSF(p,d);

% Compare lateral line profiles
lineProfi = squeeze(PSFi(p.numPoints/2+1,:,p.zRange/p.sampDens+1))/max(PSFi,[],'all');
lineProfd = squeeze(PSFd(p.numPoints/2+1,:,p.zRange/p.sampDens+1))/max(PSFd,[],'all');
plot(d.positionIdx,lineProfi,d.positionIdx,lineProfd);


% View XZ projection
figure;
imagesc(squeeze(sum(PSFd,2))')
axis equal tight
colormap gray