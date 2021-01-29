function out = create_spherical_object(posIdx,zPosIdx,centerPos,r,nd)


x = posIdx;
y = posIdx'; % Y axis is dim 2
z = permute(zPosIdx,[3 1 2]); % Z axis is dim 3

F = (x - centerPos(1)).^2 + (y - centerPos(2)).^2 + (z - centerPos(2)).^2; % Implicit expansion to 3 dimensions

out = nd*single(F <= r^2);

