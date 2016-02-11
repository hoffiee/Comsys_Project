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
        bError=;        %Implement error check here
    
    
    otherwise
        error('Invalid error check!')
        
end

end

