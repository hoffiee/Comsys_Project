clc
clear all

%g=[1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];
g=[1 0 1 1];
d=[1 1 0 1 0 0 1 1 1 0 1 1 0 0];
d=[0 0 0 0 0 0 0 0 0 0 0 0 0 0];
q=[1 1 1 1 0 0 0 1 1 1 1 1 0 0];
pl=length(g)-1;
nd= [d zeros(1,pl)];

ind=0;

if sum(d) == 0
ind=length(d)-pl+1;
end
while ind <= length(d)-pl
            
    ind = find(nd);
    ind=ind(1);
    
    nd(ind:ind+pl) = bitxor(nd(ind:ind+pl),g);
    
end

p=nd(end-pl+1:end)

%% Internet Checksum
clc
d=[0 1 0 0 0 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0 1 1 0 1 0 0 1 1 1 1 0 1 1 0 1 0 0];


if ~(mod(length(d),16)==0)
   disp('ej jämt delbart med 16')  
end


% Denna paddar automatiskt på en massa nollor i slutet
mat=vec2mat(d,16)

% mat ska vara
% 46AA = 0100 0110 1010 1010 = 18090
% AE01 = 1010 1110 0000 0001 = 44545
% A7B4 = 1010 0111 1011 0100 = 42932
% === STÄMMER ===

% bi2de ser allting tvärtom mot vad vi brukar, därav fliplr
a=bi2de(fliplr(mat))

b=sum(a)
% SUmman ska bli 19C5F = 105567 

c=mod(b,2^16-1)
% c ska bli 9C60 = 40032

p=mod(2^16-1,c)
% p = 639F = 25503 = 0110 0011 1001 1111 
p=fliplr(de2bi(p))

% Denna fyller ut med 0 så att det blir en 16 bitars
p=[zeros(1,16-length(p)) p]

csuppose=[0 1 1 0 0 0 1 1 1 0 0 1 1 1 1 1];
isequal(p,csuppose)
% C ska bli 0110 0011 1001 1111



%%
clear all

tic
timeout= 0.5;
while toc < timeout
    
end


%% Single parity 


a=[1 1 1 1 1 1];
sum(a)
p=mod(sum(a),2)

%% Check available packets
clc

for i=2:14300
    if mod(14300,i)==0
        14300/i
    end
end


%% Testa mäta tiden över Fread och Write

% ingen aning om vad jag gör
Channel=tcpip('localhost', 30000, 'NetworkRole', 'client');
set(Channel,'TransferDelay','off')
set(Channel,'OutputBufferSize',15000)
set(Channel,'InputBufferSize',4000)

fopen(Channel);
fwrite(Channel, TransmissionAttempts, 'int8') 
pause(0.1)
fclose(Channel);

ackframe = [1 1]
tic
WriteToChannel(Channel, ackframe)
Y = ReadFromChannel(Channel, 2);
toc



%Aja fungerar inte