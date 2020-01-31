function [mu_x,mu_y,eta] = set_spatial_freq_range(p)

% Computes a set of spatial frequencies to calculate OTF at

% Compute a list of lateral indices
nyquistLateral = 1/(2*p.pixelSize);
fullLateralIndex = linspace(-nyquistLateral,nyquistLateral,p.arrayLength+1);
fullLongitudinalIndex = linspace(-nyquistLateral,nyquistLateral,p.arrayLength*p.longitudinalUpsampling+1);
fullLateralIndex = fullLateralIndex(1:end-1);
fullLongitudinalIndex = fullLongitudinalIndex(1:end-1);
dmu = fullLateralIndex(2)-fullLateralIndex(1);

% Find indices only in support region for OTF
maxLateralSpatialFreq = (p.illuminationNA+p.imagingNA)/p.lightWavelength;
lateralIndex = fullLateralIndex(abs(fullLateralIndex) <= (maxLateralSpatialFreq+dmu));

maxLongitudinalSpatialFreq = (1/p.lightWavelength)*(1-cos(asin(p.imagingNA)));
longitudinalIndex = fullLongitudinalIndex(abs(fullLongitudinalIndex) <= (maxLongitudinalSpatialFreq+dmu/p.longitudinalUpsampling));


% Assuming no symmetries
mu_x = lateralIndex;
mu_y = mu_x;
eta = longitudinalIndex;