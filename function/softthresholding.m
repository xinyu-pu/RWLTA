function [soft_thresh] = softthresholding(b, lambda)
	soft_thresh = sign(b).*max(abs(b) - lambda, 0);
end