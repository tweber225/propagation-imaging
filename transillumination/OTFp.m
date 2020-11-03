function out = OTFp(p,d)

% Compute a few factors
H_det = H(d.sfX,d.sfY,p.sfCutoff);
H_illum = abs(H(-d.sfX,-d.sfY,p.sfCutoffi)).^2;
G1 = G(p.k,d.sfX,d.sfY,-d.posZ);
D1 = D(p.k,d.sfX,d.sfY,d.posZ);

% Convolve effective partially coherent transmission CSFs in the frequency domain
p1 = H_det.*G1.*H_illum;
p2 = conj(H_det).*D1;
o1 = ifft2(fft2(p1).*fft2(p2));

p1 = H_det.*conj(D1);
p2 = conj(H_det).*conj(G1).*H_illum;
o2 = ifft2(fft2(p1).*fft2(p2));

out = o1 + o2; % subtract for absorption OTF