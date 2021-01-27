function out = make_pinhole(posIdx,r)

posSqr = posIdx.^2 + (posIdx').^2;  % implicitly expand the dimensions
out = posSqr <= r^2;