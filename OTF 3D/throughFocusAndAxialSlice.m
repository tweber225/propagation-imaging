function toShow = throughFocusAndAxialSlice(filtObj,slices)

% Gather the slices
toShow = [];
for sIdx = slices
    toShow = [toShow, filtObj(:,:,end/2+1 + sIdx)];
    
end

% Append axial section
toShow = [toShow, squeeze(filtObj(end/2+1,:,:))'];

% Scale
toShow = (toShow-min(toShow(:)))./(max(toShow(:))-min(toShow(:)));
