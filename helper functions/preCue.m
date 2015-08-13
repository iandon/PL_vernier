function preCue(wPtr, cueLocation)
global params;

switch params.preCue.type 
    
    case 0 % Type is neutral
        rect1 = CenterRectOnPointd(params.neutralCue.rectPix, params.neutralCue.locationsPix1(1),params.neutralCue.locationsPix1(2));
        rect2 = CenterRectOnPointd(params.neutralCue.rectPix, params.neutralCue.locationsPix2(1), params.neutralCue.locationsPix2(2));
        rect = [rect1', rect2'];
        Screen('FillRect', wPtr ,params.neutralCue.color, rect);
    case 1, % Type is exogenous
        rect = CenterRectOnPointd(params.preCueExg.rectPix, cueLocation(1,1),cueLocation(1,2));
        Screen('FillRect', wPtr ,params.preCueExg.color, rect);
    
    otherwise 
        error('Set type of pre cue - neutral 0, exogenous 1');
end

end

