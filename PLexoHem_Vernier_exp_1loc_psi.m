clear all;
addpath(genpath('/users/purplab/Desktop/Ian/PL_vernier/helper functions'))
addpath(genpath('/users/Shared/Psychtoolbox'))
addpath(genpath('/users/purplab/Desktop/Ian/PL_vernier/palamedes1_6_0'))


PLexoHem_Vernier_defs_1loc_psi_YZ; 

global params; params.practice.run = 0;

% params.eye.run = 0;
% params.stairVars.run = 0;
params.stim.colorTest = 0;

%initials = 'test'; sesNum = '0';
initials = input('Please enter subject initials: \n', 's'); initials = upper(initials);
params.subj.gender = input('Please enter subject GENDER: M/F/O \n', 's');
params.subj.age = input('Please enter subject AGE: \n', 's');
sesNumquest = input('Please enter the session number:\n', 's'); sesNum = str2double(sesNumquest); params.saveVars.sesNum = sesNum; params.sesVar.sesNum = sesNum;
sesTypequest = input('Test(0) or Training(1)? \n', 's'); sesType = str2double(sesTypequest); params.saveVars.sesType = sesType;
% TRAIN LOCATION is in Plexp_defs file -> Make sure it is the right one!

if (sesNumquest > 1) && ~strcmp(initials,params.saveVars.SubjectInitials)
    error('Check if settings file used is correct for this participant'); 
end

if sesType == 0; params.preCue.type = 0; end 

numBlocks = params.blockVars.numBlocks;
nTrials = params.trialVars.numTrialsInBlock;


if params.stim.trainLoc == 1
    params.stim.possibleStimNums = [1,2,3,4]; %trained, U_diffHem, U_sameHem, U_diag
elseif params.stim.trainLoc == 4
    params.stim.possibleStimNums = [4,3,2,1]; %trained, U_diffHem, U_sameHem, U_diag
end


if sesType == 0,                       
    if params.stim.trainLoc == 1
        if strcmp(params.stim.orderType,'A')
            params.blockVars.StimNumOnBlock = [1,4,3,2];%trained, U_diag, U_sameHem, U_diffHem
        elseif strcmp(params.stim.orderType,'B')
            params.blockVars.StimNumOnBlock = [2,3,4,1];%U_diffHem, U_sameHem, U_diag, trained
        end
    elseif params.stim.trainLoc == 4
        if strcmp(params.stim.orderType,'A')
            params.blockVars.StimNumOnBlock = [4,1,2,3];%U_diag, trained, U_diffHem, U_sameHem
        elseif strcmp(params.stim.orderType,'B')
            params.blockVars.StimNumOnBlock = [3,2,1,4];%U_sameHem, U_diffHem, trained, U_diag
        end
    end
elseif sesType == 1
    params.stim.order = [1,1,1,1];
    params.blockVars.StimNumOnBlock = params.stim.possibleStimNums([1,1,1,1]);
else
    error('Session type must be 1 (training) or 0 (test)')
end


if ~mod(params.blockVars.numBlocks/4,1)
    params.blockVars.StimNumOnBlock = repmat(params.blockVars.StimNumOnBlock,[params.blockVars.numBlocks/4,1]);
else
    error('Number of blocks must be a multiple of 4')
end

%params.screenVar.num
wPtr = Screen('OpenWindow', params.screenVar.num, params.screenVar.bkColor, params.screenVar.rectPix);
%Load  new gamma table to fit the current scre 
startclut = Screen('ReadNormalizedGammaTable', params.screenVar.num);
load( params.screenVar.calib_filename); 
new_gamma_table = repmat(calib.table, 1, 3);
Priority(MaxPriority(wPtr));
Screen('LoadNormalizedGammaTable',params.screenVar.num,new_gamma_table,[]);     

% instructions(wPtr);  
%%%% ------------  Start experiment  ----------%%%%%
NanMtxBlock = nan(1, nTrials);
results.Ses = cell(numBlocks,1);
sesStair1 = cell(numBlocks,1); sesStair2 = cell(numBlocks,1);sesStair3 = cell(numBlocks,1);sesStair4 = cell(numBlocks,1);
expData = cell(numBlocks, 1);



