init_workspace('3A: Sampling', 2, 1, 0, 0, exist('csv_write'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 3A: Sampling
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Nyquist is 80Hz
x = @(t) 10*cos(2*pi*20*t) - 4*sin(2*pi*40*t + 5);

% Lets sample at 320Hz for 128 samples.
L = 128;  % Samples
Fs = 320; % Sampling Frequency
T = 1/Fs; % Sampling Period

t_s   = (0:L-1)*T;
t_detail = linspace(t_s(1), t_s(end), 512);

% Plot
plot_continuous(...
  sprintf('x(t) with 128 samples, t=[%.1fs, %.1fs], F_s=%.2fHz', t_s(1), t_s(end), Fs),...
  1, t_detail, x(t_detail));
hold on;
stem(t_s, x(t_s));
hold off;

% CSV
csv('3a_x_detail', t_detail, x(t_detail));
csv('3a_x', t_s, x(t_s));

% B Spectrum

% X = fft(x(t_s));
% P2 = abs(X/L);    % Two-sided Spectrum
% P1 = P2(1:L/2+1); % One-sided Spectrum
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;

X = fftshift(abs(2*fft(x(t_s)/L)));
f = -Fs/2:Fs/L:Fs/2-Fs/L;

plot_discrete('Amplitude Spectrum of x(t)', 2, f, X);
xlabel('f (Hz)')
ylabel('|P(f)|')
axis([-50 50 0 11])

csv('3a_spectrum', f, X);
