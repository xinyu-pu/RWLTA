function [ out ] = solveNorm21( tensor, lambda )
    tmp = tensor2matrix(tensor, 2)';  % mode-2 unfold and transpose to get matrix we need
    nw = sum(tmp.^2).^0.5;  
    nw = (nw - lambda)./nw;
    nw(nw < 0) = 0;
    tmp = tmp .* nw;
    out = matrix2tensor(tmp', size(tensor), 2);  % fold the matrix back into a tensor 
end