if params.eye.run
    Eyelink('Initialize');
    el = prepEyelink(wPtr);
    ELfileName = sprintf('%s%d', initials, sesNum); edfFileStatus = Eyelink('OpenFile', ELfileName);
    if edfFileStatus ~= 0, fprintf('Cannot open .edf file. Exiting ...'); return; end
    cal = EyelinkDoTrackerSetup(el);
end


halfWay = 0;halfWaySes = 0;
for b = 1:numBlocks
    
    
    [trialProc] = calcTrialVars_Vernier_1loc_psi(b);
    
%     if sesType == 1
%         if halfWaySes == 0
%             if (b-1) >= (numBlocks/2)
%                 halfWaySes = 1;
%                 halfwayBreak(wPtr,b);
%             end
%         end
%     end
    
    instructions(wPtr);
    
    driftCorr = 1;
    if params.eye.run && (b > 1)
        driftCorr = EyelinkDoDriftCorrect(el, params.screenVar.centerPix(1),...
                                          params.screenVar.centerPix(2), 1, 1);
    end
    
    if params.eye.run && ~driftCorr
        EyelinkDoDriftCorrect(el, 'c');
    end
    
    stair = PAL_AMPM_setupPM('stimRange',params.stairVars.stimRangeSTAIR,...
                             'priorAlphaRange',params.stairVars.priorAlphaRange,...
                             'priorBetaRange',params.stairVars.priorBetaRange,...
                             'gamma',params.stairVars.gamma,'lambda',params.stairVars.lambda,...
                             'PF',params.stairVars.PF,'numTrials',nTrials,'marginalize',params.stairVars.marginalize);
    
    clear results.Block
    results.Block = struct('rt',{NanMtxBlock},...
                           'key', {NanMtxBlock},...
                           'correct',{NanMtxBlock});
                       
    clear breakFix.Block
    breakFix.Block = struct('check', {[]}, 'track', {[]}, 'count', {0}, 'recent', {0});
    breakFix.Block.count = 0; breakFix.Block.recent = 0; breakFix.Block.recalCount = 0;

    timestamp = cell(nTrials, 1); halfWay = 0;
    j = 0; nTrialsUPDATE = nTrials;
    while j < nTrialsUPDATE
        j = j + 1;
        i = floor(j) - breakFix.Block.count;
        recal = 0;
        
        if (i > (nTrials/2)) && (halfWay == 0)
            halfWay = 1; halfwayBreakblock(wPtr,b);
        end
        
        targetAngle = params.stim.baseAngle; %trialProc{i}.targets.angle*(params.stairVars.stimRangeREAL(2)*stair.xCurrent) + params.stim.baseAngle; 
        trialProc{i}.targetAngle = targetAngle;
        trialProc{i}.stimVal = stair.xCurrent;
        trialAngles = targetAngle;
        
        
        cont = trialProc{i}.cont;
        
        
        switch params.stim.baseAngle
            case 0
                horizSepDeg = trialProc{i}.offsetDir*params.stairVars.stimMinMax(2)*stair.xCurrent;
                horizSepPix = deg2pix1Dim(horizSepDeg, params.screenVar.ratioX);
                trialProc{i}.stimLocsBOTH = [trialProc{i}.stimLocs(1)+horizSepPix/2,trialProc{i}.stimLocs(2)+params.stim.vertSeparationPix/2;...
                                             trialProc{i}.stimLocs(1)-horizSepPix/2,trialProc{i}.stimLocs(2)-params.stim.vertSeparationPix/2];
            case 90
                vertSepDeg = trialProc{i}.offsetDir*params.stairVars.stimMinMax(2)*stair.xCurrent;
                vertSepPix = deg2pix1Dim(vertSepDeg, params.screenVar.ratioY);
                trialProc{i}.stimLocsBOTH = [trialProc{i}.stimLocs(1)+params.stim.horizSeparationPix/2,trialProc{i}.stimLocs(2)+vertSepPix/2;...
                                             trialProc{i}.stimLocs(1)-params.stim.horizSeparationPix/2,trialProc{i}.stimLocs(2)-vertSepPix/2];
        end

        
        [breakFix.Block.check, correctTrial, respTrial, trialProc{i}.timestamp]...
                                      = trial(wPtr, b, i, trialProc{i}.stimNum,... 
                                              trialProc{i}.preCue.locs, trialProc{i}.angle,...
                                              trialProc{i}.stimLocsBOTH, trialProc{i}.postCueLocs,...
                                              cont, targetAngle, trialProc{i}.phase_offset,...
                                              trialProc{i}.targets.validity,trialProc{i}.angle,trialProc{i}.offsetDir);
                                          
        if breakFix.Block.check == 1
            beep3(237,157,.1,0);
            nTrialsUPDATE = nTrialsUPDATE + 1;
            breakFix.Block.count = breakFix.Block.count + 1;
            [trialProc, recal, breakFix.Block.recent, breakFix.Block.track]...
                                             = breakProc(trialProc, nTrials,...
                                                         i, j, breakFix.Block.count,...
                                                         breakFix.Block.track,...
                                                         breakFix.Block.recent);
        else    %Note: if there is no fixation break, the trial is not taken into account for stair casing
            results.Block.rt(i)      = respTrial.rt; results.Block.key(i)     = respTrial.key(1);
            results.Block.correct(i) = correctTrial;
            stair = PAL_AMPM_updatePM(stair,correctTrial);
            Screen('Close');
        end
        
        if recal; breakFix.Block.recalCount = breakFix.Block.recalCount + 1; recalProc(el, wPtr); end
    end
    
    if params.eye.run == 1
    Eyelink('Message', '~*~*~*~*BLOCK END*~*~*~*~');
    end
    dircB = sprintf('results/%s/%s/Block%d', params.saveVars.expTypeDirName,initials,b);
    blockFileName = sprintf('%s_%s_BlockData_Ses%d_Block%d.mat',...
                            params.saveVars.fileName, initials, sesNum, b);
    
    results.Ses{b}.rt = results.Block.rt; %Each row in each .mat w/in resultsSes is a separate block
    results.Ses{b}.key = results.Block.key; results.Ses{b}.correct = results.Block.correct;
    
    breakFix.Ses{b}.count = breakFix.Block.count; breakFix.Ses{b}.track = breakFix.Block.track;
    breakFix.Ses{b}.check = breakFix.Block.check; breakFix.Ses{b}.recent = breakFix.Block.recent;
    breakFix.Ses{b}.recalCount = breakFix.Block.recalCount;
    
    correctProp = 0;
    for tt = 1:nTrials
        if results.Block.correct(tt) == 1, correctProp = correctProp+1; end
    end
    correctPercent = 100*(correctProp/nTrials);
    blockBreak(wPtr, b, correctPercent);
    
    
    
    expData{b}.procedure = trialProc;
    expData{b}.accuracy = correctPercent;
    sesStair{b} = stair;
    save(blockFileName, 'expData', 'results','sesNum', 'params', 'breakFix', 'sesStair');
    if params.eye.run, Eyelink('StopRecording'); Eyelink('Message', sprintf('Block # %d Complete', b));end
    
    
    
    
    
    Screen('Close');
