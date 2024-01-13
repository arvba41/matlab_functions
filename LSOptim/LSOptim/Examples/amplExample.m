% Example that sets up and solves the problem for the charge amplifier calibration.
%

% Load the calibration data

global t yOut Ts
load amplCalib
Ts=mean(diff(t)); 

%  Load the parameters
global PARAMETERS
load amplCalibSetup
PARAMETERS.noOptSteps=10;

% Make variables available for Simulink during simulation

global amplOut time
global t0 tau1 tau2 K y_off Qin

figure(1);clf
lsoptgui
figure(2);clf
drawnow
amplPlot
