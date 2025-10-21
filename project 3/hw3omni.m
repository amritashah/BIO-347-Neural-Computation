%% HW3 omni script.

% This is overarching container script for HW3 for BIO 347 / NEU 547 (2020 Fall)
% Run PUBLISH on this script to generate the html file for your submission
% for this homework assignment. Please save the generated html file as a
% pdf and submit that pdf on Blackboard.
%
% Make sure to save this script in the same folder as the other files:
%   * hw3q1template.m
%   * init_city.m
%   * SAILnet.m
%   * activities.m
%   * showrfs.m
%   * imagereconstruction.m
%   * IMAGES_CITY.mat
%   * SBUimage.mat
%
% The following files will be required for the bonus problem:
%   * filterimages.m
%   * init_myimages.m

%% Q1.a-b

hw3q1template % This will run the script hw3q1template, which you must complete.

%% Q1c: Write your answers as comments here:

% i) As Tmax is increased, the SGD predictions agree better with the
% theoretical prediction. This is because increasing Tmax is increasing the
% number of iterations. For each iteration, a new stimulus is presented to
% the neuron and the value of A is adjusted another time to be closer to 
% the optimal value shown in Atheory. The more stimuli that are presented 
% to the neuron, the better the neuron can determine the optimal value of
% amplitude A.

% ii) For each run, a different set of stimulus values is presented to the
% neuron across all the iterations. A different set of stimulus values is
% being used to predict the optimal values of A for the neurons. This
% causes the predicted values of A to be slightly different for each run.


%% Palate cleansing (clean up before running next set of scripts)

clear % clear workspace
close all % close figures

%% Q2a. Write your answers as comments here:

% i) The receptive fields of the neuron trained on natural images have
% large variation in their features, and therefore in the visual stimuli
% they would respond to. These receptive fields include many different
% angles for edge detection, edges of varying widths, and different
% levels of contrast. The receptive fields of the neuron trained on grating
% images only include four different angles, all edges have the same
% widths, and only include a high level of contrast.

% ii) The network trained on gratings is much worse at encoding the image
% of SBU because its receptive field features only 0, 45, and 90 degree
% edges. These neurons only respond to edges of these angles, which are 
% relatively uncommon in a real photograph. They will not respond to any of 
% the natural aspects of the photo - trees, grass, bushes - since these 
% have edges of random angles. They will respond to some man-made structures 
% in the photo, as these are more likely to have perfect 0, 45, or 90 degree
% angle edges. Some examples include horizontal roofs, vertical poles and 
% walls, and tile patterns that may include horizontal, vertical, or 
% diagonal lines. The network trained on natural images, on the other hand, 
% responds to edges of many different angles. It is therefore able to 
% better encode the image of SBU.

% iii) An animal raised in a visual envrionment consisting of only these
% grating images would be unable to visualize most features of a natural
% landscape. The animal's brain would only be able to respond to edges with 
% a few angles, which are less likely to appear in nature.

%% Q2b. Write your answers as comments here:

% The receptive fields of the neuroons will include edges with a wide
% variety of angles and variety of widths. Since the images of the city
% include trees and man-made structures, the receptive fields will respond 
% to both softer (natural) and harsher (man-made) edges. Compared to the
% neurons trained on natural images, these neurons will respond better to
% buildings and man-made structures with more rigid angles. Compared to the
% neurons trained on grating images, these neurons will respond better to
% trees and humans with more random angles. Since these receptive fields
% essentially combine the response capabilities of the other two types of
% receptive fields, they will encode the image the best. 
 %% SAILnet on city images

% Initialize
init_city

%% Plot initial random receptive fields
figure; 
showrfs(Q)

%% Run SAILnet
SAILnet

%% Use the receptive fields to decode the SBU image from model neuron activity!

imagereconstruction

%%
close all % close figures

%% BONUS

% Uncomment the following lines only if you are doing the bonus problem.

%% SAILnet on city images

% Before running this section, find 10 images of a few hundred pixels on 
% each side. Save these images to this same folder and then modify and run
% the script filterimages.m. Once you have run the filterimages function
% you can run this section of the script. Note that the images you select
% will be displayed here, so do not select something inappropriate for 
% class/work! 

% Initialize
init_myimages

% Display the images the network is being "trained" on

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,1))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,2))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,3))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,4))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,5))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,6))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,7))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,8))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,9))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

figure; 
ax = axes;
imagesc(ax,IMAGES(:,:,10))
ax.XTick = [];
ax.YTick = [];
axis square
colormap('gray')

%% Plot initial random receptive fields
figure; 
showrfs(Q)


%% Run SAILnet
SAILnet

%% Use the receptive fields to decode a novel image!

imagereconstruction

%%
close all % close figures

%% BONUS b: Write your answers as comments here.

%


