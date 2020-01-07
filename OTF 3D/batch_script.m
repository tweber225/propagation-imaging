% Run sequence of scripts to make object, make illumination and imaging
% CSFs, and generate the OTF
load_params

object = make_complex_object(p);
objectSpectrum = fftn(object);

phaseTF = generate_phase_tf(p);

objectSpectrumFiltered = objectSpectrum.*ifftshift(phaseTF);
objectFiltered = imag(ifftn(objectSpectrumFiltered)) + p.noiseLevel*randn(size(objectSpectrumFiltered));

%%
numSlices = 7;
sliceRange = 15;
slices = round(linspace(-sliceRange/p.pixelSize,sliceRange/p.pixelSize,numSlices));
toShow = throughFocusAndAxialSlice(objectFiltered,slices);
figure;imshow(toShow)

%% Save image?
toShow8b = uint8(toShow*255);
%imwrite(toShow8b,'C:\Users\twebe\Desktop\pcoh33-asym-point.png');