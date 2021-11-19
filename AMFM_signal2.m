clc, clear all, close all

%[y, fs] = audioread('test_sound.mp3');
[y, fs] = audioread('recording.m4a');
y_single_channel = y(:,1)';
%sound(single_channel,fs) % uncomment to play original sound

fc = fs/2;
t = 0:(1/fs):(length(y_single_channel)/fs);
t(end)=[];

subplot(3,2,1);
plot(t,y_single_channel); title('sound');
xlabel('time [s]'); ylabel('amplitude [-]');

% signal preprocessing
sig_min = min(y_single_channel);
y_single_channel_translated = y_single_channel + abs(sig_min);

% amplitude modulation
y_am = ammod(y_single_channel_translated, fc, fs);
subplot(3,2,2);
plot(t,y_am); title('modulated signal');
xlabel('time [s]'); ylabel('amplitude [-]');

%% Manual Hilbert
f = fft(y_am);
n = length(y_am);

% create a copy that is multiplied by the complex operator
complexf = 1i*f;

% find indices of positive and negative frequencies
posF = 2:floor(n/2)+mod(n,2);
negF = ceil(n/2)+1+~mod(n,2):n;

% rotate Fourier coefficients
f(posF) = f(posF) + -1i*complexf(posF);
f(negF) = f(negF) +  1i*complexf(negF);

% take inverse FFT
hilbertx = ifft(f);
imh2 = imag(hilbertx);
reh2 = real(hilbertx);

subplot(3,2,3);
plot(t,reh2,t,imh2); ylim([-1 1]);
legend('real','imaginary')
title('Manual Hilbert function')
xlabel('time [s]'); ylabel('amplitude [-]');

% signal demodulation
y_dem_translated2 = abs(hilbertx); 

% signal postprocessing
y_dem2 = y_dem_translated2 - abs(sig_min);

subplot(3,2,4);
plot(t,y_dem2); title('Manual demodulated signal');
xlabel('time [s]'); ylabel('amplitude [-]');
ylim([-0.5 0.5]);

%% MATLAB Hilbert transform 
h = hilbert(y_am);
imh = imag(h);
reh = real(h);
subplot(3,2,5);
plot(t,reh,t,imh); ylim([-1 1]);
legend('real','imaginary')
title('Hilbert function')
xlabel('time [s]'); ylabel('amplitude [-]');

% signal demodulation
y_dem_translated = abs(h); 
%y_dem = sqrt(imh.^2 + reh.^2);

% signal postprocessing
y_dem = y_dem_translated - abs(sig_min);

subplot(3,2,6);
plot(t,y_dem); title('demodulated signal');
xlabel('time [s]'); ylabel('amplitude [-]');
%% compare sound
sound(y,fs)
pause(6)
sound(y_dem2,fs)
pause(6)
sound(y_dem,fs)
