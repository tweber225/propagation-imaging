function pinholeSpots = make_quadrant_pinhole_spots(pinholeFunc)

posIdx = 1:size(pinholeFunc,1);
posIdx = posIdx - size(pinholeFunc,1)/2 - 1/2;

% Select only the upper right quadrant
pinholeFunc(:,posIdx<=0) = 0;
pinholeFunc(posIdx>0,:) = 0;

[y,x] = ind2sub(size(pinholeFunc),find(pinholeFunc));

pinholeSpots = zeros(size(pinholeFunc,1),size(pinholeFunc,2),1,1,numel(y),'single');

% Loop through each slice and change one position to value 1
for spotIdx = 1:numel(y)
    pinholeSpots(y(spotIdx),x(spotIdx),1,1,spotIdx) = 1;
end
