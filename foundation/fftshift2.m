function out = fftshift2(f)

out = fftshift(fftshift(f,1),2);