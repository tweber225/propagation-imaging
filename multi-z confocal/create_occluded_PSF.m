function occludedPSF = create_occluded_PSF(pinhole,pinholeSeparation,posIdx,zPosIdx,sfIdx,k_em,sfCutoff_em)

% Propagate image of pinhole spots to upstream blocking pinhole
pinholeSpots = make_quadrant_pinhole_spots(pinhole,posIdx);
pinholeImg = fftshift2(fft2(pinholeSpots)).*H(sfIdx,sfCutoff_em);
pinholeProp = pinholeImg.*D(sfIdx,k_em,pinholeSeparation);

% Apply blocking mask (just the inverse of the pinhole)
pinholeBlocked = convn(pinholeProp,fftshift(fft2(~pinhole)),'same');

% Propagate back to original plane
pinholePropBack = pinholeBlocked.*D(sfIdx,k_em,-pinholeSeparation);

% Over-ride first channel so that it's not occluded
pinholePropBackOverride = cat(4,pinholeImg,repmat(pinholePropBack,[1 1 1 size(zPosIdx,1)-1 1]));

% Use 3D CTF
CTF = create_circular_CTF(sfIdx,sfCutoff_em,k_em,zPosIdx);
detect3D = ifft2(ifftshift2(pinholePropBackOverride.*CTF));

% Integrate all the pinhole spots (incoherently)
occludedPSF = sum(detect3D.*conj(detect3D),5); 

% Repeat for all quadrants (rotational symmetry exploit)
occludedPSF = occludedPSF + rot90(occludedPSF,1) + rot90(occludedPSF,2) + rot90(occludedPSF,3);
