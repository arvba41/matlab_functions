function [X_cpx,f] = FFT_function_3d(x,t)
% [X_cpx,f] = FFT_function_3d(x,t) is the discrete Fourier transform (DFT) 
% of vector x, along the 3rd dimension, where t is the time vector 

L = length(t); % Sample length
dt = mean(diff(t)); % sampling period
fs= 1/dt; % sampling frequency

Y = fft(x,[],3); % Computing FFT
P2 = Y/L; % Dual side-band spectrum

X = P2(:,:,1:L/2+1); % single sided spectrum based on even value of L
X(:,:,2:end-1) = 2*X(:,:,2:end-1);

f = fs*(0:(L/2))/L; % frequency 

X_cpx = X; % peak complex spectra 