function toShow = thru_focus_axial_slice(filtObj,crop,frameThruFocusStartEnd,frameThruFocusdz)

% Gather selected slices
slices = -frameThruFocusStartEnd:frameThruFocusdz:frameThruFocusStartEnd;
toShow = [];
for sIdx = slices
    toShow = [toShow, filtObj((floor(end/2)+1-crop):(floor(end/2)+1+crop),(floor(end/2)+1-crop):(floor(end/2)+1+crop),floor(end/2)+1 + sIdx)];
end

% Append axial section
toShow = [toShow, squeeze(filtObj(floor(end/2)+1,(floor(end/2)+1-crop):(floor(end/2)+1+crop),(floor(end/2)+1-crop):(floor(end/2)+1+crop)))'];

% Scale
toShow = (toShow-min(toShow(:)))./(max(toShow(:))-min(toShow(:)));
