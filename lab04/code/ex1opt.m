init_workspace('1: Low Pass FIR', 2, 1, 0, 0, exist('csv_write'));

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

WINT = {{'Rectangular', @rectwin}, {'Hamming', @hamming}};
for w=WINT
  fl = 512;
  f = -Fs/2:Fs/(fl-1):Fs/2;
  t=[-(N-1)/2:(N-1)/2]/Fs;
  
  win_type = w{1}{2};
  x = win_type(N).';
  X = abs(2 * fftshift(fft(x, fl) / fl));
  
  plot_discrete(w{1}{1}, 1, t, x);
  plot_custom(w{1}{1}, 2, @semilogy, f, X);
  csv(sprintf('ex1opt_%s', w{1}{1}), t, x);
  csv(sprintf('ex1opt_%s_F', w{1}{1}), f, X);
end
plot_name(1, 'Impulse Response', 't [s]', 'h(t)');
plot_name(2, 'Frequency Response', 'f [Hz]', '|H(f)|');
