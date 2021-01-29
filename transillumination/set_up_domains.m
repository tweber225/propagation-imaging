function d = set_up_domains(p)

% Make position index
d.maxPosition = single((p.numLatPix/2 - 1)*p.pixSize);
d.minPosition = single(-(p.numLatPix/2)*p.pixSize);
d.posIdx = single(d.minPosition:p.pixSize:d.maxPosition);

% Make z position index
d.maxZPosition = single((p.numZPix/2 - 1)*p.pixSize);
d.minZPosition = single(-(p.numZPix/2)*p.pixSize);
d.zPosIdx = single(d.minZPosition:p.pixSize:d.maxZPosition);

% Make spatial frequency index
d.maxSf = single(1/(2*p.pixSize));     % inverse um
d.dSf = single(2*d.maxSf/p.numLatPix);
d.sfIdx = -d.maxSf:d.dSf:(d.maxSf-d.dSf);