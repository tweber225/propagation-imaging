% Run sequence of scripts to make object, make illumination and imaging
% CSFs, and generate the OTF
load_params

object = make_complex_object(p);
objectSpectrum = fftn(object);

phaseTF = generate_phase_tf(p);

objectSpectrumFiltered = objectSpectrum.*ifftshift(phaseTF);
objectFiltered = imag(ifftn(objectSpectrumFiltered));

%%
numSlices = 9;
sliceRange = 48;
slices = linspace(-sliceRange,sliceRange,numSlices);
toShow = throughFocusAndAxialSlice(objectFiltered,slices);
figure;imshow(toShow)