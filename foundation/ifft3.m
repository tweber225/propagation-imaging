function image3d = ifft3(spectrum3d)

% Transform 1st dim
image3d = fft(spectrum3d,[],1);

% Transform 2nd dim
image3d = fft(image3d,[],2);

% Transform 3rd dim
image3d = fft(image3d,[],3);