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

%%
clear all

tic
timeout= 0.5;
while toc < timeout
    
end


