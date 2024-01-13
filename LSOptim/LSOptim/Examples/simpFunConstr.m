function [residual,out]=simpFunConstr(par)

% function [residual,out]=simpFunConstr(par)
%
% This function returns the residual between the data and a linear
% function, and the testrun adds a constraint that places the global
% optimum outside the feasible region.
%
% Together with lsoptim it fits a linear function to the (x,y) data.
% y=par(1)+x*par(2)
% 
% To make a simple test run the following in the command window
% simpFunConstr
%
% The example is designed to illustrate that the current algorithm in
% lsoptim v1.3 does not solve a constrained problem correctly, since it is
% only intended to dampen the search and avoid searching outside feasible
% region for the model. Version 1.4 solves this more correctly but the
% solution onl converges towards the boundary but does not reach the
% boundary.

if nargin<1,
  % This is a test that illustrates how to use the function
  % the following could be run in the command window
  global xData yData
  xData=[1 2 3 4]';
  yData=[2 3 4 5]'+randn(4,1)*0.1;
  parInit=[2.9 2.9]';
  
  [x,y]=meshgrid(-1:.02:3,-1:.02:3);
  z=x;
  for ii=1:size(x,1),
    for jj=1:size(y,2),
      tmp=simpFunConstr([x(ii,jj) y(ii,jj)]);
      z(ii,jj)=tmp'*tmp;
    end
  end
  max(max(z));
  min(min(z));
  figure(2);clf;hold on
  contour(x,y,z,logspace(log10(min(min(z))),log10(max(max(z))),10));
  A=[0 1]; B=1.2;
  A=[0 1;1 1]; B=[1.2;2];
  %parSol=lsoptim_new('simpleFunction',parInit,10,[A;1 0],[B;2]);
  parSol=lsoptim('simpFunConstr',parInit,10,[A],[B]);
  global PARAMETER_TRACE
  set(plot([-1 3],[B(1) B(1)],'-k'),'LineWidth',3);
  set(plot([-1 3],[B(1) B(1)],'-k',[3 -1],[-1 3],'-k'),'LineWidth',3);
  plot(PARAMETER_TRACE(:,1),PARAMETER_TRACE(:,2),'-r');
  plot(PARAMETER_TRACE(2:(end-1),1),PARAMETER_TRACE(2:(end-1),2),'xr');
  [resid,out]=simpleFunction(parSol(:,end));
  xlabel('\theta_1')
  ylabel('\theta_2')
  
  plot(PARAMETER_TRACE(1,1),PARAMETER_TRACE(1,2),'ro');
  plot(PARAMETER_TRACE(end,1),PARAMETER_TRACE(end,2),'gp','LineWidth',2);
  print -depsc SimpFunConstr
  

  figure(1);clf;
  plot(xData,yData,'o',xData,out);
  legend('Data','Fitted Model',0)
%  print -depsc SimpFunDataSol
else  
  global xData yData
  out=(par(1)+xData*par(2));
  residual=yData-out;
end
