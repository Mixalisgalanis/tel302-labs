init_workspace('1: Butterworth', 1, 1, 0, 0, exist('csv_write'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 1: Butterworth
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs = 10e3;
Rpass = 3;

fpass = 3e3;
fstop = 4e3;

Wpass = 2*pi*fpass;
Wstop = 2*pi*fstop;

for i=[0,1]
  if i == 0
    Rstop = 30;
  else
    Rstop = 50;
  end

  [N, Wn] = buttord(Wpass, Wstop, Rpass, Rstop, 's');
  fprintf('Rstop = %d has N = %d\n', Rstop, N);

  % Use buttap
  [z, p, k] = buttap(N);
  [B_norm, A_norm] = zp2tf(z, p, k);
  [B_a, A_a] = lp2lp(B_norm, A_norm, Wn);

  [B_d, A_d] = bilinear(B_a, A_a, fs);

  Nf = 2048;
  f = linspace(0, fs/2, Nf);
  h_a = freqs(B_a, A_a, 2*pi*f);
  h_d = freqz(B_d, A_d, f, fs);

  % Convert response to amplitude/phase
  todb   = @(res) 20*log10(abs(res));
  todeg  = @(res) (180/pi) .* unwrap(angle(res));

  h_db   = todb(h_a);
  h_ph   = todeg(h_a);
  h_d_db = todb(h_d);
  h_d_ph = todeg(h_d);

  % Plot
  line_style = isel(i, 0, '-', 1, '--');
  plot_continuous(sprintf('H(j\\Omega), R_{stop}=%ddB', Rstop), 1, f, h_db, line_style);
  plot_continuous(sprintf('H(z),   R_{stop}=%ddB', Rstop), 1, f, h_d_db, line_style);

  csv(sprintf('ex1_s_db_%d', Rstop), f, h_db);
  csv(sprintf('ex1_s_ph_%d', Rstop), f, h_ph);

  csv(sprintf('ex1_d_db_%d', Rstop), f, h_d_db);
  csv(sprintf('ex1_d_ph_%d', Rstop), f, h_d_ph);
end

plot_name(1, 'Butterworth Frequency Response', 'f(hz)', 'Magnitude (dB)');
ylim([-400 20])
legend('Location', 'southwest')
