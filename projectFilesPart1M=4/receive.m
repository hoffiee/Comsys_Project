function [b_hat] = receive(r,plot_flag)
% [b_hat] = receive(r,plot_flag)
% Receiver program for part 1 of the project. The program should produce the
% received information bits given the samples of the received signal (sampled 
% at fs Hz.)
%
% Input:
%   r = samples of the received signal
%   plot_flag = flag for plotting [0: don't plot, 1: plot] 
%
% Output:
%   b_hat = vector containing the received information bits
%
% Rev. C (VT 2016)

%********** Begin program EDIT HERE

% Complete the code below:     

% Constants
M=2;        % nr of symbols
alpha=0.2;  % Roll off effect
sps=10;     % Symbol per sample
fs=10e6;    % sample frequency
Ts=1/fs;    
Ns=10;      

T=Ns*Ts;

g=ones(1,Ns);
MF=g;
%1. filter with Rx filter (Matched filter)

%[];                  % Specify Rx filter here (vector)
y = filter(MF,1,r);       % Here the received signal r is passed through the matched filter to obtain y 

%2. Sample filter output

y_sampled = y(1:Ns:length(y));             % Compute the sampled signal y_sampled

%3. Make decision on which symbol was transmitted
boundaries = [];          % Specify decision boundaries for minimum distance detection (vector)
a_hat = [];                 % Compute the received symbols (in vector a_hat) from  
                        % the sampled signal, based on your decision
                        % boundaries


b_hat = [];             % Convert the symbols in vector a_hat to bits in vector b_hat

%********** DON'T EDIT FROM HERE ON ***************
% plot Rx signals
PlotSignals(plot_flag, 'Rx', r, y, y_sampled)
%********** End program ***************************