function fx = My2DGauss(pixelWidth,mean, sd)
    x = [-2*pi: 4*pi/pixelWidth : 2*pi];
    y = (-(x-mean).^2) /(2*sd^2);
    f = (1/(sd*sqrt(2*pi))) * exp(y);
    fx = f'*f;