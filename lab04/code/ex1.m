init_workspace('1: Low Pass FIR', 1, 1, 0, 0, exist('csv_write'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 1: Low Pass FIR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wc = 0.4 * pi;
Fs = 100;
N = 21;

Wn = wc / pi;
L = 512;

f_h = @(win_type) freqz(fir1(N - 1, Wn, 'low', win_type(N)), 1, L, Fs);

WINT = {{'Rectangular', @rectwin}, {'Hamming', @hamming}};
for w=WINT
  [h, f] = f_h(w{1}{2});
  plot_continuous(w{1}{1}, 1, f, abs(h));
  csv(sprintf('ex1_%s', w{1}{1}), f.', abs(h).');
end
plot_name(1, 'Frequency Response', 'f [Hz]', '|H(f)|');
