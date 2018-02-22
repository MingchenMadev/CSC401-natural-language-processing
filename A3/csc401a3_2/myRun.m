dir_test    = '/u/cs401/speechdata/Testing';
dir_hmm     = 'trained_phoneme';
dir_bnt    = '/u/cs401/A3_ASR/code/FullBNT-1.0.7';
max_testfiles = 10;
num_c = 0;
num_t = 0;

phonemes = dir([dir_test, filesep, '*.phn']);
mfccs = dir([dir_test, filesep, '*.mfcc']);
N = length(phonemes);

% For all test utterances
for i=1:min(N, max_testfiles)
    
    phn_data = textread([dir_test, filesep, phonemes(i).name], '%s', 'delimiter', '\n');
    num_phn = length(phn_data);
    mfcc_data = dlmread(strcat(dir_test, filesep, mfccs(i).name));
    mfcc_N = size(mfcc_data, 1);
    
    % For each phoneme contained in utterance
    for j=1:num_phn
        phn_lines  = strsplit(phn_data{j}, ' ');
        phn_start = (str2num(phn_lines{1}) / 128) + 1;
        phn_end   = min(str2num(phn_lines{2}) / 128, mfcc_N);
            
        mfcc_block = mfcc_data(phn_start:phn_end, :);
        trained_hmms = dir([dir_hmm, filesep]);
        trained_hmms = trained_hmms(3:end);
        num_hmms = length(trained_hmms);
        
        max_prob = -Inf;
        phn_tested = '';
        
        % For all possible phonemes
        for k=1:num_hmms
            
            phoneme_trained = trained_hmms(k).name;
            load([dir_hmm, filesep, phoneme_trained], 'HMM', '-mat');
            
            data = mfcc_block';
            addpath(genpath(dir_bnt));
            test_prob = loglikHMM(HMM, data);
            rmpath(genpath(dir_bnt));

            if test_prob > max_prob
                max_prob  = test_prob;
                idx = strfind(phoneme_trained,'_');
                phn_tested = phoneme_trained(idx+1:end);
            end
        end
        if strcmp(phn_lines{3}, 'h#')
            phn_lines{3} = 'sil';
        end
        if strcmp(phn_lines{3}, phn_tested)
            num_c = num_c + 1;
        end
    end
    num_t = num_t + num_phn;
end

fprintf('accuracy of testing %d utterances is %f\n', i, num_c/num_t);