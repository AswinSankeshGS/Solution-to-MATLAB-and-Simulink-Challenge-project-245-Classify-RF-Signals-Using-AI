function [] = TransmitUsingBluetooth(stringName,centerFreqOfBluetooth,MonteCarlo)
cfg = bluetoothWaveformConfig;
cfg.Mode = 'BR'; % Mode of transmission as one of BR, EDR2M and EDR3M
cfg.PacketType = 'FHS';     % Packet type
cfg.SamplesPerSymbol = 60; % Samples per symbol
cfg.WhitenInitialization = [0;0;0;0;0;1;1]; % Whiten initialization
payloadLength = getPayloadLength(cfg); % Payload length in bytes
octetLength = 8;

numRepeat=MonteCarlo;
% data bit generation
str = stringName; % limit 18 characters

% Convert the string to its ASCII values
ascii_values = double(str);

% Convert ASCII values to binary with 7 bits
binary_values = dec2bin(ascii_values, 8);

 
binary_values_double = double(binary_values - '0');
binary_values_91x1 = reshape(binary_values_double', [], 1);
dataBits = [binary_values_91x1;zeros(((payloadLength*8)-length(binary_values_91x1)),1)]; % Generate random payload bits
txWaveform = bluetoothWaveformGenerator(dataBits,cfg); % Create Bluetooth waveform
packetDuration = bluetoothPacketDuration(cfg.Mode,cfg.PacketType,payloadLength);
symbolRate = 1e6; % Symbol rate
sampleRate = 15e6;
numChannels = 10; % Number of channels
filterSpan = 8*any(strcmp(cfg.Mode,{'EDR2M','EDR3M'})); % To meet the spectral mask requirements
% Initialize the parameters required for signal sink
txCenterFrequency = centerFreqOfBluetooth;  % In Hz, varies between 2.402e9 to 2.480e9 with 1e6 spacing
txFrameLength     = length(txWaveform);
txNumberOfFrames  = 1e4;
% The default signal sink is 'File'
signalSink = 'ADALM-PLUTO';
% For 'ADALM-PLUTO'
    % Check if the pluto Hardware Support Package (HSP) is installed
    if isempty(which('plutoradio.internal.getRootDir'))
        error(message('comm_demos:common:NoSupportPackage', ...
            'Communications Toolbox Support Package for ADALM-PLUTO Radio',...
            ['<a href="https://www.mathworks.com/hardware-support/' ...
            'adalm-pluto-radio.html">ADALM-PLUTO Radio Support From Communications Toolbox</a>']));
    end
    connectedRadios = findPlutoRadio; % Discover ADALM-PLUTO radio(s) connected to your computer
    radioID = connectedRadios(1).RadioID;
    sigSink = sdrtx('Pluto',...
        'RadioID',           'usb:0',...
        'CenterFrequency',   txCenterFrequency,...
        'Gain',              0,...
        'SamplesPerFrame',   txFrameLength,...
        'BasebandSampleRate',sampleRate);
    % The transfer of baseband data to the SDR hardware is enclosed in a
    % try/catch block. This implies that if an error occurs during the
    % transmission, the hardware resources used by the SDR System object
    % are released.
   transmitRepeat(sigSink,txWaveform);
   
%receiver
% The default signal source is 'File'
signalSource = 'ADALM-PLUTO';
bbSymbolRate = 1e6; % 1 MSps

    % Check if the ADALM-PLUTO Hardware Support Package (HSP) is installed
    if isempty(which('plutoradio.internal.getRootDir'))
        error(message('comm_demos:common:NoSupportPackage', ...
                      'Communications Toolbox Support Package for ADALM-PLUTO Radio',...
                      ['<a href="https://www.mathworks.com/hardware-support/' ...
                      'adalm-pluto-radio.html">ADALM-PLUTO Radio Support From Communications Toolbox</a>']));
    end
    connectedRadios = findPlutoRadio; % Discover ADALM-PLUTO radio(s) connected to your computer
    radioID = connectedRadios(1).RadioID;    
    rxCenterFrequency =centerFreqOfBluetooth;  % In Hz, choose between 2.402e9 to 2.480e9 with 1e6 spacing
    bbSampleRate = 15e6;
    sigSrc = sdrrx('Pluto',...
        'RadioID',            'usb:0',...
        'CenterFrequency',     rxCenterFrequency,...
        'BasebandSampleRate',  bbSampleRate,...
        'SamplesPerFrame',     txFrameLength,...
        'GainSource',         'Manual',...
        'Gain',                35,...
        'OutputDataType',     'double');
for i=1:1:numRepeat
% *Capture the Bluetooth LE Packets*
  sigSrc.SamplesPerFrame = 2*length(txWaveform);
% The transmitted waveform is captured as a burst
 fprintf('\nStarting a new RF capture.\n')

 dataCaptures= capture(sigSrc,  sigSrc.SamplesPerFrame,'Samples');
  
% Setup spectrum viewer
spectrumScope = spectrumAnalyzer('Method','welch', ...
    'SampleRate',       bbSampleRate,...
    'SpectrumType',     'Power density', ...
    'SpectralAverages', 10, ...
    'YLimits',          [-130 -30], ...
    'Title',            'Received Baseband Bluetooth Signal Spectrum', ...
    'YLabel',           'Power spectral density', ...
    'ViewType','spectrogram');
% Show power spectral density of the received waveform
spectrumScope(dataCaptures);


% Bluetooth practical receiver
[decBits,decodedInfo,pktStatus] = helperBluetoothPracticalReceiver(dataCaptures,cfg);
% Get the number of detected packets
pktCount = length(pktStatus);
disp(['Number of Bluetooth packets detected: ' num2str(pktCount)])
% Get the decoded packet statistics
displayFlag = true; % set true, to display the decoded packet statistics  
if(displayFlag && (pktCount~=0))
    decodedInfoPrint = decodedInfo;
    for ii = 1:pktCount
        if(pktStatus(ii))
            decodedInfoPrint(ii).PacketStatus = 'Success';
        else
            decodedInfoPrint(ii).PacketStatus = 'Fail';
        end
    end
    packetInfo = struct2table(decodedInfoPrint,'AsArray',1);
    fprintf('Decoded Bluetooth packet(s) information: \n \n')
    disp(packetInfo);
end
% Get the packet error rate performance metrics
if(pktCount)
    pktErrCount = sum(~pktStatus);
    pktErrRate = pktErrCount/pktCount;
    disp(['Simulated Mode: ' cfg.Mode ', '...
        'Packet error rate: ',num2str(pktErrRate)])
end

% Remove padded zeros
dataBitsTrimmed = decBits(1:length(binary_values_91x1));

% Reshape the trimmed dataBits back to its original shape
binary_values_trimmed = reshape(dataBitsTrimmed, 8, []).';

% Convert the binary values back to ASCII
ascii_values_trimmed = bin2dec(char(binary_values_trimmed + '0'));

% Convert ASCII values back to characters
decodedString = char(ascii_values_trimmed);

disp(char(decodedString'));
% Release the signal source
release(sigSrc);
end
release(sigSink);