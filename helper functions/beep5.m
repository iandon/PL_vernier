function beep5(waveVect, t, good)
%beep3(w1,, w2, t, good)
%plays two short tones as an audible cue
%
%USAGE:
%    beep3
%    beep3(w1, w2)    specify frequency (200-1,000 Hz)
%    beep3(w1, w2, t)     "       "       and duration in seconds
%    beep3(w1, w2, t,good)   " "  and  " " and if good = 0, then tone is perturbed (more harsh -> for 'incorrect' response tone)

fs= 8192;  %sample freq in Hz

if (nargin < 1 )
    waveVect = 1000;   %default
    t = 0:1/fs:.2;   %default
elseif (nargin < 2)
    t = 0:1/fs:.2;   %default
elseif nargin == 3
    t = 0:1/fs:t;
    t2 = t*10;
end

n = length(t);
wave = zeros(1,length(waveVect)*length(t));






scale = .7;


wave = scale*chirp(t,waveVect(1),max(t),waveVect(2));
if good == 0
    wave1 = wave;
    wave = wave + .2*chirp(t,waveVect(1)*10,max(t),waveVect(2)*10,'logarithmic', 45);
end

sound(wave,fs);
% 
% if (nargin == 3)
%     for i = 1:length(waveVect)
%         b = 1+(n*(i-1));
%         wave(b:(b+n-1)) = scale*sin(2*pi.*waveVect(i)*t);
%     end
%     for i = 1:(length(waveVect)-1)
%         b = 1+(n*(i-1));
%         changeRange = (b+n-11):(b+500);
%         wave(changeRange) = linspace(wave(min(changeRange)-1),wave(max(changeRange)+1),length(changeRange));
%     end
%     if good == 0
%         wave1 = wave;
%         for i = 1:length(waveVect)
%             b = 1+(n*(i-1));
%             wave(b:b+n-1)= scale*(sin(2*pi*waveVect(i)*t) + (.1*cos(2*pi*waveVect(i)*t2 +(pi/3))));
%         end
%     end
%     
% end
% %
% % for i = 1:length(waveVect)
% %     wave2 = wave(1+(n*(i-1))
% % end
% 
% %play sound
% sound(wave,fs);

Xrange = 200; if length(wave) < Xrange, Xrange = length(wave); end
figure
hold on
if good == 0, plot(wave1(1:Xrange), 'r.-', 'LineWidth', 1.2); end
plot(wave(1:Xrange))
axis([0 Xrange -1.2 1.2])
hold off

item = 10;
p = wave(item);
sprintf('wave(%d) = %d, max = %d, min = %d, length = %d', item,p, max(wave), min(wave), length(wave))


end