function [phaseTF,absorptionTF] = generate_TF_exact(p,mu_x,mu_y,eta)
% Function to numerically approximate phase and absorption transfer
% functions (TFs) for a partially coherent microscope.
%
% Variable names roughly match Streibl's notation.
% mu_x/y are transverse spatial frequencies
% eta is longitudinal spatial frequency

% Extract some parameters from p structure
imagingNA = p.imagingNA;
lambda = p.lightWavelength;     % um

% Ensure 1D vectors in the right dimensions; convert to requested data type
mu_x = mu_x(:)';
mu_y = mu_y(:);
eta = reshape(eta(:),[1 1 numel(eta)]);
if strcmp(p.dataType,'single') 
    mu_x = single(mu_x);
    mu_y = single(mu_y);
    eta = single(eta);
    imagingNA = single(imagingNA);
    lambda = single(lambda);
end

% Make the CSFs: tilde{p} and tilde{S} (in latex speak)
[tildep,tildeS] = make_imaging_illumination_csfs(p);

% Make line integral parameter, t
tLim = asin(imagingNA);      % defines int limits of line integral
t = reshape(linspace(-tLim,tLim,p.numLineIntPoints),[1 1 1 p.numLineIntPoints]);
sint = sin(t);
cost = cos(t); clear t

% Transverse spatial frequency modulus
muAbs = sqrt(mu_x.^2 + mu_y.^2);

% Parameterize the primed variables (mu_x' and mu_y') by first forming a
% line path as if mu_y=0 and mu_x,eta~=0, then rotate into place
R_perp = sqrt(lambda^(-2)-0.25*(muAbs.^2 + eta.^2));
R_par = R_perp./sqrt(1 + (muAbs./eta).^2);
mu_perp = R_perp.*sint;
mu_par = sign(eta).*R_par.*cost;
theta = atan2(mu_y,mu_x);
cosTheta = cos(theta); sinTheta = sin(theta); clear theta
mu_xPrime = cosTheta.*mu_par - sinTheta.*mu_perp;
mu_yPrime = sinTheta.*mu_par + cosTheta.*mu_perp; clear sinTheta cosTheta mu_par mu_perp

% Store some common arguments with shorter variable names
mux1 = mu_xPrime+0.5*mu_x;
mux2 = mu_xPrime-0.5*mu_x; clear mu_xPrime
muy1 = mu_yPrime+0.5*mu_y;
muy2 = mu_yPrime-0.5*mu_y; clear mu_yPrime


% Break up integral into parts,
% part 1: tildep(muPrime + 1/2 mu) tildep*(muPrime - 1/2 mu)
% part 2: gradient of the delta function's argument
% part 3: arc length term
% part 4A (for absorption): tildeS(muPrime + 1/2 mu) + tildeS(muPrime - 1/2 mu)
% part 4P (for phase): tildeS(muPrime + 1/2 mu) - tildeS(muPrime - 1/2 mu)
integrand = tildep(mux1,muy1).*conj(tildep(mux2,muy2));
gradSquared = (mux1.^2 + muy1.^2)./(lambda^(-2) - mux1.^2 - muy1.^2) ... 
    + (mux2.^2 + muy2.^2)./(lambda^(-2) - mux2.^2 - muy2.^2) ...
    - 2*(mux1.*mux2 + muy1.*muy2)./(sqrt((lambda^(-2) - mux1.^2 - muy1.^2)).*sqrt((lambda^(-2) - mux2.^2 - muy2.^2)));
integrand = integrand./sqrt(gradSquared); clear gradSquared
integrand = integrand.*sqrt((R_perp.*cost).^2 + (R_par.*sint).^2); clear cost sint
S1 = tildeS(mux1,muy1);
S2 = tildeS(mux2,muy2);
integrandA = integrand.*(S1 + S2);
integrandP = integrand.*(S1 - 1*S2); clear S1 S2 integrand

% Integrate (ie sum along t dimension)
phaseTF = sum(integrandP,4); clear integrandP
absorptionTF = sum(integrandA,4); clear integrandA

% Set TF(mu=0) to 0
phaseTF(floor(end/2)+1,floor(end/2)+1,:) = 0;
absorptionTF(floor(end/2)+1,floor(end/2)+1,:) = 0;


