function out = make_pinhole(x,y,r)

posSqr = x.^2 + y.^2;
out = posSqr <= r^2;