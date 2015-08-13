function boxes(wPtr, centersOfBoxes)
screen_defs; global box;
% centersOfBoxes - is a matrix of n*2 determining the center for each
% corresponding box

for i = 1:size(centersOfBoxes,1)
    rect = CenterRectOnPoint([0 0 box.slopeH box.slopeV], centersOfBoxes(i,1), centersOfBoxes(i,2));

    %%%   Upper left corner %%%
    %Upper left horizontal
    x1= rect(1);
    x2 = x1 + box.sizePixels +box.penWidth;
    y1 = rect(2); 
    y2 = y1;
    Screen('DrawLine',wPtr, box.color, x1, y1, x2, y2, box.penWidth);

    %Upper left vertical
    x1= rect(1);
    x2 = x1;
    y1 = rect(2);
    y2 = y1 + box.sizePixels;
    Screen('DrawLine',wPtr, box.color, x1, y1, x2, y2, box.penWidth);

    %%%   Upper left corner %%%
    %Upper right horizontal
    x1= rect(3);
    x2 = x1 - box.sizePixels - box.penWidth;
    y1 = rect(2); 
    y2 = y1;
    Screen('DrawLine',wPtr, box.color, x1, y1, x2, y2, box.penWidth);

    %Upper right vertical
    x1= rect(3);
    x2 = x1;
    y1 = rect(2); 
    y2 = y1 + box.sizePixels + box.penWidth;
    Screen('DrawLine',wPtr, box.color, x1, y1, x2, y2, box.penWidth);

    %%%   Lower right corner %%%
    %Lower right horizontal
    x1= rect(3);
    x2 = x1 - box.sizePixels - box.penWidth;
    y1 = rect(4); 
    y2 = y1;
    Screen('DrawLine',wPtr, box.color, x1, y1, x2, y2, box.penWidth);

    %Upper right vertical
    x1= rect(3);
    x2 = x1;
    y1 = rect(4); 
    y2 = y1 - box.sizePixels - box.penWidth;
    Screen('DrawLine',wPtr, box.color, x1, y1, x2, y2, box.penWidth);


    %Lower left horizontal
    x1= rect(1);
    x2 = x1 + box.sizePixels + box.penWidth;
    y1 = rect(4); 
    y2 = y1;
    Screen('DrawLine',wPtr, box.color, x1, y1, x2, y2, box.penWidth);

    %Upper right vertical
    x1= rect(1);
    x2 = x1;
    y1 = rect(4); 
    y2 = y1 - box.sizePixels - box.penWidth;
    Screen('DrawLine',wPtr, box.color, x1, y1, x2, y2, box.penWidth);
end


