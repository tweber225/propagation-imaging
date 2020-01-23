function toShow = throughFocusAndAxialSlice(filtObj,crop,slices)

%dZ = size(filtObj,3)/(numSlices-1);
%slices = (-(numSlices-1)/2*dZ):dZ:(numSlices-1)/2*dZ;

% Gather the slices
toShow = [];
for sIdx = slices
    toShow = [toShow, filtObj((floor(end/2)+1-crop):(floor(end/2)+1+crop),(floor(end/2)+1-crop):(floor(end/2)+1+crop),floor(end/2)+1 + sIdx)];
    
end

% Append axial section
toShow = [toShow, squeeze(filtObj(floor(end/2)+1,(floor(end/2)+1-crop):(floor(end/2)+1+crop),(floor(end/2)+1-crop):(floor(end/2)+1+crop)))'];

% Scale
toShow = (toShow-min(toShow(:)))./(max(toShow(:))-min(toShow(:)));
