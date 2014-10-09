%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 

function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MIKE RYAN - C.nodes, C.edges, C.factorList
%
% Compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. The order of assignments of factors to cliques
% should happen in the order cliques are given to this function at the end 
% of CreateCliqueTree.  Each factor should be assigned to the first clique 
% that contains the variables in the factor, where the ordering of the cliques
% is given by C.nodes.  C.nodes is a list of cliques.
% Starting with: P.cliqueList(i).var = C.nodes{i};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N,
	P.cliqueList(i).var = C.nodes{i};
end;

% Set the clique tree edges adjacency matrix to the given values
P.edges = C.edges;

fl = C.factorList;
% ReorderFactorVariables transforms each factor to arrange the .var in ascending order
% the index mapping is used to rearrange the .card and .val to keep them consistent.
% Initializing scopeMap; scopeMap(k) will return the index of the clique/cluster to which 
% a factor k is assigned.
scopeMap = zeros(1,length(fl));

for j=1:length(fl),
	i = 1;
	fl(j) = ReorderFactorVariables(fl(j));
	while i<=N,
		if (ismember(fl(j).var, P.cliqueList(i).var)),
			scopeMap(j) = i;
			i = N+1;
		endif
		i++;
	end
end

% Generate a list of all the .var and respective .card from the factorList
[allVars indexVars] = unique([fl.var], "first");
allCards = [fl.card](indexVars);

% find, unique, setdiff, isempty, isequal are all helpful functions for this.

% Need to calculate the .val fields for each clique/cluster by 1. multiplying factors together
% in the case where multiple factors have been assigned to a clique/cluster, 2. assigning a 
% single factor, or 3. setting all initial potentials to 1 for all variable assignments 
% in cliques with no factors
for i=1:N,
	if (sum(i==scopeMap)>1),
		% Multiply multiple factors
		inds = find(scopeMap==i);
% assign all the factors from fl that have been assigned to i to a tmp factor list
		tmpFactorList = fl(inds);
		for k=1:length(tmpFactorList)-1,
			newFactor = FactorProduct(fl(inds(k)), fl(inds(k+1)));
			fl(inds(k+1)) = newFactor;
		end;
		P.cliqueList(i).val = newFactor.val;
		P.cliqueList(i).card = newFactor.card;
	elseif (sum(i==scopeMap)==1)
		% There's only one factor; assign the .card and .val appropriately
		index = find(scopeMap==i);
		P.cliqueList(i).card = fl(index).card;
		P.cliqueList(i).val = fl(index).val;
	else
		% There are no factors assigned to this clique; set .card properly
		% and initialize .val to 1 for all variable assignments
		y = ismember(allVars, [P.cliqueList(i).var]);
		index = find(y==1);
		P.cliqueList(i).card = allCards(index);
		P.cliqueList(i).val = ones(1, prod(P.cliqueList(i).card));
	endif
end
	
			
