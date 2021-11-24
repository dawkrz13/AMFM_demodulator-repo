function h_manual = step_by_step_hilbert(y_mod)

    f = fft(y_mod);
    n = length(y_mod);
    
    % create a copy that is multiplied by the complex operator
    complexf = 1i*f;
    
    % find indices of positive and negative frequencies
    posF = 2:floor(n/2)+mod(n,2);
    negF = ceil(n/2)+1+~mod(n,2):n;
    
    % rotate Fourier coefficients
    f(posF) = f(posF) + -1i*complexf(posF);
    f(negF) = f(negF) +  1i*complexf(negF);
    
    % take inverse FFT
    h_manual = ifft(f);

end