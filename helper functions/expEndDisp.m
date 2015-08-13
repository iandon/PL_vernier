function expEndDisp(wPtr)
global params;

instruct = 'Experiment ended. Thank you for your participation!';
Screen('TextSize', wPtr, params.textVars.size);

Screen('DrawText', wPtr, instruct, params.screenVar.centerPix(1)-270, params.screenVar.centerPix(2)-150, [0 0 0]);
Screen('Flip', wPtr);

WaitSecs(2);
end