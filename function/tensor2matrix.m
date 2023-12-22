function [ unfold_matrix ] = tensor2matrix( tensor, k)
    dim = size(tensor);
    unfold_matrix = reshape(permute(tensor,[k,1:k-1,k+1:length(dim)]),dim(k),[]);
end

