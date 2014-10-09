%ComputeMarginal Computes the marginal over a set of given variables
%   M = ComputeMarginal(V, F, E) computes the marginal over variables V
%   in the distribution induced by the set of factors F, given evidence E
%
%   M is a factor containing the marginal over variables V
%   V is a vector containing the variables that remain in the marginal e.g. [1 2 3] for
%     X_1, X_2 and X_3.
%   F is a vector of factors (struct array) containing the factors 
%     defining the distribution
%   E is an N-by-2 matrix, each row being a variable/value pair. 
%     Variables are in the first column and values (as in indices) are in the second column.
%     If there is no evidence, pass in the empty matrix [] for E.


function M = ComputeMarginal(V, F, E)

% Check for empty factor list
if (numel(F) == 0)
      warning('Warning: empty factor list');
      M = struct('var', [], 'card', [], 'val', []);      
      return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create a joint distribution from the product of CPD factors
M = ComputeJointDistribution(F);

if (~isempty(E)),
	% Remove incongruent cases from observed evidence if evidence exists
	M = ObserveEvidence(M,E);	
	% Normalize the values in M to 1 
	M.val = M.val ./ sum(M.val);
end;

if (~isempty(V)),
	tmp = setdiff(M.var, V);
	if(~isempty(tmp)),
		% Marginalize out the variables not listed in V
		M = FactorMarginalization(M, tmp);
	end;
end;
				
M = StandardizeFactors(M);

end
