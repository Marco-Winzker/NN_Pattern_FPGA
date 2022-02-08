%==========================================================================
%
%   NN_shift_samples.m
%	Project: NN_Pattern_FPGA
%   Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
%   Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022
%
%===============================Description================================
% Reads data from a .mat file with all the training images 
% Shifts the image in intervals 
% Trims image from 15x15 to 7x7
% Rearranges the image from 7x7 matrix to 49x1 column vector including the 4x1 label vector   
% Saves the shifted and the trimmed trainings data as .mat file   
%==========================================================================
%
clear; close all;
%
fprintf('Starting script shift_samples\n')
%
% use always the same random numbers for reproducibility
rand ("seed", 123456);
%
%input: .mat
unshiftedPathMat   = '.\';
unshiftedNameMat   = "training_samples";
unshiftedFormatMat = ".mat";
%
%output .mat
shiftedPathMat   = '.\';
shiftedNameMat   = "shifted_samples";
shiftedFormatMat = ".mat";
%
%loads the input data 
load(strcat(unshiftedPathMat,unshiftedNameMat,unshiftedFormatMat));
%
%reads the array from the input data 
imageArrayUnshifted = imageArray; 
labelArrayUnshifted = labelArray;
%
%total numer of output samples
numberOfShiftedSamples = 200e3;
%
%initializes arrays for the shifted data 
imageArrayShifted = zeros(49,numberOfShiftedSamples);
labelArrayShifted = zeros(4,numberOfShiftedSamples);
%
%width and height of the input image 
widthActual=15; 
heightActual=widthActual; 
%
%width and height of the output image 
widthTarget=7; 
heightTarget=widthTarget; 
%
%maximum shifting 
shiftHeight = 7;
shiftWidth = shiftHeight;
%
%array with values for shifting in intervals 
randomNumber = [-7, -6, -1, 0, 0, 1, 6, 7];
%randomNumber = [-7, -6, -2, -1, 0, 0, 1, 2, 6, 7];
%randomNumber = [-7, -6, -5, -1, 0, 0, 1, 5, 6, 7];
%randomNumber = [-7, -6, -5, -2, -1, 0, 0, 1, 2, 5, 6, 7];
%
%everything <= shiftTrue is the symbol
shiftTrue = 2;
%
beginImage = (widthActual-widthTarget)/2+1;
endImage = beginImage+widthTarget-1;
%
for i = 1:numberOfShiftedSamples
  %
  %gets a random integer for a random image   
  randImage = randi(size(imageArray,3));
  %
  %for shifting with intervals 
  randX = randomNumber(randi(size(randomNumber)));
  randY = randomNumber(randi(size(randomNumber)));
  %
  %gets a random image with associated label 
  currentImage = imageArrayUnshifted(:,:,randImage);
  currentLabel = labelArrayUnshifted(:,randImage);
  %
  %shifts the image 
  currentImage = circshift(currentImage,[randY,randX]);
  %
  %trims the image 
  currentImage = currentImage([beginImage:endImage],[beginImage:endImage]);
  %
  %converts the ixj matrix into a i*jx1 column vector  
  currentImage = reshape(currentImage',[],1);
  %
  %writes the image and the label into an output array  
  imageArrayShifted(:,i) = currentImage;
  %checks if the shift is in the range   
  if abs(randY) <= shiftTrue && abs(randX) <= shiftTrue
    labelArrayShifted(:,i) = currentLabel;
  end 
end
%
%saves the shifted and the trimmed data 
save(strcat(shiftedPathMat, shiftedNameMat, shiftedFormatMat), 'imageArrayShifted', 'labelArrayShifted');
fprintf('Finished script \n');