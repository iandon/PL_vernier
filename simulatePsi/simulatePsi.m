%%
clear all

% noiseMean = 0;
% noiseSD = 1.5;
% 
% % signalMean = @ContrastFunction; 
% % 
% % signalDPmax = 5;
% % signalC50 = 5;
% % signalSlope = 20;
% % signalParams = [signalDPmax,signalSlope,signalC50];
% 
% 
% signalSD = 1.5;



numTrials = 50; % must be even

angle = [0,1];
angle = repmat(angle,[1,numTrials/2]);


%%


stimValsRange = [.1,15];
numStimVals = 100;
numAlphaRange = 100;
 
alphaREAL = .924235;
betaREAL = 4;


stimVals = linspace(stimValsRange(1),stimValsRange(2),numStimVals);
 
priorAlphaRange = linspace(stimValsRange(1),stimValsRange(2),numAlphaRange);
priorBetaRange = 0:.1:1;%0:20;
priorLambdaRange = 0:.01:.1;
gamma = .5;
lambda = .04123;

signalParamsREAL = [alphaREAL,betaREAL,gamma,lambda];


stairVars = struct('stimRange',stimVals,...
                   'priorAlphaRange',priorAlphaRange,...
                   'priorBetaRange',priorBetaRange,...
                   'gamma',gamma,'lambda',priorLambdaRange,...
                   'PF',@PAL_CumulativeNormal,'marginalize',[4, 2],'AvoidConsecutive',1,...
                   'WaitTime',4);

% PAL_Weibull
%



% stair = PAL_AMPM_setupPM('stimRange',stairVars.stimRange,...
%                            'priorAlphaRange',stairVars.priorAlphaRange,...
%                            'priorBetaRange', stairVars.priorBetaRange,...
%                            'gamma', stairVars.gamma,'lambda',stairVars.lambda,...
%                            'PF',stairVars.PF,'numTrials',numTrials,'marginalize',stairVars.marginalize);


                      

xCurve = linspace(0,stimValsRange(end)+1,1000);
figure(2),clf,hold on
plot(xCurve,stairVars.PF(signalParamsREAL,xCurve))
hold off




%%

numSim = 20;

for simNum = 1:numSim

stair{simNum} = PAL_AMPM_setupPM('stimRange',single(stairVars.stimRange),...
                           'priorAlphaRange',single(stairVars.priorAlphaRange),...
                           'priorBetaRange', single(stairVars.priorBetaRange),...
                           'gamma', single(stairVars.gamma),'lambda',single(stairVars.lambda),...
                           'PF',stairVars.PF,'numTrials',numTrials,'marginalize',stairVars.marginalize);
    
dpCurrent{simNum} = nan(numTrials,1);
internalSignal{simNum} = nan(numTrials,1);
resp{simNum} = zeros(numTrials,1);
correctTrial{simNum} = nan(numTrials,1);
curveYVal{simNum} = nan(numTrials,1);
suspend{simNum} = zeros(numTrials,1);
figure(1),clf
for trialNum = 1:numTrials
    
%     dpCurrent(trialNum) = ContrastFunction(signalParams,stair.xCurrent);
%     internalSignal(trialNum) = (dpCurrent(trialNum)*angle(trialNum))+randn;
    internalSignal{simNum}(trialNum) = rand;
    curveYVal{simNum}(trialNum) = stairVars.PF(signalParamsREAL,stair{simNum}.xCurrent);
    if internalSignal{simNum}(trialNum) < (curveYVal{simNum}(trialNum))
        resp{simNum}(trialNum) = angle(trialNum); %present
    else
        resp{simNum}(trialNum) = abs(angle(trialNum)-1); %absent
    end
    correctTrial{simNum}(trialNum) = resp{simNum}(trialNum)==angle(trialNum);
    
    
    if stair{simNum}.xCurrent == max(single(stair{simNum}.stimRange)) && stairVars.AvoidConsecutive
        suspend{simNum}(trialNum) = 1;
    end
    if suspend{simNum}(trialNum) == 1
        suspend{simNum}(trialNum) = rand(1) > 1./stairVars.WaitTime;
    end 
    
    
    stair{simNum} = PAL_AMPM_updatePM(stair{simNum},correctTrial{simNum}(trialNum),'fixLapse',suspend{simNum}(trialNum));
%     sprintf('Completed trial %d out of %d \n',trialNum,numTrials)
    
    
    
    figure(1),
    subplot(2,2,1), hold on
    plot([0,numTrials+1],[alphaREAL,alphaREAL],'k:')
    plot(stair{simNum}.threshold(1:trialNum))
%     plot(stair{simNum}.seThreshold(1:trialNum))
    axis([0,numTrials+1,priorAlphaRange(1)-1,priorAlphaRange(end)+1])
    title('Threshold')
    hold off
    
    subplot(2,2,2), hold on
    plot([0,numTrials+1],[betaREAL,betaREAL],'k:')
    plot(stair{simNum}.slope(1:trialNum))
    axis([0,numTrials+1,priorBetaRange(1)-1,priorBetaRange(end)+1])
    title('Slope')
    hold off
    
    subplot(2,2,3), hold on
    plot(stair{simNum}.x(1:trialNum))
    axis([0,numTrials+1,stimVals(1)-1,stimVals(end)+1])
    title('Stimulus Intensity')
    hold off
    
    subplot(2,2,4), hold on
    plot([0,numTrials+1],[lambda,lambda],'k:')
    plot(stair{simNum}.lapse(1:trialNum))
    axis([0,numTrials+1,priorLambdaRange(1)-.01,priorLambdaRange(end)+.01])
    title('Lapse Rate')
    hold off
 
    
