% Parameters go into structure "p" which gets passed to functions
p.dataType = 'single';      % data type in which to compute OTF (single or double)
p.pixelSize = 1/2;          % um per pixel
p.lightWavelength = 0.85;   % um
p.objectSize = 128;          % um
p.arrayLength = p.objectSize/p.pixelSize; %AUTO-CALCULATES

% options: point, sphere, tube, monolayer
p.objectType = 'sphere';    
p.deltaN = single(0.1);     % keep in single precision
p.radius = 2.5;               % um, for object type: sphere, tube, monolayer

p.sphereCenterSpacing = 10; % um
p.centerRandomOffset = .5;
p.tiltXY = [.01 .03];        % rad, about x axis and about y axis, resp.

p.illuminationNA = 0.3;
p.imagingNA = 0.4;

p.asymmetricIllumination = false;


% Number of points used to approximate line integral for each transfer function point
p.numLineIntPoints = 24;
p.longitudinalUpsampling = 1;


p.noiseLevel = .0001;

