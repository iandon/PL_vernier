function [] = recalProc(el, wPtr)
%global params


 
% recalMSG = sprintf('Eyetracker is being recalibrated');
% buttonMSG = sprintf('Press SPACE to begin');
% 
% Screen('DrawText', wPtr, recalMSG, params.screenVar.centerPix(1)-270, params.screenVar.centerPix(2)-200,[0 0 0]);
% Screen('DrawText', wPtr, buttonMSG, params.screenVar.centerPix(1)-270, params.screenVar.centerPix(2)+100,[0 0 0]);
% Screen('Flip', wPtr);
% WaitSecs(params.eye.recalHoldDur);

% recal = ...

Eyelink('Message', 'RECALIBRATE OBSERVER')
EyelinkDoTrackerSetup(el, 'c');

doneRecalMSG = sprintf('Recalibration complete!')



end
