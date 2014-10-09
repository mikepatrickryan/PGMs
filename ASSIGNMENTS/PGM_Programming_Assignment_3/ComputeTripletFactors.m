function factors = ComputeTripletFactors (images, tripletList, K)
% This function computes the triplet factor values for one word.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   tripletList: An array of the character triplets we will consider (other
%     factor values should be 1). tripletList(i).chars gives character
%     assignment, and triplistList(i).factorVal gives the value for that
%     entry in the factor table.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Hint: Every character triple in the word will use the same 'val' table.
%   Consider computing that array once and then resusing for each factor.


n = length(images);

% If the word has fewer than three characters, then return an empty list.
if (n < 3)
    factors = [];
    return
end

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 2, 1);

% MIKE RYAN: each of the random variables (characters) has a scope of K
% therefore, the factor will have K^3 total values; the val array will be
% ordered correctly by stepping down the columns then across rows 
% in the initialized triplet matrix 
numVals = length(tripletList);

for i=1:n-2, 
	val = ones(K, K, K);
	factors(i).var = [i, i+1, i+2];
	factors(i).card = [K, K, K];
	for k=1:numVals,
		thisVal = tripletList(k).factorVal;
		thisIndex = tripletList(k).chars;
		a = thisIndex(1);
		b = thisIndex(2); 
		c = thisIndex(3);
		val(a, b,c) = thisVal;
	end;
	val = val(:);
	factors(i).val = val;
end;

end
