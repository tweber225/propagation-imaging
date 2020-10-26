function propFunc = propagator(z,k,sfX,sfY)
% Multiplcation with the output of this function, propFunc will propagate a
% spatial frequency domain representation of field to a distance, z
% Must also include wavenumber k (adjusted for refractive index)

% Note: for some reason, large negative z values into exp function below
% can give erroneous results, so first take absolute value of z, then flip
% the phase by complex conjugate afterwards

spatFreqSqr = sfX.^2 + sfY.^2;
propFunc = exp(2i*pi*abs(z).*sqrt(k^2 - spatFreqSqr));

% Fix negative values
propFunc(:,:,z<0) = conj(propFunc(:,:,z<0));