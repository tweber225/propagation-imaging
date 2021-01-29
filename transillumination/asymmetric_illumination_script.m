% Add the support code
addpath ../foundation/

load_parameters
d = set_up_domains(p);

% Create object
centerPos = [p.x0,p.y0,p.z0];
object = create_spherical_object(p,d,centerPos);

% Create 3D asymmetric phase OTF
OTF = OTFp(p,d,'asym');

% Perform imaging
imgs = intensity_imaging(object,p.zPixSize,OTF,p.numFocalPlanes,p.focalPlanes);



