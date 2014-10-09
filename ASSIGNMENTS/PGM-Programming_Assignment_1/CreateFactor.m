% CreateFactor creates a factor data structure
%     The factor data structure has the following fields:
%       .var    Vector of variables in the factor, e.g. [1 2 3]
%       .card   Vector of cardinalities corresponding to .var, e.g. [2 2 2]
%       .val    Value table of size prod(.card)
%
%   The resultant factor should have at least one variable remaining or this
%   function will throw an error.


function A = CreateFactor (vr, c, vl)

% Check for 1) empty vectors, 2) non-unique variable numbers in vr, or 3) inconsistent # of var and card
if (isempty(vr) || isempty(c)) ,
	error('Error: neither .var nor .card arguements can have null values');
elseif (length(vr) != length(unique(vr))),
	error('Error: .var must contain a vector with unique numbers for variables');
elseif (length(vr) != length(c)),
	error('Error: .var must have the same length as .card');
end;

% Check for inconsisent # of val arguements
if (length(vl) < prod(c)), 
  warning('Assigning 0s to value vector since val < prod(card)');
  vl = zeros(1,prod(c));
elseif ( length(vl) > prod(c)),
  error('Error: the length of val > prod(c)');
else 
end;

% Create the factor A
A = struct('var', vr, 'card', c, 'val', vl);

end
