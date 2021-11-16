clear all

fc = 10;
fs = 1000;
t = (0:1/fs:4)';
x = 0.5*sin(2*pi*t);

subplot(2,2,1);
plot(t,x); title('information signal');
xlabel('time [s]'); ylabel('amplitude [-]');

% signal preprocessing
sig_min = min(x);
x_translated = x + abs(sig_min);

% amplitude modulation
x_am = ammod(x_translated, fc, fs);
subplot(2,2,2);
plot(t,x_am); title('modulated signal');
xlabel('time [s]'); ylabel('amplitude [-]');

% Hilbert transform
h = hilbert(x_am);
imh = imag(h);
reh = real(h);
subplot(2,2,3);
plot(t,reh,t,imh); ylim([-1 1]);
legend('real','imaginary')
title('Hilbert function')
xlabel('time [s]'); ylabel('amplitude [-]');

% signal demodulation
x_dem_translated = abs(h); 
%x_dem_translated = sqrt(imh.^2 + reh.^2);

% signal postprocessing
x_dem = x_dem_translated - abs(sig_min);

subplot(2,2,4);
plot(t,x_dem); title('demodulated signal');
xlabel('time [s]'); ylabel('amplitude [-]');
ylim([-0.5 0.5]);