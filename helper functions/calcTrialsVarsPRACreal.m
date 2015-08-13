function [trialProc] = calcTrialsVarsPRACreal(blockNum)
global params;

if params.practice.run == 1
    n = params.practice.nTrials;
else
    n = params.trialVars.numTrialsInBlock;
end

%%%%%%%----- COVARIATES -----%%%%%%%
%ord = randperm(n); % will be used to order all covariates

anglesPossibilities = params.stim.possibleAngles';
numAngles = size(anglesPossibilities, 1);

numLoc = 2;
% % if params.saveVars.sesType == 0 %Pre or Post test
% %     numLoc = 3;
% % elseif params.saveVars.sesType == 1 %Training
% %     numLoc = 1;
% % end
% % %numLoc is the number of posssible locations a stimulus can occur across
% % %the whole exp
% % %For the current experiment, there is only 1 stimulus per trial. If more
% % %locations contain stimuli on each trial, a separate variable is needed,
% % %and this needs to be accounted for when dealing with covariate # calc


numCovarCombos = numAngles*numLoc;

%%%%%%----  Validity of Trial -----%%%%%%%%
% Validity = Does the cued  location equal the post cue location?

if params.preCue.type == 0
    propValid = 0;
elseif params.preCue.type == 1
    propValid = params.preCueExg.validity;
end
validitiesPRE = rand(n,1);
validities = validitiesPRE < propValid; 



% % propNeut = params.preCue.propNeut;
% % propVal = params.preCue.propValid;
% % propInval = 1 - propNeut - propVal;
% % 
% % if propInval < 0
% %     error('Proportion of Valid and Neutral precue trials must sum to a # < or == 1.0')
% % end

% % [minNumTrials, cueValMtx] = makeCueValMtx(propNeut, propVal, propInval, numCovarCombos);

% % [numTrialsPRE] = makeApproxTrialNum(minNumTrials, params.trialVars.numTrialsInBlockAPPROX);

%Check if number of trials is OK - i.e is a multiple of the total number of
%variable parameter combinations
% 
% if (round(n/(numCovarCombos))-(n/(numCovarCombos)))~=0
%        error('Number of trials must be able to be divided by number of possible angles times number of possible locations');
% end

ord = randperm(n);

%%%%%%%----- Angles -----%%%%%%%
% Computing gabor angles for all stimuli for all trials, so angles are
% distributed randomly
%
% ord will be used again for locations (and should be used for all other 
% covariates), such that each location and angle combination appears an 
% equal number of time

%NOTE: This experiment presents only 1 stimulus per trial
%         If 2 or more stimuli need to be presented on each trial, then
%         addtional columsn in 'angles' can be dedicated to these
%         additional stimuli
%
%       IMPORTANT: Later in this script, target features/details will be
%       formed assuming that the first columns in 'angles' and other arrays
%       pertain to the target.

angleNumPRE1 = [1,2];

anglesMtx = nan(numCovarCombos,1); %length is the product of # of each covariate
PossMtx = repmat(anglesPossibilities, [numLoc,1]);
angleNumMTX = nan(numCovarCombos,1);
for i = 1:numAngles
    clear anglesMtxIndex;
    anglesMtxIndex = (1:numLoc) + ((numLoc)*(i-1));  %for each angle, you need all locations; if you need more covariates, such as contrast or cues, you need to use numLoc*numContrats, etc.
    for j = 1:numLoc
        anglesMtx(anglesMtxIndex(j)) = PossMtx(i);
        angleNumMTX(anglesMtxIndex(j)) = angleNumPRE1(i);
    end
end

anglesPRE = repmat(anglesMtx, [n,1]);
angleNumPRE2 = repmat(angleNumMTX, [n,1]);


angles = anglesPRE(ord,:); %use ord so that it matches the order of the remaining covariates
%Will be a mtx of integers. 1 being counterclockwise, 2 being clockwise
angleNum = angleNumPRE2(ord,:);

%%%%%%----  Constrast -----%%%%%%%%
%constrast = params.stim.contrast*ones(n ,params.stim.num);
%numContrasts = length(params.stim.contrast);

