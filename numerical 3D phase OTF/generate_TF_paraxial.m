function [phaseTF,absorptionTF] = generate_TF_paraxial(p,mu_x,mu_y,eta)
% GENERATE_TF_PARAXIAL
% Function to generate phase and absorption transfer functions (TFs) for a
% partially coherent microscope under paraxial approximation.
%
% Variable names roughly match Streibl's notation, that is
% mu_x/y are transverse spatial frequencies
% eta is longitudinal spatial frequency

% Make sure 1D vectors are in correct dims: mu_x occupies 1st dimension,
% mu_y dim 2, eta dim 3, and t (which will be integration variable) dim 4 
mu_x = mu_x(:)';
mu_y = mu_y(:);
eta = reshape(eta(:),[1 1 numel(eta)]);

% convert to requested data type
if strcmp(p.dataType,'single') 
    mu_x = single(mu_x);
    mu_y = single(mu_y);
    eta = single(eta);
    p.imagingNA = single(p.imagingNA);
    p.lightWavelength = single(p.lightWavelength);
end

% Autocalculated parameter: defines int limits of line integral [um^-1]
muLim = p.imagingNA*p.lightWavelength^-1;

% Make the amplitude/coherent transfer functions CSFs: tilde{p} & tilde{S}
[tildep,tildeS] = make_imaging_illumination_csfs(p);

% Make line integral parameter, t
t = reshape(linspace(-muLim,muLim,p.numLineIntPoints),[1 1 1 p.numLineIntPoints]);

% Transverse spatial frequency modulus
muAbs = sqrt(mu_x.^2 + mu_y.^2);

% Parameterize the primed variables (mu_x' and mu_y') by first forming a
% line as if mu_y=0 and mu_x,eta=/=0, then rotate into place
mu_par = -eta./(p.lightWavelength.*muAbs);
mu_perp = t;
theta = atan2(mu_y,mu_x);
cosTheta = cos(theta); sinTheta = sin(theta); clear theta
mu_xPrime = cosTheta.*mu_par - sinTheta.*mu_perp;
mu_yPrime = sinTheta.*mu_par + cosTheta.*mu_perp; clear sinTheta cosTheta mu_par

% Break up integral into parts,
% part 0: prefactors
% part 1: tildep(muPrime + 1/2 mu) tildep*(muPrime - 1/2 mu)
% part 2A (for absorption): tildeS(muPrime + 1/2 mu) + tildeS(muPrime - 1/2 mu)
% part 2A (for phase): tildeS(muPrime + 1/2 mu) - tildeS(muPrime - 1/2 mu)
part0 = muAbs;
part1 = tildep(mu_xPrime+0.5*mu_x,mu_yPrime+0.5*mu_y).*conj(tildep(mu_xPrime-0.5*mu_x,mu_yPrime-0.5*mu_y));
S1 = tildeS(mu_xPrime+0.5*mu_x,mu_yPrime+0.5*mu_y);
S2 = tildeS(mu_xPrime-0.5*mu_x,mu_yPrime-0.5*mu_y); clear mu_xPrime mu_yPrime
part2A = S1 + S2;
part2P = S1 - S2; clear S1 S2

% Compute integral approximates (ie sum along t dimension)
phaseTF = sum(part1.*part2P,4)./part0; clear part2P
absorptionTF = sum(part1.*part2A,4)./part0; clear part2A part1

% Set TF(mu=0) to 0
phaseTF(floor(end/2)+1,floor(end/2)+1,:) = 0;
absorptionTF(floor(end/2)+1,floor(end/2)+1,:) = 0;

% Set any NaNs to 0
phaseTF(isnan(phaseTF)) = 0;
absorptionTF(isnan(absorptionTF)) = 0;
