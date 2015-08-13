function beep2(w,t,good)
%plays a short tone as an audible cue
%
%USAGE:
%    beep2
%    beep2(w)    specify frequency (200-1,000 Hz)
%    beep2(w,t)     "       "       and duration in seconds
%    beep2(w,t,good)   " "  and  " " and if good = 0, then tone is perturbed (more harsh -> for 'incorrect' response tone)

fs=8192;  %sample freq in Hz

if (nargin == 0)
    w=1000;            %default
    t = 0:1/fs:.2;   %default
elseif (nargin == 1)
    t = 0:1/fs:.2;   %default
elseif (nargin == 2)
    t = 0:1/fs:t;
elseif (nargin == 3)
    t = 0:1/fs:t;
    t2 = t*100;
end

if (nargin == 3)
    if good == 1
        wave = sin(2*pi*w*t);
    else
        wave=sin(2*pi*w*t) + (.1*cos(2*pi*w*t2 +(pi/3)));
    end
else
    wave = sin(2*pi*w*t);
end
    
    
%play sound
sound(wave,fs);
end
