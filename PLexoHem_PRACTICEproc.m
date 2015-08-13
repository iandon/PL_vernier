%PLexoHem_PRACTICEproc
clear all; addpath(genpath('mgl'));
PLexoHem_defs; global params;


params.practice.run = 1;
params.practice.nTrials = 20;
params.practice.nBlocks = 2;
params.practice.stair = 0;
params.eye.run = 0;

params.stim.possibleStimNums = [1, 4; 2, 3];

params.stim.possibleAngles = [176, 184];

params.stim.contrast = .32;

params.eye.run = 1;
params.preCue.type = 0;
 
params.stim.colorTest = 0;
params.stim.color = [255, 0, 0; 0, 0, 255];


nTrials = params.practice.nTrials;
numBlocks = params.practice.nBlocks;


wPtr = Screen('OpenWindow', params.screenVar.num, params.screenVar.bkColor, params.screenVar.rectPix);


numBlocks = params.practice.nBlocks;
nTrials = params.practice.nTrials;


StimNumOnBlockPRE = params.stim.possibleStimNums;
StimOnBlockORD = randperm(size(params.stim.possibleStimNums,1));
StimNumOnBlockPRE2 = StimNumOnBlockPRE(StimOnBlockORD, :);
numRep = numBlocks/size(params.stim.possibleStimNums,1);
if mod(numRep,1) ~= 0
    error('Number of Blocks must be a multiple of # of possible stimulus locations')
end

params.blockVars.StimNumOnBlock = repmat(StimNumOnBlockPRE2, [numRep,1]);

initials = 'TEST'; sesNum = 0;


if params.eye.run
    Eyelink('Initialize');
    el = prepEyelink(wPtr);
    ELfileName = sprintf('%s%d', initials, sesNum); edfFileStatus = Eyelink('OpenFile', ELfileName);
    if edfFileStatus ~= 0, fprintf('Cannot open .edf file. Exiting ...'); return; end
    cal = EyelinkDoTrackerSetup(el);
end

if params.stim.colorTest == 1, practiceInstrDispColor(wPtr);
else
    practiceInstrDisp(wPtr);end

for b = 1:numBlocks
    
    [trialProc] = calcTrialsVarsPRACreal(b);
    
    if params.practice.stair 
        stair = upDownStaircase(1,2, .6, .2, 'levitt');
        stair.minThreshold = .01; stair.maxThreshold = 1;
        stair.minStepsize = .005;
    end
    
                       
    clear breakFix.Block
    breakFix.Block = struct('check', {[]}, 'track', {[]}, 'count', {0}, 'recent', {0});
    breakFix.Block.count = 0; breakFix.Block.recent = 0; breakFix.Block.recalCount = 0;
    
    resultsBlockCorrect = nan(nTrials,1);
    
    j = 0; nTrialsUPDATE = nTrials;
    while j < nTrialsUPDATE
        j = j + 1;
        i = floor(j - breakFix.Block.count);
        recal = 0;
        trialProc{i}.cont = params.stim.contrast;
        if params.practice.stair
            cont = stair.threshold;
        else
            cont = trialProc{i}.cont;
        end
        breakFix.Block.check = 0;
        
        targetAngle = trialProc{i}.targets.angle;
        
        if params.stim.colorTest == 1
            [correctTrial, respTrial, breakFix.Block.check]...
                   = trialPRACcolor(wPtr, b, i, trialProc{i}.stimNum,...
                               trialProc{i}.preCue.locs, trialProc{i}.angleNum,...
                               trialProc{i}.stimLocs, trialProc{i}.postCueLocs,...
                               cont, trialProc{i}.angleNum, trialProc{i}.phase_offset);
        else
        [correctTrial, respTrial, breakFix.Block.check]...
            = trialPRAC(wPtr, b, i, trialProc{i}.stimNum,...
            trialProc{i}.preCue.locs, trialProc{i}.angles,...
            trialProc{i}.stimLocs, trialProc{i}.postCueLocs,...
            cont, targetAngle, trialProc{i}.phase_offset);
        end
        
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
            resultsBlockCorrect(i,:) = correctTrial;
            Screen('Close');
        end
        
        if recal; breakFix.Block.recalCount = breakFix.Block.recalCount + 1; recalProc(el, wPtr); end
        
        if params.practice.stair, stair = upDownStaircase(stair, correctTrial); end
        Screen('Close');
    end
    
    correctProp = 0;
    for i = 1:nTrials
        if resultsBlockCorrect(i,1) == 1
            correctProp = correctProp+1;
        end
    end
    correctPercent = 100*(correctProp/nTrials);
    blockBreak(wPtr, b, correctPercent);
    Screen('Close');
end

expEndDisp(wPtr);

Screen('CloseAll');
