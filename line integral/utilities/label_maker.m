function outStr = label_maker(p)
% Automatically labels display image

p1 = ['+/-' num2str(p.thruFocusRange) ' \mum'];
p2 = ' through focus,';
p3 = [' ' num2str(p.thruFocusdz) ' \mum increments'];
p4 = ' + XZ slice';
p5 = [' (' num2str(p.thruFocusImgWidthCrop) ' x ' num2str(p.thruFocusImgWidthCrop) ' \mum frame size)'];
    
outStr = [p1 p2 p3 p4 p5];