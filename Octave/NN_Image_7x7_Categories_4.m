%==========================================================================
%
%   NN_Image_7x7_Categories_4.m
%	Project: NN_Pattern_FPGA
%   Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
%   Based on project NN_RGB_FPGA by Thomas Florkowski
%   Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022
%
%===============================Description================================
% reads the prepared training samples
% generates the network structue 
% trains the network with the training samples  
% evaluates the trained network with the test image
%==========================================================================
%
clear; close all;
%
fprintf('Starting script to train network\n')
%
%=============== Constants Definition =================
%
epochs = 400;   %Number of epochs you want to train the network
alpha = 0.00001;%Learning rate for the training process
%
% use always the same random numbers for reproducibility
rand ("seed", 123456);
%
synmbolsNumber = 4;
%
%format 
formatMat           = ".mat";
%
%input: training samples
trainingPath        = '.\';
trainingName        = "shifted_samples";
%
%output: trained network
trainedNetworkPath  = '.\';
trainedNetworkName  = "trained_network";
%
%input: test Image
testImagePath       = '.\';
testImageName       = '0_symbols';
testImageFormat     = '.png';
%
%output: test Image
predictionImagePath = '.\';
predictionImageName = strcat('NN_',testImageName);
formatPNG           = '.png';
%
%loading the training samples and the labes 
load (strcat(trainingPath,trainingName,formatMat));
imageArrayTraining = imageArrayShifted'; 
labelArrayTraining = labelArrayShifted';
%
%Prepare the data for the training
imageArrayTraining = cast(imageArrayTraining, 'double');
%
% Scale the input from [0;255] to [0;1] because of the sigmoid function
% Only for input values between [-4;4] the sigmoid function shows significant
% differences in the output
imageArrayTraining = imageArrayTraining/255;
%=============== Generate Network =================
fprintf('Generate Network \n')
%Define the network structure as a vector
networkStructure = [49 37 synmbolsNumber];
%Create the Network
network = generateNetwork(networkStructure);
%=============== Training =================
fprintf('Start Training \n')
%Train the network.
%The small alpha is required to get a working results.
%The big alpha only works with fewer pixels per pictures
[trainedNetwork,costLog,accuracyLog]=trainNetwork(imageArrayTraining,labelArrayTraining,network,'epochs',epochs, 'alpha',alpha);
%
%Accuracy log does not work if the number of output neurons != number of categories
figure();
plot(accuracyLog);
title('accuracy log');
ylabel('accuracy');
xlabel('epochs');
%Plot the cost log from training
figCostLog=figure();
plot(costLog);
title('cost log');
ylabel('loss');
xlabel('epochs');
fprintf('\nTraining Done\n')
%=============== Prediction =================
fprintf('Using Trained Network for Test Prediction\n')
%Use the trained network on the input picture to see results
%
[picture] = imagePrediction(testImagePath,testImageName,testImageFormat,trainedNetwork);
figure(); 
imshow(picture);
imwrite (picture, strcat(predictionImagePath,predictionImageName,formatPNG),'png');
%
%=============== Generate Results =================
fprintf('Results \n')
%Remove the last line from the first matrix because that would be weights for
%connections that go to the bias in the hidden layer.
%These weights are not needed for the VHDL implementation.
nnParams = trainedNetwork;
nnParams{1} = nnParams{1}(1:end-1,:); %Ignore Last Column
%
fprintf('\nWeight Matrix from the Input to the Hidden Layer\n')
disp(nnParams{1});
fprintf('Weight Matrix from the Hidden to the Output Layer\n')
disp(nnParams{2});
%
save(strcat(trainedNetworkPath,trainedNetworkName,formatMat),'trainedNetwork','networkStructure','nnParams');
fprintf('\nFinished Script\n')