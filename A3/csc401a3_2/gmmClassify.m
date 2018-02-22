test_folder = '/u/cs401/speechdata/Testing';
M = 8;
S = size(gmms, 2);
utterance_file = dir([test_folder, filesep, '*.mfcc']);

for i = 1:length(utterance_file)
    filename = utterance_file(i).name;
    fprintf('testing %s \n', filename);
    filename_split = strsplit(filename,'.');
    output_filename = strcat(filename_split{1}, 'lik');
    
    data = dlmread([test_folder, filesep, filename]);

    T = size(data, 1);
    D = size(data, 2);
    l = zeros(1, S);
    for j = 1:S
        theta = struct();
        theta.weights = gmms{j}.weights;
        theta.means = gmms{j}.means;
        theta.cov = gmms{j}.cov;
        [l(j), pm] = computeLikelihood(data, theta, M);
    end
    % Sort on the result to find top five
    [like, idx] = sort(l, 'descend');
    % Write result to file
    fp = fopen(strcat('testing/', output_filename), 'w');
    for k = 1:5
        fprintf(fp, '%d place: %s\n', k, gmms{idx(k)}.name);
    end
    fclose(fp);
end
        