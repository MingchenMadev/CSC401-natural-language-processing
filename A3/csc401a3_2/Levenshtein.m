function [SE IE DE LEV_DIST] =Levenshtein(hypothesis,annotation_dir)
% Input:
%	hypothesis: The path to file containing the the recognition hypotheses
%	annotation_dir: The path to directory containing the annotations
%			(Ex. the Testing dir containing all the *.txt files)
% Outputs:
%	SE: proportion of substitution errors over all the hypotheses
%	IE: proportion of insertion errors over all the hypotheses
%	DE: proportion of deletion errors over all the hypotheses
%	LEV_DIST: proportion of overall error in all hypotheses

SE = 0;
IE = 0;
DE = 0;
num_words = 0;
hypos = textread(hypothesis, '%s', 'delimiter', '\n');
N = length(hypos);

% for each test utterances
for n = 1:N
    
    % Construct reference
    ref_file = textread([annotation_dir, filesep, 'unkn_', int2str(n), '.txt'], '%s', 'delimiter', '\n');
    ref_split = strsplit(ref_file{1},' ');
    ref = ref_split(3:end);
    
    % Construct hypothesis
    hypothesis_line = hypos{n};
    hypothesis_split = strsplit(hypothesis_line, ' ');
    hypo = hypothesis_split(3:end);
    
    fprintf('>>testing %d sentence:\n', n);
    fprintf('hypo: %s\n', strjoin(hypo,' '));
    fprintf('ref: %s\n', strjoin(ref,' '));
    
    [new_se, new_ie, new_de] = leven_score(hypo, ref);
    
    % Update parameters
    SE = SE + new_se;
    IE = IE + new_ie;
    DE = DE + new_de;
    num_words = num_words + length(ref);
    
    % Print paramters
    fprintf('Substitution: %f\nInsert: %f\nDelete: %f\n', new_se/length(ref), new_ie/length(ref), new_de/length(ref));
end
SE = SE / num_words;
IE = IE / num_words;
DE = DE / num_words;
LEV_DIST = SE + IE + DE;
end
