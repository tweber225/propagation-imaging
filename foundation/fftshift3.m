function out = fftshift3(f)

out = fftshift(fftshift(fftshift(f,1),2),3);