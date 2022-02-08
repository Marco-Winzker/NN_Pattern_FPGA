%==========================================================================
%
%   NN_samples_to_mat.m
%	Project: NN_FPGA_Pattern
%   Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
%   Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022
%
%===============================Description================================
% reads the various .png images 
% saves the images as .mat 
%==========================================================================
%
%clear data
clear; close all;
%
fprintf('Starting script samples_to_mat\n');
%
%input: .png
pathSamples = '.\samples_png\';
directory   = dir(pathSamples);
format      = '.png';
%
%output: .mat
pathMat   = '.\';
nameMat   = "training_samples";
formatMat = ".mat";
%
%defines the sample names without the sequence number 
name_dot     = 'dot_';
name_circle  = 'circle_';
name_ex      = 'ex_';
name_plus    = 'plus_';
name_blank   = 'blank_';
%
%defines the position of the sample in the output layer 
position_dot    = 1;
position_circle = 2;
position_ex     = 3;
position_plus   = 4;
%
% count samples
number_dot    = 0;
number_circle = 0;
number_ex     = 0;
number_plus   = 0;
number_blank  = 0;
%defines the number of different symbols 
synmbolsNumber = 4;
%
%provides options for different "ones" and "zeros" for training   
zero  = 0; 
one   = 1;
%
%names with the path and format 
fileName = strcat(pathMat, nameMat, formatMat);
%
%creates an empty Matrix 
imageArray = [];
labelArray = [];
%
fprintf('Start reading images \n')
%
%iterates through the files in the diretory
for i = 1:length(directory);
  %gets the file name 
  file = directory(i).name;
  %check if the file name is longer than the name of the image type 
  if (length(file)-length(format)+1) > 0
    %get the ending 
    match = file((length(file)-length(format)+1):end);
    %get the name without the ending 
    name = file(1:length(file)-length(format));
    %check if ending matches the image type 
    if match == format
      %reads the image 
      inputPicture = imread(strjoin({pathSamples,file},''));
      %takes only one layer of the rgb matrix since the image is in grayscale 
      inputPicture = inputPicture(:,:,1);
      %checks if the image is in the file; first checks the length and than the name   
      if length(name_dot) <= length(name) && name_dot  == name(1:length(name_dot))
        labelArray = [labelArray zeros(synmbolsNumber,1) + zero];
        labelArray(position_dot,size(labelArray, 2)) = one;
        imageArray(:,:,size(labelArray, 2)) = inputPicture; 
        number_dot = number_dot + 1;
      elseif length(name_circle) <= length(name) && name_circle  == name(1:length(name_circle))
        labelArray = [labelArray zeros(synmbolsNumber,1) + zero];
        labelArray(position_circle,size(labelArray, 2)) = one;
        imageArray(:,:,size(labelArray, 2)) = inputPicture;  
        number_circle = number_circle + 1;
        elseif length(name_ex) <= length(name) &&  name_ex  == name(1:length(name_ex))
        labelArray = [labelArray zeros(synmbolsNumber,1) + zero];
        labelArray(position_ex,size(labelArray, 2)) = one;
        imageArray(:,:,size(labelArray, 2)) = inputPicture;
        number_ex = number_ex + 1;
      elseif length(name_plus) <= length(name) && name_plus  == name(1:length(name_plus))
        labelArray = [labelArray zeros(synmbolsNumber,1) + zero];
        labelArray(position_plus,size(labelArray, 2)) = one;
        imageArray(:,:,size(labelArray, 2)) = inputPicture;
        number_plus = number_plus + 1;
      elseif length(name_blank) <= length(name) && name_blank  == name(1:length(name_blank))
        labelArray = [labelArray zeros(synmbolsNumber,1) + zero];
        % labelArray is zero
        imageArray(:,:,size(labelArray, 2)) = inputPicture;
        number_blank = number_blank+ 1;
      else    
        fprintf('Is not matching any shape %s\n',file)
      endif
    else 
      fprintf('Format is not matching: %s\n',file)
    endif
  else
    if     ((file = '.'))  % current directory
    elseif ((file = '..')) % up one directory
    else   fprintf('Format is not matching: %s\n',file)
    endif
  endif
end
%
fprintf('Finished reading images\n')
fprintf('    dot:    %d\n',number_dot);
fprintf('    circle: %d\n',number_circle);
fprintf('    ex:     %d\n',number_ex);
fprintf('    plus:   %d\n',number_plus);
fprintf('    blank:  %d\n',number_blank);
%
%saves the images as .mat 
save(fileName, 'imageArray', 'labelArray');
%
fprintf('Finished script \n');