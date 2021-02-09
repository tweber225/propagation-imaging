function movingObject = create_spherical_moving_object(posIdx,zPosIdx,stackIdx,objStruct,subFrameFocalPlanes)

%% Make domain coordinates
x = posIdx;                     % X axis is dim 2
y = posIdx';                    % Y axis is dim 2
z = permute(zPosIdx,[3 1 2]);   % Z axis is dim 3
dt = (objStruct.timeEnd-objStruct.timeStart)/(objStruct.numStacks*numel(subFrameFocalPlanes));
t = objStruct.timeStart:dt:(objStruct.timeEnd-dt);
tStart = (stackIdx-1)*numel(subFrameFocalPlanes) + 1;
tEnd = tStart + numel(subFrameFocalPlanes) -1;
t = t(tStart:tEnd);
t = permute(t,[4 3 1 2]);       % T is dim 4
% dim 5 will be particle index (for multi particle objects)


%% Create vectors of time-varying sphere center positions

% Make list of center locations for each particle
centerPos = objStruct.centerStartPos + objStruct.velocity.*t + ...
    objStruct.movementAmplitude.*cos(2*pi*t./objStruct.movementPeriod);

% Evaluate each separate sphere boundary (have to loop because of memory
% constraints)
movingObject = zeros(length(y),length(x),length(z),length(t),'logical');
for pIdx = 1:objStruct.particleCount
    %disp(['Rendering particle ' num2str(pIdx) ' of ' num2str(objStruct.particleCount)])
    
    F = (x - centerPos(1,1,1,:,1,1,pIdx)).^2 ...
        + (y - centerPos(2,1,1,:,1,1,pIdx)).^2 ...
        + (z - centerPos(3,1,1,:,1,1,pIdx)).^2; % Implicit expansion to 3 dimensions
    
    movingObject = movingObject | (F <= single(objStruct.r)^2);
end
    
% Sum all the spheres
%movingObject = sum(movingObject,5);