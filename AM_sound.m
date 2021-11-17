clear all

% choose soung source
recording = true;

if recording == true
    [y, Fs] = audioread('recording.m4a');
else
    [y, Fs] = audioread('test_sound.mp3');
end
y_single_channel = y(:,1)';

% play original sound
%sound(single_channel,fs)

subplot(2,2,1);
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
subplot(2,2,2);
plot(y_am); title('modulated signal');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% Hilbert transform 
h = hilbert(y_am);  %TODO: replace this function with our implementation
subplot(2,2,3);
plot(imag(h)); hold on; plot(real(h));
legend('real','imaginary')
title('Hilbert function')
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% AM signal demodulation
y_dem_translated = abs(h); 
%y_dem_translated = sqrt(imh.^2 + reh.^2);

% signal postprocessing
y_dem = y_dem_translated - abs(sig_min);

subplot(2,2,4);
plot(y_dem); title('demodulated signal');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% play demodulated AM signal
sound(y_dem,Fs)
