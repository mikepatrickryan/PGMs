function factor = ComputeSimilarityFactor (images, K, i, j)
% This function computes the similarity factor between two character images
% in one word --- which characters is given by indices i and j 
%
% Input:
%   images: A struct array of character images from one word.
%   K: The alphabet size.
%   i,j: The scope of that factor. That is, you should construct a factor
%     between characters i and j in the images array.
%
% Output:
%   factor: The similarity factor between these two characters. For any
%     assignment C_i != C_j, the factor value should be one. For any
%     assignment C_i == C_j, the factor value should be
%     ImageSimilarity(I_i, I_j) --- ie, the computed value given by
%     ImageSimilarity.m on the two images.

factor = struct('var', [], 'card', [], 'val', []);

% MIKE RYAN: 
tmp1 = ones(K, K);
tmp2 = eye(K);
tmp1=tmp1-tmp2;
tmp2=tmp2.*ImageSimilarity(images(i).img, images(j).img);
val = tmp1 + tmp2;
factor.var = [i, j];
factor.card = [K, K];
factor.val = val;

end

