function [datastream]=Receiver(Channel, FrameLength)
%<Receiver> Receive the information bits sent by the Transmitter via the 
%channel (Channel)
%
%   Function inputs:
%       <Channel>       - Object used for identifying the channel between 
%                         the client and the server
%       <FrameLength>   - variable used to specify the number of 
%                         information bits per packet
%   
%   Function output: 
%       <datastream>    - received information bits that should be returned
%                         to the upper layers in the server
%
%
%   Author(s):  Erik Steinmetz, Katharina Hausmair 
%   Email:      estein@chalmers.se, hausmair@chalmers.se
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algorithm description             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Here is given an example of how to implement an stop and wait ARQ 
%   receiver (update this section with your actual implementation): 
%
%     1. Check for data
%     2. if frame correctly received and not earlier received, store and
%        update R_next (sequence number)
%     3. if frame correctly received send acknowledgement frame
%     4. if all data received terminate connection  
%
%   The greener the code, the better the environment! (Use comments!)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.00, 2013-11-29, Erik Steinmetz: First version...
% 2.00, 2014-12-10, Erik Steinmetz: Second version...
% 3.00, 2016-01-14, Katharina Hausmair: chnaged comments and some variable
% names
%------------- BEGIN CODE - DO NOT EDIT HERE --------------
lengthBitStream = 14300;                  %total length of information bitstream that should be received
nBitsPacket = FrameLength;                %bits per packet 
nPackets = lengthBitStream/nBitsPacket;   %number of packages to receive
if mod(nPackets,1)>0
 error('You must specify FrameLength such that number of packets is a positive integer')
end
infopackets = NaN(nPackets,nBitsPacket);  %variable to store received packages in
ipacket = 1;                              %initialize packet counter 
R_next = 0;                               %initialize next frame expected (sequence number)

%------------- START EDITING HERE --------------
%error('You must complete the Receiver function!!!!!')

while ipacket<=nPackets 
    
    % med det g vi har i CRC nu så har vi 3+3 bitar 
    
    %1 check for data, 16 bits for both CRC-16? and IC
    nBitsOverhead = 1+16;%[]; %define the number of overhead bits here!
    ExpectedLengtOfFrame = nBitsPacket+nBitsOverhead; %this is the length of the frame we should receive
    Y = ReadFromChannel(Channel, ExpectedLengtOfFrame);
    
    if ~isnan(Y) %if data received
        %disp(['Received packet no.', num2str(ipacket),' med seq no.', num2str(Y(1))])
        
        %2-3 if data correctly received send ack and store data (if not received earlier)       
        %implement rest of receiver side of stop-and-wait ARQ protocol below (inlc. error check etc.)
        %send ack by using: WriteToChannel(Channel,ackframe) where ackframe is your ackknowledgement frame
        %Complete the function [bError] = ErrorCheck(data,TypeOfErrorCheck) for error check of received data  
 
        
        ackframe = [R_next R_next]; % Vi har en extra bit som kontrollbit på R_Next med
        
        % The sequence number is getting errorchecked within the
        % errorcheck, therefore no controlbits is needed at this point.
        if (ErrorCheck(Y,'CRC')) && isequal(Y(1),R_next)            
            splitData=Y(2:end-16);
            %disp(Y(4:end-3));
            infopackets(ipacket,:)=splitData;
            R_next = bitxor(R_next,1);
            ackframe = [R_next R_next]; % Vi har en extra bit som kontrollbit på R_Next med
            %disp(['Ackframe: ', num2str(ackframe(1)), ' ', num2str(ackframe(2)), ' ', num2str(ackframe(3))])
            ipacket = ipacket+1;
            WriteToChannel(Channel, ackframe)
        elseif ~isequal(Y(1),R_next)
            WriteToChannel(Channel, ackframe)
        end 
    end    
end

%infopackets=infopackets';
%disp(size(infopackets))
%disp(infopackets(1,:))
%disp(length(Y(4:end-3)))
%disp(reshape(infopackets,1,[]))
%disp(length(reshape(infopackets,1,[])))
%disp(sum(reshape(infopackets,1,[])))
%------------- DO NOT EDIT HERE --------------
%4. terminate connection 
%TerminateConnection('Rx', Channel, ExpectedLengtOfFrame, R_next, ackframe);
%function output
datastream=reshape(infopackets, 1, []);
end