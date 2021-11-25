function AM_FM_Hilbert(audio_source, modulation_type, play_sound, fc, fs, fd, h1, h2, h3, h4, h5, h6)
    
    % plot configuration in command window
    fprintf('Audio source: %s', audio_source)
    fprintf('Modulation type: %s', modulation_type)
    fprintf('Play sound: %d', play_sound)
    fprintf('Fc: %d', fc)
    fprintf('Fs: %d', fs)
    fprintf('Fd: %d', fd)
    
    if audio_source  == "Recording"
        [y, Fs] = audioread('recording.m4a');
    else
        [y, Fs] = audioread('test_sound.mp3');
    end
    
    %% Calculations
    
    % extract single sound channel
    y_single_channel = y(:,1)';
    
    % plot original signal
    % subplot(3,2,1);
    plot(h1, y_single_channel); title(h1, 'Original signal');
    xlabel(h1, 'n [-]'); ylabel(h1, 'amplitude [-]');
    xlim(h1, [0 length(y_single_channel)]);
    
    % modulate signal
    if modulation_type == "AM"
        % signal preprocessing
        sig_min = min(y_single_channel);
        y_single_channel_translated = y_single_channel + abs(sig_min);
        y_mod = ammod(y_single_channel_translated, fc, fs);
    else
        y_mod = fmmod(y_single_channel, fc, fs, fd);
    end
    
    % plot modulated signal
    % subplot(3,2,2);
    plot(h4, y_mod); title(h4, 'Modulated signal');
    xlabel(h4, 'n [-]'); ylabel(h4, 'amplitude [-]');
    xlim(h4, [0 length(y_single_channel)]);
    
    % calculate Hilbert transform step by step
    h_manual = step_by_step_hilbert(y_mod);
    
    % plot step by step Hilbert function
    % subplot(3,2,3);
    plot(h2, imag(h_manual)); hold(h2); plot(h2, real(h_manual));
    legend(h2, 'real','imaginary')
    title(h2, 'Step by step Hilbert function')
    xlabel(h2, 'n [-]'); ylabel(h2, 'amplitude [-]');
    xlim(h2, [0 length(y_single_channel)]);
    
    % calculate matlab Hilbert transform
    h_matlab = hilbert(y_mod);
    
    % plot matlab Hilbert function
    % subplot(3,2,4);
    plot(h3, imag(h_matlab)); hold(h3); plot(h3, real(h_matlab));
    legend(h3, 'real','imaginary');
    title(h3, 'Matlab Hilbert function');
    xlabel(h3, 'n [-]'); ylabel(h3, 'amplitude [-]');
    xlim(h3, [0 length(y_single_channel)]);
    
    % demodulate signal
    if modulation_type == "AM"
        y_dem_translated_manual = abs(h_manual);
        y_dem_translated_matlab = abs(h_matlab);
        % signal postprocessing
        y_dem_manual = y_dem_translated_manual - abs(sig_min);
        y_dem_matlab = y_dem_translated_matlab - abs(sig_min);
    else
        inst_phase_manual = unwrap(angle(h_manual));
        inst_freq_manual = (diff(inst_phase_manual)*Fs)/(2*pi);
        y_dem_manual = inst_freq_manual/(2*Fs);
        inst_phase_matlab = unwrap(angle(h_matlab));
        inst_freq_matlab = (diff(inst_phase_matlab)*Fs)/(2*pi);
        y_dem_matlab = inst_freq_matlab/(2*Fs);
    end
    
    % plot demodulated signal - step by step Hilbert
    % subplot(3,2,5);
    plot(h5, y_dem_manual); title(h5, 'Demodulated signal - step by step Hilbert');
    xlabel(h5, 'n [-]'); ylabel(h5, 'amplitude [-]');
    xlim(h5, [0 length(y_single_channel)]);

    % plot demodulated signal - matlab Hilbert
    % subplot(3,2,6);
    plot(h6, y_dem_matlab); title(h6, 'Demodulated signal - matlab Hilbert');
    xlabel(h6, 'n [-]'); ylabel(h6, 'amplitude [-]');
    xlim(h6, [0 length(y_single_channel)]);
    
    %% Compare results
    
    %[c,lags] = xcorr(y_dem_manual,y_dem_matlab);
    %figure; stem(lags,c); title('Cross Correlation of step by step and matlab solution')
    
    if play_sound
        % play original sound
        sound(y,Fs)
        pause(length(y)/Fs)
        % play demodulated sound - step by step Hilbert
        sound(y_dem_manual,Fs)
        pause(length(y)/Fs)
        % play demodulated sound - matlab Hilbert
        sound(y_dem_matlab,Fs)
        pause(length(y)/Fs)
    end


end