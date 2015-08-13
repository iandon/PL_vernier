


numTrials = 125;

stimValsRange = [.5,7];
numStimVals = 9; %must be odd

stimVals = logspace(log10(stimRange(1)),log10(stimRange(2)),numStimVals);

priorAlphaRange = stimVals(1):.5:stimValsRange(2);
priorBetaRange = 1:2:30;

gammaGuess = .5;
lambdaGuess = .02;

stair = PAL_AMPM_setup('stimRange',stimVals,...
                    'priorAlphaRange',priorAlphaRange,...
                    'priorBetaRange',priorBetaRange,...
                    'gamma',gammaGuess,'lambda',lambdaGuess,...
                    'PF',PAL_Weibull,'numTrials',numTrials);
                
%%

stair = PAL_AMPM_updatePM(stair,response);
%%
stair.xCurrent;