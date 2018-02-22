function theta = speakerTrain(data, max_iter, epsilon, M )
% gmmTain
%
%  inputs:  data       : T x D data
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
%
%  output:  theta      : a struct with this structure:
%                            gmm.weights : 1xM vector of GMM weights
%                            gmm.means   : DxM matrix of means (each column 
%                                          is a vector
%                            gmm.cov     : DxDxM matrix of covariances. 
%                                          (:,:,i) is for i^th mixture

T = size(data, 1);
D = size(data, 2);

theta = struct();
theta.weights = zeros(1, M) + 1/M;
theta.means = data(ceil(rand(1, M) * T), :)'; % D x M
theta.cov = ones(D, D, M); % D x D x M

prev = -Inf;

% For each iteration
for i = 1:max_iter
    
    % Compute likelihood
    [L, pm] = computeLikelihood(data, theta, M);
    
    % Update theta
    theta = updateParameters(data, theta, pm, M);
    
    % Calculate improvement
    improvement = L - prev;
    if improvement < epsilon
        break;
    end
    prev = L;
end

end

function theta = updateParameters(data, theta, pm, M)
    
    T = size(data, 1);
    D = size(data, 2);

    sum_p = sum(pm, 1); % 1 x M
    theta.weights = sum_p ./ T;
    
    rep_sum_p = repmat(sum_p, D, 1);
    sum_p_X = data' * pm; 
    theta.means = sum_p_X ./ rep_sum_p;
    
    mu_squared = theta.means .* theta.means;
    X_squared = data .* data;
    sum_p_X_squared = X_squared' * pm;
    E_X_squared = sum_p_X_squared ./ rep_sum_p;
    for m = 1:M
        theta.cov(:, :, m) = diag(E_X_squared(:, m) - mu_squared(:,m));
    end
end