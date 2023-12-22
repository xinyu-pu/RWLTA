function [ X, objV ] = solveWNATNN( tensor, weight, theta, nonconvex_fun, rotate )
    sX = size(tensor);
    if ~exist('rotate','var')
        % mode = 1 --> lateral slice
        % mode = 2 --> front slice
        % mode = 3 --> top slice
        rotate = 1;
    end
     if ~exist('nonconvex_fun','var')
        % mode = 1 --> lateral slice
        % mode = 2 --> front slice
        % mode = 3 --> top slice
        nonconvex_fun = 1;
    end
    % rotate
    if rotate
        Y = shiftdim(tensor, 1);
        n3 = sX(1);
    else
        Y = tensor;
        n3 = sX(3);
    end
    
    % set nonconven function
    switch(nonconvex_fun)
        case 1
            nFun = @gemman;
        otherwise
            nFun = nonconvex_fun;
    end
    
    % run t-SVD
    Yhat = fft(Y,[],3);
    objV = 0;
    endValue = int16(n3/2+1);
    for i = 1:endValue
        [uhat,shat,vhat] = svd(full(Yhat(:,:,i)),'econ');
        tau = weight .* nFun(shat, theta);
        shat = max(shat - tau, 0);
        objV = objV + sum(shat(:));
        Yhat(:,:,i) = uhat * shat * vhat';
        if i > 1
            Yhat(:,:,n3-i+2) = conj(uhat) * shat * conj(vhat)';
            objV = objV + sum(shat(:));
        end
    end
    if isinteger(n3/2)
         [uhat,shat,vhat] = svd(full(Yhat(:,:,endValue+1)),'econ');
         tau = weight .* nFun(shat, theta);
         shat = max(shat - tau, 0);
         objV = objV + sum(shat(:));
         Yhat(:,:,endValue+1) = uhat*shat*vhat';
    end
    Y = ifft(Yhat,[],3);
    
    % rotate
    if rotate
        X = shiftdim(Y, 2);
    else
        X = Y;
    end
end

function out = gemman(x, theta)
    out = (1+theta)*theta./(theta+x).^2;
end
