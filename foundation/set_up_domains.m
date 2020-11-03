function d = set_up_domains(p)
% Takes in the simulation parameter structure, p and outputs calculated
% domains structure, d
%
% Specifically p must contain:
% numLatPix (number of pixels/points along lateral axes X & Y)
% realPixSize (absolute pixel size)

d.maxPosition = single((p.numLatPix/2 - 1)*p.realPixSize);
d.minPosition = single(-(p.numLatPix/2)*p.realPixSize);
d.positionIdx = single(d.minPosition:p.realPixSize:d.maxPosition);

d.maxZPosition = single((p.numZPix/2 - 1)*p.zSpacing);
d.minZPosition = single(-(p.numZPix/2)*p.zSpacing);
d.ZPositionIdx = single(d.minZPosition:p.zSpacing:d.maxZPosition);

d.maxSf = single(1/(2*p.realPixSize));     % inverse um
d.dSf = single(2*d.maxSf/p.numLatPix);
d.sfIdx = -d.maxSf:d.dSf:(d.maxSf-d.dSf);

% generate spatial domain
[x,y,z] = meshgrid(d.positionIdx,d.positionIdx,d.ZPositionIdx);
d.posX = x;
d.posY = y;
d.posZ = z;

% generate spatial frequency domain
[sfX,sfY] = meshgrid(d.sfIdx);
d.sfX = sfX;
d.sfY = sfY;

