function otf = generate_otf(p)


% Make sampled Illumination and Detection CSFs
[kx,ky,kz,w,kIdx] = set_up_spat_freq_domain(p);
illumSampledCSF = sample_illumination_csf(p,kx,ky,kz,w);
imagingSampledCSF = sample_imaging_csf(p,kx,ky,kz,w);

numIllumPoints = size(illumSampledCSF,1);
numImagingPoints = size(imagingSampledCSF,1);
numConvPoints = numIllumPoints*numImagingPoints;


% Convolve CSFs
convPoints = zeros(numConvPoints,4,'single');
for illumIdx = 1:numIllumPoints
    cStart = (illumIdx-1)*numImagingPoints+1;
    cEnd = numImagingPoints*illumIdx;
    convPoints(cStart:cEnd,1:3) = illumSampledCSF(illumIdx,1:3)-imagingSampledCSF(:,1:3);
    convPoints(cStart:cEnd,4) = illumSampledCSF(illumIdx,4).*imagingSampledCSF(:,4);
end

% Make z bins
kzMax = max(convPoints(:,3));
kzMin = min(convPoints(:,3));
spFreqPix = kIdx(2)-kIdx(1);
minZBin = max(kIdx(kIdx+spFreqPix/2 < kzMin));
maxZBin = min(kIdx(kIdx-spFreqPix/2 > kzMax));

% Gather points to assemble OTF volume
kxUnique = unique(convPoints(:,1));
kyUnique = unique(convPoints(:,2));
if p.kySym
    kyUnique = kyUnique(1:ceil(end/2));
end
otf = zeros([p.objectSize,p.objectSize,p.objectSize]/p.pixelSize,'single');

tic
for kzIdx = minZBin:spFreqPix:maxZBin
    binStart = kzIdx-.5*spFreqPix; binEnd = kzIdx+.5*spFreqPix;
    
    % Select just match kz
    z = convPoints(:,3) > binStart & convPoints(:,3) < binEnd;
    zConvPoints = convPoints(z,[1 2 4]);
        
    for kyIdx = 1:length(kyUnique)
        % Select matching ky
        zy = zConvPoints(:,2) == kyUnique(kyIdx);
        zyConvPoints = zConvPoints(zy,[1 3]);
        
        for kxIdx = 1:length(kxUnique)
            % Select just matching kx
            zyx = (zyConvPoints(:,1) == kxUnique(kxIdx));
            
            OTFEntry = sum(zyConvPoints(zyx,2));
            otf(find(kIdx==kyUnique(kyIdx),1),find(kIdx==kxUnique(kxIdx),1),find(kIdx==kzIdx,1)) = OTFEntry;

        end
        
    end   
    disp(kzIdx)
end

% Fill symmetric regions of OTF
if p.kySym
    otf((end/2+2):end,:,:) = flip(otf(2:(end/2),:,:),1);
end
    
toc