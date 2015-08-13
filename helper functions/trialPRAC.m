function [correctTrial, resp, fixBreak] = trialPRAC(wPtr, blockNum, trialNum, stimLocNum, cueLocation, trialAngles, stimLocations, postCueLocation, constrast, targetAngle, phase_offset)
global params; 

fixBreak = 0;

if params.preCue.type; preCueTime = params.preCueExg.dur; else preCueTime = params.neutralCue.dur; end
cumulativeDur = struct('fixation', (params.fixationVar.dur),...
    'preCue', (params.fixationVar.dur + preCueTime),...
    'ISIpre', (params.fixationVar.dur + preCueTime + params.ISIVar.preDur),...
    'stim', (params.fixationVar.dur + preCueTime + params.ISIVar.preDur + params.stim.dur),...
    'ISIpost', (params.fixationVar.dur + preCueTime + params.ISIVar.preDur + params.stim.dur + params.ISIVar.postDur),...
    'total', (params.fixationVar.dur + preCueTime + params.ISIVar.preDur + params.stim.dur + params.ISIVar.postDur + params.postCueVar.dur));

pressQ = 0;
[keyIsDown, secs, keyCode] = KbCheck;
fixation(wPtr); Screen('Flip', wPtr); WaitSecs(.300);


if params.eye.run
    Eyelink('StartRecording');
    Eyelink('Message', sprintf('StartTrial'));
end


if params.eye.run
    fixBreakPRE = 1; FirstFixClock = tic;
    keyIsDown = 0;
    while fixBreakPRE && ~pressQ
        tsFirstFix = toc(FirstFixClock); [fixBreakPRE] = fixCheck; fixation(wPtr);
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown == 1; pressQ = keyCode(KbName('Q')); end
        if tsFirstFix > .02
            fixation(wPtr, 0)
            %Screen('TextSize', wPtr, (params.textVars.size*(2/3)));
            %Screen('DrawText', wPtr, fixBreakObsvMSG, params.screenVar.centerPix(1)-90, params.screenVar.centerPix(2)-50,[0 0 0]);
        end
        Screen('Flip', wPtr);
        if tsFirstFix > 2
            fixBreak = 1; correctTrial = []; resp = []; timestamp = [];
            Eyelink('Message', sprintf('DID NOT FIXATE BEFORE TRIAL'));
            clear FirstFixClock tsFirstFix;
            return;
        end
        [fixBreakPRE] = fixCheck;
    end
end


trialStart = tic;
ts = 0;
if params.eye.run, [fixBreak] = fixCheck; end
while ~fixBreak && (ts < cumulativeDur.total) && ~pressQ
    ts = toc(trialStart);
    [keyIsDown, secs, keyCode] = KbCheck; pressQ = keyCode(KbName('Q'));
    if ts < cumulativeDur.fixation
        fixation(wPtr); Screen('Flip', wPtr);
        timestamp.fixation = ts;
    elseif ts < cumulativeDur.preCue
        fixation(wPtr); preCue(wPtr, cueLocation); Screen('Flip', wPtr);
        timestamp.preCue = ts;
    elseif ts < cumulativeDur.ISIpre
        fixation(wPtr); Screen('Flip', wPtr);
        timestamp.ISIpre = ts;
    elseif ts < cumulativeDur.stim
        presentStimuli(wPtr, trialAngles, stimLocations, constrast, phase_offset);
        fixation(wPtr); Screen('Flip', wPtr);
        timestamp.stim = ts;
    elseif ts < cumulativeDur.ISIpost
        fixation(wPtr); Screen('Flip', wPtr);
        timestamp.ISIpost = ts;
    elseif ts < cumulativeDur.total %postCue -> last phase on which we care about fixation
        postCue_new(wPtr, postCueLocation, stimLocNum); fixation(wPtr); Screen('Flip', wPtr);
        timestamp.postCue = ts;
    end
     if params.eye.run, [fixBreak] = fixCheck; end
end
if params.eye.run && ~fixBreak, Eyelink('Message', sprintf('Fixation Check Window Closed')); end

if params.eye.run
    Eyelink('StopRecording');
end

if pressQ
    Screen('CloseAll'); Eyelink('StopRecording'); error('Experiment stopped by user!');
end

if fixBreak
    Eyelink('Message', sprintf('TRIAL INCOMPLETE'));
    timestamp = []; resp = []; correctTrial = []; fixation(wPtr); tsBrkMsg = 0; BrkTime = tic; rng = -5:0.2:5;
    while tsBrkMsg < params.eye.breakWaitDur;
        tsBrkMsg = toc(BrkTime); %shadeX = rng(ceil(tsBrkMsg*100));
        %txtShade = params.screenVar.bkColor - ((params.screenVar.bkColor*(10/4))*normpdf(shadeX,0,1));
        %Screen('TextSize', wPtr, (params.textVars.size*(2/3)));
        %Screen('DrawText', wPtr, fixBreakObsvMSG, params.screenVar.centerPix(1)-90, params.screenVar.centerPix(2)-50,[txtShade txtShade txtShade]);
        fixation(wPtr, 0); Screen('Flip', wPtr);
    end
    clear BrkTime
else
    
    if params.eye.run, Eyelink('Message', sprintf('Post Cue OFF')); end
    fixation(wPtr); Screen('Flip', wPtr); resp = response;
    correctTrial = checkResp(resp, targetAngle); audFB(correctTrial);
    timestamp.resp = ts;
end



clear trialStart
end
