%% HW3 Q1. Stochastic Gradient Descent on a simple neuron model

% This is a template for HW3 for BIO 347 / NEU 547 (2021 Fall)
% You'll need to fill in missing parts of this script. (marked as % TODO)
% You are not required to change anything but the lines marked with TODO
% Make sure to save this script in the same folder as hw3omni.m.

%% Let's start fresh!
clear % clear workspace variables
close all % close all figures

%% Q1a. Stochastic gradient descent starting from zero amplitude

%%%%%%%%%%%%%%%%%%%%
% Define parameters:
%%%%%%%%%%%%%%%%%%%%

% Array of tuning curve exponents
alpha = 0:0.1:8;

% learning rate
c = 0.1;

% Number of gradient descent iterations
Tmax = 50;

% The theoretically predicted value of the optimal firing amplitude
Atheory = (1+2*alpha)./(2+alpha);


%%%%%%%%%%%%%%%%%%%%
% Define variables:
%%%%%%%%%%%%%%%%%%%%

% The initial value of the amplitude for each value of theta.
A = zeros(1,numel(alpha));

% Stochastic gradient descent iterations
for t=1:Tmax
    
    s = rand(); % Randomly draw a new stimulus from the range [0, 1].
    A = A - c*(2.*(s.^alpha).*(((s.^alpha).*A)-s)); % TODO. Enter your expression for the 
                              % derivative of E(s,A) with respect to A.
   
end

%% Plot results of the gradient descent. [DO NOT MODIFY!]

% Plot the amplitude versus firing threshold
figure;
ax = axes;
plot(ax,alpha,Atheory,'LineWidth',5)
hold on;
plot(ax,alpha,A,'ro','MarkerSize',10)
ylim([0,3])
xlabel('$\alpha$','interpreter','latex')
title('Amplitude $A$ for initial value $A_1 = 0$','interpreter','latex')
lg = legend('$A_{\rm optimal}$','$A_{\rm SGD}$','Location','Northwest');
legend('boxoff')
lg.Interpreter = 'latex';
lg.FontSize = 20;
ax.FontSize = 20;

%% Q1b. Stochastic gradient descent starting from a non-zero amplitude.

% This section is a copy of part of the code for Q1a except that the initial value
% of the amplitude is to be increased. You will have to fill in your
% solution from Q1a again.

%%%%%%%%%%%%%%%%%%%%
% Define variables:
%%%%%%%%%%%%%%%%%%%%

% The initial value of the amplitude for each value of theta.
Tmax1 = 100; % TODO. Change this line to increase the number 
                       % of stimulus presentations.

A1 = zeros(1,numel(alpha));
% Stochastic gradient descent iterations
for t=1:Tmax1
    
    s = rand(); % Randomly draw a new stimulus from the range [-1, 1].
    A1 = A1 - c*(2.*(s.^alpha).*(((s.^alpha).*A1)-s)); % TODO. Enter your expression for the 
                              % derivative of E(s,A) with respect to A.
   
end

% The initial value of the amplitude for each value of theta.
Tmax2 = 2000; % TODO. Change this line to increase the number 
                       % of stimulus presentations.

A2 = zeros(1,numel(alpha));
% Stochastic gradient descent iterations
for t=1:Tmax2
    
    s = rand(); % Randomly draw a new stimulus from the range [-1, 1].
    A2 = A2 - c*(2.*(s.^alpha).*(((s.^alpha).*A2)-s)); % TODO. Enter your expression for the 
                              % derivative of E(s,A) with respect to A.
   
end

% The initial value of the amplitude for each value of theta.
Tmax3 = 8000; % TODO. Change this line to increase the number 
                       % of stimulus presentations.

A3 = zeros(1,numel(alpha));
% Stochastic gradient descent iterations
for t=1:Tmax3
    
    s = rand(); % Randomly draw a new stimulus from the range [-1, 1].
    A3 = A3 - c*(2.*(s.^alpha).*(((s.^alpha).*A3)-s)); % TODO. Enter your expression for the 
                              % derivative of E(s,A) with respect to A.
   
end

%% Plot results of the gradient descent. [DO NOT MODIFY!]

% Plot the amplitude versus firing threshold
figure;
ax = axes;
plot(ax,alpha,Atheory,'LineWidth',5)
hold on;
plot(ax,alpha,A1,'ro','MarkerSize',10)
plot(ax,alpha,A2,'mo','MarkerSize',10)
plot(ax,alpha,A3,'ko','MarkerSize',10)
ylim([0,3])
xlabel('$\alpha$','interpreter','latex')
title('Optimal firing amplitudes $A$ for $T_{\rm max} = 100,  2000,  8000 $ iterations','interpreter','latex') % TODO. Fill in your initial value of A in the title
lg = legend('$A_{\rm optimal}$','$A^{\rm SGD}_1$','$A^{\rm SGD}_2$','$A^{\rm SGD}_3$','Location','Northwest');
legend('boxoff')
lg.Interpreter = 'latex';
lg.FontSize = 20;
ax.FontSize = 20;

