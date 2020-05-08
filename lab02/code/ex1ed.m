init_workspace('1D: H(z) Frequency Graphs', 2, 2, 0, 0, exist('csv_write'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 1D,E: Frequency Graphs
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine H
h_num = [0 0.2];
h_den = [1 -0.7 -0.18];
[h_z, h_p, h_k] = zpkdata(tf(h_num, h_den, 1), 'v');


% Space
space = [-pi : pi/128 : pi];
nspace = space ./ pi;

% Without (z = 1) pole
h_res = freqz(h_num, h_den, space);
% With (z = 1)
[a, b] = zp2tf(h_z, [h_p; 1], h_k);
h_e_res = freqz(a, b, space);


% Convert response to amplitude/phase
todb   = @(res) 20*log10(abs(res));
todeg  = @(res) (180/pi) .* unwrap(angle(res));

h_db   = todb(h_res);
h_ph   = todeg(h_res);
h_e_db = todb(h_e_res);
h_e_ph = todeg(h_e_res);


% Plot
plot_continuous('H(Z)', 1, nspace, h_db);
plot_continuous('H(Z)', 2, nspace, h_ph);

plot_continuous('H(Z) \\w z=1', 3, nspace, h_e_db);
plot_continuous('H(Z) \\w z=1', 4, nspace, h_e_ph);

plot_name(1, 'H(Z)', 'Norm. Frequency (\times\pi rad/sample)', 'Magnitude (dB)');
plot_name(2, 'H(Z)', 'Norm. Frequency (\times\pi rad/sample)', 'Phase (degrees)');
plot_name(3, 'H(Z) with z = 1 pole.', 'Norm. Frequency (\times\pi rad/sample)', 'Magnitude (dB)');
plot_name(4, 'H(Z) with z = 1 pole.', 'Norm. Frequency (\times\pi rad/sample)', 'Phase (degrees)');

% Export
csv('h', nspace, h_db, h_ph);
csv('h_e', nspace, h_e_db, h_e_ph);
