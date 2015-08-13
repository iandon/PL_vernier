function halfwayBreak(wPtr,b)
global params;


halfwayMsg = sprintf('You are halfway through the block!', (b-1), params.blockVars.numBlocks);
getExpter = sprintf('Press space to continue with this block');

Screen('TextSize', wPtr, params.textVars.size);
Screen('TextColor', wPtr, params.textVars.color);
Screen('TextBackgroundColor',wPtr, params.textVars.bkColor );

Screen('DrawText', wPtr, halfwayMsg, params.screenVar.centerPix(1)-200, params.screenVar.centerPix(2)-150);
Screen('DrawText', wPtr, getExpter, params.screenVar.centerPix(1)-210, params.screenVar.centerPix(2)+150);

Screen('Flip', wPtr);

WaitSecs(2);

keyIsDown = 0;
while (~keyIsDown)
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('Space')),  keyIsDown = 7; break; else keyIsDown =0;  end
end

end