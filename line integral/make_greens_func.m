function G = make_greens_func(p)
% Creates anonymous function for forward propagating Green's function


% Extract some parameters from p stuctures
wl = p.lightWavelength;
k = 1/wl;

G = @(kx,ky) single( 1./(1i*4*pi*sqrt(k^2- kx.^2-ky.^2)) );
