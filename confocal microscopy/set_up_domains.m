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

% generate spatial frequency domain
[sfX,sfY] = meshgrid(d.sfIdx);
d.sfLatSqr = sfX.^2 + sfY.^2;

% generate circular coherence transfer function (CTF) in 3D
d.CTFi = single(d.sfLatSqr <= (p.sfCuti^2));
d.CTFd = single(d.sfLatSqr <= (p.sfCutd^2));
