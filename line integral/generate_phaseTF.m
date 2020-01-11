function phaseTF = generate_phaseTF(p,kxdRequested,kydRequested,kzdRequested)
% Function to generate phase transfer function (TF) for a partially
% coherent microscope

% Extract some parameters from p structure
minNA = min(p.imagingNA,p.illuminationNA);
wl = p.lightWavelength;     % um

if strcmp(p.dataType,'single') % Convert parameters to requested data type
    kxdRequested = single(kxdRequested);
    kydRequested = single(kxdRequested);
    kzdRequested = single(kxdRequested);
    minNA = single(minNA);
    wl = single(wl);
end

% Autocalculated parameters
k = 1/wl;                   % um^-1
spatFreqLim = minNA*k;      % um^-1, defines int limits of line integral

% Make the CSFs, G
[H,Hi] = make_imaging_illumination_csfs(p);
G = make_greens_func(p);

% Make parameter index
tRequested = linspace(-spatFreqLim,spatFreqLim,p.numLineIntPoints);

% Make grids of kxd, kyd, kzd, and parameter t
[kxd,kyd,kzd,t] = ndgrid(kxdRequested,kydRequested,kzdRequested,tRequested);

% Save where kzd is 0
kzdCorrection = kzd(:,:,:,1) == 0;

% Transverse displacement
ktransd = sqrt(kxd.^2+kyd.^2);

% Compute intersection radii 
% (perp and par refer to perpendicular and parallel shift direction)
Rperp = sqrt(k^2 - (ktransd.^2+kzd.^2)/4);
Rpar = Rperp./sqrt(1 + ktransd.^2./kzd.^2);

% Parameterize kx, ky, kz and derivatives
kpar = sign(kzd).*Rpar.*cos(t);
kperp = Rperp.*sin(t);
theta = atan2(kyd,kxd);

kx = cos(theta).*kpar - sin(theta).*kperp;
ky = sin(theta).*kpar + cos(theta).*kperp;

clear kpar kperp theta

dkxdt = Rpar.*sin(t);
dkydt = Rperp.*cos(t);
dkzdt = -Rpar.*(ktransd./kzd).*sin(t);

clear ktransd Rpar Rperp t kzd

% Break up the integrand a bit
arcLengthTerm = sqrt(dkxdt.^2 + dkydt.^2 + dkzdt.^2); clear dkxdt dkydt dkzdt
HtimesHStar = H(kx+kxd/2,ky+kyd/2).*conj(H(kx-kxd/2,ky-kyd/2));
GstarModsqrHi = conj(G(kx-kxd/2,ky-kyd/2)).*abs(Hi(-kx-kxd/2,-ky-kyd/2)).^2;
GModsqrHi = G(kx+kxd/2,ky+kyd/2).*abs(Hi(-kx+kxd/2,-ky+kyd/2)).^2;

clear kxd kyd

% Integrate along parameter t (dimension 4)
integrand = HtimesHStar.*(GstarModsqrHi + GModsqrHi).*arcLengthTerm;
clear arcLengthTerm HtimesHStar GstarModsqrHi GModsqrHi
phaseTF = sum(integrand,4);

% Correct where kzd = 0
phaseTF(kzdCorrection) = 0;




