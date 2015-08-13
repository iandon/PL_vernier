function fixation(wPtr, fix)
global params;

if nargin == 2
    if ~fix
        xHR= params.screenVar.centerPix(1)+ params.fixationVar.sizeCrossPix(1);
        xHL = params.screenVar.centerPix(1)- params.fixationVar.sizeCrossPix(1);
        yH = params.screenVar.centerPix(2);
        Screen('DrawLine',wPtr,[255, 0, 0],xHR,yH,xHL, yH,params.fixationVar.penWidthPix);
        
        yVU= params.screenVar.centerPix(2) - params.fixationVar.sizeCrossPix(2);
        yVD = params.screenVar.centerPix(2) + params.fixationVar.sizeCrossPix(2);
        xV = params.screenVar.centerPix(1);
        Screen('DrawLine',wPtr,[255, 0, 0],xV,yVU,xV, yVD,params.fixationVar.penWidthPix);
    end

else
xHR= params.screenVar.centerPix(1)+ params.fixationVar.sizeCrossPix(1);
xHL = params.screenVar.centerPix(1)- params.fixationVar.sizeCrossPix(1);
yH = params.screenVar.centerPix(2);
Screen('DrawLine',wPtr,params.fixationVar.color,xHR,yH,xHL, yH,params.fixationVar.penWidthPix);

yVU= params.screenVar.centerPix(2)+ params.fixationVar.sizeCrossPix(2);
yVD = params.screenVar.centerPix(2)- params.fixationVar.sizeCrossPix(2);
xV = params.screenVar.centerPix(1);
Screen('DrawLine',wPtr,params.fixationVar.color,xV,yVU,xV, yVD,params.fixationVar.penWidthPix);
end



