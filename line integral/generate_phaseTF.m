function phaseTF = generate_phaseTF(p,kxdRequested,kydRequested,kzdRequested)
% Function to generate phase transfer function (TF) for a partially
% coherent microscope

% Extract some parameters from p structure
minNA = min(p.imagingNA,p.illuminationNA);
wl = p.lightWavelength;     % um
k = 1/wl;                   % um^-1
spatFreqLim = minNA*k;      % um^-1, defines int limits of line integral

% Make the CSFs
[H,Hi] = make_imaging_illumination_csfs(p);

% Make parameter index
t = linspace(-spatFreqLim,spatFreqLim,p.numLineIntPoints);

% Allocate some space for phase transfer function
numKyd = length(kydRequested);
numKxd = length(kxdRequested);
numKzd = length(kzdRequested);
phaseTF = zeros(numKyd,numKxd,numKzd,'single');

% Loop through different kxd,kyd,kzd's
for kzdIdx = 1:numKzd
    kzd = kzdRequested(kzdIdx);
    
    % Check that kzd does not equal zero (skip if does)
    if kzd == 0
        continue
    end
    
    for kydIdx = 1:numKyd
        kyd = kydRequested(kydIdx);
        
        for kxdIdx = 1:numKxd
            kxd = kxdRequested(kxdIdx);
    
            % Compute some constants
            Ry = sqrt(k^2 - (kxd^2+kzd^2)/4);
            Rx = Ry/sqrt(1 + kxd^2/kzd^2);

            % Parameterize kx, ky, kz and derivatives
            kx = -Rx*cos(t);
            ky = Ry*sin(t);
            kz = Rx*(kxd/kzd)*cos(t);

            dkxdt = Rx*sin(t);
            dkydt = Ry*cos(t);
            dkzdt = -Rx*(kxd/kzd)*sin(t);

            % Break up the integrand a bit
            HtimesHStar = H(kx+kxd/2,ky+kyd/2).*conj(H(kx-kxd/2,ky-kyd/2));
            %modsqrHiDiff = abs(Hi(-kx-kxd/2,-ky-kyd/2)).^2 - abs(Hi(-kx+kxd/2,-ky+kyd/2)).^2;
            modsqrHiDiff = abs(Hi(-kx-kxd/2,-ky-kyd/2)).^2 - 0*abs(Hi(-kx+kxd/2,-ky+kyd/2)).^2;

            arcLengthTerm = sqrt(dkxdt.^2 + dkydt.^2 + dkzdt.^2);

            % Integrate
            %phaseTF(kydIdx,kxdIdx,kzdIdx) = sum(HtimesHStar.*modsqrHiDiff.*arcLengthTerm);
            phaseTF(kydIdx,kxdIdx,kzdIdx) = sum(modsqrHiDiff);
            
        end % kxd looping

    end % kyd looping
    
end % kzd looping

