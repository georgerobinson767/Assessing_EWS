function [sens_data, sig_data] = function_2(res, tau_bounds, bif_bounds, spat_data, temp_data, win_range)

% for an array of window sizes, specified by the window_range and the
% resolution, this will store a range of taus and p's for each window size
num_EWS = 9;
sig_data = zeros(num_EWS, res);
sens_data = zeros(num_EWS, res);

ws_min = win_range(1);
ws_max = win_range(2);

window_range = linspace(ws_min, ws_max, res);

for i = 1:res

    window_percent = window_range(i);
    
    [taus, ps, ~, ~] = function_1(spat_data, temp_data , window_percent, tau_bounds, bif_bounds, 0, 'n');

    sens_data(:, i) = taus;
    sig_data(:, i) = ps;

end