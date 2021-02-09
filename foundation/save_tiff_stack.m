function save_tiff_stack(saveDirAndName,stackData)
% This function requires "Fast_Tiff_Write.m" to be in the path

% Make the fTIF object
fTIF = Fast_Tiff_Write(saveDirAndName,1,0);

% The writer's 3rd dimension is reserved for color, so we need to permute
% the input data's 3rd dimension into the 4th dimension. Also turns out we
% have to swap the first and second dimensions too.
stackData = permute(stackData,[2 1 4 3]);

% Loop through writing each slice's data
for fIdx = 1:size(stackData,4)
    fTIF.WriteIMG(stackData(:,:,:,fIdx));
end

% Close the fTIF object, which also writes all the IFDs
fTIF.close;