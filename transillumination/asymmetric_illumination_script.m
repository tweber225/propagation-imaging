% Add the support code
addpath ../foundation/

load_parameters
d = set_up_domains(p);

% Create object
object = create_spherical_object(d.posIdx,d.zPosIdx,p.centerPos,p.r,p.nd);

% Create 3D asymmetric phase OTF
OTF = OTFp(p,d,'asym');

% Perform imaging
imgs = intensity_imaging(object,p.zPixSize,OTF,p.numFocalPlanes,p.focalPlanes);



