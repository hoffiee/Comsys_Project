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

M=4;
Ns=51;    % 51 Samples have been tested and we receive a BER under 10e-3


% Specify Symbol constallation and corresponding bits
symb = [-5 -5/3 5/3 5];
m{1}=[0 0]; m{2}=[0 1]; m{3}=[1 1]; m{4}=[1 0];

%1. filter with Rx filter (Matched filter)
MF=rectpulse(1,Ns);
y = filter(MF,1,r);       % Here the received signal r is passed through the matched filter to obtain y 

%2. Sample filter output
Eh=sum(abs(MF).^2);
y_sampled = y(Ns:Ns:length(y))./Eh;             % Compute the sampled signal y_sampled

%3. Make decision on which symbol was transmitted
%Minimum-distance-receiver
a_hat=zeros(1,length(y_sampled));   % Preallocate
D=zeros(1,length(symb));            % Preallocate
for i=1:length(y_sampled) 
    for j=1:length(symb)
       D(j)= (abs(y_sampled(i)-symb(j)))^2; %Calculate the distance between chosen value and the constellations
    end
    [dispose,I]=min(D);    %Decides which constellation that matches the value. (minimum distance)
    a_hat(i)=symb(I);
end                       

%Symbol to bits for M=4
b_hat=-ones(1,2*length(a_hat)); % Preallocate
for i=1:length(a_hat)
   for j=1:M
       if a_hat(i) == symb(j)
          b_hat(2*(i-1)+1)=m{j}(1);
          b_hat(2*(i-1)+2)=m{j}(2);
       end
   end
end

%********** DON'T EDIT FROM HERE ON ***************
% plot Rx signals
PlotSignals(plot_flag, 'Rx', r, y, y_sampled)
%********** End program ***************************