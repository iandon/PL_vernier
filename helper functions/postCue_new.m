function postCue_new(wPtr, targetLocation, stimLocNum)
global params;

% cuedLocation is the location of the stimulus that is cued. The post cue line will be from the 
% center of the screen (postCueVar.center, can be updated in the defs to
% the cued location. The length of the line is defined by the defs postCueVar.size.


% % %total distance, from center to location of cued stimuli
% % distance = sqrt((params.screenVar.centerPix(1)-targetLocation(1))^2 ...
% %                 + (params.screenVar.centerPix(2)-targetLocation(2))^2); 
% % 
% % prop = params.postCueVar.length;
% % 
% % % postCuex2 = [prop*x1 + (1-prop)*targetLocation(1)];
% % % postCuey2 = [prop*y1 + (1-prop)*targetLocation(2)];
% % 
% % %To DO: with new subjects use correct version below:
% % 
% % if stimLocNum == 1
% % postCuex2 = [(1-prop)*x1 - (prop)*targetLocation(1)];
% % postCuey2 = [(1-prop)*y1 - (prop)*targetLocation(2)];
% % elseif stimLocNum == 2
% % postCuex2 = [(1-prop)*x1 + (prop)*targetLocation(1)];
% % postCuey2 = [(1-prop)*y1 - (prop)*targetLocation(2)];
% % elseif stimLocNum == 3
% % postCuex2 = [(1-prop)*x1 - (prop)*targetLocation(1)];
% % postCuey2 = [(1-prop)*y1 + (prop)*targetLocation(2)];
% % elseif stimLocNum == 4
% % postCuex2 = [(1-prop)*x1 + (prop)*targetLocation(1)];
% % postCuey2 = [(1-prop)*y1 + (prop)*targetLocation(2)];
% % end


x1 = params.postCueVar.centerPix(stimLocNum, 1);
y1 = params.postCueVar.centerPix(stimLocNum, 2);

x2 = params.postCueVar.endPix(stimLocNum,1);
y2 = params.postCueVar.endPix(stimLocNum,2);


Screen('DrawLine',wPtr, params.postCueVar.color, x1, y1, x2, y2, params.postCueVar.penWidthPix);


% BELOW: if you want to check the distance from the center to the center o
% of the postcue
% % 
% % frameVect = [params.postCueVar.centerPix(1,1),params.postCueVar.centerPix(2,2), ...
% %              params.postCueVar.centerPix(2,1),params.postCueVar.centerPix(3,2)];
% % Screen('FrameRect', wPtr, [255,255,255],frameVect,1);
% % 
% % 
% % 
% % 
% % xHR = params.screenVar.centerPix(1)+ params.fixationVar.sizeCrossPix(1);
% %         xHL = params.screenVar.centerPix(1)- params.fixationVar.sizeCrossPix(1);
% % 
% % 
% %         yVU = params.screenVar.centerPix(2)- params.fixationVar.sizeCrossPix(2);
% %         yVD = params.screenVar.centerPix(2)+ params.fixationVar.sizeCrossPix(2);
% % 
% %         
% %         
% % Screen('FrameOval', wPtr, [255, 255, 255], [xHL,yVU, xHR, yVD], 1, 1);