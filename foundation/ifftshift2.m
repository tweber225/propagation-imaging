function out = ifftshift2(f)

out = ifftshift(ifftshift(f,1),2);