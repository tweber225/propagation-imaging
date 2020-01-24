function object = make_complex_object(p)

% Initialize a 3D array for the object to fill
arraySize = p.objectSize/p.pixelSize;
object = zeros(arraySize,arraySize,arraySize,'single');

% Check which type of object
switch p.objectType
    
    case 'point' % delta function
        midPoint = arraySize/2+1;
        object(midPoint,midPoint,midPoint) = p.deltaN;
        
    case 'sphere'
        % Make 3d indices
        dimIdx = single((-arraySize/2):(arraySize/2-1));
        [xGr,yGr,zGr] = meshgrid(dimIdx,dimIdx,dimIdx);
        
        % Add centered sphere to object
        sphereRadiusInPixels = p.radius/p.pixelSize;
        sph = p.deltaN*(xGr.^2+yGr.^2+zGr.^2 < sphereRadiusInPixels^2);
        object = object + sph;
        
    case 'tube'
        % Make 2d indices
        dimIdx = single((-arraySize/2):(arraySize/2-1));
        [xGr,~,zGr] = meshgrid(dimIdx,1,dimIdx);
        
        % Add centered circle to 2D plane
        circleRadiusInPixels = p.radius/p.pixelSize;
        circ = p.deltaN*(xGr.^2 + zGr.^2 < circleRadiusInPixels^2);
        object = object + repmat(circ,[arraySize 1 1]);
        
    case 'monolayer'
        % Make 3d indices
        dimIdx = int16((-arraySize/2):(arraySize/2-1));
        [xGr,yGr,zGr] = meshgrid(dimIdx,dimIdx,dimIdx);
        sphereRadiusInPixels = p.radius/p.pixelSize;
        
        % Determine sphere centers in hex lattice
        spacingInPixels = p.sphereCenterSpacing/p.pixelSize;
        xCenters = int16((-arraySize/2):spacingInPixels:(arraySize/2));
        yCenters = int16((-arraySize/2):(spacingInPixels*sqrt(3)/2):(arraySize/2));
        
        % Make prototype sphere
        sph = uint8(xGr.^2+yGr.^2+zGr.^2 < sphereRadiusInPixels^2);
        
        % Shift protoype sphere and add to image
        object = zeros(arraySize,arraySize,arraySize,'uint8');
        for yIdx = 1:length(yCenters)
            yCenter = yCenters(yIdx);
            for xIdx = 1:length(xCenters)
                xCenter = xCenters(xIdx) + mod(yIdx,2)*spacingInPixels/2;
                zOffset = round(xCenter*tan(p.tiltXY(2)) + yCenter*tan(p.tiltXY(1)));
                newSphere = circshift(sph,[yCenter,xCenter,zOffset] + int16(p.centerRandomOffset*randn(1,3)));
                object = object + newSphere;
            end
        end
        
        object = single(object)*p.deltaN;
        
end