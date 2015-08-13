%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      screen params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screenVar = struct('num', {1}, 'rectPix',{[0 0  1280 960]}, 'dist', {58},...
                   'size', {[36.2,26.6]}, 'res', {[1280 960]},...
                   'calib_filename', {'0001_titchener_130226.mat'}); 
screenVar.centerPix = [(screenVar.rectPix(3)/2), (screenVar.rectPix(4)/2)];
    % In a new screen, run:
     %test = Screen('OpenWindow', screenVar.num, [], [0 0 1 1]); 
     %white = WhiteIndex(test);
     %black = BlackIndex(test);
     %Screen('Resolutions')
     %Screen('CloseAll');
white = 255; black = 0;
gray = (white+black)/2;
screenVar.bkColor = gray ; screenVar.black = black; screenVar.white = white;

%Compute deg to pixels ratio:
ratio = degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, [1 1]);
ratioX = ratio(1); screenVar.ratioX = ratio(1); 
ratioY = ratio(2); screenVar.ratioY = ratio(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      stimuli params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stim = struct('sizeDeg', {[1 1]}, 'cyclesPerImage', {8}, 'dur', {.2},...
              'num', {2},'XdistDeg',{0}, 'YdistDeg', {0},...
              'radiusDeg', {5},'polarAng', {45},'bkColor', {screenVar.bkColor},...
              'trainLoc', {1}, 'orderType',{'A'}, 'baseAngle',0,... %MOST IMPORTANT to change per observer/session type
              'pilot', {0},'separationDeg',{1});

stim.contrast = .64; 

stim.XdistDeg = stim.radiusDeg*cosd(stim.polarAng);
stim.YdistDeg = stim.radiusDeg*sind(stim.polarAng);

stim.XdistPix = deg2pix1Dim(stim.XdistDeg, ratioX); 
stim.YdistPix = deg2pix1Dim(stim.YdistDeg, ratioY);

switch stim.baseAngle
    case 0
        stim.vertSeparationPix = deg2pix1Dim(stim.separationDeg, ratioY);
    case 90
        stim.horizSeparationPix = deg2pix1Dim(stim.separationDeg, ratioX);
end

stim.radiusPix = deg2pix1Dim(stim.radiusDeg, ratioX);

stim.sizePix = floor(degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, stim.sizeDeg)); %{[100 100]}

rc1 = degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, stim.sizeDeg); 
stim.rectPix =[0, 0, rc1]; 

% Define locations of stimuli in pixels
stimlocation.TL = nan(1,2); stimlocation.TR = nan(1,2); stimlocation.BL = nan(1,2); stimlocation.BR = nan(1,2); 
stimlocation.TL(1) = (screenVar.centerPix(1) - stim.XdistPix); stimlocation.TL(2) = (screenVar.centerPix(2) - stim.YdistPix);
stimlocation.TR(1) = (screenVar.centerPix(1) + stim.XdistPix); stimlocation.TR(2) = (screenVar.centerPix(2) - stim.YdistPix);
stimlocation.BL(1) = (screenVar.centerPix(1) - stim.XdistPix); stimlocation.BL(2) = (screenVar.centerPix(2) + stim.YdistPix);
stimlocation.BR(1) = (screenVar.centerPix(1) + stim.XdistPix); stimlocation.BR(2) = (screenVar.centerPix(2) + stim.YdistPix);

stim.locationsPix = [stimlocation.TL; stimlocation.TR; stimlocation.BL; stimlocation.BR]; %define all locations of stimuli in an array


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            fixation params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw fixation cross, sizeCross is the cross size,
% and sizeRect is the size of the rect surronding the cross
fixationVar = struct( 'color',{white},'dur', {.3}, 'penWidthPix', {2}, 'bkColor', screenVar.bkColor,...
                      'sizeCrossDeg', {[0.4 0.4]}, 'respColorVect', [0, 255, 0]);
                  
