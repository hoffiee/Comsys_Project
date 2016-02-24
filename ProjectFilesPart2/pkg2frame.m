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
 

% Metoder för att kolla error, val anges 
% när man anropar funktionen

switch type
    case 'sp'   % Single parity check codes
        p = mod(sum([header packet]),2);
        
    case 'IC' % Internet Checksum
         %while sum(a(1:len(d)-3)) != 0
           % ind = find(d)
            %ind=ind(1)   
             %   d(ind:ind+3) = bitxor(d(ind:ind+3),g);   
                
           % end
        
    case 'BP'   % Binary polynomials   
        
    case 'BPD'  % Binary polynomial divison
        
    case 'CRC'  % Cyclic redundancy codes CRC
        %g=[1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];
        g=[1 0 1 1];
        d=[header packet];
        %i=[1 1 0 1 0 0 1 1 1 0 1 1 0 0];
        %q=[1 1 1 1 0 0 0 1 1 1 1 1 0 0];
        pl=length(g)-1;
        nd= [d zeros(1,pl)];

        ind=0;
        
        if sum(d) == 0 % Ett hax för att få bara nollor att fungera...
            ind=length(d)-pl+1;
        end
        
        while ind <= length(d)-pl        
            ind = find(nd);
            ind=ind(1);
            nd(ind:ind+pl) = bitxor(nd(ind:ind+pl),g);
    
        end

        p=nd(end-pl+1:end);
        
        
end



 frame=[header packet p];                  % construct frame including header and error check bits

end
