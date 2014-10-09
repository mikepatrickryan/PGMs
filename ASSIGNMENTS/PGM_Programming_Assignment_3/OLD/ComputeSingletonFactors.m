function factors = ComputeSingletonFactors (images, imageModel)
% This function computes the single OCR factors for all of the images in a
% word.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word. You could, for example, pass in allWords{1} to
%     use the first word of the provided dataset.
%   imageModel: The provided OCR image model.
%
% Output:
%   factors: An array of the OCR factors, one for every character in the
%   image.
%
% Hint: You will want to use ComputeImageFactor.m when computing the 'val'
% entry for each factor.
%

% The number of characters in the word
n = length(images);

% Preallocate the array of factors
factors = repmat(struct('var', [], 'card', [], 'val', []), n, 1);


end
% for i= 1:numLetters 
% ComputeSingletonFactors(allWords{i}, imageModel)
% fieldnames(imageModel) -> returns the keys in this "struct" 
% repmat (5, 3, 4) -> creates a 3x4 matrix of fives; like 5 * ones(3,4)
% reshape([1, 2, 3, 4], 2, 2) -> returns  [1, 3; 2, 4] ; in other words counts down by columns 