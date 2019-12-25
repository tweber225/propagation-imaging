% Run sequence of scripts to make object, make illumination and imaging
% CSFs, and generate the OTF
load_params

object = make_complex_object(p);

otf = generate_otf(p);

phaseTF = make_phase_tf(otf);


objectFiltered = imag(ifftn(fftn(object).*ifftshift(phaseTF)));


