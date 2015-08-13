function instructions(wPtr)
global params;

switch params.stim.baseAngle
    case 0
        instruct = 'Is the bottom stimulus more LEFT or RIGHT relative to the upper stimulus?';
        keys = sprintf('Press ''%s'' for LEFT or ''%s'' for RIGHT. ', params.responseVar.allowedRespKeys(1), params.responseVar.allowedRespKeys(2));
    case 90
        instruct = 'Is the right stimulus more UP or DOWN relative to the left stimulus?';
        keys = sprintf('Press ''%s'' for UP or ''%s'' for DOWN. ', params.responseVar.allowedRespKeys(1), params.responseVar.allowedRespKeys(2));
end
keys = sprintf('Press ''%s'' for counter-clockwise tilt or ''%s'' for clockwise tilt. ', params.responseVar.allowedRespKeys(1), params.responseVar.allowedRespKeys(2));
start = 'Press space to start!';

Screen('TextSize', wPtr, params.textVars.size);
Screen('TextColor', wPtr, params.textVars.color);
Screen('TextBackgroundColor',wPtr, params.textVars.bkColor );
%DrawFormattedText(wPtr, instruct, 'center', 'center', 1, []);

Screen('DrawText', wPtr, instruct, params.screenVar.centerPix(1)-500, params.screenVar.centerPix(2)-150);
Screen('DrawText', wPtr, keys, params.screenVar.centerPix(1)-350, params.screenVar.centerPix(2));
Screen('DrawText', wPtr, start, params.screenVar.centerPix(1)-150, params.screenVar.centerPix(2)+150);

Screen('Flip', wPtr);

[keyIsDown,secs,keyCode] = KbCheck;  WaitSecs(3);
clear keyIsDown secs keyCode


keyIsDown = 0;
while (~keyIsDown)
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('Space')),  keyIsDown = 1; break; else keyIsDown =0;  end
end

