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

while ipacket<=nPackets 
    
    % 1 bit for sequence number, it is included in the crc/ic, 
    %therefore no controlbit is needed, 
    % 16 bits for both CRC-16 and IC atm
    % 32 bits for CRC-32
    
    hbits=1;
    pbits=32;
    
    nBitsOverhead = hbits+pbits;%[]; % number of overhead bits
    ExpectedLengtOfFrame = nBitsPacket+nBitsOverhead; % length of the frame we should receive
    Y = ReadFromChannel(Channel, ExpectedLengtOfFrame);
    
    if ~isnan(Y) %if data received
        %disp(['Received packet no.', num2str(ipacket),' with seq no.', num2str(Y(1))])

        ackframe = [R_next R_next]; 
        
        % The sequence number is getting errorchecked within the
        % errorcheck, therefore no controlbits is needed at this point.
        if (~ErrorCheck(Y,'CRC')) && isequal(Y(1),R_next)            
            splitData=Y(1+hbits:end-pbits); % Remove header and trailer
            infopackets(ipacket,:)=splitData; % Add data to infopackets
            R_next = bitxor(R_next,1); % update R_next
            ackframe = [R_next R_next]; % Ack with one cbit corresponding to the same value as R_next
            ipacket = ipacket+1; % Increment ipacket
            WriteToChannel(Channel, ackframe) % Send ack with cbit
        else
            WriteToChannel(Channel, ackframe) % Send ack wich cbit
        end 
    end    
end

%------------- DO NOT EDIT HERE --------------
%4. terminate connection 
%TerminateConnection('Rx', Channel, ExpectedLengtOfFrame, R_next, ackframe);
%function output
datastream=reshape(infopackets, 1, []);
end