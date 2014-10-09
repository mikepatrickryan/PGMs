function factors = ComputePairwiseFactors (images, pairwiseModel, K)
% This function computes the pairwise factors for one word and uses the
% given pairwise model to set the factor values.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   pairwiseModel: The provided pairwise model. It is a K-by-K matrix. For
%     character i followed by character j, the factor value should be
%     pairwiseModel(i, j).
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Output:
%   factors: The pairwise factors for this word.


n = length(images);

% If there are fewer than 2 characters, return an empty factor list.
if (n < 2)
    factors = [];
    return;
end

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 1, 1);

% MIKE RYAN: each of the random variables (characters) has a scope of K
% therefore, the factor will have K^3 total values; the val array will be
% ordered correctly by stepping down the columns then across rows 
% in the initialized triplet matrix 

for i=1:n-1, 
	val = zeros(K^2,1);
	factors(i).var = [i, i+1];
	factors(i).card = [K, K];
	for k=1:K,
		for j=1:K,
			val((k-1)*K + j, 1) = pairwiseModel(j,k);
		end;
	end;
	factors(i).val = val;
end;

end
