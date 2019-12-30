function toShow = throughFocusAndAxialSlice(filtObj,slices)

%dZ = size(filtObj,3)/(numSlices-1);
%slices = (-(numSlices-1)/2*dZ):dZ:(numSlices-1)/2*dZ;

% Gather the slices
toShow = [];
for sIdx = slices
    toShow = [toShow, filtObj(:,:,end/2+1 + sIdx)];
    
end

% Append axial section
toShow = [toShow, squeeze(filtObj(end/2+1,:,:))'];

% Scale
toShow = (toShow-min(toShow(:)))./(max(toShow(:))-min(toShow(:)));
