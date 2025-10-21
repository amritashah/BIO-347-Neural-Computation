%% CC-BY 4.0 (Il Memming Park, 2020)
% 1D cellular automaton consisting of McCulloch-Pitts neurons

T = 100;
N = T*2;
X = zeros(N, T);
threshold = 2;

%% Initial condition (uncomment one of the following)
%X(ceil(N/2), 1) = 1; % initial condition: single spike at the center
X(:, 1) = rand(N, 1) > 0.5; % initial condition: random fair coin flips
%X(:, 1) = ones(N, 1); % initial condition: everybody active
%X(1:2:N, 1) = 1; % initial condition: everybody other one active

%% Weights (uncomment one of the following)
% each neuron is connected to itself and two neighbors with the following
% weights: [neighbor_above, self, neighbor_below]
w = [2, 0, 0];
%w = [0, 0, 2];
%w = [1, 1, 2];
%w = [0, 2, 0];
%w = [1, 0, 1];
%w = [1, -1, 1];
%w = [2, -4, 2];
%w = [1, 1, 1];

%% Simulate and plot
figure(347); clf;
colormap('copper');

for t = 2:T % time loop
    % random boundary conditions
    X(1,t) = rand > 0.5; % fair coin flip
    X(N,t) = rand > 0.5;
    
    for k = 2:N-1 % loop over each neuron within the boundary
        if  w * X(k-1:k+1,t-1) >= threshold
            X(k,t) = 1;
        end
    end
    imagesc(X); ylim([2, N-1]);
    axis square
    drawnow; % update the figure now
end

xlabel('time'); ylabel('neurons'); axis square; ylim([2, N-1]);
title('McCulloch-Pitts neurons');