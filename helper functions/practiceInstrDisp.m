function practiceInstrDisp(wPtr)
% practiceInstDisp(wPtr)
%
%
% Ian Donovan
%  March 2013
global params;


phase_offset = 2*pi*rand;

%Compute grating
grating = genGrating(params.stim.sizePix*3, params.stim.cyclesPerImage, phase_offset);
mask = My2DGauss_nonSym(params.stim.sizePix*3,0,2);
gabor = grating.*mask;
    

locations1 = [(params.screenVar.centerPix(1) - 225);...
              (params.screenVar.centerPix(2) + 100)];
locations2 = [(params.screenVar.centerPix(1) + 175);...
              (params.screenVar.centerPix(2) + 100)];


texture = params.stim.bkColor + 128*(.8).*gabor;
    
%display grating
rect1 =  CenterRectOnPoint(params.stim.rectPix, locations1(1), locations1(2));%rect of stimulus, to be centered at location
rect2 =  CenterRectOnPoint(params.stim.rectPix, locations2(1), locations2(2));
textureIndex=Screen('MakeTexture', wPtr, texture); 
Screen('DrawTexture', wPtr, textureIndex, [], rect1, params.stim.possibleAngles(1));
Screen('DrawTexture', wPtr, textureIndex, [], rect2, params.stim.possibleAngles(2));


instruct = 'Is the stimulus tilted more counter-clockwise or more clockwise, relative to 45 degrees?';
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

keyIsDown = 0;
while (~keyIsDown)
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('Space')),  keyIsDown = 1; break; else keyIsDown =0;  end
end




end
