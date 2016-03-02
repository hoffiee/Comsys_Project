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
    case 'parity'   % Single parity bit
        p = mod(sum(data(1:end-1)),2);
        
        % Check if the calculated bit is the same as the received
        % Return bError, 0 if no error is detected
        bError=~isequal(p,data(end));
        
    case 'IC'   % Internet Checksum

        % Pads with zeros so that its a multiplication of 16
        pd=[zeros(1,ceil(numel(data')/16)*16-length(data')) data'];

        % Shapes the data into X rows with 16 bits
        % then takes the sum all rows. 
        nsum=sum(bi2de(reshape(pd,16,[])','left-msb'));
        
        % Takes modulo FFFF 
        modulo=mod(nsum,2^16-1);
        
        % Negate bits and return bError, 0 if no error is detected
        bError=mod(-modulo,2^16-1);
        
    case 'CRC'
        % CRC-32
        g=[1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1]; 
        
        pl=length(g)-1; % Takes the length of the control bits
        d=data(1:end-pl)'; % Removes the parity bits from the received data
        nd=[d zeros(1,pl)]; % adds zeros in the end
        
         % If all entered bits is zero, return p as zeros()
        if sum(d) == 0 
            p=nd(end-pl+1:end);
        else    % While find finds a one and that the index does not exceed
                % the length of the data
            while ~isempty(find(nd,1)) && find(nd,1) <= length(d)    
                ind = find(nd,1); % find the index where the first 1 is.
                nd(ind:ind+pl) = bitxor(nd(ind:ind+pl),g); % perform Division
            end
            p=nd(end-pl+1:end); % the resulting bits
        end       
        % Return bError, 0 if no error is detected
        bError = ~isequal(p,data(length(data)-pl+1:end)');
end
end

