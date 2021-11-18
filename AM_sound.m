clc, clear all, close all

% choose soung source
recording = true;

if recording == true
    [y, Fs] = audioread('recording.m4a');
else
    [y, Fs] = audioread('test_sound.mp3');
end
y_single_channel = y(:,1)';

subplot(3,2,1);
plot(y_single_channel); title('sound');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% signal preprocessing
sig_min = min(y_single_channel);
y_single_channel_translated = y_single_channel + abs(sig_min);

% amplitude modulation
fc = 10;
fs = 100;
y_am = ammod(y_single_channel_translated, fc, fs);
subplot(3,2,2);
plot(y_am); title('modulated signal');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

%% Manual Hilbert transform
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
plot(imag(hilbertx)); hold on; plot(real(hilbertx));
legend('real','imaginary')
title('Manual Hilbert function')
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% signal demodulation
y_dem_translated2 = abs(hilbertx); 

% signal postprocessing
y_dem2 = y_dem_translated2 - abs(sig_min);

subplot(3,2,4);
plot(y_dem2); title('Manual demodulated signal');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

%% Matlab Hilbert transform 
h = hilbert(y_am);
subplot(3,2,5);
plot(imag(h)); hold on; plot(real(h));
legend('real','imaginary');
title('Matlab Hilbert function');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% AM signal demodulation
y_dem_translated = abs(h);

% signal postprocessing
y_dem = y_dem_translated - abs(sig_min);

subplot(3,2,6);
plot(y_dem); title('demodulated signal');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

%% compare sound
sound(y,Fs)
pause(6)
sound(y_dem2,Fs)
pause(6)
sound(y_dem,Fs)
