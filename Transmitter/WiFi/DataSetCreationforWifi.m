clc;
clear all;

folderName = 'demo_wifi';
files = dir(fullfile(folderName, '**/*.wav'));

centerFreqOfWifi = 4.4e9;
MonteCarlo =5;

% Iterate through each file
for i = 1:numel(files)
    % Get the file name
    try
    filename = fullfile(files(i).folder, files(i).name);
    TransmitUsingWifi(filename,centerFreqOfWifi,MonteCarlo);
    catch ME
        fprintf('error occured in file %d',i);
        disp(ME.message);
    end

end
