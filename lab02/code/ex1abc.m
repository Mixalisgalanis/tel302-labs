init_workspace('1A-C: Z Transfer Function', 1, 2, 0, 0, exist('csv_write'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 1A-C: Z Transfer Function
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fs = 1;
Ts = 1 / Fs;

% G_1 = 0.2/(1 - 0.9z-1)
g1_num = [0.2];
g1_den = [1 -0.9];
G1 = tf(g1_num, g1_den, Ts);

% G_2 = (0 + z-1)/(1 + 0.2z-1)
g2_num = [0 1];
g2_den = [1 0.2];
G2 = tf(g2_num, g2_den, Ts);

% H = (0 + 0.2z-1)/(1 - 0.7z-1 - 1.8z-2)
h_num = [0 0.2];
h_den = [1 -0.7 -0.18];
H_TF = tf(h_num, h_den, Ts);

H_ML = G1 .* G2;

% Find Zeros/Poles
[h_z, h_p, h_k]          = zpkdata(H_TF, 'v');
[h_ml_z, h_ml_p, h_ml_k] = zpkdata(H_ML, 'v');

plot_get(1);
zplane(h_z, h_p);
title('H(Z) Pole/Zero Plot with manual solution')
plot_get(2);
zplane(h_ml_z, h_ml_p);
title('H(Z) Pole/Zero Plot with multiplication')
