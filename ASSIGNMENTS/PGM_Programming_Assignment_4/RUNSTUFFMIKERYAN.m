% Load all the prepared data
load PA4Sample.mat
load PA4Test.mat


% After loading in the PA3Data.mat PA3Models.mat PA3SampleCases.mat PA3TestCases.mat
% set the 'ignoreSimilarity' parameter to true before running 
% [charAcc, wordAcc] = ScoreModel(allWords, imageModel, [], []);
% to allow the test to run prior to defining image similarity factors: 
imageModel.ignoreSimilarity = true;

% Compute a baseline accuracy of the ComputeSingletonFactors.m function with
% no pairwise or triplet factors; and assign outputs to charAcc and wordAcc;
% should be 76% and 22% respectively.  Uses libDai inference engine; only
% runs on Linux VM because the C++ library needs to be rebuilt for Windows 64-bit

[charAcc, wordAcc] = ScoreModel(allWords, imageModel, [], []);

% Compute a pairwise accuracy for comparison to the baseline

[charAcc2, wordAcc2] = ScoreModel(allWords, imageModel, pairwiseModel, []);

% this saves the variable tripletList to a file
%save tmp.m tripletList 

[charAcc3, wordAcc3] = ScoreModel(allWords, imageModel, pairwiseModel, tripletList);

% Resety ignoreSimilarity to false and run 
imageModel.ignoreSimilarity = true;

%shortWords = {allWords{9}, allWords{14}};
% Need to cut allWords in half due to memory limitations
shortWordList = allWords(1:50,1);
[charAcc4, wordAcc4] = ScoreModel(shortWordList, imageModel, pairwiseModel, tripletList);
