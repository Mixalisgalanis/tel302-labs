init_workspace('3A: Application of Butterworth', 2, 1, 0, 0, exist('csv_write'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 3A: Application of Butterworth
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xt = @(t) 1 + cos(1e3*t) + cos(16e3*t) + cos(30e3*t);

% Use higher frequency for smoother result
fs = 50e3;
Ts = 1/fs;
nyq = fs / 2;
L = 0.02*fs;

t = [1:(L-1)] * Ts;
x = xt(t);

% Create butterworth filters
[N, Wn] = buttord(3e3 / nyq, 4e3 / nyq, 3, 30);
[B_bw30, A_bw30] = butter(N, Wn, 'low');
[N, Wn] = buttord(3e3 / nyq, 4e3 / nyq, 3, 50);
[B_bw50, A_bw50] = butter(N, Wn, 'low');

x_bw30 = filter(B_bw30, A_bw30, x);
x_bw50 = filter(B_bw50, A_bw50, x);

plot_continuous('x(t)', 1, t, x);
plot_continuous('Butterworth 30db', 1, t, x_bw30, '--');
plot_continuous('Butterworth 50db', 1, t, x_bw50, '-.');
plot_name(1, 'Butterworth Application', 't [s]', 'x(t)');
xlim([0.005, 0.015])

csv(sprintf('ex3a_x', N), t, x);
csv(sprintf('ex3a_x_30db', N), t, x_bw30);
csv(sprintf('ex3a_x_50db', N), t, x_bw50);

% Fourier Spectrum
% Recreate with orignal frequency
fs = 10e3;
Ts = 1/fs;
nyq = fs / 2;
L = 500;

t = [1:(L-1)] * Ts;
x = xt(t);

% Create butterworth filters
[N, Wn] = buttord(3e3 / nyq, 4e3 / nyq, 3, 30);
[B_bw30, A_bw30] = butter(N, Wn, 'low');
[N, Wn] = buttord(3e3 / nyq, 4e3 / nyq, 3, 50);
[B_bw50, A_bw50] = butter(N, Wn, 'low');
x_bw30 = filter(B_bw30, A_bw30, x);
x_bw50 = filter(B_bw50, A_bw50, x);

fl = 500;
f = -fs/2:fs/(fl-1):fs/2;
spectrum = @(X) abs(2 * fftshift(fft(X, fl) / fl)) .^ 2;

X = spectrum(x);
X_bw30 = spectrum(x_bw30);
X_bw50 = spectrum(x_bw50);

plot_custom('X', 2, @semilogy, f, X);
plot_custom('Butterworth 30db', 2, @semilogy, f, X_bw30, '--');
plot_custom('Butterworth 50db', 2, @semilogy, f, X_bw50, '-.');
plot_name(2, 'Butterworth Spectrum', 'f [hz]', 'X(f)');

csv(sprintf('ex3a_xf', N), f, X);
csv(sprintf('ex3a_xf_30db', N), f, X_bw30);
csv(sprintf('ex3a_xf_50db', N), f, X_bw50);
