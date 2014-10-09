% FactorProduct Computes the product of two factors.
%   C = FactorProduct(A,B) computes the product between two factors, A and B,
%   where each factor is defined over a set of variables with given dimension.
%   The factor data structure has the following fields:
%       .var    Vector of variables in the factor, e.g. [1 2 3] for X_1, X_2 and X_3.
%       .card   Vector of cardinalities corresponding to .var, e.g. [2 2 2]
%       .val    Value table of size prod(.card)
%
%   See also FactorMarginalization.m, IndexToAssignment.m, and
%   AssignmentToIndex.m

function C = FactorProduct(A, B)

% Check for empty factors
if (isempty(A.var)), C = B; return; end;
if (isempty(B.var)), C = A; return; end;

% Check that variables in both A and B have the same cardinality
[dummy iA iB] = intersect(A.var, B.var);
if ~isempty(dummy)
	% A and B have at least 1 variable in common
	assert(all(A.card(iA) == B.card(iB)), 'Dimensionality mismatch in factors');
end

% Set the variables of C as the UNIQUE COMMON VARIABLES to A and B in ASCENDING order (hence all the mapping to follow)
C.var = union(A.var, B.var);

% Construct the mapping between variables in A and B and variables in C.
% In the code below, we have that
%
%   mapA(i) = j, if and only if, A.var(i) == C.var(j)
% 
% and similarly 
%
%   mapB(i) = j, if and only if, B.var(i) == C.var(j)
%
% For example, if A.var = [3 1 4], B.var = [4 5], and C.var = [1 3 4 5],
% then, mapA = [2 1 3] and mapB = [3 4]; mapA(1) = 2 because A.var(1) = 3
% and C.var(2) = 3, so A.var(1) == C.var(2).

[dummy, mapA] = ismember(A.var, C.var);
[dummy, mapB] = ismember(B.var, C.var);

% Set the cardinality of variables in C
C.card = zeros(1, length(C.var));
C.card(mapA) = A.card;
C.card(mapB) = B.card;

% Initialize the factor values of C:
%   prod(C.card) is the number of entries in C
C.val = zeros(1, prod(C.card));

% Compute some helper indices for calculating C.val

% Creates a matrix of a permutation of the indices of vars in C in each row for all possibilities 
% IndexToAssignment maps a value (or vector of values) to the correct permutation
assignments = IndexToAssignment(1:prod(C.card), C.card);

% Sets indxA (or indxB) to the appropriate index from a reordered assignment matrix 
% with columns mapping from C back to A (or B) based on the var mapping
% AssignmentToIndex maps a vector corresponding to a permutation(or matrix) to the corresponding index
indxA = AssignmentToIndex(assignments(:, mapA), A.card);
indxB = AssignmentToIndex(assignments(:, mapB), B.card);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Populate the factor values of C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C.val = A.val(indxA) .* B.val(indxB);

% Do we need to use GetValueOfAssignment(phi, [1 2 1]) and SetValueOfAssignment(phi, [1 2 1]) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
