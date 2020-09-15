function d = set_up_domains(p)

% calculated values
d.maxPosition = single((p.numPoints/2 - 1)*p.sampDens);
d.minPosition = single(-(p.numPoints/2)*p.sampDens);
d.positionIdx = single(d.minPosition:p.sampDens:d.maxPosition);

d.maxSpatFreq = single(1000/(2*p.sampDens));     % inverse mm
d.dFreq = single(2*d.maxSpatFreq/p.numPoints);
d.spatFreqIdx = -d.maxSpatFreq:d.dFreq:(d.maxSpatFreq-d.dFreq);

% generate spatial frequency domain
[spatX,spatY] = meshgrid(d.spatFreqIdx);
d.spatLatSqr = spatX.^2 + spatY.^2;

% generate circular coherence transfer function (CTF) in 3D
d.CTF = single(d.spatLatSqr <= (p.spatFreqCut^2));
