function [residual,out]=simpleFunction(par)

% function [residual,out]=simpleFunction(par)
%
% This function returns the residual between the data
% and a linear function.
% y=par(1)+x*par(2)
% Together with lsoptim this fits a linear function
% to the global data in xData and yData. 

global xData yData

out=(par(1)+xData*par(2));
residual=yData-out;
