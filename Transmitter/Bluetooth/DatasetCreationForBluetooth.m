clc;
clear all;

%% Traverse strings in file one by one
stringFileName = 'stringDatasetFile.txt';

% Open the file for reading
fileID = fopen(stringFileName, 'r');

% Initialize an empty cell array to store strings
strings = {};

% Read strings from the file until the end
while ~feof(fileID)
    % Read one line at a time
    line = fgetl(fileID);
    
    % Append the line (string) to the cell array
    strings{end+1} = line;
end

% Close the file
fclose(fileID);

%% 
% Display the strings
disp('Strings read from the file:');
disp(strings);


centerFreqOfWifi = 4.390e9:1e6:4.410e9; % In Hz, choose between 2.402e9 to 2.480e9 with 1e6 spacing
MonteCarlo = 3;


% Iterate through each file
for i = 1:numel(strings)
try   
    freqIndex = mod(i,length(centerFreqOfWifi));
    TransmitUsingBluetooth(strings{i},centerFreqOfWifi(freqIndex),MonteCarlo);

catch exception
    % Handle the exception/error
    errormsg = sprintf('An error occurred while transmitting file:%d',i);
    disp(errormsg);
    disp(exception.message);
end

end