function factorList = constructDecoupledGeneticNetwork(pedigree, alleleFreqs, alphaList)
% This function constructs a Bayesian network for genetic inheritance.  It
% assumes that there are only 2 phenotypes.  It also assumes that, in the
% pedigree, either both parents are specified or neither parent is
% specified.
%
% Here is an example of how the variable numbering should work: if
% pedigree.names = {'Ira', 'James', 'Robin'} and pedigree.parents = [0, 0;
% 1, 3; 0, 0], then the variable numbering is as follows:
%
% Variable 1: IraGeneCopy1
% Variable 2: JamesGeneCopy1
% Variable 3: RobinGeneCopy1
% Variable 4: IraGeneCopy2
% Variable 5: JamesGeneCopy2
% Variable 6: RobinGeneCopy2
% Variable 7: IraPhenotype
% Variable 8: JamesPhenotype
% Variable 9: RobinPhenotype
%
% Input:
%   pedigree: Data structure that includes the names and parents of each
%   person
%   alleleFreqs: n x 1 vector of allele frequencies in the population,
%   where n is the number of alleles
%   alphaList: m x 1 vector of alphas for different genotypes, where m is
%   the number of genotypes -- the alpha value for a genotype is the 
%   probability that a person with that genotype will have the physical 
%   trait
%
% Output:
%   factorList: struct array of factors for the genetic network (In each
%   factor, .var, .card, and .val are row 1-D vectors.)

numPeople = length(pedigree.names);

% Initialize factors
factorList(3*numPeople) = struct('var', [], 'card', [], 'val', []);

% Number of alleles
numAlleles = length(alleleFreqs); 

% populate the genotype factors
for i=1:numPeople, 
	parent1 = pedigree.parents(i,:)(1,1);
	parent2 = pedigree.parents(i,:)(1,2);
	if (0==(parent1+parent2)),
		factorList(i) = childCopyGivenFreqsFactor(alleleFreqs, i);
		factorList(i+numPeople) = childCopyGivenFreqsFactor(alleleFreqs, i+numPeople);
	else
		factorList(i) = childCopyGivenParentalsFactor(numAlleles, i, parent1, parent1+numPeople);
		factorList(i+numPeople) = childCopyGivenParentalsFactor(numAlleles, i+numPeople, parent2, parent2+numPeople);

	end;
end;

%populate the phenotype factors 
for j=2*numPeople+1:3*numPeople,
	genotypeCopyVar1 = j-2*numPeople;
	genotypeCopyVar2 = j-numPeople;
	factorList(j) = phenotypeGivenCopiesFactor(alphaList, numAlleles, genotypeCopyVar1, genotypeCopyVar2, j);
end;
% phenotypeGivenCopiesFactor(alphaList, numAlleles, geneCopyVarOne, geneCopyVarTwo, phenotypeVar)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable numbers:
% 1 - numPeople: first parent copy of gene variables
% numPeople+1 - 2*numPeople: second parent copy of gene variables
% 2*numPeople+1 - 3*numPeople: phenotype variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  