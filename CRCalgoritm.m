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

% Denna paddar automatiskt på en massa nollor i slutet
mat=vec2mat(d,16)

% mat ska vara
% 46AA = 0100 0110 1010 1010 = 18090
% AE01 = 1010 1110 0000 0001 = 44545
% A7B4 = 1010 0111 1011 0100 = 42932
% === STÄMMER ===

% bi2de ser allting tvärtom mot vad vi brukar, därav fliplr

% SUmman ska bli 19C5F = 105567 

% c ska bli 9C60 = 40032
% p = 639F = 25503 = 0110 0011 1001 1111 

% Denna fyller ut med 0 så att det blir en 16 bitars
sumOfData=sum(bi2de(vec2mat(mat,16),'left-msb'))
% This takes modulo FFFF = 
modulo=mod(sumOfData,2^16-1)
        
% negate bits
negBits=mod(2^16-1,modulo)

% This is the parity bits, though they aren't at exactly 16 bits.
% This is handled below
p=de2bi(negBits,16,'left-msb')
csuppose=[0 1 1 0 0 0 1 1 1 0 0 1 1 1 1 1];
isequal(p,csuppose)
% C ska bli 0110 0011 1001 1111

mod(sum(bi2de(vec2mat([d csuppose],16),'left-msb')),2^16-1);

%% Paddar med nollor i början!!
clc
a=ones(1,17)
zeros(1,ceil(numel(a)/16)*16-length(a))
a=[zeros(1,ceil(numel(a)/16)*16-length(a)) a]

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
a=[];
for i=2:sqrt(14300)
    if mod(14300,i)==0
        a=[a 14300/i];
    end
end
disp(a)


%% Val av framelength
clc

% CRC: N=n-k
% information bits k
% polynomets grad N
% codewords bits n

% Maxlängden
N=31;


disp(['codeword length must be shorter than: ',num2str(2^(N)-1)])
disp(['Det måste vara ett polynom av minst ' num2str(ceil(log2(14300+1))),' bitar '])
disp(['Burst error upptäckbara upptill: ',num2str(N)])

log2(14300+1)


