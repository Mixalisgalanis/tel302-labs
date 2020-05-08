init_workspace('2a: Multiple Order Low Pass FIRs', 1, 2, 0, 0, exist('csv_write'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 2a: Multiple Order Low Pass FIRs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wc = 0.5 * pi;
Fs = 100;
Wn = wc / pi;
L = 512;

f_h = @(N, win_type) freqz(fir1(N - 1, Wn, 'low', win_type(N)), 1, L, Fs);

WINT = {{'Hamming', @hamming}, {'Hanning', @hanning}};
NT = [21, 41];

for i=1:length(NT)
  N = NT(i);
  for w=WINT
    [h, f] = f_h(N, w{1}{2});
    plot_custom(sprintf('%s with N=%d', w{1}{1}, N), i, @semilogy, f, abs(h));
    csv(sprintf('ex2a_%d_%s_%d', Fs, w{1}{1}, N), f.', abs(h).');
  end
  plot_name(i, sprintf('Frequency Response, N=%d', N), 'f [Hz]', '|H(f)|');
end
