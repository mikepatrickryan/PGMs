% FactorMarginalization Sums given variables out of a factor.
%   B = FactorMarginalization(A,V) computes the factor with the variables
%   in V summed out. The factor data structure has the following fields:
%       .var    Vector of variables in the factor, e.g. [1 2 3]
%       .card   Vector of cardinalities corresponding to .var, e.g. [2 2 2]
%       .val    Value table of size prod(.card)
%
%   The resultant factor should have at least one variable remaining or this
%   function will throw an error.
% 
%   See also FactorProduct.m, IndexToAssignment.m, and AssignmentToIndex.m

function B = FactorMarginalization(A, V)

% Check for empty factor or variable list
if (isempty(A.var) || isempty(V)), B = A; return; end;

% Construct the output factor over A.var \ V (the variables in A.var that are not in V)
% and map between variables in A and B
% setdiff gives all the elements in A.var that are not in V (being marginalized)
% these values are returned in ascending order in the first element, B.var
% the second element, mapB, are the indices such that A.var(mapB) = B.var 
[B.var, mapB] = setdiff(A.var, V);

% Check for empty resultant factor
if isempty(B.var)
  error('Error: Resultant factor has empty scope');
end;

% Initialize B.card and B.val
B.card = A.card(mapB);
B.val = zeros(1, prod(B.card));

% Compute some helper indices useful for calculating B.val
% assignments are all possible assignments of A 
assignments = IndexToAssignment(1:length(A.val), A.card);

% assignments(:, mapB) are all rows of assignments in A's order of 
% permutations selecting the columns in B.
% indxB is a vector mapping the order of all assignments for A to the
% B.val indices affected
indxB = AssignmentToIndex(assignments(:, mapB), B.card);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Populate the factor values of B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(A.val),
		B.val(indxB(i)) = B.val(indxB(i)) + A.val(i);
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