% c1 = repmat(params.stim.contrast',n/length(params.stim.contrast), 1);
% c2 = repmat(c1,1,params.stim.num);
if ~params.stairVars.run
    cont = params.stim.contrast(params.blockVars.StimNumOnBlock(blockNum));
else
    cont = repmat(params.stim.contrast(1),[n,1]);
end

%%%%%%----  Stimulus location -----%%%%%%%%
% If locations of stimuli do not change through the experiment, use following code. Otherwise
% change code here

stimNumpre = params.blockVars.StimNumOnBlock(blockNum,:);
stimNumpre = stimNumpre';


angleCount = 0; locCount = 1;
stimNumpre2 = nan(size(stimNumpre,1)*numAngles);
stimNumChoicePRE = nan(size(stimNumpre2));
for i = 1:(size(stimNumpre,1)*2)
    angleCount = angleCount + 1;
    if angleCount <= 2
        stimNumpre2(i) = stimNumpre(locCount);
        stimNumChoicePRE(i) = locCount;
    else
        locCount = locCount+1;
        angleCount = 0;
    end
end
% 
% stimNumChoice =  repmat(stimNumChoicePRE, [n,1]);
% stimNumChoice = stimNumChoice(ord);
% 
% stimNumChoice

stimNum = repmat(stimNumpre, [n,1]);
stimNum = stimNum(ord);

stimLocspre = nan(n,2);
for i = 1:n
    stimLocspre(i,:) = params.stim.locationsPix(stimNum(i),:);
end
stimLocs = repmat(stimLocspre,[n, 1]);






% % trainLoc = params.stim.trainLoc;
% % 
% % if numLoc == 1 %Training
% %     stimNumpre = trainLoc;
% %     stimLocspre = params.stim.locationsPix(trainLoc, :);
% % elseif numLoc == 3 %Pre or Post test
% %     if trainLoc == 1
% %         stimNumpre = [1; 2; 3];
% %     elseif trainLoc == 2
% %         stimNumpre = [2; 1; 4];
% %     elseif trainLoc == 3
% %         stimNumpre = [3; 1; 4];
% %     elseif trainLoc == 4
% %         stimNumpre = [4; 2; 3];
% %     end
% %     
% %     stimLocspre = [params.stim.locationsPix(stimNumpre(1),:);...
% %                    params.stim.locationsPix(stimNumpre(2),:);...
% %                    params.stim.locationsPix(stimNumpre(3),:)];
% % end
% % 
% % stimLocspre2 = repmat(stimLocspre,[n, 1]);
% % 
% % stimLocs = stimLocspre2(ord, :);
% % 
% % stimNumpre2 = repmat(stimNumpre, [n, 1]);
% % 
% % stimNum = stimNumpre2(ord,:);


%%%%%%----  Pre Cued location -----%%%%%%%%

%cuequest = 1; %%%%CHANGE%%%%%%%%CHANGE%%%%%%%%CHANGE%%%%%%%%CHANGE%%%%%%%%CHANGE%%%%%%%%CHANGE%%%%

%possibleCuedLocs = params.precueExg.locationsPix;
%numCuedLocs = size(possibleCuedLocs,1); %possible orders of angles like [0 90] and [90 0] its 2

% cueLocspre = nan(size(stimLocspre,1), size(stimLocspre,2)); %If there is more than 1 stimulus per trial, there will only be 1 cue, so this ignores the 3rd dimension (non-target stimuli locations) of stimLocs if there is one
% for i = 1:size(stimLocspre,1)
%     if validities(i) == 0
%         cueLocspre(i,:) = params.screenVar.centerPix; %Neutral cue
%     elseif validities(i) == 1
%         cueLocspre(i, :) = [params.preCueExg.locationsPix(stimNumpre(i,1),1), params.preCueExg.locationsPix(stimNumpre(i,1),2)]; %Location of cue corresponding to target
%     elseif validities(i) == 2
%         cueLocspre(i, :) = [params.preCueExg.locationsPix(stimNumpre(i,2),1), params.preCueExg.locationsPix(stimNumpre(i,2),2)]; %Location of cue corresponding to distractor1
%     end
% end
% 
% cueLocspre2 = repmat(cueLocspre, [n,1]);
% 
% cueLocs = cueLocspre2(ord,:);


    


%repCue = repmat(possibleCuedLocs,[n 1]);
%cuedStimLocs = repCue(ord, :);
% calculate the number of the stimulus which was cued
% % for j = 1:n
% %     s = nan(size(stimLocs,1), size(stimLocs,2),n);
% %     s = stimLocs(:,:,j);
% %     rep = repmat(cuedStimLocs(j,:),size(params.stim.locationsPix, 2),1);
% %     cuedStimNum(j) = find(sum(s == rep,2)== size(params.stim.locationsPix, 2));
% % end
cueLocs = nan(n,2);
cuedStimNum = nan(n,1);
for i = 1:n
    if validities(i) == 1
        cuedStimNum(i) = stimNum(i,1);
        cueLocs(i,:) = [params.preCueExg.locationsPix(stimNum(i,1),1),...
                        params.preCueExg.locationsPix(stimNum(i,1),2)];
    elseif validities(i) == 0
        cuedStimNum(i) = 0;
        cueLocs(i,:) = params.screenVar.centerPix;
    elseif validities(i) == 2
        cuedStimNum(i) = stimNum(i,2);
        cueLocs(i,:) = [params.preCueExg.locationsPix(stimNum(i,2),1),...
                        params.preCueExg.locationsPix(stimNum(i,2),2)]; %Location of cue corresponding to distractor1
        % NOTE: the current exp only has 1 stimulus. If there are 2, this
        % would cue the distractor on invalid trials (validity = 2)
    end
end

% update cue location to be slightly different from stim location
%prop = params.precueExg.radiusPix/params.stim.radiusPix;
%cueLocs =  [(1-prop)* params.screenVar.centerPix(1) + (prop)*cuedStimLocs(:,1) ,...
%            (1-prop)* params.screenVar.centerPix(2) + (prop)*cuedStimLocs(:,2)];
        

preCue = struct('locs', cueLocs,'cuedStimNum', cuedStimNum); 


%%%%%%----  Post Cued location -----%%%%%%%%
postCueLocs = stimLocs; %Post cue is always pointing to the target. if there is more than 1 stimulus, postCueLocs = stimLocs(:,1,:);
targetNums = stimNum; %Target is always the only stimulus on the screen. If there is more than 1 stimulus on the screen, targNum = stimNum(:,1);



%%%%%%----  Phase offset -----%%%%%%%%
phase_offset = 2*pi*rand(size(stimNum));


%%%%%%----  Staircase Order -----%%%%%%%%
if params.stairVars.run
    stairNumPoss1 = 1:params.stairVars.numStaircases; stairNumPoss1 = stairNumPoss1';
    stairNumPoss2 = (1+params.stairVars.numStaircases):(params.stairVars.numStaircases*numLoc); stairNumPoss2 = stairNumPoss2';
    
    stairNumpre2 = repmat(stairNumPoss1, [(params.stairVars.numTrialsPerStaircase),1]);
    stairNumpre3 = repmat(stairNumPoss2, [(params.stairVars.numTrialsPerStaircase),1]);
    
    stairOrd = randperm(size(stairNumpre2,1));
    stairOrd2 = randperm(size(stairNumpre3,1));
    
    stairNumpre4 = [stairNumpre2(stairOrd), stairNumpre3(stairOrd2)];
    stairNum = nan(n,1); stair1Count = 0; stair2Count = 0;
    for i = 1:n
        if stimNum(i) == params.blockVars.StimNumOnBlock(blockNum,1)
            stair1Count = stair1Count + 1;
            stairNum(i) = stairNumpre4(stair1Count,1);
        elseif stimNum(i) == params.blockVars.StimNumOnBlock(blockNum,2)
            stair2Count = stair2Count + 1;
            stairNum(i) = stairNumpre4(stair2Count,2);
        end
    end
    
end
%%%%%NOTE: will have to factor in # of trials



%%%%%%----  Target's data -----%%%%%%%%
% targets = struct('angle', {[]}, 'validity', {validities'}, 'num', targetNums', 'loc', postCueLocs); 

% targets = nan(n,1);

targets = cell(n,1);
for idx = 1:n
    targets{idx}.angle = angles(idx,1);
    targets{idx}.validity = validities(idx);
    targets{idx}.num = targetNums(idx);
    targets{idx}.loc = postCueLocs(idx);
end
    
trialNum = 1:n;
trialNum = trialNum';
% % 
% % trial = struct('angles', angles, 'cont', cont, 'stimLocs', stimLocs,...
% %                'precue', precue, 'validities',validities, 'postCueLocs', postCueLocs,...
% %                'targets', targets, 'phase_offset', phase_offset, 'stairNum',stairNum,...
% %                'trialNum', trialNum);
           
    
trialProc = cell(n,1);
for i = 1:n
    trialProc{i}.trialNum = trialNum(i);
    trialProc{i}.angles = angles(i,:);
    trialProc{i}.stimNum = stimNum(i,:);
    trialProc{i}.stimLocs = stimLocs(i,:);
    trialProc{i}.preCue.locs = preCue.locs(i,:); trialProc{i}.preCue.cuedStimNum = preCue.cuedStimNum(i);
    trialProc{i}.validity = validities(i);
    trialProc{i}.postCueLocs = postCueLocs(i,:);
    trialProc{i}.targets = targets{i};
    trialProc{i}.phase_offset = phase_offset(i);
    if params.stairVars.run == 1, trialProc{i}.stairNum = stairNum(i); end
    trialProc{i}.cont = cont;
    trialProc{i}.angleNum = angleNum(i);
end



end





