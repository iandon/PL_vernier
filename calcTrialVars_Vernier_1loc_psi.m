function [trialProc] = calcTrialVars_Vernier_1loc_psi(blockNum)
global params;

if params.practice.run == 1
    n = params.practice.nTrials;
else
    n = params.trialVars.numTrialsInBlock;
end

%%%%%%%----- COVARIATES -----%%%%%%%

% 
% counterBalance = cell(3,1);
% 
% counterBalance{1} = params.stim.contLevels;                      %contrast Levels
% counterBalance{2} = params.blockVars.StimNumOnBlock(blockNum); %locations
% counterBalance{3} = params.stim.possibleAngles;                  %angles
% 
% 
% %The function below will counter balance all of the variables in the array,
% %and replicate the counterbalanced array so that
% 
% [CB, CBnums] = calcVarsCBauto(counterBalance,n);
% 

%Here, you must reference the same cell that in which placed the original
%values
offsetDirPossible = [-1,1];
offsetDirNumPossible = [1,2];
offsetDir = repmat(offsetDirPossible',[ceil(n/2),1]);
offsetDirNum = repmat(offsetDirNumPossible',[ceil(n/2),1]);


ord = randperm(n);
offsetDir = offsetDir(ord);
offsetDirNum = offsetDirNum(ord);

cont = repmat(params.stim.contrast,[n,1]);

stimNum = repmat(params.stim.possibleStimNums(params.blockVars.StimNumOnBlock(blockNum)),[n,1]);

stimLocs = nan(n,2);
for i = 1:n
    stimLocs(i,:) = params.stim.locationsPix(stimNum(i),:);
end


%%%%%%----  Cue Validity -----%%%%%%%%
% Validity = Does the cued location equal the post cue location?

if params.preCue.type == 0
    propValid = 0;
elseif params.preCue.type == 1
    propValid = params.preCueExg.validity;
end
validitiesPRE = rand(n,1);
validities = validitiesPRE < propValid;

%%%%%%----  Pre Cued location -----%%%%%%%%

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
        

preCue = struct('locs', cueLocs,'cuedStimNum', cuedStimNum); 


%%%%%%----  Post Cued location -----%%%%%%%%
postCueLocs = stimLocs; %Post cue is always pointing to the target. if there is more than 1 stimulus, postCueLocs = stimLocs(:,1,:);
targetNums = stimNum; %Target is always the only stimulus on the screen. If there is more than 1 stimulus on the screen, targNum = stimNum(:,1);



%%%%%%----  Phase offset -----%%%%%%%%
phase_offset = 2*pi*rand(size(stimNum));


%%%%%%----  Staircase Order -----%%%%%%%%
% if params.stairVars.run
%     stairNumPoss1 = 1:params.stairVars.numStaircases; stairNumPoss1 = stairNumPoss1';
%     stairNumPoss2 = (1+params.stairVars.numStaircases):(params.stairVars.numStaircases*numLocs); stairNumPoss2 = stairNumPoss2';
%     
%     stairNumpre2 = repmat(stairNumPoss1, [(params.stairVars.numTrialsPerStaircase),1]);
%     stairNumpre3 = repmat(stairNumPoss2, [(params.stairVars.numTrialsPerStaircase),1]);
%     
%     stairOrd = randperm(size(stairNumpre2,1));
%     stairOrd2 = randperm(size(stairNumpre3,1));
%     
%     stairNumpre4 = [stairNumpre2(stairOrd), stairNumpre3(stairOrd2)];
%     stairNum = nan(n,1); stair1Count = 0; stair2Count = 0;
%     for i = 1:n
%         if stimNum(i) == params.blockVars.StimNumOnBlock(blockNum,1)
%             stair1Count = stair1Count + 1;
%             stairNum(i) = stairNumpre4(stair1Count,1);
%         elseif stimNum(i) == params.blockVars.StimNumOnBlock(blockNum,2)
%             stair2Count = stair2Count + 1;
%             stairNum(i) = stairNumpre4(stair2Count,2);
%         end
%     end
%     
% end
%%%%%NOTE: will have to factor in # of trials



%%%%%%----  Target's data -----%%%%%%%%

targets = cell(n,1);
for idx = 1:n
    targets{idx}.offsetDir = offsetDir(idx,1);
%     targetsP{idx}.cont = cont(idx,1);
    targets{idx}.validity = validities(idx);
    targets{idx}.num = targetNums(idx);
    targets{idx}.loc = postCueLocs(idx);
end
    
trialNum = 1:n;
trialNum = trialNum';
    
trialProc = cell(n,1);
for i = 1:n
    trialProc{i}.trialNum = trialNum(i);
    trialProc{i}.offsetDir = offsetDir(i,:);
    trialProc{i}.offsetDirNum = offsetDirNum(i,:);
    trialProc{i}.stimNum = stimNum(i,:);
    trialProc{i}.stimLocs = stimLocs(i,:);
    trialProc{i}.preCue.locs = preCue.locs(i,:); 
    trialProc{i}.preCue.cuedStimNum = preCue.cuedStimNum(i);
    trialProc{i}.validity = validities(i);
    trialProc{i}.postCueLocs = postCueLocs(i,:);
    trialProc{i}.targets = targets{i};
    trialProc{i}.phase_offset = phase_offset(i);
    trialProc{i}.angle = params.stim.baseAngle;
%     if params.stairVars.run == 1, trialProc{i}.stairNum = stairNum(i); end
    trialProc{i}.cont = cont(i,:);
%     trialProc{i}.contLevelNum = contLevelNum(i,:);
end



end





