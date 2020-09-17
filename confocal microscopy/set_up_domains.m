function d = set_up_domains(p)

% calculated values
d.maxPosition = single((p.numPoints/2 - 1)*p.sampDens);
d.minPosition = single(-(p.numPoints/2)*p.sampDens);
d.positionIdx = single(d.minPosition:p.sampDens:d.maxPosition);

d.maxSf = single(1000/(2*p.sampDens));     % inverse mm
d.dSf = single(2*d.maxSf/p.numPoints);
d.sfIdx = -d.maxSf:d.dSf:(d.maxSf-d.dSf);

% generate spatial domain
[x,y] = meshgrid(d.positionIdx);
d.posX = x;
d.posY = y;

% generate pinhole image
d.pinhole = (d.posX.^2 + d.posY.^2) <= (p.pinholeDiam/2)^2;

% generate spatial frequency domain
[sfX,sfY] = meshgrid(d.sfIdx);
d.sfLatSqr = sfX.^2 + sfY.^2;

% generate limiting circular coherence transfer function (CTF) for
% detection
d.CTFd = single(d.sfLatSqr <= (p.sfCutd^2));

% Limit the lateral spatial frequency squared by the CSF, so it doesn't
% overflow at very high values
d.sfLatSqr = d.sfLatSqr.*d.CTFd;
