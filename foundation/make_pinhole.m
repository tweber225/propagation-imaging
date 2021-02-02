function out = make_pinhole(posIdx,pinholeDiam)

r = pinholeDiam/2;
posSqr = posIdx.^2 + (posIdx').^2;  % implicitly expand the dimensions
out = posSqr <= r^2;