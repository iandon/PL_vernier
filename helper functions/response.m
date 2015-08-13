function resp = response
global params; 
resp = struct('rt', 0, 'key', 0, 'check', 0);
KbName('UnifyKeyNames');

beep2(params.responseVar.cueTone,params.fbVars.dur, 1)


keyIsDown = 0;
keyChck = 0;
secs1 = GetSecs;
t = 0; tic;
while ~keyChck && (t < params.responseVar.dur)
    [keyIsDown,secs2,keyCode] = KbCheck;
    if keyIsDown == 1
        %check if key pressed was allowed one and if so end the trial
        if sum(find(keyCode)== params.responseVar.allowedRespKeysCodes),
            keyChck = 1;
            resp.key = find(keyCode);
            resp.rt = secs2-secs1;
            resp.check = 1;
            break;
        else
            if keyCode(KbName('Q')),  Screen('CloseAll'); error('Experiment stopped by user!'); end
        end
    end
    t=toc;
end


end
