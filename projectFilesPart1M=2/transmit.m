function s = transmit(b,plot_flag)
% s = transmit(b,plot_flag)
% Transmitter program for part 1 of the project. The program should produce samples
% of the transmitted signal. The sample rate is fs Hz.
%
% Input:
%   b = vector containing the information bits to be transmitted
%   plot_flag = flag for plotting [0: don't plot, 1: plot]  
%
% Output:
%   s = vector containing samples of the transmitted signal at at rate of fs Hz
%
% Rev. C (VT 2016)

%********** Begin program, EDIT HERE

% Complete the code below to create samples of the transmitted signal.

clc        % Clears the command window for easier debuggin

% Constants
M=2;        % nr of symbols
Ns=6;      % Specify the length of the transmit pulse here (scalar)
%fs=1e12;    % sample frequency: 1GHz
%Ts=1/fs;   % Vi kommer nog behöva använda dessa för att beräkna fram    
%T=Ns*Ts;   % det Ns vi vill ha, samt beräkna systemets prestanda

%1. Convert bits to symbols
const = [0 1];              % Specify constellation here (vector)
symb = [-5 5];                 % Convert the bits in vector b to symbols in vector a

% This maps the amplitude for k signal. M=2
for k=1:M
    a(b==const(k))=symb(k); % loops through b and creates a new vector ak with the corresponding symbol
end

%2. Pulse Amplitude Modulation
% Creates a rectangular pulse with Ns samples
% for each symbol
s=rectpulse(a,Ns);

%********** DON'T EDIT FROM HERE ON ****************
% plot Tx signals
PlotSignals(plot_flag, 'Tx', a, s)
%********** End program ****************************