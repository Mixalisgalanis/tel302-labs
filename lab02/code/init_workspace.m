function init_workspace(fig_title, row, col, clear_vars, fig, csv_export)
% load_functions  Initialises the code environment with shared functions
%

if clear_vars
  clear global;
end

% Handle Figures based on input
switch fig
  case -1
    % Nothing
  case 0
    % Clear current figure only and rename
    clf(gcf)
    set(gcf, 'Name', fig_title)
  case 1
    % Clear and Recreate
    close all;
    figure('Name', fig_title)
  case 2
    % Add new figure
    figure('Name', fig_title)
end
clf;

% Subplots
ho = @() evalc('hold on'); % Hold on has no output so we force one with evalc.
plot_get        = @(num) subplot(row, col, num);
plot_discrete   = @(plot_title, num, varargin) {subplot(row, col, num), stem(varargin{:}, 'DisplayName', plot_title), ho(), title(plot_title)};
plot_continuous = @(plot_title, num, varargin) {subplot(row, col, num), plot(varargin{:}, 'DisplayName', plot_title), ho(), title(plot_title)};
plot_custom     = @(plot_title, num, comm, varargin) {subplot(row, col, num), comm(varargin{:}, 'DisplayName', plot_title), ho(), title(plot_title)};
plot_name       = @(num, plot_title, x_axis, y_axis) {subplot(row, col, num), title(plot_title), xlabel(x_axis), ylabel(y_axis), legend};

% CSV
if csv_export
  csv = @(name, varargin) csvwrite(sprintf('../csv/%s.csv', name),...
    cell2mat(cellfun(@transpose, varargin, 'un', 0)));
else
  csv = @(name, varargin) 0;
end

% Basic Functions
d = @(x) x == 0;
u = @(x) x >= 0;
r = @(x) x.*u(x);
rect = @(x) 1 * (abs(x) <= 0.5);

% Convolution
conv_time   = @(t1, t2, dt) (t1(1) + t2(1)):dt:(t1(end) + t2(end));
convolution = @(t1, x1, t2, x2, dt) deal(conv_time(t1, t2, dt), conv(x1, x2) * dt);


% Global Vars
assignin('base', 'plot_get', plot_get);
assignin('base', 'plot_discrete', plot_discrete);
assignin('base', 'plot_continuous', plot_continuous);
assignin('base', 'plot_custom', plot_custom);
assignin('base', 'plot_name', plot_name);
assignin('base', 'csv', csv);
assignin('base', 'd', d);
assignin('base', 'u', u);
assignin('base', 'r', r);
assignin('base', 'rect', rect);
assignin('base', 'conv_time', conv_time);
assignin('base', 'convolution', convolution);
