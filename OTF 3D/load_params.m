% Parameters go into structure "p" which gets passed to functions
p.pixelSize = 0.5;          % um per pixel
p.lightWavelength = 0.85;   % um
p.backgroundN = 1.36;       % refractive index of background
p.objectSize = 128;         % um


p.objectType = 'point';    % options: sphere, point, monolayer
p.deltaN = single(0.1);     % keep in single precision
p.noiseLevel = 2;

p.sphereRadius = 3;         % um, for object type: sphere, monolayer
p.sphereCenterSpacing = 15; % um
p.centerRandomOffset = 2;
p.tiltXY = [.11 .2];         % rad, about x axis and about y axis, resp.

p.illuminationNA = 0.4;
p.imagingNA = 0.4;

p.kySym = true;