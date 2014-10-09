function factors = ChooseTopSimilarityFactors (allFactors, F)
% This function chooses the similarity factors with the highest similarity
% out of all the possibilities.
%
% Input:
%   allFactors: An array of all the similarity factors.
%   F: The number of factors to select.
%
% Output:
%   factors: The F factors out of allFactors for which the similarity score
%     is highest.
%
% Hint: Recall that the similarity score for two images will be in every
%   factor table entry (for those two images' factor) where they are
%   assigned the same character value.


% If there are fewer than F factors total, just return all of them.
if (length(allFactors) <= F)
    factors = allFactors;
    return;
end

% MIKE RYAN: 
%factors = allFactors; 
% Create a holder variable with a value from one of the diagonals in the allFactor variable .val
% sort this holder in descending order and use the 'order' values as indices to the allFactors

for i=1:length(allFactors),
	holder(i)=allFactors(i).val(1,1);
end;
[dummy, order] = sort([holder(:)], 'descend');
factors = allFactors(order);
factors = factors(1:F);

end

