clc, clear all, close all

%% User Panel

% choose sound source
recording = true;

if recording == true
    [y, Fs] = audioread('recording.m4a');
else
    [y, Fs] = audioread('test_sound.mp3');
end

% choose modulation type
modulation_type_AM = false;  % for FM set to false

% choose modulation parameters
fc = 200;
fs = 1000;
fd = 50;

%% Calculations

% extract single sound channel
y_single_channel = y(:,1)';

% plot original signal
subplot(3,2,1);
plot(y_single_channel); title('Original signal');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);
%ylim([-0.1 0.1]);

% modulate signal
if modulation_type_AM == true
    % signal preprocessing
    sig_min = min(y_single_channel);
    y_single_channel_translated = y_single_channel + abs(sig_min);
    y_mod = ammod(y_single_channel_translated, fc, fs);
else
    y_mod = fmmod(y_single_channel, fc, fs, fd);
end

% plot modulated signal
subplot(3,2,2);
plot(y_mod); title('Modulated signal');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% calculate Hilbert transform step by step
h_manual = step_by_step_hilbert(y_mod);

% plot step by step Hilbert function
subplot(3,2,3);
plot(imag(h_manual)); hold on; plot(real(h_manual));
legend('real','imaginary')
title('Step by step Hilbert function')
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% calculate matlab Hilbert transform
h_matlab = hilbert(y_mod);

% plot matlab Hilbert function
subplot(3,2,4);
plot(imag(h_matlab)); hold on; plot(real(h_matlab));
legend('real','imaginary');
title('Matlab Hilbert function');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% demodulate signal
if modulation_type_AM == true
    y_dem_translated_manual = abs(h_manual);
    y_dem_translated_matlab = abs(h_matlab);
    % signal postprocessing
    y_dem_manual = y_dem_translated_manual - abs(sig_min);
    y_dem_matlab = y_dem_translated_matlab - abs(sig_min);
else
    inst_phase_manual = unwrap(angle(h_manual));
    inst_freq_manual = (diff(inst_phase_manual)*Fs)/(2*pi);
    y_dem_manual = inst_freq_manual/Fs;
    inst_phase_matlab = unwrap(angle(h_matlab));
    inst_freq_matlab = (diff(inst_phase_matlab)*Fs)/(2*pi);
    y_dem_matlab = inst_freq_matlab/Fs;
end

% plot demodulated signal - step by step Hilbert
subplot(3,2,5);
plot(y_dem_manual); title('Demodulated signal - step by step Hilbert');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

% plot demodulated signal - matlab Hilbert
subplot(3,2,6);
plot(y_dem_matlab); title('Demodulated signal - step by step Hilbert');
xlabel('n [-]'); ylabel('amplitude [-]');
xlim([0 length(y_single_channel)]);

%% Compare results

[c,lags] = xcorr(y_dem_manual,y_dem_matlab);
figure; stem(lags,c); title('Cross Correlation of step by step and matlab solution')

% play original sound
sound(y,Fs)
pause(6)
% play demodulated sound - step by step Hilbert
sound(y_dem_manual,Fs)
pause(6)
% play demodulated sound - matlab Hilbert
sound(y_dem_matlab,Fs)
pause(6)