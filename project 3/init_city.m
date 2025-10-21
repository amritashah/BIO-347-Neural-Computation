% initialize SAILnet parameters
% Joel Zylberberg, UC Berkeley 2010
% joelz@berkeley.edu
%*****************************************************
% for work stemming from use of this code, please cite
% Zylberberg, Murphy & DeWeese (2011) "A sparse coding model with synaptically
% local plasticity and spiking neurons can account for the diverse shapes of V1
% simple cell receptive fields", PLoS Computational Biology 7(10).
%****************************************************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This version of the code has by modified by Braden Brinkman for BIO
% 347/NEU 547 at Stony Brook University. (Sept. 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Image credits:
%
% https://www.flickr.com/photos/andreas_komodromos/33222592348/in/album-72157691401355372/
% https://www.flickr.com/photos/andreas_komodromos/42880510522/in/album-72157691401355372/
% https://www.flickr.com/photos/andreas_komodromos/44793714435/in/album-72157691401355372/
% https://www.flickr.com/photos/andreas_komodromos/27893382227/in/album-72157691401355372/
% https://www.flickr.com/photos/andreas_komodromos/34582839506/in/album-72157691401355372/
% https://www.flickr.com/photos/andreas_komodromos/5975816961/in/album-72157691401355372/
% https://www.flickr.com/photos/andreas_komodromos/48889147436/in/album-72157691401355372/
% https://www.flickr.com/photos/andreas_komodromos/48890139412/in/album-72157691401355372/
% https://www.flickr.com/photos/andreas_komodromos/12310958263/in/album-72157691401355372/
% https://www.flickr.com/photos/andreas_komodromos/48610017708/in/album-72157691401355372/

fprintf('Here we go _/) \n');

clear

% the filtered image array
load IMAGES_CITY

%general params
batch_size =100;        
%num_trials = 25000;
num_trials = 5000;


%input data
[imsize, imsize, num_images]=size(IMAGES);
BUFF=20;

% number of inputs
N=256;      %number of pixels in the patches
sz = sqrt(N);

% number of outputs
OC = 1;		%overcompleteness of neurons wrt pixels
M=OC*N;

% target output firing rate; spikes per neuron per image
p=0.05;

% Initialize network parameters 
%feedforward weights Q
%horizontal connections W
%thresholds theta

Q=randn(M,N);
Q=diag(1./sqrt(sum(Q.*Q,2)))*Q;
W=zeros(M);
theta=2*ones(M,1);

% learning rates
alpha=1;
beta=0.01;
gamma=0.1;

% rate parameter for computing moving averages to get activity stats
eta_ave=0.3;

% initialize average activity stats
Y_ave=p;
Cyy_ave=p^2;