function blockBreak(wPtr, b, corrPerc)
global params;

correctPercent = num2str(corrPerc);

blockMsg = sprintf('Block number %d complete.', b);
accuracyMsg = sprintf('You responded with %s%% accuracy.', correctPercent);
pressSpace = sprintf('Press space to start the next block!');
Screen('TextSize', wPtr, params.textVars.size);

Screen('DrawText', wPtr, blockMsg, params.screenVar.centerPix(1)-270, params.screenVar.centerPix(2)-200,[0 0 0]);
Screen('DrawText', wPtr, accuracyMsg, params.screenVar.centerPix(1)-270, params.screenVar.centerPix(2)-50,[0 0 0]);
Screen('DrawText', wPtr, pressSpace, params.screenVar.centerPix(1)-270, params.screenVar.centerPix(2)+150,[0 0 0]);
Screen('Flip', wPtr);

keyIsDown = 0;
while (~keyIsDown)
    [keyIsDown,secs,keyCode] = KbCheck;
     if keyCode(KbName('Space')),  keyIsDown = 1; break; else keyIsDown =0;  end
   
end