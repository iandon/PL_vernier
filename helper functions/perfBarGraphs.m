function [diffPrePost] = perfBarGraphs(perfMTX)


contLevels = [.02,.04,.08,.12,.16,.24,.32,.64];

numSubj = size(perfMTX,1);


numLevels = length(contLevels);



for j = 1:5
    for i = 1:numSubj
        if j == 1 || j == 5
            lamda.T.subj(i,j) = perfMTX{i}{j}.fitResultsAllT.paramVals(4);
            beta.T.subj(i,j) = perfMTX{i}{j}.fitResultsAllT.paramVals(2);
            alpha.T.subj(i,j) = perfMTX{i}{j}.fitResultsAllT.paramVals(1);
            thresh75.T.subj(i,j) = perfMTX{i}{j}.fitResultsAllT.thresh75perc;
            
        else
            lamda.T.subj(i,j) = perfMTX{i}{j}.T.paramVals(4);
            beta.T.subj(i,j) = perfMTX{i}{j}.T.paramVals(2);
            alpha.T.subj(i,j) = perfMTX{i}{j}.T.paramVals(1);
            thresh75.T.subj(i,j) = perfMTX{i}{j}.T.thresh75perc;
        end
        
        if j == 1
            lamda.U.subj(i,1) = perfMTX{i}{j}.fitResultsAllU.paramVals(4);
            beta.U.subj(i,1) = perfMTX{i}{j}.fitResultsAllU.paramVals(2);
            alpha.U.subj(i,1) = perfMTX{i}{j}.fitResultsAllU.paramVals(1);
            thresh75.U.subj(i,j) = perfMTX{i}{j}.fitResultsAllU.thresh75perc;
        end
        
        if j == 5
            lamda.U.subj(i,2) = perfMTX{i}{j}.fitResultsAllU.paramVals(4);
            beta.U.subj(i,2) = perfMTX{i}{j}.fitResultsAllU.paramVals(2);
            alpha.U.subj(i,2) = perfMTX{i}{j}.fitResultsAllU.paramVals(1);
            thresh75.U.subj(i,j) = perfMTX{i}{j}.fitResultsAllU.thresh75perc;
        end
        
    end


    
    
    lamda.T.all.std(j) = std(lamda.T.subj(:,j))/(sqrt(numSubj));
    beta.T.all.std(j) = std(beta.T.subj(:,j))/(sqrt(numSubj));
    alpha.T.all.std(j) = std(alpha.T.subj(:,j))/(sqrt(numSubj));
    thresh75.T.all.std(j) = std(thresh75.T.subj(:,j))/(sqrt(numSubj));
    
    if j == 1   
        lamda.U.all.std(1) = std(lamda.U.subj(:,1))/(sqrt(numSubj));
        beta.U.all.std(1) = std(beta.U.subj(:,1))/(sqrt(numSubj));
        alpha.U.all.std(1) = std(alpha.U.subj(:,1))/(sqrt(numSubj));
        thresh75.U.all.std(1) = std(thresh75.U.subj(:,1))/(sqrt(numSubj));
        
    end
    
    if j == 5
        
        lamda.U.all.std(2) = std(lamda.U.subj(:,2))/(sqrt(numSubj));
        beta.U.all.std(2) = std(beta.U.subj(:,2))/(sqrt(numSubj));
        alpha.U.all.std(2) = std(alpha.U.subj(:,2))/(sqrt(numSubj));
        thresh75.U.all.std(2) = std(thresh75.U.subj(:,2))/(sqrt(numSubj));
    end
    
    
    
    
end

for i = 1:numSubj
    lamda.T.diff.subj(i) = lamda.T.subj(i,5) - lamda.T.subj(i,1);
    beta.T.diff.subj(i) = beta.T.subj(i,5) - beta.T.subj(i,1);
    alpha.T.diff.subj(i) = alpha.T.subj(i,5) - alpha.T.subj(i,1);
    thresh75.T.diff.subj(i) = thresh75.T.subj(i,5) - thresh75.T.subj(i,1);
    
    lamda.U.diff.subj(i) = lamda.U.subj(i,2) - lamda.U.subj(i,1);
    beta.U.diff.subj(i) = beta.U.subj(i,2) - beta.U.subj(i,1);
    alpha.U.diff.subj(i) = alpha.U.subj(i,2) - alpha.U.subj(i,1);
    thresh75.U.diff.subj(i) = thresh75.U.subj(i,2) - thresh75.U.subj(i,1);
end


lamda.T.diff.mean = mean(lamda.T.diff.subj);
beta.T.diff.mean = mean(beta.T.diff.subj);
alpha.T.diff.mean = mean(alpha.T.diff.subj);


lamda.U.diff.mean = mean(lamda.U.diff.subj);
beta.U.diff.mean = mean(beta.U.diff.subj);
alpha.U.diff.mean = mean(alpha.U.diff.subj);

