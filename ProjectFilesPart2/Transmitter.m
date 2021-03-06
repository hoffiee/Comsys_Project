function Transmitter(Channel,bitStream, FrameLength)
%<Transmitter> Transmitts the information bits in (bitstream) to the server
%using the available channel in (Channel)
%
%   Function inputs:
%       <Channel>       - Object used for identifying the channel between 
%                         the client and the server
%       <bitStream>     - stream of information bits that should be 
%                         transmitted between the client and the server
%       <FrameLength>   - variable used to specify the number of information
%                         bits per packet
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
%   Here is given an example of how to implement and stop and go ARQ 
%   transmitter (update this section with your actual implementation): 
%
%     1. retrieve current package according to packet counter
%     2. embedd packet in frame (add sequenc number and crc bits)
%     3  send Frame
%     4. stop and wait for ack (set timer)
%     5. if error free ack is received and R_next=(S_last+1)mod 2, update
%        packet counter and S_last and go to step 1 for retrieval
%        of next packet 
%     6. if time-out go to step 3 to retransmit current frame
%     7. if all data received terminate connection  
%
%   The greener the code, the better the environment! (Use comments!)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.00, 2013-11-29, Erik Steinmetz: First version...
% 2.00, 2014-12-10, Erik Steinmetz: Second version...
% 3.00, 2016-01-12, Katharina Hausmair: comments changed/added

%------------- BEGIN CODE - DO NOT EDIT HERE --------------
% Split the bitstream into packages
nBitsPacket = FrameLength;                             %number of bits per packet(eg. 2,4,10,11,13,20,22,25,26,44,50,52,55,65,100,110,130,143,286,572...,14300]
nPackets = length(bitStream)/nBitsPacket;              %number of packets to split bitstream into
if mod(nPackets,1)>0
 error('You must specify FrameLength such that number of packets is a positive integer')
end
packages = reshape(bitStream,nPackets,nBitsPacket);
ipacket = 1;         %initialize packet counter
S_last = 0;          %initialize sequence number for transmitter

%------------- BEGIN EDITING HERE --------------

while ipacket<=size(packages,1)
    
    %1 retrieve current packet according to packet counter
    packet = packages(ipacket,:);
    
    %2 embedd packet in frame: 
    frame=pkg2frame(packet,S_last);

    sent = false; 
    while ~sent
        
        %3 Send current frame
        WriteToChannel(Channel, frame)
        %disp(['sent packet no.', num2str(ipacket), ' with S_last: ',num2str(S_last)])
        
        timeout= 0.006; % This is hopefully little bit bigger than tprop.
        % Did test where timeout were lowered until the total time stopped
        % getting smaller, if the timeout is to small, the total time will
        % begin to get bigger again.
       
        
        % 4. stop and wait
        tic
        while toc < timeout 
            ExpectedLengthOfFrame = 2; % 1 ack, 1 cbit
            % Reads the channel
            Y = ReadFromChannel(Channel, ExpectedLengthOfFrame);
            
            if ~isnan(Y) %if data received
                % If no error detected and corr seq number.  
                if isequal(Y',[~S_last ~S_last])          
                    sent = true; % stop the outer while loop
                    ipacket=ipacket+1; % increment ipacket
                    S_last=~S_last; % Update S_last
                end
                break; % If data received, leave wait state
            end
        end
    end
end

%------------- STOP EDITING HERE --------------
%7 terminate connection
% dont shut down until the receiver has confirmed reception of last ack
%TerminateConnection('Tx', Channel, nBitsPacket, S_last);
end
%--------------- END CODE ---------------------