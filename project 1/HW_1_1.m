%% 1. Writing a MATLAB script
%% I = 0.1 nA

% Define parameters and variables

% Membrane capacitance
C = 1/3; % in units nF ("nanofarad") 

% Membrane resistance
R = 90; % in units of MOhm ("megaohm")

% membrane time constant
tau = R*C; % in units of ms ("milliseconds")

% Tonic current
I = 0.1; % in units of nA ("nanoamperes")
 
 % Rest potential
Vrest = -65; % in units of mV

% Threshold
Vth = -55; % in units of mV

% time-step
dt = 0.1; % in units of ms
 
Tmax = 5000; % max number of timesteps

% Unknowns

 % membrane potential
V = Vrest * ones(1, Tmax);

 % 0 if no spike fired, 1 if spike was fired on that time-step
spks = zeros(1, Tmax); 

% Simulation
for t=1:(Tmax-1)
    V(t+1) = V(t) - (dt/tau)*(V(t)-Vrest) + (I/C)*dt;
    if  V(t+1) >= Vth %check if neuron spiked
        spks(t+1) = 1; %record 1 for time
        V(t+1) = Vrest; %reset membrane potential
    end
end

% Plot the data
time = (1:Tmax) * dt;
figure;
ax =  axes;
plot(ax, time, V, 'LineWidth',3)
hold on; %do not overwrite plot
plot(ax, time, 1.1*(Vth-Vrest)*spks+Vrest, 'LineWidth',3, 'Marker', 'none') %visualize when spikes occur
xlabel('time (ms)', 'FontSize', 18) %label x-axis
ylabel('membrane potential (mV)', 'FontSize',18) %label y-axis
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;

%% I = 0.3 nA

% Define parameters and variables

% Membrane capacitance
C = 1/3; % in units nF ("nanofarad") 

% Membrane resistance
R = 90; % in units of MOhm ("megaohm")

% membrane time constant
tau = R*C; % in units of ms ("milliseconds")

% Tonic current
I = 0.3; % in units of nA ("nanoamperes")
 
 % Rest potential
Vrest = -65; % in units of mV

% Threshold
Vth = -55; % in units of mV

% time-step
dt = 0.1; % in units of ms
 
Tmax = 5000; % max number of timesteps

% Unknowns

 % membrane potential
V = Vrest * ones(1, Tmax);

 % 0 if no spike fired, 1 if spike was fired on that time-step
spks = zeros(1, Tmax); 

% Simulation
for t=1:(Tmax-1)
    V(t+1) = V(t) - (dt/tau)*(V(t)-Vrest) + (I/C)*dt;
    if  V(t+1) >= Vth %check if neuron spiked
        spks(t+1) = 1; %record 1 for time
        V(t+1) = Vrest; %reset membrane potential
    end
end

% Plot the data
time = (1:Tmax) * dt;
figure;
ax =  axes;
plot(ax, time, V, 'LineWidth',3)
hold on; %do not overwrite plot
plot(ax, time, 1.1*(Vth-Vrest)*spks+Vrest, 'LineWidth',3, 'Marker', 'none') %visualize when spikes occur
xlabel('time (ms)', 'FontSize', 18) %label x-axis
ylabel('membrane potential (mV)', 'FontSize',18) %label y-axis
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;

%% There is no spiking activity for I = 0.1 nA, because this amount of external current was not enough to counteract the leak of ions out of the neuron and reach the threshold membrane potential. It can be hypothesized that the membrane resistance was too small of a value, meaning there were too many open channels for leakage of ions out of the neuron. Since the membrane was not sufficiently depolarized, no action potential fired.