%     subplot(2,2,4), hold on
%     
%     alphaVect = repmat(priorAlphaRange',[1,length(priorBetaRange)]);
%     betaVect = repmat(priorBetaRange,[length(priorAlphaRange),1]);
%     
%     plot3(alphaVect,betaVect,stair.pdf)
%     axis([priorAlphaRange(1)-1,priorAlphaRange(end)+1,priorBetaRange(1)-1,priorBetaRange(end)+1,0-.1,1.1])
%     title('PDF')
%     view([90,90,90])
%     hold off
%  
end
sprintf('Completed simulation %d out of %d \n',simNum,numSim)
end




%%
% 
% xCurve = linspace(0,15,5000);
% 
% paramsOutput = [stair.threshold(end),stair.slope(end),gammaGuess,lambdaGuess];
% 
% figure, hold on,
% plot(xCurve,stair.PF(paramsOutput,xCurve))
% hold off
% 

numSimToPlot = 4;

simRunsToPlot = randperm(numSim);

for i = 1:numSimToPlot
    run = simRunsToPlot(i);
    threshold.indiv(i,:) = stair{run}.threshold;
    slope.indiv(i,:) = stair{run}.slope;
    lapse.indiv(i,:) = stair{run}.lapse;
    
% at50.indiv(i,:) = [stair{run}.threshold(50),stair{run}.slope(50),stair{run}.lapse(50)];
% at75.indiv(i,:) = [stair{run}.threshold(75),stair{run}.slope(75),stair{run}.lapse(75)];
% at100.indiv(i,:) = [stair{run}.threshold(100),stair{run}.slope(100),stair{run}.lapse(100)];
% at125.indiv(i,:) = [stair{run}.threshold(125),stair{run}.slope(125),stair{run}.lapse(125)];
% at150.indiv(i,:) = [stair{run}.threshold(150),stair{run}.slope(150),stair{run}.lapse(150)];
% at200.indiv(i,:) = [stair{run}.threshold(200),stair{run}.slope(200),stair{run}.lapse(200)];
% at250.indiv(i,:) = [stair{run}.threshold(250),stair{run}.slope(250),stair{run}.lapse(250)];

end
% 
% realMTX = repmat([alphaREAL,betaREAL,lambda],[numSimToPlot,1]);
% 
% at50.mean = mean(at50.indiv,1);%mean(abs(realMTX-at50.indiv),1);
% at75.mean = mean(at75.indiv,1);%mean(abs(realMTX-at75.indiv),1);
% at100.mean = mean(at100.indiv,1);%mean(abs(realMTX-at100.indiv),1);
% % at125.mean = mean(abs(realMTX-at125.indiv),1);
% % at150.mean = mean(abs(realMTX-at150.indiv),1);
% % at200.mean = mean(abs(realMTX-at200.indiv),1);
% % at250.mean = mean(abs(realMTX-at250.indiv),1);
%  
% 
% xVect = [50,75,100];%,125,150,200,250];
% threshVect = [at50.mean(1),at75.mean(1),at100.mean(1)];%,at125.mean(1),at150.mean(1),at200.mean(1),at250.mean(1)]
% slopeVect = [at50.mean(2),at75.mean(2),at100.mean(2)];
% lapseVect = [at50.mean(3),at75.mean(3),at100.mean(3)];

xVect = 1:numTrials;
threshold.mean = mean(threshold.indiv,1);
slope.mean = mean(slope.indiv,1);
lapse.mean = mean(lapse.indiv,1);

figure(3),clf,
subplot(1,3,1),hold on
% plot(xVect,threshVect,'bo-')
plot(xVect,threshold.mean,'bo-')
plot([0,numTrials+1],[alphaREAL,alphaREAL],'k:')
axis([0,numTrials+1,0,priorAlphaRange(end)+1])
title('Threshold')
hold off

subplot(1,3,2),hold on
% plot(xVect,slopeVect,'bo-')
plot(xVect,slope.mean,'bo-')
plot([0,numTrials+1],[betaREAL,betaREAL],'k:')
axis([0,numTrials+1,0,20])
title('Slope')
hold off

subplot(1,3,3),hold on
% plot(xVect,lapseVect,'bo-')
plot(xVect,lapse.mean,'bo-')
plot([0,numTrials+1],[lambda,lambda],'k:')
axis([0,numTrials+1,0,.1])
hold off




%% worked well
% 
% stimValsRange = [.1,20];
% numStimVals = 200;
% numAlphaRange = 100;
%  
% alphaREAL = 1;
% betaREAL = 4;
% signalParamsREAL = [alphaREAL,betaREAL,gamma,lambda];
% 
% stimVals = linspace(stimValsRange(1),stimValsRange(2),numStimVals);
%  
% priorAlphaRange = linspace(stimValsRange(1),stimValsRange(2),numAlphaRange);
% priorBetaRange = 0:.5:10;
% priorLambdaRange = 0:.005:.1;
% gamma = .5;
% lambda = .03;

