function ax = figtex(axis,legend)
% Function to modify matlab plot with latex fonts
% ax = figlatex(axis,{legend})
% handle to the current axis in the current figure
% axis --> handle to the current axis in the current figure
% legend --> legend handle, if legend is not used then this variable has
% any value
if nargin < 2
    legend = [];
    if nargin < 1
        error(message('MATLAB: figtex: Not Enough Input arguments'));
    end  
end

ax = axis;
ax.TickLabelInterpreter = 'latex'; % latex axis names
ax.XLabel.Interpreter = 'latex'; % latex x-axis labels
ax.YLabel.Interpreter = 'latex'; % latex y-axis labels
ax.ZLabel.Interpreter = 'latex'; % latex z-axis labels
ax.Title.Interpreter = 'latex'; % latex plot title 
if ~isempty(legend)
    ax.Legend.Interpreter = 'latex'; % 
end
    