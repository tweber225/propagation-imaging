function paddedFT = zero_pad_3D_fft(inputFunc,upSampFactor)
% Add zeros to the interior of 3D Fourier Transform data

paddedFT = inputFunc;

% Dim 1
zeroChunk = zeros(upSampFactor*size(paddedFT,1)-size(paddedFT,1),size(paddedFT,2),size(paddedFT,3),'single');
paddedFT = cat(1,paddedFT(1:end/2,:,:),zeroChunk,paddedFT((end/2+1):end,:,:));

% Dim 2
zeroChunk = zeros(size(paddedFT,1),upSampFactor*size(paddedFT,2)-size(paddedFT,2),size(paddedFT,3),'single');
paddedFT = cat(2,paddedFT(:,1:end/2,:),zeroChunk,paddedFT(:,(end/2+1):end,:));

% Dim 3
zeroChunk = zeros(size(paddedFT,1),size(paddedFT,2),upSampFactor*size(paddedFT,3) - size(paddedFT,3),'single');
paddedFT = cat(3,paddedFT(:,:,1:end/2),zeroChunk,paddedFT(:,:,(end/2+1):end));