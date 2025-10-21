function plotConvSTA(sta, img)
% Generate a plot with 3 things: STA, image convolved with STA, and
% its thresholded version.
%
% Input
%   sta: (nx x ny) 2D matrix of receptive field or spike-triggered-average
%   img: (ix x iy) 2D grayscale image to be analyzed via the eye of sta
%
% This function is part of BIO 347 / NEU 547 homework 2.

    nCol = 5;
    colormap('gray'); colorbar
    
    %%
    subplot(1, nCol, 1);
    imagesc(sta);
    axis square;
    axis ij
    caxis([-1, 1] * max(abs(sta(:))));
    title('STA');

    %%
    subplot(1, nCol, 1 + (1:2));
    cimg = conv2(img, sta, 'same');
    imagesc(cimg);
    caxis([-1, 1] * max(abs(caxis())));
    axis equal; axis tight; set(gca, 'XTick', [], 'YTick', []);
    title('simple neural response');
    
    %%
    subplot(1, nCol, 1 + (3:4));
    imagesc(cimg > quantile(cimg(:), 0.8));
    axis equal; axis tight; set(gca, 'XTick', [], 'YTick', []);
    title('thresholded neural response');
end