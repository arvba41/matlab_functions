function figsize(scale_textwidth,scale_textheight,textwidth,textheight,x0,y0)
% Function to set the length and width of the figure
% figsize(scale_textwidth,scale_textheight,textwidth,textheight,x0,y0)
% scale_textwidth --> textwidth sclaing (i.e, width=scale_textwidth\textwidth)
% scale_textheight --> textwidth sclaing (i.e, height=scale_textheight\textheight)
% textwidth --> 

if nargin < 5
    x0 = 10; y0 = 10; % default origin of figure
    if nargin < 3
        textwidth = 16; textheight = 24; % standard 14 size papaer 
        if nargin < 1
            scale_textwidth = 1; scale_textheight = 1;
        end
    end
end

tw = textwidth*scale_textwidth; th = textheight*scale_textheight;

set(gcf,'Units','centimeters','position',[x0,y0,tw,th]) % set the dimentions of the figure
end