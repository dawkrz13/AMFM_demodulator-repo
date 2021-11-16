[y, fs] = audioread('test_sound.mp3');
single_channel = y(:,1)';
%sound(single_channel,fs) % uncomment to play original sound

fc = 10;
t = 0:(1/fs):(length(single_channel)/fs);
t(end)=[];

subplot(2,2,1);
plot(t,single_channel); title('sound');
xlabel('time [s]'); ylabel('amplitude [-]');

% signal preprocessing
sig_min = min(single_channel);
single_channel_translated = single_channel + abs(sig_min);

% amplitude modulation
y_am = ammod(single_channel_translated, fc, fs);
subplot(2,2,2);
plot(t,y_am); title('modulated signal');
xlabel('time [s]'); ylabel('amplitude [-]');

% Hilbert transform 
h = hilbert(y_am);
imh = imag(h);
reh = real(h);
subplot(2,2,3);
plot(t,reh,t,imh); ylim([-1 1]);
legend('real','imaginary')
title('Hilbert function')
xlabel('time [s]'); ylabel('amplitude [-]');

% signal demodulation
y_dem = abs(h); 
%y_dem = sqrt(imh.^2 + reh.^2);

% signal postprocessing
y_dem_translated = y_dem - abs(sig_min);

subplot(2,2,4);
plot(t,y_dem_translated); title('demodulated signal');
xlabel('time [s]'); ylabel('amplitude [-]');

sound(y_dem,fs)
