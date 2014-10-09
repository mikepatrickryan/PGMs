function P = ComputeImageFactor (img, imgModel)
% This function computes the singleton OCR factor values for a single
% image.
%
% Input:
%   img: The 16x8 matrix of the image
%   imgModel: The provided, trained image model
%
% Output:
%   P: A K-by-1 array of the factor values for each of the K possible
%     character assignments to the given image
%

X = img(:);
N = length(X);
K = imgModel.K;

theta = reshape(imgModel.params(1:N*(K-1)), K-1, N);
bias  = reshape(imgModel.params((1+N*(K-1)):end), K-1, 1);

W = [ bsxfun(@plus, theta * X, bias) ; 0 ];
W = bsxfun(@minus, W, max(W));
W = exp(W);

P=bsxfun(@rdivide, W, sum(W));


end

% A function handle is a point to another function; @function-name; used when passing
% functions as an argument 

% the Geometry package provides functions to manipulate geometric entities in 2D and 3D
% It is based on matGeom, and provides interfaces to SVG files and polygon meshing using Gmsh
 