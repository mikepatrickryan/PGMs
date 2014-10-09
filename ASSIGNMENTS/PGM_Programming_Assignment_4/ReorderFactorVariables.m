function out = ReorderFactorVariables(in)
% Function accepts a factor and reorders the factor 
% variables, .card and .val fields such that the .var are in ascending order

[in_ordered, index] = sort(in.var);
out.var = in_ordered;
out.card = in.card(index);
allAssignmentsIn = IndexToAssignment(1:prod(in.card), in.card);
allAssignmentsOut = allAssignmentsIn(:, index);
out.val(AssignmentToIndex(allAssignmentsOut, out.card)) = in.val; 
