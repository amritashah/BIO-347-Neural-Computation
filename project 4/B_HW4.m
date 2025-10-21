%% Q1a
%rng(2478); % set a fixed random seed [[you may uncomment this and modify]]
T = 0.001; % total duration in seconds
lambda = 10; % (spikes/sec) mean firing rate
nTrial = 1000; % number of samples to draw [[Q1a: MODIFY THIS]]
Lambda = lambda * T; % parameter for the Poisson distribution
y = poissrnd(Lambda, nTrial, 1); % draw nTrial number of pseudo-random Poisson samples

mu = mean(y); % estimate sample mean
s2 = var(y); % estimate sample variance
FF = (s2/mu); % estimate sample Fano factor [[Q1a: MODIFY THIS]]
fprintf('mean [%.3f] variance [%.3f] Fano factor [%.3f]\n', mu, s2, FF);

%% Q1b : divide the Poisson distribution for duration T into smaller bins
% to verify the sum property, and understand the **Poisson process**
T = 1; % total duration in seconds
lambda = 5.5; % (spikes/sec) mean firing rate
nTrial = 10000; % number of samples to draw [[Q1a: MODIFY THIS]]
Lambda = lambda * T; % parameter for the Poisson distribution

dt = .0001; % bin size in seconds [[Q1c: MODIFY THIS]]
nBin = ceil(T/dt); % number of bins within T, rounded up
y = poissrnd(lambda * dt, nTrial, nBin);
y2 = sum(y, 2); % add the Poisson samples for smaller time bins together
mu = mean(y2);
s2 = var(y2);
FF = (s2/mu); % estimate sample Fano factor [[Q1b: MODIFY THIS]]

fprintf('mean [%.3f] variance [%.3f] Fano factor [%.3f]\n', mu, s2, FF);

% optional plotting of the spike trains
% fig = figure(4000); clf;
% imagesc(y < 1); axis xy; colormap('gray'); set(gca, 'TickDir', 'out');
% xlabel('time (ms)');
% ylabel('trials');
% ylim(0.5 + [0, min(nTrial,50)]); % just the first 50 trials
% note that the spikes may not show up correctly if your figure window is 
% too small. Try zooming in if you suspect there are more spikes.
% poisspdf([0.1,0.01,0.001,0.0001],Lambda)

% ISI distribution (Q1d)
% Collect the inter-spike intervals from each trial
isi = [];
sts = cell(nTrial, 1);
for kTrial = 1:nTrial
    st = find(y(kTrial, :)); % find the index of all the non-zero bins
    st = st * dt; % convert array index to spike times
    isi = [isi, diff(st)]; % take the difference between the times and collect them
    sts{kTrial} = st;
end
% generate a plot of ISI distribution
fig = figure(591); clf;
histogram(isi * 1000, ceil(numel(isi)/15))
title('inter-spike interval distribution');
xlabel('ISI (ms)');
ylabel('occurrence');

%% setup the true tuning curve
% the commented examples below are for fun:
%f = @(x) 5*(sind((x-11))/2 + 0.5).^2 + 0.6; % a broad tuning curve
%f = @(x) 4*(cosd((x-150))/2 + 0.5).^10 + 0.6; % a narrow tuning curve
%f = @(x) exp(2 * cosd(x + 30).^2 - 0.5); % exponentiated exp-cos-square
%f = @(x) 2 * (x/60).^2 + 1; % quadratic
f = @(x) 4*((cosd(x-45) + 1).^2); % [[Q2a: UNCOMMENT and MODIFY THIS]]
xr = linspace(0, 360); % generate uniform grid from 0 to 360 degrees
fig = figure(3471); clf; hold all;
ph1 = plot(xr, f(xr), '-', 'LineWidth', 3);
ylabel('mean firing rate (spk/s)');
xlabel('orientation (degrees)');
title('tuning curve');

%% Simulate spike counts and estimate tuning curve 
stimuli = [0, 45, 90, 135, 180, 225, 270, 315, 360]; % equiv to 0:45:360 
T = 2;       % [[Q2c: MODIFY THIS]] 
nTrial = 20; % [[Q2c: MODIFY THIS]] 
  
nStim = numel(stimuli); % number of stimuli 
meanSpikeCount = zeros(nStim, 1); % prepare to save the mean spike counts 
fig = figure(3471); % plot on the same figure as tuning curve 
  
for kStim = 1:nStim % for each stimuli     
    stim = stimuli(kStim); 
     
    % simulate the Poisson neuron model     
    lambda = f(stim); 
    y = poissrnd(T * lambda, nTrial, 1); 
     
    % estimate the mean spike count, pretending we don't know f     
    meanSpikeCount(kStim) = lambda*T/2;  %% [[Q2b: MODIFY THIS]] 
     
    % plot individual trials (use random jitter to enhance visualization)     
    ph2 = plot(stim + 5 * (rand(nTrial, 1) - 0.5), y / T, 'xk'); 
end 
  
% plot the estimated curve 
ph3 = plot(stimuli, meanSpikeCount, 'o:r', 'MarkerFaceColor', 'r', 'MarkerSize', 8, 'LineWidth', 2); 
legend([ph1, ph2, ph3], 'true tuning curve', 'spike counts', 'estimated tuning curve'); 

