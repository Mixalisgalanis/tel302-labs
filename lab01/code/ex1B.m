init_workspace('1B: Proof Convolution is multiplication in Freq Domain', 4, 2, 0, 0, exist('csv_write'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 1B: Proof Convolution is multiplication in Freq Domain
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Functions
x1 = @(n) 5*sin((2*pi*n)/30);
x2 = @(n) -3*cos((2*pi*n)/60);

% Space
dN = 1;
n = -60:dN:60;

% Conv
yn = conv_time(n, n, dN);
y = conv(x1(n), x2(n)) * dN;

% Fourier
fl = length(yn);
X1 = fft(x1(n), fl);
X2 = fft(x2(n), fl);
Y = X1 .* X2;
y_f = ifft(Y);

disp_fourier = @(X) abs(2 * fftshift(X) / fl) .^ 2;
X1_r = disp_fourier(X1);
X2_r = disp_fourier(X2);
Y_r  = disp_fourier(Y);

Fs = 1 / dN;
L = length(yn);
f = -Fs/2:Fs/L:Fs/2-Fs/L;

% Plot Signals
plot_discrete('x_1', 1, n, x1(n));
plot_discrete('x_2', 2, n, x2(n));

plot_continuous('X_1', 3, f, X1_r);
plot_continuous('X_2', 4, f, X2_r);
plot_continuous('Y',   5, f, Y_r);

plot_discrete('conv y', 7, yn, y);
plot_discrete('fourier y', 8, yn, y_f);

% CSV
csv('1b_x1', n, x1(n));
csv('1b_x2', n, x2(n));
csv('1b_x1_f', f, X1_r);
csv('1b_x2_f', f, X2_r);
csv('1b_Y_f',  f, Y_r);
csv('1b_conv_builtin', yn, y);
csv('1b_conv_fourier', yn, y_f);
