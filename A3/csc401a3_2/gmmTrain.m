function gmms = gmmTrain( dir_train, max_iter, epsilon, M )
% gmmTain
%
%  inputs:  dir_train  : a string pointing to the high-level
%                        directory containing each speaker directory
%           max_iter   : maximum number of training iterations (integer)
%           epsilon    : minimum improvement for iteration (float)
%           M          : number of Gaussians/mixture (integer)
%
%  output:  gmms       : a 1xN cell array. The i^th element is a structure
%                        with this structure:
%                            gmm.name    : string - the name of the speaker
%                            gmm.weights : 1xM vector of GMM weights
%                            gmm.means   : DxM matrix of means (each column 
%                                          is a vector
%                            gmm.cov     : DxDxM matrix of covariances. 
%                                          (:,:,i) is for i^th mixture

gmms = cell(1, 30);
speaker_folder = dir(dir_train);

% Get ride of . and ..
speaker_folder = speaker_folder(3:end);

for i = 1:length(speaker_folder)
    file_info = speaker_folder(i);
    utterance_folder = file_info.name;
    fprintf('training %s...\n', utterance_folder);
    
    % New struct to hold data
    data = [];
    file_names = dir([dir_train, filesep, utterance_folder, filesep,'*.mfcc']);
    
    % For each utterance
    for j = 1:length(file_names)
        % Read file in
        m = dlmread([dir_train, filesep, utterance_folder, filesep, file_names(j).name]);
        data = vertcat(data, m);
    end
    gmms{i} = speakerTrain(data, max_iter, epsilon, M);
    gmms{i}.name = utterance_folder;
end
end
                



