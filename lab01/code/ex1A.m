init_workspace('1A: Discrete Convolution', 4, 1, 0, 0, exist('csv_write'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 1A: Discrete Convolution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xt = @(t) sin((2*pi*t)/30);

% Signals
nx = 0:60;
x = xt(nx);

nh = -8:30;
h = (nh).^2;

% Conv time
ny = nx(1)+nh(1):nx(end)+nh(end);

% Lengths
LenY = length(ny);
LenX = length(x);
LenH = length(h);

X0 = [zeros(1, LenH-1) x zeros(1, LenH-1)];
nx0 = nx(1)-(LenH-1):nx(end)+(LenH-1);

% Convolution
h_rev = h(end:-1:1);
y = zeros(1, LenY);
for i=1:LenY
  h_rev0 = [zeros(1,(i-1)) h_rev zeros(1,(LenY-i))];
  y(i) = sum(X0.*h_rev0);
end

% Plot
plot_discrete('x', 1, nx, x);
plot_discrete('h', 2, nh, h);
plot_discrete('manual conv', 3, ny, y);

[tc, yc] = convolution(nx, x, nh, h, 1);
plot_discrete('builtin conv', 4, tc, yc);

% CSV
csv('1a_x', nx, x);
csv('1a_h', nh, h);
csv('1a_conv_manual', ny, y);
csv('1a_conv_builtin', tc, yc);
