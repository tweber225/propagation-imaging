function detectPSF = compute_multiple_occluded_PSFs(pinholes,pinholeLocations,emZPosIdx,sfIdx,k_em,sfCutoff_em)

% Calculate occluded detection PSFs (first pinhole not occluded)
pinholes = repmat(pinholes,[1 1 1]);
pinholeLocations = pinholeLocations(1:1);
zPosIdx = emZPosIdx(1,:);
detectPSF1 = create_occluded_PSF(pinholes,pinholeLocations,zPosIdx,sfIdx,k_em,sfCutoff_em);

pinholes = repmat(pinholes,[1 1 2]);
pinholeLocations = pinholeLocations(2:-1:1);
zPosIdx = emZPosIdx(2,:);
detectPSF2 = create_occluded_PSF(pinholes,pinholeLocations,zPosIdx,sfIdx,k_em,sfCutoff_em);

pinholes = repmat(pinholes,[1 1 3]);
pinholeLocations = pinholeLocations(3:-1:1);
zPosIdx = emZPosIdx(3,:);
detectPSF3 = create_occluded_PSF(pinholes,pinholeLocations,zPosIdx,sfIdx,k_em,sfCutoff_em);

pinholes = repmat(pinholes,[1 1 4]);
pinholeLocations = pinholeLocations(4:-1:1);
zPosIdx = emZPosIdx(4,:);
detectPSF4 = create_occluded_PSF(pinholes,pinholeLocations,zPosIdx,sfIdx,k_em,sfCutoff_em);

detectPSF = cat(4,detectPSF1,detectPSF2,detectPSF3,detectPSF4);