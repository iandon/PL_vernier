function fixationResp(wPtr)
global params;


xHR= params.screenVar.centerPix(1)+ params.fixationVar.sizeCrossPix(1);
xHL = params.screenVar.centerPix(1)- params.fixationVar.sizeCrossPix(1);
yH = params.screenVar.centerPix(2);
Screen('DrawLine',wPtr,params.fixationVar.respColorVect,xHR,yH,xHL, yH,params.fixationVar.penWidthPix);

yVU= params.screenVar.centerPix(2)+ params.fixationVar.sizeCrossPix(2);
yVD = params.screenVar.centerPix(2)- params.fixationVar.sizeCrossPix(2);
xV = params.screenVar.centerPix(1);
Screen('DrawLine',wPtr,params.fixationVar.respColorVect,xV,yVU,xV, yVD,params.fixationVar.penWidthPix);