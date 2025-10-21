%% CC-BY 4.0 (Il Memming Park, 2020)
% Let's simulate some forest fire! 2D cellular automaton.

%% Setting parameters
% our forest will be modeled as a rectangle grid of size nx by ny
nx = 200;
ny = 400;
% we'll represent young trees as 1, and old trees as 10. 0 means no tree.
nTreeState = 10; % how many discrete states of forest growth?
% we'll represent the fire as 11, and cooling ashes as 12 to 15
nFireState = 5;

%% some premade scenarios
switch(0) % <-- Try changing the number in here from 0 to 5 (HERE!!)
    case 0
        pFirePropagates = 0.55;
        pFireStarts = 1;
        tauGrowth = 7;
        minBurnAge = 6;
    case 1
        pFirePropagates = 0.5;
        pFireStarts = 0.5;
        tauGrowth = 10;  % how fast the trees grow (shorter time constant is faster)
        minBurnAge = 4;
    case 2
        pFirePropagates = 0.8;
        pFireStarts = 0.3;
        tauGrowth = 10;
        minBurnAge = 4;
    case 3
        pFirePropagates = 0.8;
        pFireStarts = 0.3;
        tauGrowth = 3;
        minBurnAge = 4;
    case 4
        pFirePropagates = 0.48;
        pFireStarts = 100;
        tauGrowth = 10;
        minBurnAge = 4;
    case 5
        pFirePropagates = 1;
        pFireStarts = 0.1;
        tauGrowth = 5;
        minBurnAge = 5;
end

assert(minBurnAge < nTreeState)
assert(tauGrowth > 0)
assert(pFirePropagates >= 0)
assert(pFireStarts >= 0)

%% let's make a forest
forest = round(nTreeState * rand(nx,ny)); % start with some randomly grown trees
forest_cmap = [linspace(0,100,nTreeState)',linspace(0,255,nTreeState)',zeros(nTreeState,1)] / 255;
fire_cmap = [linspace(255,0,nFireState)', 32 * ones(nFireState,2)] / 255;
cmap = [forest_cmap; fire_cmap];

% Let's open a new figure window, numbered 347
fig = figure(347);
colormap(cmap); % set the colormap
image(forest);
axis equal
axis tight
axis ij
gcaOpts = {'XTick', [], 'YTick', []};
set(gca, gcaOpts{:}); % remove ticks for more plesant viewing
set(gcf, 'Color', 'w');

%%
T = 10000;

for t = 1:T
    fprintf('%d/%d (press Ctrl-C to stop)\r', t, T);
    %% first grow some trees. Younger trees grow faster
    treeIdx = find(forest < nTreeState);
    pGrowth = exp(-forest(treeIdx)/nTreeState*tauGrowth);
    growIdx = treeIdx(rand(numel(pGrowth),1) < pGrowth);
    forest(growIdx) = forest(growIdx) + 1;
    
    %% fire keeps burning
    fireConitnuesIdx = find(forest > nTreeState);
    
    %% propagate the fire
    fireIdx = find(forest == nTreeState + 1);
    [row, col] = ind2sub([nx, ny], fireIdx);
    neiSub = [row+1, col; row-1, col; row, col+1; row, col-1];
    neiSub = neiSub(neiSub(:,1) > 0 & neiSub(:,1) <= nx, :);
    neiSub = neiSub(neiSub(:,2) > 0 & neiSub(:,2) <= ny, :);
    neiIdx = sub2ind([nx,ny],neiSub(:,1),neiSub(:,2));
    neiSub = neiSub(forest(neiIdx) <= nTreeState & forest(neiIdx) >= minBurnAge,:);
    if ~isempty(neiSub)
        neiSub = neiSub(rand(size(neiSub,1),1) < pFirePropagates,:);
        propagateIdx = sub2ind([nx,ny],neiSub(:,1),neiSub(:,2));
        forest(propagateIdx) = nTreeState + 1;
    end
    
    %%
    forest(fireConitnuesIdx) = forest(fireConitnuesIdx) + 1;
    ashIdx = find(forest > nTreeState + nFireState);
    forest(ashIdx) = 0; % no tree, no fire
    
    %% ignite some trees. Older trees are more likely to start burning.
    treeIdx = find(forest <= nTreeState);
    pIgnite = pFireStarts * exp(forest(treeIdx)/nTreeState*10) / exp(10) / nx / ny;
    igniteIdx = treeIdx(rand(numel(pIgnite),1) < pIgnite);
    forest(igniteIdx) = nTreeState + 1;
    
    %% redraw the updated forest
    image(forest);
    set(gca, gcaOpts{:});
    drawnow;
    pause(0.01);
end