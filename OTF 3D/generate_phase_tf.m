function phaseTF = generate_phase_tf(p)

% Make sampled Illumination and Detection CSFs
% (these are basically sampled versions of the pupil functions over a rectangular grid in k_x/y)
[kx,ky,kz,w,kIdx] = set_up_spat_freq_domain(p);
[illCSFCoords,illCSFAmps] = sample_illumination_csf(p,kx,ky,kz,w);
[imgCSFCoords,imgCSFAmps] = sample_imaging_csf(p,kx,ky,kz,w);

% Calculate number of points for later
numIllumPoints = size(illCSFCoords,1);
numImagingPoints = size(imgCSFCoords,1);
numConvPoints = numIllumPoints*numImagingPoints;

% Convolve sampled CSFs
convCoords1 = zeros(numConvPoints,3,'single');
convCoords2 = convCoords1;
convAmps1 = zeros(numConvPoints,1,'single');
convAmps2 = convAmps1;
for illumIdx = 1:numIllumPoints
    cStart = (illumIdx-1)*numImagingPoints+1;
    cEnd = numImagingPoints*illumIdx;
    convCoords1(cStart:cEnd,1:3) = illCSFCoords(illumIdx,:)-imgCSFCoords;
    convCoords2(cStart:cEnd,1:3) = -illCSFCoords(illumIdx,:)+imgCSFCoords;
    convAmps1(cStart:cEnd) = (illCSFAmps(illumIdx).^2)*imgCSFAmps(illumIdx).*conj(imgCSFAmps);
    convAmps2(cStart:cEnd) = (illCSFAmps(illumIdx).^2)*conj(imgCSFAmps(illumIdx)).*imgCSFAmps;
end
convCoords = [convCoords1;convCoords2];
convAmps = [convAmps1;-convAmps2];

% Make z bins
kzMax = max(convCoords(:,3));
kzMin = min(convCoords(:,3));
spFreqPix = kIdx(2)-kIdx(1);
minZBin = max(kIdx(kIdx+spFreqPix/2 < kzMin));
maxZBin = min(kIdx(kIdx-spFreqPix/2 > kzMax));

% Gather points to assemble OTF volume
kxUnique = unique(convCoords(:,1));
kyUnique = unique(convCoords(:,2));
if p.kySym
    kyUnique = kyUnique(1:ceil(end/2));
end
OTFReal = zeros([p.objectSize,p.objectSize,p.objectSize]/p.pixelSize,'single');
OTFImag = OTFReal;

for kzIdx = minZBin:spFreqPix:maxZBin
    binStart = kzIdx-.5*spFreqPix; binEnd = kzIdx+.5*spFreqPix;
    
    % Select just matching kz
    z = convCoords(:,3) > binStart & convCoords(:,3) < binEnd;
    zConvCoords = convCoords(z,[1 2]);
    zConvAmps = convAmps(z);
    kz = find(kIdx==kzIdx,1);
        
    for kyIdx = 1:length(kyUnique)
        % Select matching ky
        zy = zConvCoords(:,2) == kyUnique(kyIdx);
        zyConvCoords = zConvCoords(zy,1);
        zyConvAmps = zConvAmps(zy);
        ky = find(kIdx==kyUnique(kyIdx),1);
        
        for kxIdx = 1:length(kxUnique)
            % Select just matching kx
            zyx = zyConvCoords == kxUnique(kxIdx);
            OTFEntryReal = sum(real(zyConvAmps(zyx)));
            OTFEntryImag = sum(imag(zyConvAmps(zyx)));
            kx = find(kIdx==kxUnique(kxIdx),1);
            OTFReal(ky,kx,kz) = OTFEntryReal;
            OTFImag(ky,kx,kz) = OTFEntryImag;

        end
        
    end   
    disp(kzIdx)
end

phaseTF = OTFReal + 1i*OTFImag;


% Fill symmetric regions
if p.kySym
    phaseTF((end/2+2):end,:,:) = flip(phaseTF(2:(end/2),:,:),1);
end
    
