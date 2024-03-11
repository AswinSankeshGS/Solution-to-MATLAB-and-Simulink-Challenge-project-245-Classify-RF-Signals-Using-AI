clc;
clear all;
close all;
outputFolder = 'destination_Folder'; % Replace with the actual path

numRepeat = 400; %Number of datasets to take

for i = 1:numRepeat

sdrReceiver = sdrrx('Pluto');
    sdrReceiver.BasebandSampleRate = 30e6;
    sdrReceiver.CenterFrequency = 2.4e9; %change this to your need
    sdrReceiver.OutputDataType = 'double';
    sdrReceiver.GainSource = 'Manual';
    sdrReceiver.Gain = 30;
    sdrReceiver.SamplesPerFrame = 8e6;


    rxWaveform = capture(sdrReceiver,sdrReceiver.SamplesPerFrame,'Samples');
    SampleRate = sdrReceiver.BasebandSampleRate;
    pspectrum(rxWaveform, SampleRate, 'FrequencyLimits', [-SampleRate/2 SampleRate/2],'spectrogram');

    colormap turbo
    colorbar off;
    axis off;
    title('');
    figName = sprintf('spectrogram_%d.png', i); 
    saveas(gcf, fullfile(outputFolder, figName));
    close(gcf);

    release(sdrReceiver);

end
