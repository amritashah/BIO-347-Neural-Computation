% The following code simulates a two-neuron leaky integrate-and-fire
% network, in which the neurons may be coupled by both inhibitory chemical
% synapses and electrical gap junctions.

% This model has been used to study phase locking in simple neural
% networks, and more specifically in which parameter regimes synchronous,
% antisynchronous, or asynchronous behavior is stable.

%function [t,T,V,S] = twoneuronLIF(I,J)
function twoneuronLIF(I,J)

Cmem = 2/3; % in nF.
R = 45; % in megaohm.
taumem = R*Cmem; % membrane time constant in ms
vth = -50; % in mV
vleak = -65; % in mV
vreset = -65; % in mV
dt = 0.1; % size of time-step in ms
Nmax = 5e5; % maximum number of time steps
tausyn = taumem/3; % time-scale of synaptic decay
alpha = 1/tausyn;
    
v10 = 0.59*(vth-vreset)+vreset; % Initial value of neuron 1's membrane potential
v20 = 0*(vth-vreset)+vreset; % Initial value of neuron 2's membrane potential

v1 = zeros([1 Nmax]);
v2 = zeros([1 Nmax]);

sx12 = zeros([1 Nmax]);
sx21 = zeros([1 Nmax]);
sy12 = zeros([1 Nmax]);
sy21 = zeros([1 Nmax]);

v1last = v10;
v2last = v20;
sx12last = 0.0;
sx21last = 0.0;
sy12last = 0.0;
sy21last = 0.0;

tspike1 = sparse(zeros(size(v1))); % create sparse vector to hold neuron 1 spike times
tspike2 = sparse(zeros(size(v2))); % create sparse vector to hold neuron 2 spike times

I1 = I; % typical value: 0.55/3 nA
I2 = I; % typical value: 0.55/3 nA
gsyn12 = J; % typical value: -1.0
gsyn21 = J; % typical value: -1.0

for i=1:Nmax  % Runs our simulation for Nmax time steps.
    
    % Differential equations for the membrane potentials of the two neurons
    
    v1(i) = v1last + dt*(vleak -v1last + R*I1 + R*gsyn12*sx12last)/taumem;
    v2(i) = v2last + dt*(vleak -v2last + R*I2 + R*gsyn21*sx21last)/taumem;
    
    % These next equations implement the synaptic alpha function. To get 
    % the desired form, s(t) = alpha^2*t*exp(-alpha*t), we need a
    % second-order differential equation, which can be written as a system
    % of 2 first order differential equations. Then, when a spike occurs,
    % we boost the derivative s'(t) by alpha^2. In formulating the synapses
    % this way, we do not need to manually keep track of the time since the
    % last spike.
    
    sx12(i) = sx12last + sy12last*dt;
    sy12(i) = sy12last - (2*alpha*sy12last + alpha^2*sx12last)*dt;
    
    sx21(i) = sx21last + sy21last*dt; 
    sy21(i) = sy21last - (2*alpha*sy21last + alpha^2*sx21last)*dt;
    
    % Now, check to see if either of the neurons fired.
    
    if v1(i) >= vth % if true, neuron 1 spikes
        tspike1(i) = 1; % record that neuron 1 spiked (represented by a '1')
        if v2(i) < vth % if true, neuron 2 did NOT spike
            v1(i) = vreset; % reset neuron 1's membrane potential.
            sy21(i) = sy21(i) + alpha^2; % neuron 2 receives synaptic gating boost
        else % if previous if was false, then neuron 2 fires as well.
            tspike2(i) = 1;
            v1(i) = vreset;
            v2(i) = vreset;
            sy12(i) = sy12(i) + alpha^2;
            sy21(i) = sy21(i) + alpha^2;
        end
    elseif v2(i) > vth % if first 'if' was false, neuron 1 does not fire, check if neuron 2 fires.
        tspike2(i) = 1;
        v2(i) = vreset;
        sy12(i) = sy12(i) + alpha^2;
    end 
    
    v1last = v1(i); % update the '_last' variables to the current values for use on next run of loop.
    v2last = v2(i);
    sx12last = sx12(i);
    sx21last = sx21(i);
    sy12last = sy12(i);
    sy21last = sy21(i);
    
end % for loop ends

% Define output variables.
t = (1:Nmax)*dt;
T = [tspike1; tspike2];
V = [v1; v2];
S = [sx12; sx21];

% Plot results in a figure.
Twin = 5000;
figure; ax = axes;
plot(ax,t(1:Twin),v1(1:Twin)+1.2*(vth-vreset)*tspike1(1:Twin),'LineWidth',3)
hold on; plot(ax,t(1:Twin),v2(1:Twin)+1.2*(vth-vreset)*tspike2(1:Twin),'r-.','LineWidth',3)
xlabel('time (ms)','FontSize',20,'Interpreter','latex');
ylabel('membrane potential (mV)','FontSize',20,'Interpreter','latex');
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;

% Plot results in a figure.
figure; ax = axes;
plot(ax,t((end-Twin):end),v1((end-Twin):end)+1.2*(vth-vreset)*tspike1((end-Twin):end),'LineWidth',3)
hold on; plot(ax,t((end-Twin):end),v2((end-Twin):end)+1.2*(vth-vreset)*tspike2((end-Twin):end),'r-.','LineWidth',3)
xlabel('time (ms)','FontSize',20,'Interpreter','latex');
ylabel('membrane potential (mV)','FontSize',20,'Interpreter','latex');

ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;

end

