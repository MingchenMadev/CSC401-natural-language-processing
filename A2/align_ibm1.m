function AM = align_ibm1(trainDir, numSentences, maxIter, fn_AM)
%
%  align_ibm1
% 
%  This function implements the training of the IBM-1 word alignment algorithm. 
%  We assume that we are implementing P(foreign|english)
%
%  INPUTS:
%
%       dataDir      : (directory name) The top-level directory containing 
%                                       data from which to train or decode
%                                       e.g., '/u/cs401/A2_SMT/data/Toy/'
%       numSentences : (integer) The maximum number of training sentences to
%                                consider. 
%       maxIter      : (integer) The maximum number of iterations of the EM 
%                                algorithm.
%       fn_AM        : (filename) the location to save the alignment model,
%                                 once trained.
%
%  OUTPUT:
%       AM           : (variable) a specialized alignment model structure
%
%
%  The file fn_AM must contain the data structure called 'AM', which is a 
%  structure of structures where AM.(english_word).(foreign_word) is the
%  computed expectation that foreign_word is produced by english_word
%
%       e.g., LM.house.maison = 0.5       % TODO
% 
% Template (c) 2011 Jackie C.K. Cheung and Frank Rudzicz
  
  global CSC401_A2_DEFNS
  
  AM = struct();
  
  % Read in the training data
  [eng, fre] = read_hansard(trainDir, numSentences);

  % Initialize AM uniformly 
  AM = initialize(eng, fre);

  % Iterate between E and M steps
  for iter=1:maxIter,
    AM = em_step(AM, eng, fre);
  end
  
  % Save the alignment model
  save( fn_AM, 'AM', '-mat'); 

  end





% --------------------------------------------------------------------------------
% 
%  Support functions
%
% --------------------------------------------------------------------------------

function [eng, fre] = read_hansard(mydir, numSentences)
%
% Read 'numSentences' parallel sentences from texts in the 'dir' directory.
%
% Important: Be sure to preprocess those texts!
%
% Remember that the i^th line in fubar.e corresponds to the i^th line in fubar.f
% You can decide what form variables 'eng' and 'fre' take, although it may be easiest
% if both 'eng' and 'fre' are cell-arrays of cell-arrays, where the i^th element of 
% 'eng', for example, is a cell-array of words that you can produce with
%
%         eng{i} = strsplit(' ', preprocess(english_sentence, 'e'));
%
  eng = {};
  fre = {};
  DD = dir( [ mydir, filesep, '*', 'e'] );
  disp([ mydir, filesep, '.*', 'e'] );
  numLines = 1;
  for iFile=1:length(DD)

    lines = textread([mydir, filesep, DD(iFile).name], '%s','delimiter','\n');
    for l=1:length(lines)
        eng{numLines} = strsplit(' ', preprocess(lines{l}, 'e'));
        numLines = numLines + 1;
    end
  end
  
  DD = dir( [ mydir, filesep, '*', 'f'] );
  disp([ mydir, filesep, '.*', 'f'] );
  numLines = 1;
  for iFile=1:length(DD)

    lines = textread([mydir, filesep, DD(iFile).name], '%s','delimiter','\n');
    for l=1:length(lines)
        fre{numLines} = strsplit(' ', preprocess(lines{l}, 'f'));
        numLines = numLines + 1;
    end
  end

  % TODO: your code goes here.
  numSentences = min(numSentences, length(eng));
  eng = eng(1:numSentences);
  fre = fre(1:numSentences);
end


function AM = initialize(eng, fre)
%
% Initialize alignment model uniformly.
% Only set non-zero probabilities where word pairs appear in corresponding sentences.
%
    AM = struct(); % AM.(english_word).(foreign_word)
    AMs = struct(); % AMs.(english_word) is list of french word
    % TODO: your code goes here
    for l=1:length(eng)
        words = eng{l};
        for p=1:length(words)
            eng_word = words{p};
            if (~isfield(AMs, eng_word))
                AMs.(eng_word) = {};
            end
            AMs.(eng_word) = [AMs.(eng_word), fre{l}];
        end
    end
    
    names = fieldnames(AMs);
    for n=1:length(names)
        nList = unique(AMs.(names{n}));
        for nl=1:length(nList)
            AM.(names{n}).(nList{nl}) = 1.0 / length(nList);
        end
    end
    
    AM.SENTSTART.SENTSTART = 1;
    AM.SENTEND.SENTEND = 1;
end

function t = em_step(t, eng, fre)
% 
% One step in the EM algorithm.
%
  tcount = struct();
  total = struct();
  % TODO: your code goes here
  for l=1:length(eng)
      uniquewf=unique(fre{l});
      uniquewe=unique(eng{l});
      for ufl=1:length(uniquewf)
          
          wf = uniquewf{ufl};
          countf = sum(ismember(fre{l}, wf));
          denom_c = 0;
          for uel=1:length(uniquewe)
              denom_c = denom_c + t.(uniquewe{uel}).(wf) * countf;
          end
          for uel=1:length(uniquewe)
              we = uniquewe{uel};
              counte = sum(ismember(eng{l}, we));
              if (~isfield(tcount, we))
                  tcount.(we).(wf) = 0;
              elseif (~isfield(tcount.(we), wf))
                  tcount.(we).(wf) = 0;
              end
              tcount.(we).(wf) = tcount.(we).(wf) + t.(we).(wf) * counte / denom_c;
              if (~isfield(total, we))
                  total.(we) = 0;
              end
              total.(we) = total.(we) + t.(we).(wf) * counte / denom_c;
          end
      end
  end
  name = fieldnames(total);
  for nl=1:length(name)
      we = name{nl};
      frenchName = fieldnames(tcount.(we));
      for fnl=1:length(frenchName)
          wf = frenchName{fnl};
          t.(we).(wf) = tcount.(we).(wf) / total.(we);
      end
  end
end


