
pscore = struct();
pscore.e = zeros(1, 5);
pscore.f = zeros(1, 5);

for i = 1:5
    i
    if i == 1
        pscore.e(1, i) = perplexity(LME, '/u/cs401/A2_SMT/data/Hansard/Testing/', 'e', '', 0);
        pscore.f(1, i) = perplexity(LMF, '/u/cs401/A2_SMT/data/Hansard/Testing/', 'f', '', 0);
    else
        pscore.e(1, i) = perplexity(LME, '/u/cs401/A2_SMT/data/Hansard/Testing/', 'e', 'smooth', (0.1).^(i-1));
        pscore.f(1, i) = perplexity(LMF, '/u/cs401/A2_SMT/data/Hansard/Testing/', 'f', 'smooth', (0.1).^(i-1));
    end
end

