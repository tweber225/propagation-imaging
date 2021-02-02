function out = OTFp(p,d,symFlag)

% Compute a few factors
H_det = H(d.sfIdx,p.sfCutoff);
if strcmp(symFlag,'asym')
    H_illum = abs(H_asym(-d.sfIdx,p.sfCutoffi)).^2;
else
    H_illum = abs(H(-d.sfIdx,p.sfCutoffi)).^2;
end
G1 = G(d.sfIdx,p.k,-d.zPosIdx);
D1 = D(d.sfIdx,p.k,d.zPosIdx);

% Convolve effective partially coherent transmission CSFs in the frequency domain
p1 = H_det.*G1.*H_illum;
p2 = conj(H_det).*D1;
o1 = ifft2(fft2(p1).*fft2(p2));

p1 = H_det.*conj(D1);
p2 = conj(H_det).*conj(G1).*rot90(H_illum,2);
o2 = ifft2(fft2(p1).*fft2(p2));

out = o1 - o2; % add for phase OTF