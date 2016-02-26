function [bError] = ErrorCheck(data,TypeOfErrorCheck)
%<ErrorCheck> check received frame for errors

%   Function inputs:
%       <data>                - received data
%       <TypeOfErrorCheck>    - string for the type of error check that shoudl be
%                               performed(eg. 'Parity')
%
%   Function output:
%       <bError>    - boolean variable that is [0: when no error, 1: when error]
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

switch TypeOfErrorCheck
    case 'parity'
        p = mod(sum(data(1:end-1)),2);
        
        if isequal(p,data(end))
            bError = true;
        else
            bError = false;
        end
    case 'IC'
        
        d=data(1:end-16)';
        
        % the result from bi2de need to be flipped in order for the
        % bits to come in the right order.
        sumOfData=sum(bi2de(fliplr(vec2mat(d,16))));
        % This takes modulo FFFF = 
        modulo=mod(sumOfData,2^16-1);
        
        % negate bits
        negBits=mod(2^16-1,modulo);

        % This is the parity bits, though they aren't at exactly 16 bits.
        % This is handled below
        p=fliplr(de2bi(negBits));
        % The zeros adds zeros in front due to de2bi doesn't return it to a
        p=[zeros(1,16-length(p)) p];
        %disp(p)
        
                % La till +1 för att se de fyra sista med
        %disp(p)
        
        %disp(data(length(data)-15:end))
        if isequal(p,data(length(data)-15:end)')
            bError = true;
        else
            bError = false;
        end
        
    case 'CRC'
        %g=[1 0 1 1];
        %g=[1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];
        g=[1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1];
        pl=length(g)-1;
        d=data(1:end-pl)';
        nd=[d zeros(1,pl)]; % la till ' för att ändra matrisen till en vektor 
        
        if sum(d) == 0 % Ett hax för att få bara nollor att fungera...
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
        

        % La till +1 för att se de fyra sista med
        %disp(p)
        %disp(data(length(data)-pl+1:end)')
        if isequal(p,data(length(data)-pl+1:end)')
            bError = true;
        else
            bError = false;
        end
    %otherwise
      %  error('Invalid error check!')      
end
end