lamda.T.diff.std = std(lamda.T.diff.subj)/sqrt(numSubj);
beta.T.diff.std = std(beta.T.diff.subj)/sqrt(numSubj);
alpha.T.diff.std = std(alpha.T.diff.subj)/sqrt(numSubj);


lamda.U.diff.std = std(lamda.U.diff.subj)/sqrt(numSubj);
beta.U.diff.std = std(beta.U.diff.subj)/sqrt(numSubj);
alpha.U.diff.std = std(alpha.U.diff.subj)/sqrt(numSubj);




lamda.T.all.mean = mean(lamda.T.subj,1); 
beta.T.all.mean = mean(beta.T.subj,1); 
alpha.T.all.mean = mean(alpha.T.subj,1);
thresh75.T.all.mean = mean(thresh75.T.subj,1);

lamda.U.all.mean = mean(lamda.U.subj,1);
beta.U.all.mean = mean(beta.U.subj,1);
alpha.U.all.mean = mean(alpha.U.subj,1);
thresh75.U.all.mean = mean(thresh75.U.subj,1);
        

plotByParam(thresh75,'beta',[0 6 -.2 .3],numSubj)

plotByParam(alpha,'alpha',[0 6 -.2 .3],numSubj)

plotByParam(beta,'beta',[-.1,.3],numSubj)   

plotByParam(lamda,'lamda',[0,6,-.3, .4],numSubj)  


diffPrePost = struct('lamda',lamda,'beta',beta,'alpha',alpha,'75% thresh',thresh75);


%% All subjects 

% Average
if numSubj > 1
    calcperfAllQ = input('Plot curves for average perf of whole group? [y/n] \n','s');
    
    if calcperfAllQ == 'y'
        perfAll = cell(5,1);
        nScript = sprintf('n = %d',numSubj);
        
        paramGuess = [.4,4,.5,.1];
        xCurve = linspace(.01,1,1000);
        adpath WeibullFunction
        
        
        for j = 1:5
            for i = 1:numSubj
                tLocs = perfMTX{i}{j}.trainedLocs;
                uLocs = perfMTX{i}{j}.untrainedLocs;
                perfAll{j}.T.subj.mean(i,:) = mean([perfMTX{i}{j}.propCorr(tLocs(1),:,1)+perfMTX{i}{j}.propCorr(tLocs(2),:,1); ...
                                     perfMTX{i}{j}.propCorr(tLocs(1),:,2) + perfMTX{i}{j}.propCorr(tLocs(2),:,2)],1);
                if j == 1 || j == 5
                    perfAll{j}.U.subj.mean(i,:) = mean([perfMTX{i}{j}.propCorr(uLocs(1),:,1)+perfMTX{i}{j}.propCorr(uLocs(2),:,1); ...
                                         perfMTX{i}{j}.propCorr(uLocs(1),:,2) + perfMTX{i}{j}.propCorr(uLocs(2),:,2)],1);
                end
            end
            perfAll{j}.T.mean = nanmean(perfAll{j}.T.subj.mean,1);
            [perfAll{j}.T.fit, perfAll{j}.T.otherFitStats] = fitWeibull(paramGuess,contLevels,perfAll{j}.T.mean);
            perfAll{j}.T.std = std(perfAll{j}.T.subj.mean,0,1)./sqrt(numSubj);
            
            
            if j == 1 || j == 5
                perfAll{j}.U.mean = nanmean(perfAll{j}.U.subj.mean,1);
                [perfAll{j}.U.fit, perfAll{j}.U.otherFitStats]= fitWeibull(paramGuess,contLevels,perfAll{j}.U.mean);
                perfAll{j}.U.std = std(perfAll{j}.U.subj.mean,0,1)./sqrt(numSubj);
            end
        end
            %plots
           
        figure, subplot(1,2,1), hold on
        plot(xCurve,WeibullFunction(perfAll{1}.T.fit,xCurve),'-.','Color', [0,.7,.4])
        plot(xCurve,WeibullFunction(perfAll{5}.T.fit,xCurve),'b--')
        legend('Pre','Post')
        ttl = sprintf('Trained locs');
        title(ttl)
        plot(contLevels,perfAll{1}.T.mean,'d','Color', [0,.7,.4])
        plot(contLevels,perfAll{5}.T.mean,'bo')
        
        plot([contLevels+.01,contLevels;contLevels+.01,contLevels],...
             [perfAll{1}.T.mean-perfAll{1}.T.std,perfAll{5}.T.mean-perfAll{5}.T.std;...
              perfAll{1}.T.mean+perfAll{1}.T.std,perfAll{5}.T.mean+perfAll{5}.T.std],'k-');
        
        
        xlabel('Contrast')
        ylabel('Percent Correct')
        axis([0 1 -1.5 5])
        hold off
        
        subplot(1,2,2), hold on
        plot(xCurve,WeibullFunction(perfAll{1}.U.fit,xCurve),'-.','Color', [.7,0,.9])
        plot(xCurve,WeibullFunction(perfAll{5}.U.fit,xCurve),'r--')
        legend('Pre','Post')
        ttl = sprintf('Untrained locs');
        title(ttl)
        plot(contLevels,perfAll{1}.U.mean,'d','Color', [.7,0,.9])
        plot(contLevels,perfAll{5}.U.mean,'ro')
        
        plot([contLevels+.01,contLevels;contLevels+.01,contLevels],...
             [perfAll{1}.U.mean-perfAll{1}.U.std,perfAll{5}.U.mean-perfAll{5}.U.std;...
              perfAll{1}.U.mean+perfAll{1}.U.std,perfAll{5}.U.mean+perfAll{5}.U.std],'k-');
        
        text(1,5,{nScript},'FontSize',11,'HorizontalAlignment','left','VerticalAlignment','top')

        xlabel('Contrast')
        ylabel('Percent Correct')
        axis([0 1 -1.5 5])
        hold off
        
        figure,
        for j = 2:4
            subplot(1,3,j-1), hold on
            plot(xCurve,WeibullFunction(perfAll{j}.T.fit,xCurve),'b--')
            lgnd = sprintf('Session %d',j);
            legend(lgnd)
            ttl = sprintf('Trained locs');
            title(ttl)
            plot(contLevels,perfAll{j}.T.mean,'bo')
            plot([contLevels;contLevels],...
             [perfAll{j}.T.mean-perfAll{j}.T.std;perfAll{j}.T.mean+perfAll{j}.T.std],'k-');
            
            
            xlabel('Contrast')
            ylabel('Percent Correct')
            axis([0 1 -1.5 5])
            if j == 4
                text(1,5,{nScript},'FontSize',11,'HorizontalAlignment','left','VerticalAlignment','top')
            end
        end
        hold off
        
        
        diffPrePost.perfAll = perfAll;
            
            
            
    end

