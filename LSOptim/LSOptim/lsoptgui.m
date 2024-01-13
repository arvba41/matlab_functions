function lsoptgui(inString,par1);
% A gui for accessing lsoptim, it requires that the structure PARAMETERS exist
% and that it includes the following fields.
% PARAMETERS.names        - List containing the names of the parameters
% PARAMETERS.default      - Default parameter values
% PARAMETERS.current      - Current parameter values
% PARAMETERS.noParameters - The total number of parameters
% PARAMETERS.choiceVector - Free parameters in the optimization
% PARAMETERS.function     - The function that calculates the error
% PARAMETERS.noOptSteps   - Maximum number of iteration steps

if nargin==0,
  inString='Initialize';
end
if strcmp(inString,'Initialize'),
  global OptimGuiHandle
  if length(OptimGuiHandle)==0,
    OptimGuiHandle=gcf;
    figure(gcf)
    clf;
  else
    figure(OptimGuiHandle);
    clf;
  end

  global PARAMETERS
  if length(PARAMETERS)==0,
    initLsOptGui('start',OptimGuiHandle);
    return
  end
  noParameters=length(PARAMETERS.names);
  
  % Make the window look as I wish
  set(OptimGuiHandle,'MenuBar','none');
  set(OptimGuiHandle,'Resize','off');
  set(OptimGuiHandle,'NumberTitle','off');
  set(OptimGuiHandle,'Name','LS Optimization GUI');

  % Initialize some geometric parameters
  x0=.02;
  dx0=0.15;
  y0=0.02;
  dy0=0.05;
  yN=0.95;
  ddy0=(yN-y0-2*dy0)/(noParameters-1);
  
  x1=x0+dx0+0.01;
  dx1=.14;
  x2=x1+dx1+0.01;
  dx2=dx1;
  x3=x2+dx2+0.02;
  x4=x3+0.01;
  % Draw the frame
  uicontrol(OptimGuiHandle,'Style','frame','Units','normalized',...
	  'Position',[x0-0.01 y0-0.01 x3-x0 yN+.03]);  
  uicontrol(OptimGuiHandle,'Style','text',...
      'Units','normalized',...
      'Position',[x0 y0+yN-dy0 dx0 dy0],...
      'String','Parameter Name');
  uicontrol(OptimGuiHandle,'Style','text',...
      'Units','normalized',...
      'Position',[x1 y0+yN-dy0 dx1 dy0],...
      'String','Default');
  uicontrol(OptimGuiHandle,'Style','text',...
      'Units','normalized',...
      'Position',[x2 y0+yN-dy0 dx2 dy0],...
      'String','Current');
  uicontrol(OptimGuiHandle,'Style','pushbutton',...
      'Units','normalized',...
      'Position',[(x1+dx1+x2)/2-dx2/8 y0+yN-dy0 dx2/4 dy0],...
      'String','<-',...
      'Callback','lsoptgui(''switchPar'')');


  global paramCheck defaultEdit currentEdit plotFunctionName
  for i=1:noParameters,
    paramCheck(i)=uicontrol(OptimGuiHandle,'Style','checkbox',...
	'Units','normalized','HorizontalAlignment','left',...
	'Position',[x0 y0+(noParameters-i)*ddy0 dx0 dy0]);
    defaultEdit(i)=uicontrol(OptimGuiHandle,'Style','edit',...
	'Units','normalized','HorizontalAlignment','right',...
	'Position',[x1 y0+(noParameters-i)*ddy0 dx1 dy0],...
	'Callback',['lsoptgui(''defaultEdit'',' num2str(i) ')']);
    currentEdit(i)=uicontrol(OptimGuiHandle,'Style','edit',...
	'Units','normalized','HorizontalAlignment','right',...
	'Position',[x2 y0+(noParameters-i)*ddy0 dx2 dy0],...
	'Callback',['lsoptgui(''currentEdit'',' num2str(i) ')']);
    set(paramCheck(i),'String',PARAMETERS.names{i});
  end
  
  
  % Draw the frame for the simulation and optimization procedures
  ddy2=0.06;
  dx3=0.155;
  dx2=0.15;
  yN2=yN-0.02;
  i=0;
  x5=x4+dx2+0.01;
  x6=x5+dx3+0.01;
  uicontrol(OptimGuiHandle,'Style','frame','Units','normalized',...
	  'Position',[x3 yN-4*ddy2-0.03 x6-x3+dx3+0.01 (5)*ddy2+0.01]);

  % Make some optimization controls
  uicontrol(OptimGuiHandle,'Style','text','Units','normalized',...
      'Position',[x4 yN2-i*ddy2+0.01 dx2 dy0-0.02],...
      'String','Max Iter');
  global optNoItEdit optParOption functionName plotFunction
  optNoItEdit=uicontrol(OptimGuiHandle,'Style','edit',...
      'Units','normalized','HorizontalAlignment','right',...
      'Position',[x5 yN2-i*ddy2 dx3 dy0],...
      'String',num2str(6),'Callback','lsoptgui(''optNoIt'')');
  i=i+1;
  uicontrol(OptimGuiHandle,'Style','text','Units','normalized',...
      'Position',[x4 yN2-i*ddy2+0.01 dx2 dy0-0.02],...
      'String','Par Sel');
  optParOption=uicontrol(OptimGuiHandle,'Style','popup',...
	  'Units','normalized',...
	  'Position',[x5 yN2-i*ddy2 dx3 dy0],...
	  'String','Default|Current');
  i=i+1;
  uicontrol(OptimGuiHandle,'Style','text','Units','normalized',...
      'Position',[x4 yN2-i*ddy2+0.01 dx2 dy0-0.02],...
      'String','Fun Sel');
  functionName=uicontrol(OptimGuiHandle,'Style','edit',...
	  'Units','normalized',...
	  'Position',[x5 yN2-i*ddy2 dx3 dy0],...
	  'String',PARAMETERS.function,...
	  'Callback','lsoptgui(''funSel'');' );
  
  plotFunctionName=uicontrol(OptimGuiHandle,'Style','edit',...
	  'Units','normalized',...
	  'Position',[x6 yN2-i*ddy2 dx3 dy0],...
	  'String',PARAMETERS.plotFunction,...
	  'Callback','lsoptgui(''plotFunSel'');' );

  i=i+1;
  uicontrol(OptimGuiHandle,'Style','pushbutton',...
      'Units','normalized',...
      'Position',[x5 yN2-i*ddy2 dx3 dy0],...
      'Interruptible','on',...
      'String','Hessian',...
      'Callback','lsoptgui(''calcHessian'');');
  uicontrol(OptimGuiHandle,'Style','pushbutton',...
      'Units','normalized',...
      'Position',[x6 yN2-i*ddy2 dx3 dy0],...
      'Interruptible','on',...
      'String','Plot',...
      'Callback','lsoptgui(''plot'');');

  i=i+1;
  uicontrol(OptimGuiHandle,'Style','pushbutton',...
     'Units','normalized',...
     'Position',[x5 yN2-i*ddy2 dx3 dy0],...
     'Interruptible','on',...
     'String','Optimize',...
     'Callback','lsoptgui(''optimize'');');
  
  i=i+2;
  uicontrol(OptimGuiHandle,'Style','frame','Units','normalized',...
     'Position',[x3 yN-i*ddy2-0.03 x6-x3+dx3+0.01 (1)*ddy2+0.01]);
  uicontrol(OptimGuiHandle,'Style','text','Units','normalized',...
      'Position',[x4 yN2-i*ddy2+0.01 dx2 dy0-0.02],...
      'String','PARAMETERS');
  uicontrol(OptimGuiHandle,'Style','pushbutton',...
     'Units','normalized',...
     'Position',[x5 yN2-i*ddy2 dx3 dy0],...
     'String','Load',...
     'Callback','lsoptgui(''loadParam'');');
  uicontrol(OptimGuiHandle,'Style','pushbutton',...
     'Units','normalized',...
     'Position',[x6 yN2-i*ddy2 dx3 dy0],...
     'String','Save',...
     'Callback','lsoptgui(''saveParam'');');

  SetParam;
    
