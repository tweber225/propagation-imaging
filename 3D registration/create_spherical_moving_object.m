function movingObject = create_spherical_moving_object(posIdx,zPosIdx,objStruct)


% Make domain coordinates
x = posIdx;
y = posIdx'; % Y axis is dim 2
z = permute(zPosIdx,[3 1 2]); % Z axis is dim 3
% and dim 4 will be time

% Create vectors of time-varying sphere center positions
t = permute(0:(objStruct.numTimePoints-1),[4 3 1 2]);
centerPos = objStruct.centerStartPos + objStruct.velocity.*t;

% Evaluate sphere boundary
F = (x - centerPos(1,1,1,:)).^2 + (y - centerPos(2,1,1,:)).^2 + (z - centerPos(3,1,1,:)).^2; % Implicit expansion to 3 dimensions
movingObject = objStruct.dn*single(F <= objStruct.r^2);