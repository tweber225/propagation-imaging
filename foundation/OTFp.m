function out = OTFp(sfCutoff,sfCutoffi,k,zPosIdx,sfIdx,symFlag)

% Compute a few factors
H_det = H(sfIdx,sfCutoff);
if strcmp(symFlag,'asym')
    H_illum = abs(H_asym(-sfIdx,sfCutoffi)).^2;
else
    H_illum = abs(H(-sfIdx,sfCutoffi)).^2;
end
G1 = G(sfIdx,k,-zPosIdx);
D1 = D(sfIdx,k,zPosIdx);

% Convolve effective partially coherent transmission CSFs in the frequency domain
p1 = H_det.*G1.*H_illum;
p2 = conj(H_det).*D1;
o1 = ifft2(fft2(p1).*fft2(p2));

p1 = H_det.*conj(D1);
p2 = conj(H_det).*conj(G1).*circshift(rot90(H_illum,2),[1 1]);
o2 = ifft2(fft2(p1).*fft2(p2));

out = o1 + o2; % subtract for absorption OTF