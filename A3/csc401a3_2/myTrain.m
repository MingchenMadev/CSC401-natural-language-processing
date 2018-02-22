dir_train   = '/u/cs401/speechdata/Training';
bnt_path    = '/u/cs401/A3_ASR/code/FullBNT-1.0.7';
output_file = 'trained_phoneme';

M           = 8;
Q           = 3;
initType    = 'kmeans';
max_iter    = 15;

all_phoneme = construct_phoneme(dir_train);
addpath(genpath(bnt_path));

phn_train = fields(all_phoneme);
num_phn = length(phn_train);
for i_phn=1:num_phn
    phn = phn_train{i_phn};
    data = all_phoneme.(phn);
    
    HMM = initHMM(data, M, Q, initType);
    [HMM, LL] = trainHMM(HMM, data, max_iter);
    
    save([output_file, filesep, 'trained_', phn], 'HMM', '-mat');
end

rmpath(genpath(bnt_path));