fixationVar.sizeCrossPix = degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, fixationVar.sizeCrossDeg); % {15}
fixationVar.rectPix = [0 0 fixationVar.sizeCrossPix(1) fixationVar.sizeCrossPix(2)];
fixationVar.rectPix = CenterRectOnPoint(fixationVar.rectPix, screenVar.centerPix(1), screenVar.centerPix(2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Pre Cue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The experiment is set to either be valid (type 1) or neutral (type 0)
preCue = struct('type', {1}); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Exogenous precue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preCueExg = struct('rectDeg', {[0.4 0.1]}, 'color',{black}, 'bkColor', {screenVar.bkColor}, ...
                   'dur', {.06}, 'penWidthPix', {1}, 'dist2stimDeg',{2.55}, 'validity', {1.0}); 
sp1 = deg2pix1Dim(preCueExg.rectDeg(1), ratioX); sp2 = deg2pix1Dim(preCueExg.rectDeg(2), ratioY); 
preCueExg.rectPix = [0 0 sp1 sp2];

preCueExg.dist2stimPix = deg2pix1Dim(preCueExg.dist2stimDeg, ratioY);


preCueExg.YdistPix = preCueExg.dist2stimPix + stim.YdistPix;

preCueExglocation.TL = nan(1,2); preCueExglocation.TR = nan(1,2); preCueExglocation.BL = nan(1,2); preCueExglocation.BR = nan(1,2);
preCueExglocation.TL(1) = screenVar.centerPix(1) - stim.XdistPix; preCueExglocation.TL(2) = (screenVar.centerPix(2) - preCueExg.YdistPix);
preCueExglocation.TR(1) = screenVar.centerPix(1) + stim.XdistPix; preCueExglocation.TR(2) = (screenVar.centerPix(2) - preCueExg.YdistPix);
preCueExglocation.BL(1) = screenVar.centerPix(1) - stim.XdistPix; preCueExglocation.BL(2) = (screenVar.centerPix(2) + preCueExg.YdistPix);
preCueExglocation.BR(1) = screenVar.centerPix(1) + stim.XdistPix; preCueExglocation.BR(2) = (screenVar.centerPix(2) + preCueExg.YdistPix);

preCueExg.locationsPix = nan(4,2);
preCueExg.locationsPix = [preCueExglocation.TL(1), preCueExglocation.TL(2); 
                          preCueExglocation.TR(1), preCueExglocation.TR(2);
                          preCueExglocation.BL(1), preCueExglocation.BL(2);
                          preCueExglocation.BR(1), preCueExglocation.BR(2)];



%preCueExg.radiusPix = deg2pix1Dim(preCueExg.radiusDeg, ratioX); %ignore y ratio resolution TD

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Neutral precue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neutralCue = struct('rectDeg', {[0.2, 0.1]}, 'color',{black}, 'bkColor', {screenVar.bkColor}, ...
                   'dur', {0.06}, 'penWidthPix', {1}, 'dist2centerDeg', {0.9}); 
sp1 = deg2pix1Dim(neutralCue.rectDeg(1), ratioX); sp2 = deg2pix1Dim(neutralCue.rectDeg(2), ratioY); 


neutralCue.dist2centerPix = deg2pix1Dim(neutralCue.dist2centerDeg, ratioY);

neutralCue.locationsPix1 = [screenVar.centerPix(1), (screenVar.centerPix(2) - neutralCue.dist2centerPix)];
neutralCue.locationsPix2 = [screenVar.centerPix(1), (screenVar.centerPix(2) + neutralCue.dist2centerPix)];

neutralCue.rectPix = [0 0 sp1 sp2];
% 
% neutralCue.rectPix1 = CenterRectOnPoint([0 0 sp1 sp2], neutralCue.locationsPix1(1),neutralCue.locationsPix1(2));
% neutralCue.rectPix2 = CenterRectOnPoint([0 0 sp1 sp2], neutralCue.locationsPix2(1),neutralCue.locationsPix2(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     ISI params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ISIVar = struct('preDur',{0.04}, 'postDur', {0.3}); 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%     box params
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% box = struct('sizePixels', {30}, 'color',{white}, 'slopeVpix', {300}, 'slopeHpix',{150},...
%              'bkColor', {screenVar.bkColor}, 'dur', {2}, 'penWidthPix', {5}); 
% box.locationsPix = stim.locationsPix;
% box.rectPix = CenterRectOnPoint([0 0 box.slopeHpix box.slopeVpix], stim.locationsPix(1,1), stim.locationsPix(1,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     post cue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
postCueVar = struct('color',{black},'bkColor', {screenVar.bkColor}, 'dur', {.3}, 'penWidthPix', {1.5},...
                    'lengthDeg', {.75}, 'radiusDeg', {.65}); %, 'centerPix', {screenVar.centerPix});
%NOTE: length is proportional to distance of the stimulus (1.0)


postCueVar.centerXdistDeg = postCueVar.radiusDeg*cosd(stim.polarAng);
postCueVar.centerYdistDeg = postCueVar.radiusDeg*sind(stim.polarAng);

postCueVar.centerXdistPix = deg2pix1Dim(postCueVar.centerXdistDeg, ratioX);
postCueVar.centerYdistPix = deg2pix1Dim(postCueVar.centerYdistDeg, ratioY);

postCuelocCenter.TL = nan(1,2); postCuelocCenter.TR = nan(1,2); postCuelocCenter.BL = nan(1,2); postCuelocCenter.BR = nan(1,2);
postCuelocCenter.TL(1) = (screenVar.centerPix(1) - postCueVar.centerXdistPix); postCuelocCenter.TL(2) = (screenVar.centerPix(2) - postCueVar.centerYdistPix);
postCuelocCenter.TR(1) = (screenVar.centerPix(1) + postCueVar.centerXdistPix); postCuelocCenter.TR(2) = (screenVar.centerPix(2) - postCueVar.centerYdistPix);
postCuelocCenter.BL(1) = (screenVar.centerPix(1) - postCueVar.centerXdistPix); postCuelocCenter.BL(2) = (screenVar.centerPix(2) + postCueVar.centerYdistPix);
postCuelocCenter.BR(1) = (screenVar.centerPix(1) + postCueVar.centerXdistPix); postCuelocCenter.BR(2) = (screenVar.centerPix(2) + postCueVar.centerYdistPix);

postCueVar.centerPix = [postCuelocCenter.TL; 
                        postCuelocCenter.TR; 
                        postCuelocCenter.BL; 
                        postCuelocCenter.BR];
                    
                    
                    
postCueVar.endXDeg = postCueVar.lengthDeg*cosd(stim.polarAng);
postCueVar.endYDeg = postCueVar.lengthDeg*sind(stim.polarAng);

postCueVar.endXPix = deg2pix1Dim(postCueVar.endXDeg,ratioX);
postCueVar.endYPix = deg2pix1Dim(postCueVar.endYDeg,ratioY);

postCuelocEnd.TL = nan(1,2); postCuelocEnd.TR = nan(1,2); postCuelocEnd.BL = nan(1,2); postCuelocEnd.BR = nan(1,2);
postCuelocEnd.TL(1) = (postCueVar.centerPix(1,1) - postCueVar.endXPix); postCuelocEnd.TL(2) = (postCueVar.centerPix(1,2) - postCueVar.endYPix);
postCuelocEnd.TR(1) = (postCueVar.centerPix(2,1) + postCueVar.endXPix); postCuelocEnd.TR(2) = (postCueVar.centerPix(2,2) - postCueVar.endYPix);
postCuelocEnd.BL(1) = (postCueVar.centerPix(3,1) - postCueVar.endXPix); postCuelocEnd.BL(2) = (postCueVar.centerPix(3,2) + postCueVar.endYPix);
postCuelocEnd.BR(1) = (postCueVar.centerPix(4,1) + postCueVar.endXPix); postCuelocEnd.BR(2) = (postCueVar.centerPix(4,2) + postCueVar.endYPix);

postCueVar.endPix = nan(4,2);
postCueVar.endPix = [postCuelocEnd.TL; 
                     postCuelocEnd.TR; 
                     postCuelocEnd.BL; 
                     postCuelocEnd.BR];
                
                    
                    
%postCueVar.sizePix = deg2pix(postCueVar.sizeDeg, ratioX); % considers degrees only in x axis


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     response params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KbName('UnifyKeyNames');
responseVar = struct( 'allowedRespKeys', {['1', '2']},'allowedRespKeysCodes',{[0 0]}, 'dur',{1.2}, 'cueTone', {500}); 
for i = 1:length(responseVar.allowedRespKeys)
    responseVar.allowedRespKeysCodes(i) = KbName(responseVar.allowedRespKeys(i));
end
% Note that the correctness of the resp will be computed according to the
% index in the array of resp so that allowedRespKeys(i) is the correct
% response of stim.possibleAngles(i)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Trial params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trialVars = struct('numTrialsInBlock', {50});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Feedback params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fbVars = struct('dur', {0.1}, 'durNoResp', {.4}, 'high', {300}, 'low', {150}); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Block params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
blockVars = struct('numBlocks', 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Stair params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% startCont1 = log10(50); startCont2 = log10(30);
% 
% stairVars = struct('run', {1}, 'numTrialsPerStaircase', {60}, 'numStaircases', {2},...
%                    'startContrast', {[startCont1, startCont2]}, 'maxThresh', {2}, 'minThresh', {log10(.05)},...
%                    'startStepsize', {.4},'minStepsize', {10^-3});



stimValsRangeREAL = [.0001,.5];
stimValsRangeSTAIR = [stimValsRangeREAL(1)/stimValsRangeREAL(2),1];
numStimVals = 200;
numAlphaRange = 100;


priorAlphaRange = log10(logspace(stimValsRangeSTAIR(1),stimValsRangeSTAIR(2),numAlphaRange));
priorBetaRange = 0:10;
priorLambdaRange = 0:.01:.1;
gamma = .5;


stairVars = struct('stimMinMax',stimValsRangeREAL,'stimRangeSTAIR',priorAlphaRange,'stimRangeDisplay',stimValsRangeREAL,...
                   'priorAlphaRange',priorAlphaRange,...
                   'priorBetaRange',priorBetaRange,...
                   'gamma',gamma,'lambda',priorLambdaRange,...
                   'PF',@PAL_CumulativeNormal,'marginalize',[4,2],...
                   'AvoidConsecutive',1,'WaitTime',4);

%PAL_CumulativeNormal & PAL_Weibull
       
               
               
               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Eye Tracking params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eye = struct('run', {0}, 'fixRangeDeg', {2}, 'eyeTracked', {2}, 'recalHoldDur', {1},...
             'breakWaitDur', {.5});
         
eye.dots.color = (.25*white);

eye.fixRangePix = degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, eye.fixRangeDeg);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     Text params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textVars = struct('color', black, 'bkColor', gray, 'size', 24);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Save Data params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%_
saveVars = struct('fileName', {'PLexoHem'}, 'expTypeDirName', {'1loc_psi_Vernier'}, 'SubjectInitials', {'IMD'});


%-------------------------------------------------------------------------%
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%                        TOTAL ALL params                                 %
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%-------------------------------------------------------------------------%
global params;
params = struct('screenVar', screenVar, 'stim', stim, 'fixationVar', fixationVar, 'preCueExg', preCueExg, ...
                'postCueVar', postCueVar, 'responseVar', responseVar, 'trialVars', trialVars,...
                'blockVars', blockVars, 'fbVars', fbVars, 'ISIVar', ISIVar, 'neutralCue', neutralCue,...
                'textVars', textVars,'preCue', preCue, 'saveVars', saveVars, 'stairVars', stairVars, 'eye', eye); 

clear white gray black locationL locationR screenVar stim fixationVar preCueExg box postCueVar responseVar ;
clear trialVars i blockVars fbVars ratio ratioX ratioY sp1 sp2 rc1 ISIVar sqslope hfslp neutralCue;
clear eye stairVars preCueExglocation stimlocation saveVars textVars preCue postCuelocation
