init_workspace('3B: Sampling', 3, 2, 0, 0, exist('csv_write'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 3B: Sampling
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nyquist is 2*f0Hz
x = @(t, f0, phi) sin(2*pi*f0*t + phi);
L = 512;    % Samples
Fs = 8000; % Sampling Freq
T = 1/Fs;  % Sampling Period
phi = 0;

% f0 Frequencies
f0s = [[100 225 350 475]; [7525 7650 7775 7900]];
t   = (0:L-1)*T;
t_d = linspace(t(1), t(end), 512);

% Calculate fourier spectrum
L = 1024; % length(t)
df = Fs/L;
f = -Fs/2:df:Fs/2 - df;

fourier = @(x) abs(2 * fftshift(fft(x, L)) / L) .^ 2;

% Plot Exercise
for i=1:2
  for j = 1:4
    f0 = f0s(i, j);
    curr_x = x(t, f0, phi);
    plot_continuous(sprintf('%.2fHz', f0), 2*i - 1, t, curr_x, 'o-');
    plot_continuous(sprintf('%.2fHz', f0), 2*i, f, fourier(curr_x));
  end

  if i==1
    plot_name(1, 'x(t) with small frequencies (no aliasing)', 't(s)', 'x(t)');
    xlim([-0 0.008])
    plot_name(2, 'X(F) with small frequencies (no aliasing)', 'F[Hz]', 'X(F)');
    xlim([-1000 1000])
  else
    plot_name(3, 'x(t) with high frequencies (aliasing with above)', 't(s)', 'x(t)');
    xlim([-0 0.008])
    plot_name(4, 'X(F) with high frequencies (aliasing with above)', 'F[Hz]', 'X(F)');
    xlim([-1000 1000])
  end

  % CSV: Batch samples to the same file since t and f are common
  csv(sprintf('3b_samples_%d', i),...
    t, x(t, f0s(i, 1), phi), x(t, f0s(i, 2), phi),...
    x(t, f0s(i, 3), phi), x(t, f0s(i, 4), phi));

  csv(sprintf('3b_spectrum_%d', i),...
    f, fourier(x(t, f0s(i, 1), phi)),...
    fourier(x(t, f0s(i, 2), phi)),...
    fourier(x(t, f0s(i, 3), phi)),...
    fourier(x(t, f0s(i, 4), phi)));
end

% Show aliasing

% Redefine t to be smaller
L = 24;
t   = (0:L-1)*T;
t_d = linspace(t(1), t(end), 512);

plot_discrete('7525Hz at 8kHz', 5, t, x(t, 7525, phi));
plot_continuous('7525Hz', 5, t_d, x(t_d, 7525, phi));
plot_continuous('475Hz', 5, t_d, x(t_d, 475, phi));
plot_name(5, 'Higher than Nyquist(4kHz) Freq 7525Hz aliases with 475Hz, \phi=180^{\circ}', 't(s)', 'x(t)');

% CSV
csv('3b_show_aliasing_detail', t_d, x(t_d, 475, phi), x(t_d, 7525, phi));
csv('3b_show_aliasing_sample', t, x(t, 7525, phi));
