%% CC-BY 4.0 (Il Memming Park, 2020)
% Wolfram's rule 30 1D cellular automaton
% https://mathworld.wolfram.com/Rule30.html

T = 100;
N = T*2;
X = zeros(N, T);
X(ceil(N/2), 1) = 1; % initial condition

figure(347); clf;
colormap('gray');

for t = 2:T % time loop
    for k = 2:N-1 % space loop
        if  all(X(k-1:k+1,t-1) == [1;0;0]) || ...
                all(X(k-1:k+1,t-1) == [0;1;1]) || ...
                all(X(k-1:k+1,t-1) == [0;1;0]) || ...
                all(X(k-1:k+1,t-1) == [0;0;1])

            % if the conditions are met, set the future generation to 1
            % otherwise it stays 0
            X(k,t) = 1;
        end
    end
    imagesc(X);
    axis square
    drawnow; % update the figure now
end

xlabel('time'); ylabel('space'); axis square
title('Rule 30');