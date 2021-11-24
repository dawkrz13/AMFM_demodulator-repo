clc, clear all, close all

% choose sound source
recording = true;

if recording == true
    [y, Fs] = audioread('recording.m4a');
else
    [y, Fs] = audioread('test_sound.mp3');
end
y_single_channel = y(:,1)';

% play original sound
%sound(single_channel,fs)

subplot(3,2,1);
plot(y_single_channel); title('sound');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);
ylim([-0.1 0.1]);
% signal preprocessing
%sig_min = min(y_single_channel);
%y_single_channel_translated = y_single_channel + abs(sig_min);

% frequency modulation
fc = 200;
fs = 1000;
fd = 50;
%y_fm = fmmod(y_single_channel_translated, fc, fs, fd);
y_fm = fmmod(y_single_channel, fc, fs, fd);
subplot(3,2,2);
plot(y_fm); title('modulated signal');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

%% Manual Hilbert transform
f = fft(y_fm);
n = length(y_fm);

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
plot(imh2); hold on; plot(reh2);
legend('real','imaginary')
title('Manual Hilbert function')
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% FM signal demodulation
inst_phase2 = unwrap(angle(hilbertx));
inst_freq2 = (diff(inst_phase2)*Fs)/(2*pi);

subplot(3,2,4);
plot(inst_freq2); title('Manual demodulated signal');
xlabel('n [-]'); ylabel('frequency [Hz]');
xlim([0 length(y_single_channel)]);
ylim([9350 9850]);

%% Matlab Hilbert transform 
h = hilbert(y_fm);
subplot(3,2,5);
plot(imag(h)); hold on; plot(real(h));
legend('real','imaginary')
title('Matlab Hilbert function')
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% FM signal demodulation
inst_phase = unwrap(angle(h));
inst_freq = (diff(inst_phase)*Fs)/(2*pi);

% signal postprocessing
%y_dem = y_dem_translated - abs(sig_min);

subplot(3,2,6);
%plot(y_dem); title('demodulated signal');
plot(inst_freq); title('Matlab demodulated signal');
xlabel('n [-]'); ylabel('frequency [Hz]');
xlim([0 length(y_single_channel)]);
ylim([9350 9850]);

%% compare sound
sound(y_single_channel,Fs)
pause(6)
sound(inst_freq2/Fs,Fs)
pause(6)
sound(inst_freq/Fs,Fs)