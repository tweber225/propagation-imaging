load_params
addpath('utilities')

%% Make the OTFs
[mu_x,mu_y,eta] = set_spatial_freq_range(p);
% Generate transfer functions
[ptf,atf] = generate_TF_paraxial(p,mu_x,mu_y,eta);
% Pad the transfer functions to the right sizes
[ptf,atf] = pad_TFs(ptf,atf,p);
% Set NaNs to 0
ptf(isnan(ptf)) = 0;

%% Display a slice of the OTF
ptfSlice = squeeze(ptf(p.arrayLength/2+1,:,:))';
imagesc([-1000 1000],[-1000 1000],sign(ptfSlice).*log(abs(ptfSlice)+eps))
%imagesc(ptfSlice)
axis equal
axis tight
set(gcf,'position',[100,100,250,250])
set(gca,'YDir','normal')
xticks([-1000 -500 0 500 1000])
yticks([-1000 -500 0 500 1000])
xlabel('\mu_x (cycles/mm)')
ylabel('\mu_z (cycles/mm)')

figure;
imagesc([-1000 1000],[-1000 1000],sign(ptfSlice).*log(abs(ptfSlice)+eps))
truesize
%imagesc(ptfSlice)
axis equal
axis tight
%set(gcf,'position',[100,100,1000,1000])
set(gca,'YDir','normal')
xticks([-1000 -500 0 500 1000])
yticks([-1000 -500 0 500 1000])
xlabel('\mu_x (cycles/mm)')
ylabel('\mu_z (cycles/mm)')

