%==========================================================================
%
%	Project: NN_Pattern_FPGA
%   Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
%   Based on project NN_RGB_FPGA by Thomas Florkowski
%   Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022
%
%===============================Description================================
% reads the test image 
% breaks down the test image into a 49x1 column vector for each pixel with surrounding pixels having width of 3 Pixels 
% gives network prediction for each of the 49x1 column vector (function[prediction] = networkPrediction(X, network) by Thomas Florkowski) 
% reconstructs the test image with network prediction and sets symbol as color if detected
%==========================================================================
%
function[picture] = imagePrediction (predictionImagePath,predictionImageName,format,trainedNetwork)
  %
  %size of the input frame 
  frameX = 7;
  frameY = 7;
  %
  %load the input picture 
  inputPicture = imread(strcat(predictionImagePath,predictionImageName,format));
  %
  %ignore the surrounding frame because of incomplete network input  
  x = (frameX-1)/2;
  y =  (frameY-1)/2;
  %
  %initialize arrays 
  currentImage = zeros(frameY,frameX);
  imageArray = zeros(frameX*frameY,(size(inputPicture)(1)-2*y) * (size(inputPicture)(2)-2*x));
  imageArrayOriginal = zeros(frameX*frameY,(size(inputPicture)(1)-2*y) * (size(inputPicture)(2)-2*x));
  %
  %iterate through image pixel by pixel without the surrounding frame 
  for i = 1+y:size(inputPicture)(1)-y
    for j = 1+x:size(inputPicture)(2)-x
      %read the frame 
      currentImage = inputPicture(i-y:i+y,j-x:j+x,1);
      %reshape the frame from 7x7 matrix to 49x1 column vector 
      currentImage = reshape(currentImage',[],1);
      %write the column vector into array 
      imageArray(:,(i-(1+x))*(size(inputPicture)(2)-2*x)+(j-x)) = currentImage;
    end 
  end
  %
  %initialize the output picture 
  picture = zeros(size(inputPicture)(1),size(inputPicture)(2),3);
  %
  imageArrayOriginal = imageArray;
  imageArray = imageArray'; 
  %Prepare the data for training
  imageArray = cast(imageArray, 'double');
  %
  %Scale the input from [0;255] to [0;1] because of the sigmoid function
  %Only for input values between [-4;4] the sigmoid function shows significant
  %differences in the output
  imageArray = imageArray/255;
  %
  %test the trained network with the picture  
  labelArrayTest = networkPrediction(imageArray, trainedNetwork);
  labelArrayTest = round(labelArrayTest);
  %
  %rebuild the picture with test prediction 
  for i = 1+y:size(inputPicture)(1)-y
    for j = 1+x:size(inputPicture)(2)-x
      %
      prediction = labelArrayTest(:,(i-(1+x))*(size(inputPicture)(2)-2*x)+(j-x))';
      %
      if (prediction == [0, 0, 0, 0])
        picture(i,j,:) = imageArrayOriginal(25,(i-(1+x))*(size(inputPicture)(2)-2*x)+(j-x));
      elseif (prediction == [1, 0, 0, 0])
        picture(i,j,:) = [255,255,64]; % dark yellow
      elseif (prediction == [0, 1, 0, 0])
        picture(i,j,:) = [0,255,0];    % green
      elseif (prediction == [0, 0, 1, 0])
        picture(i,j,:) = [0,0,255];    % blue
      elseif (prediction == [0, 0, 0, 1])
        picture(i,j,:) = [255,0,0];    % red
      else
        picture(i,j,:) = imageArrayOriginal(25,(i-(1+x))*(size(inputPicture)(2)-2*x)+(j-x));
      end 
    end 
  end
  %
  picture = cast(picture,'uint8');
  %
end 