function frame=pkg2frame(packet,header,type)
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
 

% Metoder för att kolla error

% Single parity check codes
% Internet Checksum
% Binary polynomials
% Binary polynomial divison
% Cyclic redundancy codes CRC

switch type
    case 'sp'
        p = sum(mod([packet header],1));
    case 'IC' % Förutsätter att det är 16 bitar in.
        g=[1 0 1 1];
        d=[1 1 0 1 0 0 1 1 1 0 1 1 0 0];
        d=[d 0 0 0];
        
        while sum(a(1:len(d)-3)) != 0
            ind = find(d)
            ind=ind(1)   
                d(ind:ind+3) = bitxor(d(ind:ind+3),g);   
                
         
        end
        
        
        
        
    case 'BP'    
    
    case 'BPD'
        
    case 'CRC'
end



 frame=[header packet p];                  % construct frame including header and error check bits

end
