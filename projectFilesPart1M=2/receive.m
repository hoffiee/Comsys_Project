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

% Constants%
M=2;        % nr of symbols
Ns=10; 
%fs=10e6;    % sample frequency
%Ts=1/fs;  
%T=Ns*Ts;

boundaries = ([-5 5]); %För denna endast -5 och 5 då M=2
const = ([0 1]);


%1. filter with Rx filter (Matched filter)
g=rectpulse(1,Ns);
% due to h*(-t) on g = g
y = filter(g,1,r);       % Here the received signal r is passed through the matched filter to obtain y 

%2. Sample filter output

% Calculate the pulse energy
Eh=sum(abs(g).^2);
% Due to the function of the filter, the spike 
% of each pulse is located at Ns
y_sampled = y(Ns:Ns:length(y))./Eh;             % Compute the sampled signal y_sampled


%3. Make decision on which symbol was transmitted

%Mnimum-distance-receiver
for i=1:length(y_sampled)
    for j=1:length(boundaries)
       D(j)= (abs(y_sampled(i)-boundaries(j)))^2; %Calculate the distance between chosen value and the constellations
    end
    [M,I]=min(D);    %Decides which constellation that matches the value. (minimum distance)
    yk(i)=boundaries(I);
end

%boundaries = const;          % Specify decision boundaries for minimum distance detection (vector)
a_hat = yk;                 % Compute the received symbols (in vector a_hat) from  
                        % the sampled signal, based on your decision
                        % boundaries
%Symbol to bits for M=2
for i=1:length(a_hat)
    for j=1:length(boundaries)
        if a_hat(i) == boundaries (j)
            b_hat(i) = const(j);    % Convert the symbols in vector a_hat to bits in vector b_hat
        end
    end             
end

%********** DON'T EDIT FROM HERE ON ***************
% plot Rx signals
PlotSignals(plot_flag, 'Rx', r, y, y_sampled)
%********** End program ***************************