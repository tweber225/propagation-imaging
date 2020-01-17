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

dkpardt = Rpar.*sin(t);
dkperpdt = Rperp.*cos(t);
dkzdt = -Rpar.*(ktransd./kzd).*sin(t);
dkzdt(kzd == 0) = -Rperp(kzd == 0).*sin(t(kzd == 0)); % kzd = 0 correction

clear ktransd Rpar Rperp t kzd

% Break up the integrand a bit
arcLengthTerm = sqrt(dkpardt.^2 + dkperpdt.^2 + dkzdt.^2); clear dkpardt dkperpdt dkzdt
HtimesHStar = H(kx+kxd/2,ky+kyd/2).*conj(H(kx-kxd/2,ky-kyd/2));
GstarModsqrHi = conj(G(kx-kxd/2,ky-kyd/2)).*abs(Hi(-kx-kxd/2,-ky-kyd/2)).^2;
GModsqrHi = G(kx+kxd/2,ky+kyd/2).*abs(Hi(-kx+kxd/2,-ky+kyd/2)).^2;

clear kxd kyd

% Integrate along parameter t (dimension 4)
integrand = HtimesHStar.*(GstarModsqrHi - GModsqrHi).*arcLengthTerm;
clear arcLengthTerm HtimesHStar GstarModsqrHi GModsqrHi
phaseTF = sum(integrand,4);


% Pesky DC point: Correction for when kzd = 0 & ktransd -> 0
% Limit is just a single arc through illumination pupil, but there are many
% directions that we could approach from for this limit. Do many approaches
% and average them. Line intergral process is the same with kxd,kyd = 0
numApproachAngles = 16;
approachAngles = linspace(0,2*pi,numApproachAngles+1); approachAngles = approachAngles(1:end-1);

DCt = repmat(tRequested',[1 numApproachAngles]);
DCkpar = zeros(size(DCt),p.dataType);
DCkperp = k.*sin(DCt);
dDCkperpdt = k.*cos(DCt);
dDCkzdt = -k.*sin(DCt);

DCkx = cos(approachAngles).*DCkpar - sin(approachAngles).*DCkperp;
DCky = sin(approachAngles).*DCkpar + cos(approachAngles).*DCkperp;

arcLengthTerm = sqrt(dDCkperpdt.^2 + dDCkzdt.^2);
HtimesHStar = H(DCkx,DCky).*conj(H(DCkx,DCky));
GstarModsqrHi = conj(G(DCkx,DCky)).*abs(Hi(-DCkx,-DCky)).^2;
GModsqrHi = G(DCkx,DCky).*abs(Hi(-DCkx,-DCky)).^2;

integrand = HtimesHStar.*(GstarModsqrHi - GModsqrHi).*arcLengthTerm;
DCTerm = sum(integrand,'all')/numApproachAngles;

phaseTF(kxdRequested==0,kydRequested==0,kzdRequested==0) = DCTerm;

