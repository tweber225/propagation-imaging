% first run batch_script.m

numFrames = 4;
offset = 1; %make odd
frameList = (-numFrames):2:(numFrames-1);

frameSet1 = objectFiltered(:,:,end/2 + frameList);
frameSet2 = objectFiltered(:,:,end/2 + offset + frameList);

toShow = [];
for fIdx = 1:size(frameSet1,3)
    bothFrames = [frameSet1(:,:,fIdx); frameSet2(:,:,fIdx)];
    toShow = [toShow bothFrames];
end

% Scale and show
toShow = (toShow-min(toShow(:)))./(max(toShow(:))-min(toShow(:)));
imshow(toShow)

% try xc
F1 = fftn(frameSet1);
F2 = fftn(frameSet2);

FXC = F1.*conj(F2);
FXCNorm = FXC./abs(FXC);

% Mask out regions with no support
phaseTFSmall = imresize3(single(abs(phaseTF)>0),size(FXCNorm),'linear');
xcMask = ifftshift(phaseTFSmall);

FXCNormMasked = padarray(fftshift(FXCNorm.*xcMask),[0 0 (8-numFrames)/2],'both');

fxc = fftshift(ifftn(ifftshift(FXCNormMasked)));

imagesc(squeeze(abs(fxc(129,:,:)))')