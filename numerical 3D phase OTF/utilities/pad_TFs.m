function [ptf,atf] = pad_TFs(ptfIn,atfIn,p)
%% PAD_TFS: pads 3D transfer functions to appropriate size

% dim 1
currentSize = size(ptfIn,1);
padAmmount = p.arrayLength - currentSize;
ptf = padarray(ptfIn,[ceil(padAmmount/2) 0 0],'pre');
ptf = padarray(ptf,[floor(padAmmount/2) 0 0],'post');
atf = padarray(atfIn,[ceil(padAmmount/2) 0 0],'pre');
atf = padarray(atf,[floor(padAmmount/2) 0 0],'post');

% dim 2
currentSize = size(ptfIn,2);
padAmmount = p.arrayLength - currentSize;
ptf = padarray(ptf,[0 ceil(padAmmount/2) 0],'pre');
ptf = padarray(ptf,[0 floor(padAmmount/2) 0],'post');
atf = padarray(atf,[0 ceil(padAmmount/2) 0],'pre');
atf = padarray(atf,[0 floor(padAmmount/2) 0],'post');

% dim 3
currentSize = size(ptfIn,3);
padAmmount = p.arrayLength - currentSize;
ptf = padarray(ptf,[0 0 ceil(padAmmount/2)],'pre');
ptf = padarray(ptf,[0 0 floor(padAmmount/2)],'post');
atf = padarray(atf,[0 0 ceil(padAmmount/2)],'pre');
atf = padarray(atf,[0 0 floor(padAmmount/2)],'post');