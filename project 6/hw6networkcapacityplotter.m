%% Hopfield network capacity plotter
% BIO 347 / NEU 547 HW 6
% Written by Dr. Braden Brinkman @ Nov. 2020

% You will use this script to plot the data you obtained during your
% investigation of the Hopfield Network's memory capacity. 

% Follow the instructions in the HW6 pdf for which set of data to plot in
% this script.

Nneurons = (2:10).^2; % the sizes of the Hopfield networks you investigated

Pmax = [1,1,5,8,11,5,14,16,21]; % [MODIFY THIS]! Replace the '?' with the values you obtained for Pmax.

figure;
ax = axes;
plot(ax,Nneurons,Pmax,'o-','LineWidth',3)
hold on;
plot(ax,Nneurons,(mean(Nneurons.*Pmax) - mean(Nneurons)*mean(Pmax))...
    /(mean(Nneurons.^2)-mean(Nneurons)^2)*(Nneurons - mean(Nneurons))...
    + mean(Pmax),'r--','LineWidth',3)
xlabel('Network size (number of neurons)','Interpreter','latex','FontSize',20);
ylabel('Maximum number of patterns stored','Interpreter','latex','FontSize',20);
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
lgd = legend('Data','Linear fit','location','northwest');
legend('boxoff');
lgd.Interpreter = 'latex';
lgd.FontSize = 20;