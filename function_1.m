function [taus, ps, EWS, fig] = function_1(spat_data, temp_data , window_percent, tau_bounds, bif_bounds, plotting, plot_mu)
% the purpose of this function is to input some data and a window size and
% compute EWS and then from the EWS compute and output kendalls tau and p
% values.

% Compute EWS from data for a given window_size;
EWS = new_ews_calc(spat_data, temp_data, window_percent);

% need to select what part of the EWS is to be used to compute kendall's
% tau, based on user input of the bifurcation parameter range and of the tau subset range of the bifurcation span which will be used to compute tau, then this
% can be passed into the Modified_MannKendall function to compute tau and
% p vals.
[subset, indices] = subset_ews(EWS, tau_bounds, bif_bounds);

% compute kendall's tau from the EWS subset
alpha = 0.05;
alpha_ac = alpha;
num_EWS = 9;
taus = zeros(num_EWS, 1);
ps = zeros(num_EWS, 1);

for i = 1:9
    % get the i'th EWS subset
    ith_subset = subset(i, :);
    
    % compute the t's and p's
    [tau, p, ~] = Modified_MannKendall_test(ith_subset, alpha, alpha_ac);

    % store them
    taus(i) = tau;
    ps(i) = p;
end

% plotting
if plotting == 1

    T = numel(temp_data);
    ws = floor(window_percent/100 * T);
    
    fig = figure('WindowState','maximized');
    EWSignals = {'Standard Deviation', 'Skewness', 'acf', 'AR(1)',...
        '$\sigma_1$', '$\sigma_1 / \sqrt{\sigma_1^2 + \cdots + \sigma_n^2}$', ...
        'Spatial Variance', 'Spatial Skewness', 'Spatial Correlation'};
    for i = 1:num_EWS
    
        if i <= 6
            array = ws:T;
        else
            array = 1:T;
        end
        tau_array = indices(1):indices(2);

    
        if strcmp(plot_mu, 'y')
            array_arg = invert(array, EWS, bif_bounds);
            tau_array_arg = invert(tau_array, EWS, bif_bounds);
        else
            array_arg = array;
            tau_array_arg = tau_array;
        end
    
        subplot(3, 3, i);
    
        if i == 1 || i == 5 || i ==7
    
            semilogy(array_arg, EWS(i, array));
            hold on
            semilogy(tau_array_arg, EWS(i, tau_array));
            hold off
    
        else
    
            plot(array_arg, EWS(i, array));
            hold on
            plot(tau_array_arg, EWS(i, tau_array));
            hold off
    
        end
    
        pbaspect([1.618, 1, 1]);
        ylabel(EWSignals{i}, 'Interpreter','latex', 'Fontsize', 20);
        % round taus for plotting
        round_taus = round(taus .* 10^3) / 10^3;
        title_string = ['$\tau = $', num2str(round_taus(i))];
        title(title_string, 'Interpreter','latex', 'Fontsize', 20);
    
    end
else
    fig = [];
end

exportgraphics(gcf, 'EWS_SLDS.pdf', 'ContentType', 'vector');

end

% mu -> Z
function [subset, indices] = subset_ews(EWS, tau_bounds, bif_bounds)

    % the purpose of this function is to take EWS and tau bounds are work out
    % the relative subset of the EWS that corresponds to the tau_bounds
    
    % get the bounds from the input argument
    mu_0 = bif_bounds(1);   % mu nought
    mu_f = bif_bounds(2);   % mu final

    % get the required length
    EWS_length = size(EWS, 2);
    L = EWS_length;     % renaming as L for math clarity
   
    % convert from mu space to integer space
    indices = round((L-1)/(mu_f - mu_0) * (tau_bounds - mu_0) + 1);
    subset = EWS(:, indices(1):indices(2));

end

% Z -> mu
function mu_based_array = invert(integer_array, EWS, bif_bounds)

    % get the bounds from the input argument
    mu_0 = bif_bounds(1);   % mu nought
    mu_f = bif_bounds(2);   % mu final

    % get the required length
    EWS_length = size(EWS, 2);
    L = EWS_length;     % renaming as L for math clarity

    mu_based_array = ((mu_f - mu_0)/(L-1)).*(integer_array - 1) + mu_0;

end