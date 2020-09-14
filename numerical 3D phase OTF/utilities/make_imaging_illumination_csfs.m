function [H,Hi] = make_imaging_illumination_csfs(p)
% Creates anonymous functions for imaging and illumination coherent spread
% functions (CSFs)

% Convert parameters to requested data type
if strcmp(p.dataType,'single') 
    p.lightWavelength = single(p.lightWavelength);
    p.imagingNA = single(p.imagingNA);
    p.illuminationNA = single(p.illuminationNA);
end

% Make illumination NA < or = to imaging NA (validity check)
if p.illuminationNA > p.imagingNA
    p.illuminationNA = p.imagingNA;
end

% Compute frequency cutoffs
imagingSpatialFrequencyCutoff = p.imagingNA/p.lightWavelength;
imagingSquared = imagingSpatialFrequencyCutoff^2;
illuminationSpatialFrequencyCutoff = p.illuminationNA/p.lightWavelength;
illumSquared = illuminationSpatialFrequencyCutoff^2;

% Many anon functions depending on data type
if strcmp(p.dataType,'single')
    H = @(kx,ky) single(kx.^2 + ky.^2 <= imagingSquared);
    
    if p.asymmetricIllumination
        Hi = @(kx,ky) single((kx.^2 + ky.^2 <= illumSquared) & kx>=0);
    else
        Hi = @(kx,ky) single((kx.^2 + ky.^2 <= illumSquared));
    end
else
    H = @(kx,ky) double(kx.^2 + ky.^2 <= imagingSquared);
    
    if p.asymmetricIllumination
        Hi = @(kx,ky) double((kx.^2 + ky.^2 <= illumSquared) & kx>=0);
    else
        Hi = @(kx,ky) double((kx.^2 + ky.^2 <= illumSquared));
    end
end


