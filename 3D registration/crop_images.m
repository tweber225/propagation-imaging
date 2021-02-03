function cropped = crop_images(img,cropFraction)
% At most the img argument should be 4D (x,y,z,t)

x1 = round(size(img,2)*(1/2 - cropFraction/2)) + 1;
x2 = round(size(img,2)*(1/2 + cropFraction/2));

y1 = round(size(img,1)*(1/2 - cropFraction/2)) + 1;
y2 = round(size(img,1)*(1/2 + cropFraction/2));

cropped = img(y1:y2,x1:x2,:,:);