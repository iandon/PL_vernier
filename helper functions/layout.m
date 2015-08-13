function PLexp()
    global_defs; global numTrials, precentValid, percentRespCue, stimLocation; 
    screenParameters()
    trialsParameters = calculateTrialParams(numTrials, percentValid,percentRespCue, stimLocation); 
    for i = 1:numTrials
        [resp, correct] = trial(trialsParameters(i), respCueType, preCueLocation, stimLocation)
        outputData(resp, correct,typeRespCue, cueLocation)
    end
end

function [resp, correct] = trial(typeRespCue, cueLocation)
    preCue(type, cueLocation)
    presentStimuli(stimLocation)
    resp = responseCue(typeRespCue)
    correct = checkResp(resp)
    end

function preCue(type)
    if type ==1 %endogenous 
    end

    if type ==2 %exogenous
    end   

end

function presentStimuli(stimLocation)

end

function responseCue()
end

function checkResp()
end

function outputData(resp, correct,typeRespCue, cueLocation)
%this function will write the data of the subject to a file
end

