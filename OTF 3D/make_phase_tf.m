function phaseTF = make_phase_tf(otf)

% Make phase transfer function
otf2 = padarray(otf,[1 1 1],'post');
otf2 = flip(flip(flip(otf2,3),2),1);
phaseTF = otf - otf2(1:(end-1),1:(end-1),1:(end-1));
