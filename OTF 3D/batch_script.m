% Run sequence of scripts to make object, make illumination and imaging
% CSFs, and generate the OTF
load_params

object = make_complex_object(p);

phaseTF = generate_phase_tf(p);


objectFiltered = imag(ifftn(fftn(object).*ifftshift(phaseTF)));

%%
toShow = throughFocusAndAxialSlice(objectFiltered,[-40 -32 -24 -16 -8 0 8 16 24 32 40]);
imshow(toShow)