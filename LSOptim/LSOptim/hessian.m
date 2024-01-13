function [hess,hessPar]=hessian(funName,parameters);

% -- optimization parameters
delta  = 1e-8;

% -- Initialize the data
evalstring=[funName '(temp_par)'];
temp_par=parameters;
F=eval(evalstring);


% -- optimization variables
nvar= length(parameters);
J   = zeros(length(F),nvar); % The Jacobian for f
fprintf(1,'Hessian countdown: %d ',nvar);


% -- Calculate the gradient for all optimization variables
for i=1:nvar,
  temp_par=parameters;
  deltaX=delta*abs(parameters(i));
  temp_par(i)=parameters(i)+deltaX;
  J(:,i)=(eval(evalstring)-F)/deltaX;
  fprintf(1,'%d ',nvar-i);
end
fprintf(1,'\n');


% -- Store the data
hess           = J'*J;
if nargout>1,
  hessPar.hess   = hess;
  hessPar.lambda = F'*F;
  hessPar.N      = length(F);
  % hessPar.psi    = J;
end
