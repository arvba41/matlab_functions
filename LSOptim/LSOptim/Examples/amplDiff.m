function yDelta=amplDiff(par);

% amplDiff(par) - calculates the difference between the model and measurement
%
% Uses the simulink model amplSim to simulate the dynamic system.
% Input:
%   par    - model parameters
% Output:
%   yDelta - Differece between model and data

global t yOut
global amplOut time
global t0 tau1 tau2 K y_off Qin
t0=par(1);
tau1=par(2);
tau2=par(3);
K=par(4);
y_off=par(5);

% Charge to the amplifier
U=0.104;    % Volt
C=28.0e-9;  % nF
Qin=C*U;

startStop=[0,150];
sim('amplSim',startStop,[],[t yOut]);
yDelta=amplOut(:,1);

