init_workspace('3A: Application of Chebyshev', 2, 1, 0, 0, exist('csv_write'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 3A: Application of Chebyshev
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xt = @(t) 1 + cos(1.5*t) + cos(5*t);

% A
Ts = 0.1;
fs = 1 / Ts;
L = 120*fs;

t = [1:(L-1)] * Ts;
x = xt(t);

% Create Chebyshev filter with N = 16
[B, A] = cheby1(16, 3, 2 / (pi*fs), 'high');
x_cheb = filter(B, A, x);

plot_continuous('x(t)', 1, t, x, '--');
plot_continuous('Chebyshev N=16', 1, t, x_cheb);
plot_name(1, 'Chebyshev Application', 't [s]', 'x(t)');
xlim([35, 85])

csv('ex3b_x', t, x);
csv('ex3b_x_cheb', t, x_cheb);

% Fourier Spectrum
% Recreate with original frequency
Ts = 0.2;
fs = 1 / Ts;
L = 500;

t = [1:(L-1)] * Ts;
x = xt(t);
[B, A] = cheby1(16, 3, 2 / (pi*fs), 'high');
x_cheb = filter(B, A, x);

fl = L;
f = -fs/2:fs/(fl-1):fs/2;
spectrum = @(X) abs(2 * fftshift(fft(X, fl) / fl)) .^ 2;

X = spectrum(x);
X_cheb = spectrum(x_cheb);

plot_custom('X', 2, @semilogy, f, X, '--');
plot_custom('Chebyshev N=16', 2, @semilogy, f, X_cheb);
plot_name(2, 'Chebyshev Spectrum', 'f [hz]', 'X(f)');
%xlim([-1, 1])

csv('ex3b_xf', f, X);
csv('ex3b_xf_cheb', f, X_cheb);