elseif strcmp(inString,'calcHessian'),
  global ParIn hess PARAMETERS confPar
  % Get the data from the gui
  GetParam;
  [hess,confPar]=hessian('lsoptFun',ones(size(PARAMETERS.choiceVector)));
  % Condition number
  fprintf(1,'\nScaled hessian, rcond: %g\n',rcond(hess));
  [U,D,V]=svd(inv(hess));
  tmp=diag(D)';
  % tmp(1)/tmp(length(tmp))
  disp([tmp(1:min(5,length(tmp)))]);
  for ii=1:length(tmp),
    for iii=1:min(5,length(tmp)),
      fprintf(1,'   %7.4f',V(ii,iii));
    end
    fprintf(1,'  ');
    fprintf(1,PARAMETERS.names{PARAMETERS.choiceVector(ii)});
    fprintf(1,'\n');
  end
  
elseif strcmp(inString,'switchPar'),
  global PARAMETERS
  PARAMETERS.default=PARAMETERS.current;
  SetParam;
elseif strcmp(inString,'funSel'),
  global PARAMETERS functionName
  PARAMETERS.function=get(functionName,'String');
elseif strcmp(inString,'plotFunSel'),
  global PARAMETERS plotFunctionName
  PARAMETERS.plotFunction=get(plotFunctionName,'String');
