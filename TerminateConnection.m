function TerminateConnection(sMode,Channel,varargin)
%<TerminateConnection> Function for termination of the connection.Its hard 
% to say Good bye (more info Leon-Garcia pp. 615)
%
%   Function inputs:
%       <sMode>         - String with specifying if it si the Tx or Rx that
%                         should be terminated     
%       <Channel>       - Object used for identifying the channel between 
%                         the client and the server
%       <varargin>      - Other required input parameters. 
%                         For Rx: nBitsPacket,
%                                 R_next
%                                 infoframe
%                         For Tx: nBitsPacket  
%                                 S_last  
%                                      
%   
%   Function output: 
%
%
%   Author(s):  Erik Steinmetz, Katharina Hausmair 
%   Email:      estein@chalmers.se, hausmair@chalmers.se
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algorithm description             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   1.
%
%   The greener the code, the better the environment! (Use comments!)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.00, 2014-12-10, Erik Steinmetz: First version...
% 2.00, 2014-12-10, Katharina Hausmair: made code independent of
% ErrorCheck(...) and pkg2frame(...) to avoid problems with student's
% implementations

  
% Procedure for terminating Connection on Receiver side  
if strcmp(sMode,'Rx')
    R_next=varargin{2};
    ackframe=varargin{3};
    nBitsPacket=varargin{1};
    FIN=0;
    while FIN==0
        Y=ReadFromChannel(Channel,nBitsPacket);
        if ~isnan(Y) %if data received          
            %2 if FIN correctly received quit, otherwise send ackframe again
            bError=mod(sum(Y),2);
            disp(['FIN received, errorcheck:',num2str(bError), ' Rnext:', num2str(R_next)])
            if ~bError                
                S_last=Y(1);
                if S_last==R_next
                    FIN=1;                            %FIN received (we can go ahead and quit)
                    disp('FIN received correctly')
                else
                    WriteToChannel(Channel,ackframe) %No FIN received (resend last ACK)
                end
            end
        end
    end
    
% Procedure for terminating Connection on Transmiter side
% (Send FIN message a few time and then quit)    
elseif strcmp(sMode,'Tx')   
    nBitsPacket = varargin{1};
    S_last = varargin{2};   
    packet = ones(nBitsPacket-2,1)';
    FIN = [S_last packet mod(sum([S_last packet]),2)];
    for iFin = 1:10
        disp(['Sent FIN:' num2str(iFin), ' Slast:', num2str(S_last)])
        WriteToChannel(Channel,FIN)
    end    
end

end
