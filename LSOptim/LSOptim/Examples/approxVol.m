function [residual,out]=approxVol(theta);

% [residual,out]=approxVol(theta) 
%
% Calculates the residual between a a model and residual. lsoptim is
% used to find the parameter values that best fits the data stored
% in xData and yData.

global xData yData

C=theta(1);
x_0=theta(2);
y_0=theta(3);
gamma=theta(4);
y_off=theta(5);

out=C*((cos(xData-x_0)+1)/2+y_0).^(-gamma)+y_off;
residual=yData-out;
