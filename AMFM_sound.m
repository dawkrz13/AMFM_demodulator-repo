fc = 10;
fs = 100;
t = (0:1/fs:5)';
x = 1.0 + 0.5*sin(2*pi*t);

subplot(2,2,1);
plot(t,x); title('signal');
xlabel('time [s]'); ylabel('amplitude [-]');

% amplitude modulation
y_am = ammod(x, fc, fs);
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
subplot(2,2,4);
plot(t,y_dem); title('demodulated signal');
xlabel('time [s]'); ylabel('amplitude [-]');
