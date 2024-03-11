clc;
clear all;
close all;

load 'Trained_ML_Model.mat'

sdrReceiver = sdrrx('Pluto');
    sdrReceiver.BasebandSampleRate = 30e6;
    sdrReceiver.CenterFrequency = 4.4e9;
    sdrReceiver.OutputDataType = 'double';
    sdrReceiver.GainSource = 'Manual';
    sdrReceiver.Gain = 30;
    sdrReceiver.SamplesPerFrame = 8e6;

    rxWaveform = capture(sdrReceiver,sdrReceiver.SamplesPerFrame,'Samples');
    SampleRate = 30e6; % Set SampleRate to match the receiver's sample rate
   pspectrum(rxWaveform, SampleRate, 'FrequencyLimits', [-SampleRate/2 SampleRate/2],'spectrogram');

   colormap turbo

   colorbar off;
   axis off;
   title('');
   legend off;

saveas(gcf, 'rxed_spectrogram.png'); 
rxed_spectrogram = imresize(imread('rxed_spectrogram.png'),[227 227]);

estimatedSignal = classify(trainedNet,rxed_spectrogram);

if estimatedSignal(1)=="Wifi only"
    disp('WiFi is Detected');
elseif estimatedSignal(1)=="Bluetooth only"
    disp('Bluetooth is Detected');
elseif estimatedSignal(1)=="Wifi and Bluetooth only"
    disp('Wifi and Bluetooth are Detected');
end
release(sdrReceiver);
