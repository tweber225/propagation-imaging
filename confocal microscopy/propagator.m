function propFunc = propagator(z,k,spatFreqSqr)
% For some reason, large negative z values into exp function below can give
% erroneous results, so first take absolute value of z, then flip the phase
% by complex conjugate afterwards

propFunc = exp(2i*pi*abs(z)/1000.*sqrt(k^2 - spatFreqSqr));

% Fix negative values
propFunc(:,:,z<0) = conj(propFunc(:,:,z<0));