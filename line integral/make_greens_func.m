function G = make_greens_func(p)
% Creates anonymous function for forward propagating Green's function


% Extract some parameters from p stuctures
wl = p.lightWavelength;
if strcmp(p.dataType,'single')
    wl = single(wl);
end
k = 1/wl;


if strcmp(p.dataType,'single')

    G = @(kx,ky) single( 1./(1i*4*pi*sqrt(k^2- kx.^2-ky.^2)) );

else
    
    G = @(kx,ky) double( 1./(1i*4*pi*sqrt(k^2- kx.^2-ky.^2)) );
    
end
