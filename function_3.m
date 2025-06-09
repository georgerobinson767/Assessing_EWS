function [stor1, stor2, stor3, stor4] = function_3(num_sims, num_cores)

% create a parpool
if isempty(gcp("nocreate"))
    parpool(num_cores)
end

stor1 = {};
stor2 = {};
stor3 = {};
stor4 = {};

% model 1
parfor i = 1:num_sims

    [spat_data, ~, temp_data] = synthetic_data('MODEL1', 20, 0.01, 0.01, 1000, 1.2, 0, 0);

    tau_bounds = [0.6, 1];
    bif_bounds = [0, 1.2];
    win_range = [5, 50];
    res = 10;

    [sens_data, sig_data] = function_2(res, tau_bounds, bif_bounds, spat_data, temp_data, win_range);

    output = struct();
    output.sens_data = sens_data;
    output.sig_data = sig_data;
    stor1{i} = output;

end

% model 2
parfor i = 1:num_sims

    [spat_data, ~, temp_data] = synthetic_data('MODEL7', 20, 0.01, 0.01, 1000, 1.2, 0, 0);

    tau_bounds = [0.52, 0.92];
    bif_bounds = [0, 1.2];
    win_range = [5, 50];
    res = 10;

    [sens_data, sig_data] = function_2(res, tau_bounds, bif_bounds, spat_data, temp_data, win_range);

    output = struct();
    output.sens_data = sens_data;
    output.sig_data = sig_data;
    stor2{i} = output;

end

% harvest model
N = 10;
temp_res = 40;
parfor i = 1:num_sims

    [spat_data, ~, temp_data] = synthetic_data('harvest', N, 0.001, 0.1, temp_res, 3, 0, 1);

    tau_bounds = [1, 2.55];
    bif_bounds = [1, 3];
    win_range = [25, 50];
    res = 11;

    [sens_data, sig_data] = function_2(res, tau_bounds, bif_bounds, spat_data, temp_data, win_range);

    output = struct();
    output.sens_data = sens_data;
    output.sig_data = sig_data;
    stor3{i} = output;

end

delete(gcp("nocreate"))
 
% transect data
% now also do the transect data, note: there are not repeated realisations
% of a model
course_grain_div = 5;
slide_int = 83;
[spat_data, temp_data] = course_grain(course_grain_div, slide_int);

tau_bounds = [0, 36]; % figure out what the tau bounds should be
bif_bounds = [0, numel(temp_data) - 1];
win_range = [25, 50];
res = 10;

[sens_data, sig_data] = function_2(res, tau_bounds, bif_bounds, spat_data, temp_data, win_range);

output = struct();
output.sens_data = sens_data;
output.sig_data = sig_data;

stor4{1} = output;

end
