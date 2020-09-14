%% LOAD_PARAMS
% Loads simulation parameters and put them into a structure, "p"
% Backeted quantities in comments denote units

% Basic simulation parameters
p.dataType = 'single';      % data type in which to compute OTF (single or double)
p.pixelSize = 1/2;          % [um] per pixel

% Imaging parameters
p.lightWavelength = 0.85;   % [um]
p.imagingNA = 0.4;
p.gamma = 0.75;             % aka incoherence factor (0 is completely coherence, 1 is incoherent)
p.asymmetricIllumination = true;

% Number of points used to approximate line integral for each transfer function point
p.numLineIntPoints = 48;

% Object options
p.objectSize = 64;          % [um]
p.objectType = 'point';     % options: point, sphere, tube, monolayer
p.deltaN = single(0.1);     % refractive index difference, keep in single precision
p.radius = 1;               % [um], only for object type: sphere, tube, monolayer

% Object monolayer settings (only if using monolayer object type)
p.sphereCenterSpacing = 10; % [um]
p.centerRandomOffset = .5;
p.tiltXY = [.01 .03];       % [rad], about x axis and about y axis, resp.

% Display settings
p.noiseLevel = .002;
p.thruFocusImgWidthCrop = 12;   % [um]
p.thruFocusRange = 15;          % [um] +/- from the focal plane
p.thruFocusdz = 3;              % [um]

% Automatically calculated 
p.arrayLength = p.objectSize/p.pixelSize; 
p.illuminationNA = p.imagingNA*p.gamma;
p.crop = p.thruFocusImgWidthCrop/p.pixelSize;
p.frameThruFocusStartEnd = p.thruFocusRange./p.pixelSize;
p.frameThruFocusdz = p.thruFocusdz./p.pixelSize;