end
expEndDisp(wPtr);



sesStair = struct('stair', {sesStair}, 'StimNumOnBlock', {params.blockVars.StimNumOnBlock});


%%%%%------------- Save all experiment data ----------%%%%%
c = clock;
homedir = pwd; 
dirc = sprintf('results/%s',initials);
mkdir(dirc); cd(dirc)
if params.eye.run; Eyelink('ReceiveFile', ELfileName, dirc,1); Eyelink('CloseFile'); Eyelink('Shutdown'); end
Screen('Close');
date = sprintf('Date:%02d/%02d/%4d  Time:%02d:%02d:%02i ', c(2),c(3),c(1),c(4),c(5),ceil(c(6)));
saveExpFile = sprintf('%s_results_%s_ses%d_%02d_%02d_%4d_time_%02d_%02d_%02i.mat',...
                      params.saveVars.fileName, initials, sesNum,...
                      c(2),c(3),c(1),c(4),c(5),ceil(c(6)));
               
save(saveExpFile ,'expData', 'results','sesNum', 'params', 'date', 'sesStair', 'breakFix');

cd(homedir);
%%%%%--------------------------------------------------%%%%%

%delete('tmpData.mat');
Screen('LoadNormalizedGammaTable',params.screenVar.num,startclut,[]);
Screen('CloseAll');
disp('Done!');



