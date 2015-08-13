function [counterBalanced, counterBalancedNUMS] = calcVarsCBauto(counterBalance, numTrials)
% Counter balances the values in a series of row vectors, which must be
% stored in a cell array ('counterBalance')
%
% Inputs:
%       counterBalance : cell array in which each cell is a row vector
%             pertaining to each possible value of a variable, with each
%             cell pertaining to a different variable
%
%       numTrials: the number of trials in the block
%
%
% Outputs:
%       counterBalanced : cell array in which each cell is a column vector,
%            with each cell pertaining to a separate variable (each cell in
%            the same order as in the input "counterBalance"), each vector
%            have a concurrently randomized order. Each column vector has
%            as many values/rows at the # of trials in the block.
%
%       counterBalancedNUMS : cell array of #s 1:totalNumberofValuesForThisVariable,
%            representing the position of the variable in the original row 
%            vector (ex. for angles = [176, 184], 176 would be angleNum =
%            1, while 186 would be angleNum = 2;)
%
%
% Ex.
%
% numTrials = 480;
% angles = [176, 184];
% contrast = [.02, .04, .08, .16, .32, .64];
% locationNumber = [1, 3];
%
%
% counterBalance = cell(3,1);
% counterBalance{1} = angles;
% counterBalance{2} = contrast;
% counterBalance{3} = locationNumber;
%
% randomizeOrder = 1;
%
% [CB, CBnums] = calcVarsCBauto(counterBalance, numTrials, randomizeOrder);
%
% angleCB = CB{1}; angleNums = CBnums{1}
% contrastCB = CB{2}; contrastNums = CBnums{2};
%




lengthsCB = nan(size(counterBalance,1),1);
counterBalanceNUMS = cell(size(counterBalance,1));
for i = 1:size(counterBalance,1)
    lengthsCB(i) = size(counterBalance{i},2);
    counterBalanceNUMS{i}(:,1) = [1:lengthsCB(i)]';
end

numReps = numTrials/(prod(lengthsCB));

if mod(numReps,1) ~= 0
    error('Number of trials must be a multiple of the number of combinations of counterbalanced covariates');
end


ord = randperm(numTrials);

counterBalancedNUMSpre = cell(size(counterBalance,1),1);
counterBalanced = cell(size(counterBalance,1),1);
counterBalancedNUMS = cell(size(counterBalance,1),1);
for i = 1:size(counterBalance,1)
    if i == 1
        counterBalancedNUMSpre{i}(:,1) = repmat(counterBalanceNUMS{i},[numReps*prod(lengthsCB((i+1):end)),1]);
    else
        lengthEachLevel = prod(lengthsCB(1:(i-1)));
        counterBalancedNUMSpre2 = nan(lengthEachLevel*lengthsCB(i),1);
        for j = 1:lengthsCB(i)
            counterBalancedNUMSpre2(1+((j-1)*lengthEachLevel):(j*lengthEachLevel)) = j*ones(lengthEachLevel,1);
        end
        counterBalancedNUMSpre{i}(:,1) = repmat(counterBalancedNUMSpre2,[numReps*prod(lengthsCB(i+1:end)),1]);
    end
    counterBalancedNUMS{i}(:,1) =  counterBalancedNUMSpre{i}(ord,1);
    for k = 1:numTrials
        counterBalanced{i}(k,1) = counterBalance{i}(counterBalancedNUMS{i}(k));
    end
end

