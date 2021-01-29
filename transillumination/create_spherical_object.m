function out = create_spherical_object(p,d,centerPos)


x = d.posIdx;
y = d.posIdx'; % Y axis is dim 2
z = permute(d.zPosIdx,[3 1 2]); % Z axis is dim 3

F = (x - centerPos(1)).^2 + (y - centerPos(2)).^2 + (z - centerPos(2)).^2; % Implicit expansion to 3 dimensions

out = single(F <= p.r^2);