end


%% Individual Naka Rushton plots
plotIndivQ = input('Plot individual curves? [y/n] \n', 's');

if plotIndivQ == 'y'
    
    adpath WeibullFunction
    
    for i = 1:numSubj
        
        xCurve = linspace(.01,1,1000);
        
        tLocs = perfMTX{i}{j}.trainedLocs;
        uLocs = perfMTX{i}{j}.untrainedLocs;
        
        figure, subplot(1,2,1), hold on
        plot(xCurve,WeibullFunction(perfMTX{i}{1}.fitResultsAllT.paramVals,xCurve),'-.','Color', [0,.7,.4])
        plot(xCurve,WeibullFunction(perfMTX{i}{5}.fitResultsAllT.paramVals,xCurve),'b--')
        legend('Pre','Post')
        ttl = sprintf('Trained locs: %d and %d',tLocs(1),tLocs(2));
        title(ttl)
        plot(contLevels,perfMTX{i}{1}.T.subj.mean(i,:),'d','Color', [0,.7,.4])
        plot(contLevels,perfMTX{i}{5}.T.subj.mean(i,:),'bo')
        
        xlabel('Contrast')
        ylabel('Percent correct')
        axis([0 1 -1.5 5])
        hold off
        
        subplot(1,2,2), hold on
        plot(xCurve,WeibullFunction(perfMTX{i}{1}.fitResultsAllU.paramVals,xCurve),'-.','Color', [.7,0,.9])
        plot(xCurve,WeibullFunction(perfMTX{i}{5}.fitResultsAllU.paramVals,xCurve),'r--')
        legend('Pre','Post')
        ttl = sprintf('Untrained locs: %d and %d',uLocs(1),uLocs(2));
        title(ttl)
        plot(contLevels,perfAll{1}.U.subj.mean(i,:),'d','Color', [.7,0,.9])
        plot(contLevels,perfAll{5}.U.subj.mean(i,:),'ro')
        
        xlabel('Contrast')
        ylabel('Percent Correct')
        axis([0 1 -1.5 5])
        hold off
        
        figure,
        for j = 2:4
            subplot(1,3,j-1), hold on
            plot(xCurve,WeibullFunction(perfMTX{i}{j}.T.paramVals,xCurve),'b--')
            lgnd = sprintf('Session %d',j);
            legend(lgnd)
            ttl = sprintf('Trained locs: %d and %d',tLocs(1),tLocs(2));
            title(ttl)
            plot(contLevels,perfMTX{i}{j}.T.subj.mean(i,:),'bo')
            
            xlabel('Contrast')
            ylabel('Percent Correct')
            axis([0 1 -1.5 5])
            
        end
        hold off
    end
end