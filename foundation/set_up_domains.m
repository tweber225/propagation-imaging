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

d.maxSf = single(1/(2*p.realPixSize));     % inverse um
d.dSf = single(2*d.maxSf/p.numLatPix);
d.sfIdx = -d.maxSf:d.dSf:(d.maxSf-d.dSf);

% generate spatial domain
[x,y] = meshgrid(d.positionIdx);
d.posX = x;
d.posY = y;

% generate spatial frequency domain
[sfX,sfY] = meshgrid(d.sfIdx);
d.sfX = sfX;
d.sfY = sfY;

