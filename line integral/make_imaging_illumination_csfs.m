function [H,Hi] = make_imaging_illumination_csfs(p)
% Creates anonymous functions for imaging and illumination coherent spread
% functions (CSFs)

% Extract some parameters from p stuctures
wl = p.lightWavelength;
imagingNA = p.imagingNA;
illuminationNA = p.illuminationNA;

% Make illumination NA < or = to imaging NA
if illuminationNA > imagingNA
    illuminationNA = imagingNA;
end

% Compute frequency cutoffs
imagingSpatialFrequencyCutoff = imagingNA/wl;
imagingSpatialFrequencyCutoffSquared = imagingSpatialFrequencyCutoff^2;

illuminationSpatialFrequencyCutoff = illuminationNA/wl;
illuminationSpatialFrequencyCutoffSquared = illuminationSpatialFrequencyCutoff^2;


H = @(kx,ky) single(kx.^2 + ky.^2 < imagingSpatialFrequencyCutoffSquared);
Hi = @(kx,ky) single(kx.^2 + ky.^2 < illuminationSpatialFrequencyCutoffSquared);