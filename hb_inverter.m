function [vout,tsim] = hb_inverter(M,Udc,f1,fsw,h,val)
% function that models the HB-inverter
% [vout,tsim] = hb_inverter(M,Udc,f1,fsw,h,val)
% ------------------------------------------------------------------------
% vout --> output voltage (w.r.t 50% DC side voltage)
% tsim --> simulation time [s]
% Udc --> Total DC-side voltage [V] 
% f1 --> fundamental frequency [Hz]
% fsw --> switching frequency [Hz]
% h --> simulation time step size [s], 1e-3 (default)
% val --> 0.5 for triangular (default) or 1 for sawtooth
narginchk(5, 7)
if nargin < 6
    if nargin < 5
        h = 1e-3;
    end
    val = 0.5;
end
%-------------------------------------------------------------------------
    tsim = 0:h:1/f1-h; % simulation time

    ref = M*sin(2*pi*f1*tsim); car = sawtooth(2*pi*fsw*tsim,val);
    g1_p = double(ref>car); % g1_n = double(ref < car); 
    vout = (g1_p - 0.5)*Udc; 
end
