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
alpha=0.1;  % Roll off effect
fs=10e6;    % sample frequency: 1GHz
Ts=1/fs;    
Ns=10;      % Specify the length of the transmit pulse here (scalar)
T=Ns*Ts;


%1. Convert bits to symbols
const = [0 1];              % Specify constellation here (vector)
a = [-5 5];                 % Convert the bits in vector b to symbols in vector a


% This maps the amplitude for k signal. M=2
for k=1:M
    ak(b==const(k))=a(k); % loops through b and creates a new vector ak with the corresponding symbol
end

%prova med M=4
%a4=[-5 -5/3 5/3 5];
%M=4;
%m{1}=[0 0]; m{2}=[0 1]; m{3}=[1 1]; m{4}=[1 0];
%ak=zeros(1,length(b)/log2(M));
%for k=0:length(b)/log2(M)-1
%    for i=1:M
%        if isequal([b(2*k+1) b(2*k+2)],m{i})
%            ak(k+1)=a4(i);
%            break
%        end
%    end
%end

disp(ak) %This works as intended


%2. Pulse Amplitude Modulation

t=0:Ts:Ns*Ts;
upp=sin((1-alpha)*pi*t/T)+(4*alpha*t/T).*cos((1+alpha)*pi*t/T);
ner=pi*t.*(1-(4*alpha.*t/T).^2);


grrc1=sqrt(T).*sin((1-alpha).*pi.*t./T)+(4.*alpha.*t./T).*cos((1+alpha).*pi.*t./T)./pi.*t.*(1-(4.*alpha.*t./T).^2);
grrc=sqrt(T)*upp./ner;

% Specify the transmit pulse here (vector)
figure(3)
stem(grrc1,'r')
hold on
stem(grrc,'b')
legend('grrc1','grrc')
%plot(t,grrc)
    
s=conv(ak(1),grrc);
for i=2:length(ak)
   s=[s conv(ak(i),grrc)]; % Tanken är att den skapar vardera med pulser
end


%hMod = comm.PAMModulator(M,'BitInput',true);                     % Perform PAM. The resulting transmit signal is the vector s.
%s =step(hMod,b.');
%********** DON'T EDIT FROM HERE ON ****************
% plot Tx signals
PlotSignals(plot_flag, 'Tx', a, s)
%********** End program ****************************