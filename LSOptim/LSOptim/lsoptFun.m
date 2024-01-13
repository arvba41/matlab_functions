function F=lsoptFun(parameters)

global ParIn ChoiceVector 
global PARAMETERS 

SimPar = ParIn;
if (nargin==1),
  for i=1:length(parameters),
    SimPar(ChoiceVector(i)) = parameters(i)*SimPar(ChoiceVector(i));
  end
end
eval(['F=' PARAMETERS.function '(SimPar);'])

