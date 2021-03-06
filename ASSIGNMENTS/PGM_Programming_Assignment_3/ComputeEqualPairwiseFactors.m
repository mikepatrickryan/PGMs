function factors = ComputeEqualPairwiseFactors (images, K)
% This function computes the pairwise factors for one word in which every
% factor value is set to be 1.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Output:
%   factors: The pairwise factors for this word. Every entry in the factor
%     vals should be 1.

n = length(images);

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 1, 1);
% MIKE RYAN: each of the random variables (C) has a scope of K
% therefore, the factor will have K^2 total values 

for i=1:n-1, 
	val = ones(K^2,1);
	factors(i).var = [i, i+1];
	factors(i).card = [K, K];
	factors(i).val = val;
end;
end
