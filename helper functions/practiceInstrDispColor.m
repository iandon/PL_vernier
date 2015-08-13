function practiceInstrDispColor(wPtr)
% practiceInstDisp(wPtr)
%
%
% Ian Donovan
%  March 2013
global params;

%Compute grating

locations1 = [(params.screenVar.centerPix(1) - 225);...
              (params.screenVar.centerPix(2) + 100)];
locations2 = [(params.screenVar.centerPix(1) + 175);...
              (params.screenVar.centerPix(2) + 100)];


%display grating
rect1 =  CenterRectOnPoint(params.stim.rectPix, locations1(1), locations1(2));%rect of stimulus, to be centered at location
rect2 =  CenterRectOnPoint(params.stim.rectPix, locations2(1), locations2(2)); 
Screen('FrameOval', wPtr, params.stim.color(1,:), rect1, 3, 3);
Screen('FrameOval', wPtr, params.stim.color(2,:), rect2, 3, 3);

instruct = 'Was the circle RED or BLUE?';
keys = sprintf('Press ''%s'' for RED or ''%s'' for BLUE. ', params.responseVar.allowedRespKeys(1), params.responseVar.allowedRespKeys(2));
start = 'Press space to start!';

Screen('TextSize', wPtr, params.textVars.size);
Screen('TextColor', wPtr, params.textVars.color);
Screen('TextBackgroundColor',wPtr, params.textVars.bkColor );
%DrawFormattedText(wPtr, instruct, 'center', 'center', 1, []);

Screen('DrawText', wPtr, instruct, params.screenVar.centerPix(1)-175, params.screenVar.centerPix(2)-150);
Screen('DrawText', wPtr, keys, params.screenVar.centerPix(1)-220, params.screenVar.centerPix(2));
Screen('DrawText', wPtr, start, params.screenVar.centerPix(1)-150, params.screenVar.centerPix(2)+150);

Screen('Flip', wPtr);

keyIsDown = 0;
while (~keyIsDown)
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('Space')),  keyIsDown = 1; break; else keyIsDown =0;  end
end




end
