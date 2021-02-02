function spectrum3d = fft3(input3d,specSize)

% Transform 1st dim
spectrum3d = fft(input3d,specSize(1),1);

% Transform 2nd dim
spectrum3d = fft(spectrum3d,specSize(2),2);

% Transform 3rd dim
spectrum3d = fft(spectrum3d,specSize(3),3);