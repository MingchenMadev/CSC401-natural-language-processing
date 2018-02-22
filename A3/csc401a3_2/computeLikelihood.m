function [L, pm] = computeLikelihood(data, theta, M)
    T = size(data, 1);
    D = size(data, 2);

    log_b = zeros(T, M);
    for m = 1:M
        mu_m = theta.means(:, m);
        mu_m_T = repmat(mu_m.', T, 1);
        cov_m = diag(theta.cov(:,:,m));
        cov_m_T = repmat(cov_m.', T, 1);
        log_b(:,m) = sum(-0.5*((data-mu_m_T).^2 ./cov_m_T + log(2*pi*cov_m_T)), 2);
    end
    b = exp(log_b);
    rep_w = repmat(theta.weights, T, 1); % T x M
    w_b = rep_w .* b; % T x M
    
    sum_w_b = b * theta.weights'; % T x 1
    rep_sum_w_b = repmat(sum_w_b, 1, M); 
    
    L = sum(log(sum_w_b), 1);
    
    pm = w_b ./ rep_sum_w_b; 
end