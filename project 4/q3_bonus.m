%%
% Load the receptive field
load('rf');
% setup the linear-nonlinear cascade
g = @(z) exp(z/2 - 0.1); % nonlinearity
f = @(x) g(sum(rf .* x, 'all'));
xFiles = {'x_theta', 'x_phase', 'x_sf'}; % mat file names with the stimuli
for kFile = 1:numel(xFiles)
    load(xFiles{kFile}); % load the stimulus images (stored in variable 'x')
    nX = numel(x); % how many stimuli?
    lambda = zeros(nX, 1); % prepare to store the mean firing rates

    fig = figure(5470 + kFile); clf
    subplot(2, nX+1, nX + 2);
    imagesc(rf); colormap('gray'); axis square; title('RF');

    for k = 1:nX % for each stimulus image
        subplot(2, nX+1, nX + k + 2);
        imagesc(x{k}); colormap('gray'); axis square % plot the stimulus
        title(paramRange(k));

        lambda(k) = f(x{k}); % <--- Key line: evaluate the tuning curve
    end

    subplot(2, nX+1, 2:(nX+1));
    plot(paramRange, lambda, 'o-');
    axis tight; xlabel(paramStr); ylabel('firing rate'); title('tuning curve');
end

[nx, ny] = size(rf);
nTrial = 10000;
s = randn(nx, ny, nTrial);          % random gaussian noise stimulus
sv = reshape(s, [nx * ny, nTrial]); % vectorize stimulus for speed

% simulate LNP
l = exp(rf(:)' * sv - 1.3);  % firing rate corresponding to each stimulus
y = poissrnd(l);             % Poisson spike count generation

mu = mean(y); % estimate sample mean
s2 = var(y);  % estimate sample variance
FF = (s2/mu); % estimate sample Fano factor [[Q1a: MODIFY THIS]]
 
fprintf('mean [%.3f] variance [%.3f] Fano factor [%.3f]\n', mu, s2, FF);

