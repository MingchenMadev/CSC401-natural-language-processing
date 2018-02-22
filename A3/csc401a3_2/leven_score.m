function [se, ie, de] = leven_score(hypo, ref)

n = length(hypo);
m = length(ref);

S = zeros(n+1, m+1);
B = zeros(n+1, m+1);

S(1, :) = Inf;
S(:, 1) = Inf;
S(1, 1) = 0;

for i = 2:n+1
    for j = 2:m+1
        if strcmp(ref{j-1}, hypo{i-1})
            sub_match = S(i-1,j-1);
        else
            sub_match = S(i-1,j-1)+1;
        end
        min_array = [S(i-1,j-1)+1, sub_match, S(i, j-1) + 1, S(i-1, j) + 1];
        [S(i, j), B(i, j)] = min(min_array);
    end
end

i = n+1;
j = m+1;

se = 0;
ie = 0;
de = 0;
while (i ~= 1) || (j ~= 1)
    if (B(i, j) == 2)
        i = i - 1;
        j = j - 1;
    elseif (B(i, j) == 1)
        i = i - 1;
        j = j - 1;
        se = se + 1;
    elseif (B(i, j) == 3)
        j = j - 1;
        de = de + 1;
    elseif (B(i, j) == 4)
        i = i - 1;
        ie = ie + 1;
    end
end

de = de + j - 1;
ie = ie + i - 1;
end
