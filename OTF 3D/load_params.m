% Parameters go into structure "p" which gets passed to functions
p.pixelSize = 1/2;          % um per pixel
p.lightWavelength = 0.85;   % um
p.backgroundN = 1.36;       % refractive index of background
p.objectSize = 64;         % um
% array size = objectSize/pixelSize

% options: point, sphere, tube, monolayer
p.objectType = 'sphere';    
p.deltaN = single(0.1);     % keep in single precision
p.radius = 2;               % um, for object type: sphere, tube, monolayer
p.sphereCenterSpacing = 15; % um
p.centerRandomOffset = 2;
p.tiltXY = [.07 .12];        % rad, about x axis and about y axis, resp.

p.illuminationNA = 0.35;
p.imagingNA = 0.4;
p.aberrationMag = 0.01;

p.asymIllum = false;

p.kySym = true;

p.noiseLevel = .1;