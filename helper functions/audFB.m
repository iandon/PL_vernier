function audFB(correctTrial)
global params;


if correctTrial == 1
    %beep2(params.fbVars.high,params.fbVars.dur, 1)
elseif correctTrial == 0
    beep2(params.fbVars.low,params.fbVars.dur, 0)
elseif correctTrial == 2
    beep2(params.fbVars.high,params.fbVars.durNoResp, 1)
end