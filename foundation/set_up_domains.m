function d = set_up_domains(p)
% Takes in the simulation parameter structure, p and outputs calculated
% domains structure, d
%
% Specifically p must contain:
% numLatPix (number of pixels/points along lateral axes X & Y)
% realPixSize (absolute pixel size)

d.maxPosition = single((p.numLatPix/2 - 1)*p.simulationPixSize);
d.minPosition = single(-(p.numLatPix/2)*p.simulationPixSize);
d.posIdx = single(d.minPosition:p.simulationPixSize:d.maxPosition);

d.maxZPosition = single((p.numZPix/2 - 1)*p.simulationPixSize);
d.minZPosition = single(-(p.numZPix/2)*p.simulationPixSize);
d.ZPosIdx = single(d.minZPosition:p.simulationPixSize:d.maxZPosition);

d.maxSf = single(1/(2*p.realPixSize));     % inverse um
d.dSf = single(2*d.maxSf/p.numLatPix);
d.sfIdx = -d.maxSf:d.dSf:(d.maxSf-d.dSf);

