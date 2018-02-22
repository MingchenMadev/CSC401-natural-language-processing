%
% evalAlign
%
%  This is simply the script (not the function) that you use to perform your evaluations in 
%  Task 5. 

% some of your definitions
trainDir     = '/u/cs401/A2_SMT/data/Hansard/Training/';
testDir      = '/u/cs401/A2_SMT/data/Hansard/Testing/';
fn_LME       = 'TrainingEnglishLM.mat';
fn_LMF       = 'TrainingFrenchLM.mat';
lm_type      = '';
delta        = 0.5;
numSentences = 1000;

% Train your language models. This is task 2 which makes use of task 1
LME = lm_train( trainDir, 'e', fn_LME );
LMF = lm_train( trainDir, 'f', fn_LMF );

% Train your alignment model of French, given English 
AMFE = align_ibm1( trainDir, numSentences, 50, 'am.mat');
% ... TODO: more 

% TODO: a bit more work to grab the English and French sentences. 
%       You can probably reuse your previous code for this  
ref1 = {};
ref2 = {};
eng = {};
lines = textread('/u/cs401/A2_SMT/data/Hansard/Training/Task5.f', '%s','delimiter','\n');
for l=1:length(lines)
    fre = lines{l};
    fre = preprocess(fre, 'f');
    eng = [eng, decode2( fre, LME, AMFE, lm_type)];
end

lines = textread('/u/cs401/A2_SMT/data/Hansard/Training/Task5.e', '%s','delimiter','\n');
for l=1:length(lines)
    ref1l = preprocess(lines{l}, 'e');
    ref1 = [ref1, ref1l];
end

lines = textread('/u/cs401/A2_SMT/data/Hansard/Training/Task5.google.e', '%s','delimiter','\n');
for l=1:length(lines)
    ref2l = preprocess(lines{l}, 'e');
    ref2 = [ref2, ref2l];
end
% Decode the test sentence 'fre'


% TODO: perform some analysis
% add BlueMix code here 
score = zeros(length(lines), 3);
for l=1:length(lines)
    score(l,1) = BLEU(eng{l}, ref1{l}, ref2{l}, 1);
    score(l,2) = BLEU(eng{l}, ref1{l}, ref2{l}, 2);
    score(l,3) = BLEU(eng{l}, ref1{l}, ref2{l}, 3);
end

[status, result] = unix('')