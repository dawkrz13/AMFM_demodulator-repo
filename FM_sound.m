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
subplot(2,2,2);
plot(y_fm); title('modulated signal');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% Hilbert transform 
h = hilbert(y_fm);  %TODO: replace this function with our implementation
subplot(2,2,3);
plot(imag(h)); hold on; plot(real(h));
legend('real','imaginary')
title('Hilbert function')
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% FM signal demodulation
inst_phase = unwrap(angle(h));
inst_freq = (diff(inst_phase)*Fs)/(2*pi);

% signal postprocessing
%y_dem = y_dem_translated - abs(sig_min);

subplot(2,2,4);
%plot(y_dem); title('demodulated signal');
plot(inst_freq); title('demodulated signal');
xlabel('n [-]'); ylabel('frequency [Hz]');
xlim([0 length(y_single_channel)]);
ylim([9350 9850]);

% play demodulated AM signal
sound(inst_freq,Fs)