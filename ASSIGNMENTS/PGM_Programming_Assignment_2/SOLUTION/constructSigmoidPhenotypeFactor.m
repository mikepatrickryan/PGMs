function phenotypeFactor = constructSigmoidPhenotypeFactor(alleleWeights, geneCopyVarOneList, geneCopyVarTwoList, phenotypeVar)
% This function takes a cell array of alleles' weights and constructs a 
% factor expressing a sigmoid CPD.
%
% In the factor, for each gene, each allele assignment maps to the allele
% whose weight is at the corresponding location.  For example, for gene 1,
% allele assignment 1 maps to the allele whose weight is at
% alleleWeights{1}(1) (same as w_1^1), allele assignment 2 maps to the
% allele whose weight is at alleleWeights{1}(2) (same as w_2^1),....  
% 
% You may assume that there are 2 possible phenotypes.
% For the phenotypes, assignment 1 maps to having the physical trait, and
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alleleWeights: 1 x m cell array of genes, containing cell entries with 1 x n 
%   arrays of weights for the alleles for a gene (n is the number of alleles for
%   the gene; m is the number of genes)
%   geneCopyVarOneList: m x 1 vector (m is the number of genes) of variable 
%   numbers for each of the first parent's copy of each gene (numbers in this 
%   list go in the .var part of the factor)
%   geneCopyVarTwoList: m x 1 vector (m is the number of genes) of variable 
%   numbers for each of the second parent's copy of each gene (numbers in 
%   this list go in the .var part of the factor) 
%   phenotypeVar: Variable number corresponding to the variable for the 
%   phenotype (goes in the .var part of the factor)
%
% Output:
%   phenotypeFactor: Factor in which the values are the probabilities of 
%   having each phenotype for each allele combination (note that this is 
%   the FULL CPD with no evidence observed)

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numGenes = length(alleleWeights);
phenotypeFactor.var(1) = phenotypeVar;
phenotypeFactor.card(1) = 2;

for i=1:numGenes, 
	numAlleles=length(alleleWeights{i});
	phenotypeFactor.var(i+1) = geneCopyVarOneList(i);
	phenotypeFactor.card(i+1) = numAlleles;	
	phenotypeFactor.var(i+1+numGenes) = geneCopyVarTwoList(i);
	phenotypeFactor.card(i+1+numGenes) = numAlleles;	
end;

phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% Replace the zeros in phentoypeFactor.val with the correct values.

[allelesToGenotypes, genotypesToAlleles] = generateAlleleGenotypeMappers(numAlleles);

% i represents allele indices 
% j represents gene indices

A = zeros(prod(phenotypeFactor.card), numGenes*2);

valCount = 1; 
geneCount = 1;
geneIndex = 1;
alleleOneCopyCount = ones(1,numGenes);
alleleTwoCopyCount = ones(1,numGenes);

cards = phenotypeFactor.card(2:end);

flippedOne = zeros(1,numGenes);
flippedTwo = zeros(1,numGenes);

for a = 1:prod(phenotypeFactor.card),
	count=1;
	% Populate the row with allele values for both copies of all genes
	rowVector = zeros(2*numGenes,1);
	for i=1:2*numGenes,
		if mod(i,2)==1,
			A(a,i) =  alleleOneCopyCount(count);
		else
			A(a,i) = alleleTwoCopyCount(count);
			count=count+1;
		end;
		tmp = A(a,i);
		count = min(count, numGenes);
		rowVector(i,1)=alleleWeights{count}(tmp);
	end;
	% Increment alleles appropriately to cover all permutations in the correct order
	phenotypeFactor.val(1,a) = sum(rowVector);
	for i=1:numGenes,
		if i==1,
			if alleleOneCopyCount(i)== cards(i), 
				alleleOneCopyCount(i)=1;
				flippedOne(i) = 1;
			else
				alleleOneCopyCount(i)= alleleOneCopyCount(i)+1;
				flippedOne(i) = 0;
			end;
		elseif and(alleleTwoCopyCount(i-1)==1, flippedTwo(i-1)==1),
			if alleleOneCopyCount(i)== cards(i),
				alleleOneCopyCount(i)=1;
				flippedOne(i)= 1;
			else
				alleleOneCopyCount(i)= alleleOneCopyCount(i)+1;
				flippedOne(i)= 0;
			end;
		else
			flippedOne(i)= 0;
		end;
		if and(alleleOneCopyCount(i)==1, flippedOne(i)),
			if alleleTwoCopyCount(i)== cards(i),
				alleleTwoCopyCount(i)=1;
				flippedTwo(i) = 1;
			else
				alleleTwoCopyCount(i)= alleleTwoCopyCount(i)+1;
				flippedTwo(i) = 0;
			end;
		else
			flippedTwo(i)= 0;
		end;
	end;
end;
		
phenotypeFactor.val = computeSigmoid(phenotypeFactor.val);
numValues = prod(phenotypeFactor.card);
half = numValues/2;
phenotypeFactor.val(1,[half+1:numValues]) = 1 - phenotypeFactor.val(1,[half+1:numValues]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%