function all_phoneme = construct_phoneme(dir_train)

all_phoneme = struct();

folders = dir([dir_train, filesep]);
folders = folders(3:end);
N = length(folders);

% for all speakers
for i=1:N
    speaker = folders(i).name;
    dir_speaker = [dir_train, filesep, speaker];
    
    utterance = dir([dir_speaker, filesep, '*.mfcc']);
    phones = dir([dir_speaker, filesep, '*.phn']);
    num_utter = length(utterance);
    
    % for all utterance under this speakers
    for j=1:num_utter
        mfcc = load([dir_speaker, filesep, utterance(j).name]);
        num_mfcc = size(mfcc, 1);
        phn = textread([dir_speaker, filesep, phones(j).name], '%s', 'delimiter', '\n');
        num_phn = length(phn);
        
        % for each phoneme under this utterance
        for k=1:num_phn
            phn_lines  = strsplit(phn{k}, ' ');
            phn_start = (str2num(phn_lines{1}) / 128) + 1;
            phn_end   = min(str2num(phn_lines{2}) / 128, num_mfcc);
            
            mfcc_data = mfcc(phn_start:phn_end, :);
            if strcmp(phn_lines{3}, 'h#')
                phn_lines{3} = 'sil';
            end
            if ~isfield(all_phoneme, phn_lines{3})
                all_phoneme.(phn_lines{3}) = cell(0);
            end
            num_phn_sequences = length(all_phoneme.(phn_lines{3}));
            all_phoneme.(phn_lines{3}){num_phn_sequences + 1} = mfcc_data';
        end
    end
end

end