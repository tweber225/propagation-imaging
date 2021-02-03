function spectrum3d = fft3(input3d)

% Transform 1st dim
spectrum3d = fft(input3d,[],1);

% Transform 2nd dim
spectrum3d = fft(spectrum3d,[],2);

% Transform 3rd dim
spectrum3d = fft(spectrum3d,[],3);