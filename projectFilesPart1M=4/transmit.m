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

M=4;
Ns=50;     % 50 Samples have been tested and we receive a BER under 10e-3

%1. Convert bits to symbols
a=[-5 -5/3 5/3 5];
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

%2. Pulse Amplitude Modulation 
s=rectpulse(ak,Ns);

%********** DON'T EDIT FROM HERE ON ****************
% plot Tx signals
PlotSignals(plot_flag, 'Tx', a, s)
%********** End program ****************************