elseif strcmp(inString,'optimize'),
  % Get data from the gui
  GetParam;

  % Selct the parameters for optimization
  global PARAMETERS optParOption ParIn
  if get(optParOption,'Value')==1,
    ParIn=PARAMETERS.default;
  else
    ParIn=PARAMETERS.current;
  end
  global ChoiceVector
  ChoiceVector=PARAMETERS.choiceVector;
  optimizationVector=ones(size(ChoiceVector'));
  if length(ChoiceVector)<1,
    msgbox('Could not start an optimization process, no parameters are choosen!',...
	'Optimization error','error','modal');
    return
  end
      
  % call the optimization procedure
  [optimizationVector]=lsoptim('lsoptFun',optimizationVector,PARAMETERS.noOptSteps);
  
  % Set the parameters to the values from the calculation
  [rows,columns]=size(optimizationVector );
  PARAMETERS.current=ParIn;
  for i=1:length(ChoiceVector),
    PARAMETERS.current(ChoiceVector(i))=optimizationVector(i,columns)*ParIn(ChoiceVector(i));
  end
  global currentEdit
  for i=1:PARAMETERS.noParameters,
	set(currentEdit(i),'String',num2str(PARAMETERS.current(i),'%0.4g'));
  end
  % sound(0.25*chirp(0:1/8000:0.07,800,0.07,4000),8000);

elseif strcmp(inString,'plot'),
  % This part is not used any longer
  % Get data from the gui
  GetParam;

  % Selct the parameters for optimization
  global PARAMETERS optParOption ParIn
  if get(optParOption,'Value')==1,
    ParIn=PARAMETERS.default;
  else
    ParIn=PARAMETERS.current;
  end
      
  % call the optimization procedure
  global plotFunctionName
  tmp=get(plotFunctionName,'String');
  eval([tmp '(ParIn)'])
  
  % sound(0.25*chirp(0:1/8000:0.07,800,0.07,4000),8000);

elseif (strcmp(inString,'defaultEdit')),
  global defaultEdit PARAMETERS
  PARAMETERS.default(par1)=str2num(get(defaultEdit(par1),'String'));
elseif (strcmp(inString,'currentEdit')),
  global currentEdit PARAMETERS
  PARAMETERS.current(par1)=str2num(get(currentEdit(par1),'String'));  
elseif (strcmp(inString,'optNoIt')),
  global optNoItEdit PARAMETERS
  PARAMETERS.noOptSteps=str2num(get(optNoItEdit,'String'));
elseif (strcmp(inString,'saveParam')),
   global PARAMETERS
   [fileName,dirName]=uiputfile('*.mat','Save PARAMETERS as');
   if fileName~=0
      global PARAMETERS
      save([dirName fileName],'PARAMETERS')
   else 
      warndlg('Could not save file.','PARAMETER save');
   end
elseif (strcmp(inString,'loadParam')),
   global PARAMETERS opNoItEdit
   [fileName,dirName]=uigetfile('*.mat','Load PARAMETERS from');
   if fileName~=0
     global PARAMETERS
     eval(['load ' dirName fileName]);
     lsoptgui('Initialize')
   else
     warndlg('Could not load file','PARAMETER load');
   end
else
  warning(['Unknown input string: ' inString]);
end

function SetParam
global defaultEdit currentEdit optNoItEdit paramCheck
global PARAMETERS 
for i=1:PARAMETERS.noParameters,
  set(defaultEdit(i),'String',num2str(PARAMETERS.default(i)));
  set(currentEdit(i),'String',num2str(PARAMETERS.current(i)));
  set(paramCheck(i),'Value',0);
end
for i=1:length(PARAMETERS.choiceVector)
  set(paramCheck(PARAMETERS.choiceVector(i)),'Value',1),
end
set(optNoItEdit,'String',num2str(PARAMETERS.noOptSteps));

function  GetParam;
global paramCheck PARAMETERS 

PARAMETERS.choiceVector=[];
for i=1:PARAMETERS.noParameters,
  if get(paramCheck(i),'Value'),
	PARAMETERS.choiceVector=[PARAMETERS.choiceVector i];
  end
end
