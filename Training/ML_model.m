% Load spectrogram images and labels
% Assuming you have labeled images organized in folders as explained in the previous example

% Data preparation and augmentation
data = imageDatastore('data_new', ...
    'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Split data into training and testing sets (80% training, 20% testing)
[trainData, valData, testData] = splitEachLabel(data, 0.6, 0.2, 0.2, 'randomized');


% Preprocess images (e.g., resize)
imageSize = [227 227]; % Adjust according to your image size
augmentedTrainData = augmentedImageDatastore(imageSize, trainData);
augmentedValData = augmentedImageDatastore(imageSize, valData);
augmentedTestData = augmentedImageDatastore(imageSize, testData);

% Transfer learning: replace last layers for fine-tuning
numClasses = numel(categories(data.Labels));

% Define CNN architecture
layers = [
    imageInputLayer([imageSize 3]) % Specify input size as 227x227x3 for RGB images
    
    convolution2dLayer(3, 16, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 64, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer
];




% Set training options
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 32, ...
    'MaxEpochs', 5, ...
    'InitialLearnRate', 1e-4, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', augmentedValData, ... % Include validation data
    'ValidationFrequency', 10, ... % Validate every 10 iterations
    'Verbose', false, ...
    'Plots', 'training-progress');

% Train the model
trainedNet = trainNetwork(augmentedTrainData, layers, options);

save('(March 8)_New_ML_Model','trainedNet');

% Evaluate the model
predictedLabels = classify(trainedNet, augmentedTestData);
actualLabels = testData.Labels;
accuracy = mean(predictedLabels == actualLabels);
fprintf('Accuracy: %.2f%%\n', accuracy * 100);
