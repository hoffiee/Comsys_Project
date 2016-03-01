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
 
% Add the header into the packet, therefore it is included
% in the error checks.
d=[header packet];

% Choosen type of control method
TypeOfErrorCheck='CRC';

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
        
        % CRC-32
        g=[1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];
        
        pl=length(g)-1; % Calculates number of bits
        nd=[d zeros(1,pl)]; % adds zero to the end
    
        % If all entered bits is zero, return p as zeros()
        if sum(d) == 0 
            p=nd(end-pl+1:end);
        else    % While find finds a one and that the index does not exceed
                % the length of the data
            while ~isempty(find(nd,1)) && find(nd,1) <= length(d)    
                ind = find(nd,1); % Find the index of the first 1.
                nd(ind:ind+pl) = bitxor(nd(ind:ind+pl),g); % Perform division
            end
            % Return the resulting bits
            p=nd(end-pl+1:end);
        end     
end
frame=[d p];     % construct frame including header and error check bits
end
