function occludedPSF = create_occluded_PSF(pinholes,phZLocations,zPosIdx,sfIdx,k_em,sfCutoff_em)
% "pinholes" should contain multiple 2d images of pinholes, first is the
% current PSF's pinhole, the rest are occluding pinholes.


% Make a 5-D array to contain pinhole spots (5th dim is the location in the collecting pinhole)
pinholeSpots = make_quadrant_pinhole_spots(pinholes(:,:,1));

% ?? Constrain angular distribution of spots by the system's aperture
pinholeImg = fftshift2(fft2(pinholeSpots)).*H(sfIdx,sfCutoff_em);

% Iterate through 2 to N pinholes
pinholeProp = pinholeImg;
for phIdx = 2:size(pinholes,3)
    
    % Propagate spots to next upstream pinhole
    pinholeProp = pinholeProp.*D(sfIdx,k_em,-phZLocations(phIdx)+phZLocations(phIdx-1));
    
    % Apply blocking mask
    blocking = ifft2(ifftshift2(pinholeProp)).*(~pinholes(:,:,phIdx)); % separating these 2 lines for readability
    pinholeProp = fftshift2(fft2(blocking));

end

% Propagate occluded field back to original plane
pinholePropBack = pinholeProp.*D(sfIdx,k_em,phZLocations(end)-phZLocations(1));

% Use 3D CTF
CTF = create_circular_CTF(sfIdx,sfCutoff_em,k_em,zPosIdx);
detect3D = ifft2(ifftshift2(pinholePropBack.*CTF));

% Integrate all the pinhole spots (incoherently)
occludedPSF = sum(detect3D.*conj(detect3D),5); 

% Repeat for all quadrants (rotational symmetry exploit)
occludedPSF = occludedPSF + rot90(occludedPSF,1) + rot90(occludedPSF,2) + rot90(occludedPSF,3);



