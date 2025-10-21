%% load the data
load('rf');
whos

%% inspect some elements of the neural responses
y = neuralResponses(2, 1:12); % (Q2)
disp(y)

%% plot the images 
figure(99); clf; colormap('gray'); % figure number 99, let's use gray

for t = 1:10 % run the next block for the first 10 time steps
    subplot(2, 5, t); % let's put several plots in one figure
    frame = stimMovie(:, :, t); % take one 25 by 25 frame at time t
    imagesc(frame); % plot the pixels stored in the matrix 'frame' 
    caxis([-128, 128]); % each pixel intensity
    title(t);
    colorbar;
    axis square;
end

%% plot the target image (Q2)
figure(9292); clf; colormap('gray');
frame = stimMovie(:, :, 12); % (Q2)
imagesc(frame);
axis square;

%% compute STA (Q3)
nNeuron = 8; % no of neurons; same as size(neuralResponses, 1)
nT = 10000;  % no of presented images; same as size(neuralResponses, 2)
nx = 25;     % same as size(stimMovie, 1)
ny = 25;     % same as size(stimMovie, 2)

figure(347); clf; colormap('gray');
staSaved = cell(nNeuron, 1); % we'll save the results to use later

for kNeuron = 1:nNeuron
    sta = zeros(nx, ny); % initialize with zeros
    y = neuralResponses(kNeuron, :); % call the kNeuron's response y
    
    for t = 1:nT % for each frame of the movie
        frame = stimMovie(:, :, t);
        sta = sta + frame * y(t); % TODO (Q3) % summation
    end
    
    sta = sta / sum(y, 'all'); % TODO (Q3) % normalization
    
    % plotting code
    subplot(5,2,kNeuron);
    imagesc(sta);
    axis square
    caxis([-1, 1] * max(abs(sta(:))));
    colorbar;
    title(kNeuron)
    
    % save your sta to use later (for Q4)
    staSaved{kNeuron} = sta;
end