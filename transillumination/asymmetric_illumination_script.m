% Add the support code
addpath ../foundation/

% User Parameters
p.realPixSize = 0.5;    % microns
p.numLatPix = 512;       % number pixels per lateral dimension
p.zSpacing = 1;
p.numZPix = 128;
p.n = 1;                % refractive index of object medium
p.NA = 0.4;            % dimensionless
p.NAi = 0.3;
p.wl = 0.850;          % microns
p.focalPlanes = -32:1:32;   %microns

% Calculated Domains and Parameters
p.numFocalPlanes = numel(p.focalPlanes);
p.k = single(p.n/p.wl);  
p.sfCutoff = single(p.NA/p.wl);
p.sfCutoffi = single(p.NAi/p.wl); 
d = set_up_domains(p);


% Create object
r = 1.51;
x0 = .1;%7.2;
y0 = .23264;%1;
z0 = 0;%-4.77;
object = single(d.posX.^2 + d.posY.^2 + d.posZ.^2 < r^2).*1;
objectSpectrum = fft2(object);

% Create each focal plane intensity image
imgIntensitySpectrumStack = complex(zeros(p.numLatPix,p.numLatPix,p.numFocalPlanes,'single'));
OTF = OTFp(p,d);
for focalPlaneIdx = 1:p.numFocalPlanes
    focalPlaneOffset = p.focalPlanes(focalPlaneIdx);
    zPixelShift = focalPlaneOffset./p.zSpacing;
    
    % Move object in Z
    shiftedObjectSpectrum = circshift(objectSpectrum,zPixelShift,3);
    
    % Multiply shifted object spectrum by depth-dependent OTF, and
    % integrate along z
    imgIntensitySpectrumStack(:,:,focalPlaneIdx) = sum(shiftedObjectSpectrum.*OTF,3);
    
end

% Compute images from spectra
imgIntensity = real(fft2(imgIntensitySpectrumStack));
