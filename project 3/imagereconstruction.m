%% Image reconstruction

% This script will use the input weight matrices (receptive fields) learned
% by SAILnet to try and decode a novel visual stimulus input. This image,
% loaded below, will be presented to the trained network in 16x16 patches
% to drive the activity of the neurons. Using the observed activity and the
% receptive field matrix Q we can try to 'decode' the original input image.
% This will allow us to assess how well different sets of receptive fields
% decode visual stimuli.

% In order to do this image reconstruction a few preprocessing steps are
% required. As explained in the assignment pdf, we assume that retina or
% LGN "filters" visual images before they arrive at V1. In V1 the mean
% pixel intensity of each image patch is removed and its standard deviation 
% is normalized. In order to properly reconstruct the image, however, we 
% need to record the original means and standard deviations of each patch
% so that we can add them back to our reconstructed image. Physiologically,
% we are essentially assuming that this information is communicated by
% neurons not explicitly modeled in SAILnet.

% Load the test image
load SBUimage.mat
imagetest = SBUW;

% Image is square; extract the size of each row/column.
[~,imsize] = size(imagetest);

% Number of neurons in SAILnet
N = 256; % default value.

% dimensions of the receptive field Q
sz = sqrt(N);

P = imsize/sz; % number of patches in the image

spkgrid = zeros(N,P,P); % spikes for each neuron and each patch of the image.
Sestimate = zeros(size(imagetest)); % Matrix to contain the decoded image.
imagemeans = zeros(P,P); % need to record the original patch mean.
imagestd = zeros(P,P); % need to record the original patch standard deviation.

% Calculate the activity of the network to each patch of the image.
for k=1:P
    for l=1:P
    X = reshape(imagetest(((k-1)*sz+1):(k*sz),((l-1)*sz+1):(l*sz)),N,1); % reshapes the array into a 1d array that SAILnet expects
    imagemeans(k,l) = mean(X); % record mean
    imagestd(k,l) = std(X); % record standard deviation.
    X = (X-imagemeans(k,l))/imagestd(k,l); % normalize the input patch
    spkgrid(:,k,l) = activities(X,Q,W,theta); % simulate the network activity
    end
end

% Decode the original images

for k=1:P
    for l=1:P
        Sestimate(((k-1)*sz+1):(k*sz),((l-1)*sz+1):(l*sz)) = imagestd(k,l)*reshape(spkgrid(:,k,l)'*Q,sz,sz)+imagemeans(k,l);  
    end
end

%% Plot the reconstructed image.

figure;
ax = axes;
imagesc(ax,imagetest)
title('Filtered input image','FontSize',20);
ax.XTick = [];
ax.YTick = [];
axis square;
colormap('gray');

figure;
ax = axes;
imagesc(ax,Sestimate)
title('Decoded image','FontSize',20);
ax.XTick = [];
ax.YTick = [];
axis square;
colormap('gray');



