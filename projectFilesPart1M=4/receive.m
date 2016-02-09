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
%M=2;        % nr of symbols
%alpha=0.2;  % Roll off effect
%sps=10;     % Symbol per sample
%fs=10e6;    % sample frequency
%%Ts=1/fs;  
%T=Ns*Ts;

Ns=10; 
boundaries = ([-5 5]); %F�r denna endast -5 och 5 d� M=2
const = ([0 1]);



g=ones(1,Ns);
MF=g;
%MF byts sedan ut mot
%MF = r(end:-1:1);
%1. filter with Rx filter (Matched filter)

%[];                  % Specify Rx filter here (vector)
S=sum(abs(g).^2);
y = filter(MF,S,r);       % Here the received signal r is passed through the matched filter to obtain y 

%2. Sample filter output


y_sampled = y(Ns:Ns:length(y));             % Compute the sampled signal y_sampled
%Placerar varje diskret diraq-spik i en vektor, d� vi vet att varje spik
%har Ns avst�nd mellan sig.


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
%Symbol to bits for M=4 | Fungerar som den ska
a=[-5 -5/3 5/3 5];
M=4;
m{1}=[0 0]; m{2}=[0 1]; m{3}=[1 1]; m{4}=[1 0];
a_hat=[-5/3 -5/3 -5 5]
for i=1:length(a_hat)
   for j=1:M
       if a_hat(i) == a(j)
          b_hat(2*(i-1)+1)=m{j}(1);
          b_hat(2*(i-1)+2)=m{j}(2);
       end
   end
end
%disp(b_hat) 


%b_hat(i)=
%********** DON'T EDIT FROM HERE ON ***************
% plot Rx signals
PlotSignals(plot_flag, 'Rx', r, y, y_sampled)
%********** End program ***************************