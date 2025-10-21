%% load the data
load('rf');
whos

%% plot the images 
figure(99); clf; colormap('gray'); % figure number 99, let's use gray

for t = 1:10 % run the next block for the first 10 time steps
    subplot(2, 5, t); % let's put several plots in one figure
    frame = rf(:, t); % take one 25 by 25 frame at time t
    imagesc(frame); % plot the pixels stored in the matrix 'frame' 
    caxis([-128, 128]); % each pixel intensity
    title(t);
    colorbar;
    axis square;
end

%% compute STA (Q3)


figure(347); clf; colormap('gray');
staSaved = cell(nNeuron, 1); % we'll save the results to use later

for kNeuron = 1:nNeuron
    sta = zeros(nx, ny); % initialize with zeros
    y = neuralResponses(kNeuron, :); % call the kNeuron's response y
    
    for t = 1:nT % for each frame of the movie
        frame = rf(:, t);
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

%%
M = [1, 2, 3; 4, 5, 6; 2, 4 ,7]
M(2,3)

b = zeros(2,3)