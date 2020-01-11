function [H,Hi] = make_imaging_illumination_csfs(p)
% Creates anonymous functions for imaging and illumination coherent spread
% functions (CSFs)

% Extract some parameters from p stuctures
wl = p.lightWavelength;
imagingNA = p.imagingNA;
illuminationNA = p.illuminationNA;

if strcmp(p.dataType,'single') % Convert parameters to requested data type
    wl = single(wl);
    imagingNA = single(imagingNA);
    illuminationNA = single(illuminationNA);
end

% Make illumination NA < or = to imaging NA
if illuminationNA > imagingNA
    illuminationNA = imagingNA;
end

% Compute frequency cutoffs
imagingSpatialFrequencyCutoff = imagingNA/wl;
imagingSquared = imagingSpatialFrequencyCutoff^2;

illuminationSpatialFrequencyCutoff = illuminationNA/wl;
illumSquared = illuminationSpatialFrequencyCutoff^2;



if strcmp(p.dataType,'single')
    H = @(kx,ky) single(kx.^2 + ky.^2 < imagingSquared);
    
    if p.asymmetricIllumination
        Hi = @(kx,ky) single((kx.^2 + ky.^2 < illumSquared) & kx>=0);
    else
        Hi = @(kx,ky) single((kx.^2 + ky.^2 < illumSquared));
    end
else
    H = @(kx,ky) double(kx.^2 + ky.^2 < imagingSquared);
    
    if p.asymmetricIllumination
        Hi = @(kx,ky) double((kx.^2 + ky.^2 < illumSquared) & kx>=0);
    else
        Hi = @(kx,ky) double((kx.^2 + ky.^2 < illumSquared));
    end
end



