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
%                         For Rx: ExpectedLengtOfFrame,
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


  
% Procedure for terminating Connection on Receiver side  
if strcmp(sMode,'Rx')
    
    ExpectedLengtOfFrame=varargin{1};
    R_next=varargin{2};
    infoframe=varargin{3};
    
    FIN=0;
    while FIN==0
        Y=ReadFromChannel(Channel,ExpectedLengtOfFrame);
        
        if ~isnan(Y) %if data received
            
            %2 if data correctly received send ack and store(if not received earlier)
            
            bError=ErrorCheck(Y,'parity');
            if ~bError
                
                S_last=Y(1);
                if S_last==R_next
                    FIN=1;                            %FIN received (we can go ahead and quit)
                    disp(['FIN received'])
                else
                    WriteToChannel(Channel,infoframe) %No FIN received (re send last ACK)
                    disp(['Sent ACK' num2str(ipacket-1)])
                end
            end
        end
    end
    
% Procedure for terminating Connection on Transmiter side
% (Send FIN message a few time and then quit)    
elseif strcmp(sMode,'Tx')
    
    
    nBitsPacket=varargin{1};
    S_last=varargin{2};
    
    
    packet=ones(nBitsPacket,1)';
    FIN=pkg2frame(packet,S_last);
    for iFin=1:10
        disp(['Sent FIN:' num2str(iFin)])
        WriteToChannel(Channel,FIN)
    end
    
    
end

end
