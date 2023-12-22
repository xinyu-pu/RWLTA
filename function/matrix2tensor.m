function [ tensor] = matrix2tensor( matrix, dim, k)
    dim0 = [([dim(1:k-1),dim(k+1:length(dim))]),dim(k)];
    tensor = permute(reshape(matrix',dim0),[1:k-1,length(dim),k:length(dim)-1]);
end

