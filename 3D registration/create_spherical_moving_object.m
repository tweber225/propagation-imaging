function movingObject = create_spherical_moving_object(posIdx,zPosIdx,objStruct)

%% Make domain coordinates
x = posIdx;                     % X axis is dim 2
y = posIdx';                    % Y axis is dim 2
z = permute(zPosIdx,[3 1 2]);   % Z axis is dim 3
t = linspace(objStruct.timeStart,objStruct.timeEnd,objStruct.numTimes);
t = permute(t,[4 3 1 2]);       % T is dim 4
% dim 5 will be particle index (for multi particle objects)


%% Create vectors of time-varying sphere center positions

% Make random center starting positions (I sincerely apologize about how
% ridiculous the indexing is getting here)
centerStartPos = [(rand(1,1,1,1,objStruct.particleCount)-.5)*(x(end)-x(1)); ...
    (rand(1,1,1,1,objStruct.particleCount)-.5)*(y(end)-y(1)); ...
    (rand(1,1,1,1,objStruct.particleCount)-.5)*(z(end)-z(1))];

% Make list of center locations for each particle
centerPos = centerStartPos + objStruct.velocity + ...
    objStruct.movementAmplitude.*cos(2*pi*t./objStruct.movementPeriod);

% Evaluate each separate sphere boundary (have to loop because of memory
% constraints)
movingObject = zeros(length(y),length(x),length(z),objStruct.numTimes,'logical');
for pIdx = 1:objStruct.particleCount
    disp(['Rendering particle ' num2str(pIdx) ' of ' num2str(objStruct.particleCount)])
    
    F = (x - centerPos(1,1,1,:,pIdx)).^2 ...
        + (y - centerPos(2,1,1,:,pIdx)).^2 ...
        + (z - centerPos(3,1,1,:,pIdx)).^2; % Implicit expansion to 3 dimensions
    
    movingObject = movingObject | (F <= single(objStruct.r)^2);
end
    
% Sum all the spheres
%movingObject = sum(movingObject,5);