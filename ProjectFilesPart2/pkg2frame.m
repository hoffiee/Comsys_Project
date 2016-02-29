function frame=pkg2frame(packet,header)
%<pkg2frame> create info frame by adding header and error check bits (eg. parity bit)
%
%   Function inputs:
%       <packet>   - information packet that should be framed
%       <header>   - bits that should be included in header (eg. sequence number)
%
%   Function output:
%       <frame>    - information frame
%
%
%   Author(s):  Erik Steinmetz, Katharina Hausmair
%   Email:      estein@chalmers.se, hausmair@chalmers.se
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.00, 2013-11-29, Erik Steinmetz: First version...
% 2.00, 2014-12-10, Erik Steinmetz: Second version...

%------------- BEGIN CODE --------------
 

%=======================================
%===== DENNA FUNGERAR SOM DEN SKA! ===== Nope
%=======================================

d=[header packet];

TypeOfErrorCheck='IC';

switch TypeOfErrorCheck
    case 'parity'   % Single parity check codes
        p = mod(sum(d),2);
        
    case 'IC' % Internet Checksum
        
        % This pads with zeros in front
        pd=[zeros(1,ceil(numel(d)/16)*16-length(d)) d];
        
        % this sums everything
        sumOfData=sum(bi2de(reshape(pd,16,[])','left-msb'));
        
        % This takes modulo FFFF 
        modulo=mod(sumOfData,2^16-1);
        
        % negate bits (flips bits)
        negBits=mod(-modulo,2^16-1);
        
        
        % This is the parity bits
        p=de2bi(negBits,16,'left-msb');
        
    case 'CRC'  % Cyclic redundancy codes CRC
        %g=[1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];
        %g=[1 0 1 1];
        g=[1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1];
        
        pl=length(g)-1;
        nd=[d zeros(1,pl)];

        if sum(d) == 0 % Ett hax f�r att f� bara nollor att fungera...
            p=nd(end-pl+1:end);
        else
            %disp(~isempty(find(nd,1)))
            %disp(length(nd))
            while ~isempty(find(nd,1)) && find(nd,1) <= length(d)    
                ind = find(nd,1);
                %disp(['ind:', num2str(ind)])
                nd(ind:ind+pl) = bitxor(nd(ind:ind+pl),g);
            end
            p=nd(end-pl+1:end);
        end     
end

frame=[d p];                  % construct frame including header and error check bits
end
