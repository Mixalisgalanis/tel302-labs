init_workspace('2b: FIR Filter Application', 2, 2, 0, 0, exist('csv_write'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 2a: Multiple Order Low Pass FIRs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wc = 0.5 * pi / 100;
Fs = 100;
Wn = wc / pi;

% Spectrum
fl = 1024;
spectrum = @(X) abs(2 * fftshift(fft(X, fl) / fl));
f = -Fs/2:Fs/(fl-1):Fs/2;

L = 2048;
xt = @(t) sin(15*t) + 0.25*sin(200*t);
t = (1:(L - 1)) / Fs;
x = xt(t);
X = spectrum(x);
csv(sprintf('ex2b_X_%d', Fs), f, X);

% Filter Settings
apply_filter = @(N, win_type, x) filter(fir1(N - 1, Wn, 'low', win_type(N)), 1, x);
WINT = {{'Hamming', @hamming}, {'Hanning', @hanning}};
NT = [21, 41];

for i=1:length(NT)
  N = NT(i);
  for j=1:length(WINT)
    w = WINT{j};
    X_f = spectrum(apply_filter(N, w{2}, x));

    % Plot
    plot_custom('X', 2*(j-1) + i, @semilogy, f, X);
    plot_custom(sprintf('%s, N=%d', w{1}, N), 2*(j-1) + i, @semilogy, f, X_f);
    plot_name(2*(j-1) + i, sprintf('%s Window, N=%d', w{1}, N), 'f [Hz]', '|X(f)|');
    csv(sprintf('ex2b_%d_%s_%d', Fs, w{1}, N), f, X_f);
  end
end
