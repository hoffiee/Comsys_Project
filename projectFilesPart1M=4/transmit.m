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
Ns=10;      % Specify the length of the transmit pulse here (scalar)
fs=10e6;    % sample frequency
Ts=1/fs;  
T=Ns*Ts;

%1. Convert bits to symbols


%prova med M=4, Denna verkar fungera bra
a=[-5 -5/3 5/3 5];
M=4;
m{1}=[0 0]; m{2}=[0 1]; m{3}=[1 1]; m{4}=[1 0];
ak=zeros(1,length(b)/log2(M));
for k=0:length(b)/log2(M)-1
    for i=1:M
        if isequal([b(2*k+1) b(2*k+2)],m{i})
            ak(k+1)=a(i);
            break
        end
    end
end
%disp(ak) %This works as intended

%2. Pulse Amplitude Modulation
g=ones(1,Ns); % Creates the pulse with Ns samples

%t=0:Ts:Ns*Ts;
%t=-1:0.1:1;
%g=rectangularPulse(t);
%Eh=sum(abs(ifft(g)).^2)

% Perform PAM. The resulting transmit signal is the vector s.



s=ak(1)*g;
for i=2:length(ak)
   s=[s conv(ak(i),g)]; 
end
%********** DON'T EDIT FROM HERE ON ****************
% plot Tx signals
PlotSignals(plot_flag, 'Tx', a, s)
%********** End program ****************************