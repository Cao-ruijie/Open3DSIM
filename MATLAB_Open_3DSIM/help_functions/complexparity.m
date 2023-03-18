function [ B ] = complexparity(A,centerposition)
% This function flips an array in all dimensions w.r.t. centerposition
% and takes the complex conjugate, centerposition must be a vector of
% integers of length equal to the number of dimensions of A.
%
% copyright Sjoerd Stallinga, TU Delft, 2018

alldims = size(A);
numdims = length(alldims);
for jdim = 1:numdims
  A = flip(A,jdim);
  dimshift = 2*centerposition(jdim)-1-alldims(jdim);
  A = circshift(A,dimshift,jdim);
end
B = conj(A);

end