init_workspace('2: Chebyshev', 1, 1, 0, 0, exist('csv_write'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 2: Chebyshev
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W_c = 2;
Ts = 0.2;
R = 3;
fs = 1 / Ts;

for i=[0, 2]
  if i == 0
    N = 2;
  else
    N = 16;
  end

  [B, A] = cheby1(N, R, W_c / (pi*fs), 'high');

  Nf = 2048;
  f = linspace(0, fs / 2, Nf);
  h = freqz(B, A, f, fs);

  % Convert response to amplitude/phase
  todb   = @(res) 20*log10(abs(res));
  todeg  = @(res) (180/pi) .* unwrap(angle(res));

  h_db   = todb(h);
  h_ph   = todeg(h);

  % Normalise Frequency because it is required
  f = 2 * f / fs;

  % Plot
  line_style = isel(i, 0, '--', 1, '-');
  plot_continuous(sprintf('H(z), N=%d', N), 1, f, h_db, line_style);
  csv(sprintf('ex2_db_%d', N), f, h_db);
  csv(sprintf('ex2_ph_%d', N), f, h_ph);
end

plot_name(1, 'Magnitude of Chebyshev', 'f(hz)', 'Magnitude (dB)');
ylim([-220 10])
legend('Location', 'southeast')
