function phenotypeFactor = phenotypeGivenGenotypeFactor(alphaList, genotypeVar, phenotypeVar)
% This function computes the probability of each phenotype given the 
% different genotypes for a trait. Genotypes (assignments to the genotype
% variable) are indexed from 1 to the number of genotypes, and the alphas
% are provided in the same order as the corresponding genotypes so that the
% alpha for genotype assignment i is alphaList(i).
%
% For the phenotypes, assignment 1 maps to having the physical trait, and 
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alphaList: Vector of alpha values for each genotype (n x 1 vector,
%   where n is the number of genotypes) -- the alpha value for a genotype
%   is the probability that a person with that genotype will have the
%   physical trait 
%   genotypeVar: The variable number for the genotype variable (goes in the
%   .var part of the factor)
%   phenotypeVar: The variable number for the phenotype variable (goes in
%   the .var part of the factor)
%
% Output:
%   phenotypeFactor: Factor in which the val has the probability of having 
%   each phenotype for each genotype combination (note that this is the 
%   FULL CPD with no evidence observed)

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
% The number of genotypes is the length of alphaList.
% The number of phenotypes is 2; either a person has or does not have a physical trait.
% Factor type 1 is P(person's phenotype | person's genotype)
genoCard = length(alphaList); 
phenoCard = 2;
phenotypeFactor.card = [phenoCard genoCard];
phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card)) ;
assignments = IndexToAssignment(1:prod(phenotypeFactor.card), phenotypeFactor.card);
phenotypeFactor.var = [phenotypeVar genotypeVar];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  	
phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));

for i=1:length(assignments), 
	odd = mod(i,2);
	if (odd == 1),
		phenotypeFactor = SetValueOfAssignment(phenotypeFactor, assignments(i,:), alphaList(ceil(i/2)));
		i;
	else
		phenotypeFactor = SetValueOfAssignment(phenotypeFactor, assignments(i,:), 1- alphaList(ceil(i/2)));
		i;
	end;
end;
end
