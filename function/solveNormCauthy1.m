function [ out ] = solveNormCauthy1( tensor, rho, lambda)
%%     orgin version
    gamma_tmp = -2*rho;
    eps_tmp = gamma_tmp/(-2)*(1 + 1/gamma_tmp + 1e-6) ^ 2;
    out  = solveNorm21( tensor./(1+1/gamma_tmp), lambda/eps_tmp);
%%     c1 have been improved 
%     gamma = abs(-2*rho/lambda);
%     mu = abs(rho - lambda);
%     out  = solveNorm21( tensor./abs(1+2/gamma), lambda/(mu + eps));
end

