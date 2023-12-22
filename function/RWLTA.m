function [ S, convergence_information, all_tensors, admm_outcome ] = RWLTA( x, p, logging, processing )
%% ATTENTION:
%  This package is free for academic usage. You can run it at your own risk. 
%  For other purposes, please contact Hangjun Che (hjche123@swu.edu.cn)
%  This package was developed by Xinyu Pu.
%  For any problem concerning the code, please feel free to contact Xinyu Pu (pushyu404@163.com)
%% Reference:
%  X. Pu, H. Che, B. Pan, M. -F. Leung and S. Wen, "Robust Weighted Low-Rank Tensor Approximation 
%  for Multiview Clustering With Mixed Noise," in IEEE Transactions on Computational Social Systems, 
%  doi: 10.1109/TCSS.2023.3331366.
%% Description:
%  Input:
%    x: multiview data set, represented as cell of (n x 1) or (1 x n)
%    weight, theta, and lambda: hyperparameters of RWLTA
%    p: the parameters of RWLTA. `P` is a structure with fields
%       ('weight', 'theta', 'lambda', 'mu', 'max_mu', 'rho', 'max_rho', 'eps', 'max_iter', 'beta'). 
%       'weight', 'theta', and 'lambda' are the hyperparameters that must be given in advance. 
%       The default values of other fields are 10e-3, 10e10, 1*10e-3, 10e10, 1e-9, 200, and 2, respectively. 
%    logging: parameter controls whether to output iteration information.
%             default 1
%    processing: parameter controls whether construct randomized wandering matrices from data set.
%                default 1
%  Output:
%    S: final affinity matrix.
%    convergence_information: a structure with residual errors of iteration. 
%           (convergence_information = {'res1',res1l, 'res2', res2l,
%           'difZ', difZl, 'difE', difEl})
%    all_tensors: all_tensors = {'T', tensor_T, 'E', tensor_E}. tensor_T
%           and tensor_E denote the low-rank tensor and noise tensor,
%           repectively.
%    admm_outcome: admm_outcome = {'time', time_consumption, 'success', is_success, 'iter', num_iter}
%%%% END OF INSTRUCTION, FOR UPDATES, PLEASE SEE <a href= "https://github.com/xinyu-pu/Fast-PGP">xinyu-pu/TCSS2023-RWLTA-code</a>. 
    
    if ~exist('logging','var')
       logging = 1;
    end
    if ~exist('processing','var')
       processing = 1;
    end

    %% processing data
     if processing == 1
         ratio=1;
         V = max(size(x));
         N = size(x{1}, 1);
         tensor_T = zeros(N, N, V);
         for i = 1:V
             options.KernelType = 'Gaussian';
             options.t = ratio*optSigma(x{i});
             tmp = constructKernel(x{i},x{i},options);
             D = diag(sum(tmp, 2));
             tensor_T(:,:,i) = D^-1 * tmp;
         end
     else
         tensor_T = x;
         V = size(x, 3);
         N = size(x, 1);
     end

     %% initialize tensor
     tensor_Z = zeros(N, N, V);
     tensor_E = zeros(N, N, V);
     tensor_E2 = zeros(N, N, V);
     tensor_E3 = zeros(N, N, V);
     tensor_Y = zeros(N, N, V);
     tensor_B = zeros(N, N, V);
     
     %% intialize parameters
     assert(all(isfield(p, {'weight','theta','lambda'})))
     p_list = isfield(p, {'mu','max_mu','rho','max_rho','eps','max_iter','beta'});
     c = 1;
     for i=p_list
         if i==0
             switch(c)
                 case 1
                     p.mu = 10e-3;
                 case 2
                     p.max_mu = 10e10;
                 case 3
                     p.rho = 1*10e-3;
                 case 4
                     p.max_rho = 10e10;
                 case 5
                     p.eps = 1e-9;
                 case 6
                     p.max_iter = 200;
                 case 7
                     p.beta = 2;
             end
         end
         c = c + 1;
     end
     clear c;
     
     %% iteration
     iter = 1;
     is_converge = 0;
     thisTIC = tic;
     while is_converge == 0
         Zpre = tensor_Z;
         Epre = tensor_E;
         
         % update E1
         tensor_E1 = updateNorm( tensor_E - tensor_E2 - tensor_E3 + ...
             tensor_B./p.rho, 'c1', p.rho, p.lambda(1));
         
         % update E2 and E3
         for i = 1:V
             tensor_E2(:, :, i) = updateNorm( tensor_E(:, :, i) - tensor_E1(:, :, i) - tensor_E3(:, :, i) ...
                 + tensor_B(:, :, i)./p.rho, 't1', p.lambda(2)/p.rho);
             tmp = tensor_E(:, :, i) - tensor_E1(:, :, i) - tensor_E2(:, :, i) + tensor_B(:, :, i)./p.rho;
             tensor_E3(:, :, i) = p.rho * tmp/(2*p.lambda(3) + p.rho);
         end
         
         % update E
         tensor_E = (p.mu * (tensor_T - tensor_Z + tensor_Y/p.mu) + ...
             p.rho * (tensor_E1 + tensor_E2 + tensor_E3 - tensor_B/p.rho)) / (p.mu + p.rho);
         
         % update Z 
         tensor_Z = updateNorm( tensor_T - tensor_E + tensor_Y/p.mu, 'WNATNN', p.weight/p.mu, p.theta );
         
         % update Y and B
         for i=1:V
             tensor_Y(:, :, i) = tensor_Y(:, :, i) + p.mu * (tensor_T(:, :, i) - ...
                 tensor_Z(:, :, i) - tensor_E(:, :, i));
             
             tensor_B(:, :, i) = tensor_B(:, :, i) + p.rho * (tensor_E(:, :, i) - ...
                 tensor_E1(:, :, i) - tensor_E2(:, :, i) - tensor_E3(:, :, i));
         end
         
         % update mu and rho
         p.mu = min(p.mu * p.beta, p.max_mu);
         p.rho = min(p.rho * p.beta, p.max_rho);
         
         % check convergence
         res_r1 = max(abs(tensor_T(:) - tensor_Z(:) - tensor_E(:)));
         res_r2 = max(abs(tensor_E(:) - tensor_E1(:) - tensor_E2(:)- tensor_E3(:)));
         difZ = max(abs(tensor_Z(:) - Zpre(:)));
         difE = max(abs(tensor_E(:) - Epre(:)));
         res1l(iter) = res_r1;
         res2l(iter) = res_r2;
         difZl(iter) = difZ;
         difEl(iter) = difE;
         if logging
             fprintf('--------------- iter = %d ---------------\n', iter);
             fprintf('mu = %.3f               rho = %.3f\n', p.mu, p.rho);
             fprintf('difZ = %.3f               difE = %.3f\n', difZ, difE);
             fprintf('res_r1 = %.3f               res_r2 = %.3f\n', res_r1, res_r2);
         end
         err = max([res_r1,difZ,difE,res_r2]);
         if err < p.eps
            is_converge = 1;
         else
             iter = iter + 1;
             if iter > p.max_iter
                 break;
             end
        end
     end
     
     %% results
     time_consumption = toc(thisTIC);
     is_success = is_converge; 
     num_iter = iter;
     S = 0;
     for i=1:V
         S = S + abs(tensor_Z(:, :, i))+abs(tensor_Z(:, :, i)');
     end
     S = S./V;
     convergence_information = {'res1',res1l, 'res2', res2l, 'difZ', difZl, 'difE', difEl};
     all_tensors = {'T', tensor_T, 'E', tensor_E};
     admm_outcome = {'time', time_consumption, 'success', is_success, 'iter', num_iter};
end

