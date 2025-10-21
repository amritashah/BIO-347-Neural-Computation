%% Change this section only (unless you are going for extra credits)
clear % note that this removes all variables in the workspace!
filename = 'R15052_001'; % <-- CHANGE THIS!
targetNeuron = 5; % <--- CHANGE THIS!

% Below are default settings. You may change them if you wish.
colorizeRaster = true; % colorize each trial's spike train with their 
sortRaster = true; % if this is false, the original experimental order is used
smoothingWindowSize = 201; % choose a large odd number (ms)
encodingDelay = 200; % how much after the stimulus onset do we start counting spikes? (ms)
encodingWindow = 500; % what's the window size for couting spikes? (ms)
figExtension = 'png'; % png or pdf, your choice

%% Load data
data = loadRomo(['hw5dataset/', filename], false);
nTrial = numel(data.f1);
nNeuron = size(data.sts, 1);
delay = data.so2 - data.so1;
fprintf('== loaded [%s] ==\n', data.filename);
fprintf('[%d trials] mean delay %.2f ms [SD: %.2f ms], median [%.2f ms]\n', nTrial, mean(delay), std(delay), median(delay));
mSC = mean(data.counts, 2);
fprintf('[%.2f spikes] ', mSC);
fprintf('\n[%d neurons total] [%d neurons with more than 5 spikes per trial]\n', nNeuron, sum(mSC > 5));
disp('f1 vibration stimulus set');
disp(unique(data.f1)')
disp('f2 vibration stimulus set');
disp(unique(data.f2)')
% prepare colormap
cmap = colormap('jet'); cmap = cmap(ceil(eps + size(cmap,1) * linspace(0, 0.9, numel(data.frange1))), :);
lstr = cell(numel(data.frange1), 1); 
for kF1 = 1:numel(data.frange1)
    lstr{kF1} = ['f1: ' num2str(data.frange1(kF1)) ' Hz'];
end

%% Encoding of the stimulus - plot tuning curves
fig = figure(347); clf;
for kNeuron = 1:nNeuron
    mFR1 = zeros(nTrial, 1); mFR2 = zeros(nTrial, 1);
    tuning1 = zeros(size(data.frange1)); tuning2 = zeros(size(data.frange2));
    tuning1SD = zeros(size(data.frange1)); tuning2SD = zeros(size(data.frange2));
    
    for kTrial = 1:nTrial
        t1 = data.so1(kTrial);
        t2 = data.so2(kTrial);
        st = data.sts{kNeuron, kTrial};
        br1 = t1 + encodingDelay <= st & st < t1 + encodingDelay + encodingWindow;
        br2 = t2 + encodingDelay <= st & st < t2 + encodingDelay + encodingWindow;
        mFR1(kTrial) = sum(br1) / encodingWindow * 1000;
        mFR2(kTrial) = sum(br2) / encodingWindow * 1000;
    end
    
    for kStim = 1:numel(data.frange1)
        tuning1(kStim) = mean(mFR1(data.f1 == data.frange1(kStim)));
        tuning1SD(kStim) = std(mFR1(data.f1 == data.frange1(kStim))) / sqrt(sum(data.f1 == data.frange1(kStim)));
    end
    
    for kStim = 1:numel(data.frange2)
        tuning2(kStim) = mean(mFR2(data.f2 == data.frange2(kStim)));
        tuning2SD(kStim) = std(mFR1(data.f2 == data.frange2(kStim))) / sqrt(sum(data.f2 == data.frange2(kStim)));
    end
    
    % plot it!
    subplot(1, nNeuron, kNeuron); hold all;
    errorbar(data.frange1, tuning1, tuning1SD, 'o-', 'LineWidth', 2)
    errorbar(data.frange2, tuning2, tuning2SD, 'o-', 'LineWidth', 1.5)
    lh = legend('f1', 'f2'); set(lh, 'box', 'off');
    xlabel('stimulus frequency (Hz)'); ylabel('mean firing rate');
    title(sprintf('Tuning curve [%d]', kNeuron));
    axis square
end

set(fig, 'Renderer', 'painters', 'PaperUnit', 'inches', 'PaperSize', [20, 6], 'PaperPosition', [0, 0, 20, 6]);
saveas(fig, sprintf('%s_tuning_curves.%s', filename, figExtension));

%% Spike train raster plot (sorted)
% Only for the selected neuron
fig = figure(547); clf; hold all;

ah = area([0, 0, 500, 500], [0, nTrial+1, nTrial+1, 0]); % f1 duration
set(ah, 'FaceAlpha', 0.1, 'EdgeAlpha', 0.1);
ah = area(median(delay) + [0, 0, 500, 500], [0, nTrial+1, nTrial+1, 0]); % f2 duration
set(ah, 'FaceAlpha', 0.1, 'EdgeAlpha', 0.1);

if sortRaster
    [~, sidx] = sort(data.f1, 'descend');
else
    sidx = 1:nTrial;
end

for kTrial = 1:nTrial
    st = data.sts{targetNeuron, kTrial} - data.so1(kTrial); % ALIGN by first stimulus time
    sTrial = find(sidx == kTrial); % sorted order
    if colorizeRaster
        c = cmap(find(data.frange1 == data.f1(kTrial), 1), :) * 0.8;
    else
        c = [0, 0, 0]; % black
    end
    plot(st, sTrial * ones(numel(st), 1), '.', 'Color', c);
end
set(gca, 'TickDir', 'out');
if sortRaster
    ylabel('sorted trials');
else
    ylabel('trials');
end
xlabel('time (ms)');
xlim([-500, 4500]);
ylim([0, nTrial+1]);

set(fig, 'Renderer', 'painters', 'PaperUnit', 'inches', 'PaperSize', [10, 6], 'PaperPosition', [0, 0, 10, 6]);
saveas(fig, sprintf('%s_%d_raster.%s', filename, targetNeuron, figExtension));

%% Get conditional PSTH
% binarized matrix representation for the ease of computing PSTH
bsts = zeros(5000, nTrial);
tr = -499:4500;
for kTrial = 1:nTrial
    st = data.sts{targetNeuron, kTrial} - data.so1(kTrial) + 500;
    st(st <= 0) = []; st(st >= 5000) = [];
    bsts(ceil(st), kTrial) = 1;
end
% smoothed conditional PSTH
smoothingWindow = normpdf(linspace(-2,2,smoothingWindowSize));
smoothingWindow = smoothingWindow - min(smoothingWindow); smoothingWindow = smoothingWindow / sum(smoothingWindow);
%smoothingWindow = hanning(smoothingWindowSize); smoothingWindow = smoothingWindow / sum(smoothingWindow);
sbsts = filter(smoothingWindow, 1, bsts, [], 1);
grpDelay = round((smoothingWindowSize - 1)/2); % round shouldn't be needed

fig = figure(548); clf; hold all;
ph = zeros(numel(data.frange1), 1);
for kF1 = 1:numel(data.frange1)
    psth = mean(sbsts(:, data.f1 == data.frange1(kF1)), 2);
    ph(kF1) = plot(tr - grpDelay, psth * 1000, 'Color', [cmap(kF1, :), 0.8], 'LineWidth', 3);
end
grid on;
xlim([-500+2*grpDelay, 4500-2*grpDelay]);
lh = legend(ph, lstr, 'Location', 'Best'); set(lh, 'box', 'off', 'FontSize', 15);
ylabel('firing rate'); xlabel('time (ms)');

set(fig, 'Renderer', 'painters', 'PaperUnit', 'inches', 'PaperSize', [10, 5], 'PaperPosition', [0, 0, 10, 5]);
saveas(fig, sprintf('%s_%d_psth.%s', filename, targetNeuron, figExtension));