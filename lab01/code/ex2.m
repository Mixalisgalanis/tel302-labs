init_workspace('2: Nyquist', 4, 1, 0, 0, exist('csv_write'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 2: Nyquist
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x Nyquist is 1/24 b/c cos has 12Hz freq
x = @(t) 5*cos(24*pi*t) - 2*sin(1.5*pi*t);
Dt = 0.001;
t_dt = @(Dt) 0:Dt:0.5;

t = t_dt(Dt);
plot_continuous('x(t)', 1, t, x(t));
csv('2_detail', t, x(t));

FS = [48 24 12];

% Plot and CSV
for i=1:length(FS)
  ts = t_dt(1/FS(i));
  plot_continuous(sprintf('x(t) with t_s=1/%d', FS(i)), i + 1, t, x(t));
  hold on;
  stem(ts, x(ts));
  hold off;

  csv(sprintf('2_fs_%d', FS(i)), ts, x(ts));
end
