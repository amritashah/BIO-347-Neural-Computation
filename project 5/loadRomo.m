function data = loadRomo(filename, verbose)
% Load a single session from 
% Romo, Brody, Hernandez, Lemus. Nature 1999.
%
% Dataset downloaded from CRCNS (PFC-4) dataset
%
% Ranulfo Romo, Carlos D. Brody, Adrián Hernández, and Luis Lemus. (2016).
% Single-neuron spike train recordings from macaque prefrontal cortex during a somatosensory working memory task.
% CRCNS.org. http://dx.doi.org/10.6080/K0V40S4D
%
% written by Memming Park. 2020

if nargin < 2
    verbose = false;
end

if ~exist(filename, 'file') && ~exist([filename, '.mat'], 'file')
    error('File not found!');
end
matLoad = load(filename);

%%
[nRow, nCol] = size(matLoad.result);
row1 = matLoad.result(1,:);

if verbose
    fprintf('[%d] rows, [%d] columns\n', nRow, nCol);
    for k = 1:nCol
        fprintf('row %2d: [%s]\n', k, row1{k});
    end
end

%%
isCorrect = cell2mat(matLoad.result(2:end,3));
if verbose; fprintf('behavior is %.2f%% correct\n', mean(isCorrect) * 100); end

f1 = cell2mat(matLoad.result(2:end,4));
f2 = cell2mat(matLoad.result(2:end,5));

%% stimulus onset times (ms)
so1 = cell2mat(matLoad.result(2:end,9));
so2 = cell2mat(matLoad.result(2:end,10));

if verbose
    fprintf('stimulus 1 onset time [%.2f][SD %.3f]\n', mean(so1), std(so1));
    fprintf('stimulus 2 onset time [%.2f][SD %.3f]\n', mean(so2), std(so2));
    fprintf('interval between 1 and 2 [%.2f][SD %.3f]\n', mean(so2-so1), std(so2-so1));
end

%%
nTrial = nRow - 1;
maxNeuron = 7;

sts = cell(maxNeuron, nTrial);
aux = cell(2, nTrial);

for kTrial = 1:nTrial
    spks = matLoad.result{kTrial+1,6};
    for kNeuron = 1:maxNeuron
        sts{kNeuron, kTrial} = spks{kNeuron};
    end
    aux{1, kTrial} = spks{8};
    aux{2, kTrial} = spks{9};
end

%%
counts = nan(maxNeuron, nTrial);
for kNeuron = 1:maxNeuron
    counts(kNeuron, :) = cellfun(@numel, sts(kNeuron, :));
    if verbose; fprintf('mean spike count [%3.1f]\n', mean(counts(kNeuron, :))); end
end

%%
data.f1 = f1;
data.f2 = f2;
data.so1 = so1;
data.so2 = so2;
data.sts = sts;
data.frange0 = [10, 14, 18, 22, 26, 30, 34];
data.frange1 = unique(data.f1);
data.frange2 = unique(data.f2);
data.frange = union(data.frange1, data.frange2);
data.counts = counts;
data.aux = aux;
data.filename = filename;

data.f1idx = zeros(nTrial, 1);
data.f2idx = zeros(nTrial, 1);
for kTrial = 1:nTrial
    data.f1idx(kTrial) = find(data.frange == data.f1(kTrial), 1);
    data.f2idx(kTrial) = find(data.frange == data.f2(kTrial), 1);
end

end