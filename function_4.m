function [fig2, fig3, fig4, table_entries] = function_4(stor1, stor2, stor3, stor4)
% this is the rewritten version of the repeat_sims_fig.m script. It's
% purpose is to unpack the information from function_3 (the sig and sens
% data for multiple realizations of the models) and visualize it in the
% pre-discussed way.

% Throughout we have changed the variance to standard deviation; however,
% we have not changed the original variable names to highlight that the
% standard deviation rather than variance is being computed.

% THESE VALUES NEED TO MATCH WHATS IN FUNCTION_3
ws_min = 5;
ws_max = 50;
res = 10;

win_range = linspace(ws_min, ws_max, res);


% plot data and extract info for table for models 1 and 2
[taus1, ps1] = extract_info(stor1, res);
[T1, P1] = mean_and_var_and_sig_percent(taus1, ps1, res);

[taus2, ps2] = extract_info(stor2, res);
[T2, P2] = mean_and_var_and_sig_percent(taus2, ps2, res);

rows = 2;
columns = 6;
EWSignals = {'Standard Deviation', 'Skewness', 'acf', 'AR(1)', '$\sigma_1$',...
    '$\sigma_1 / \sqrt{\sigma_1^2 + \dots + \sigma_n^2}$', 'Spatial Variance',...
    'Spatial Skewness', 'Spatial Correlation'};
ylabels = {'$\tau$', '$\tau_{\mathrm{sig}}$ (\%)'};

% figure 2
fig2 = figure('windowstate', 'maximized');
% Check if tight_subplot() is installed
addons = matlab.addons.installedAddons;
tight_subplot_installed = any(strcmp(addons.Name, 'tight_subplot(Nh, Nw, gap, marg_h, marg_w)'));
if tight_subplot_installed
    ha = tight_subplot(rows, columns, [0, 0.05], 0.2, 0.1);
else
    ax = zeros(rows*columns, 1);
end
for m = 1:rows
    for k = 1:columns
        im_num = (m-1)*columns + k;
        % subplot axes
        if tight_subplot_installed
            axes(ha(im_num));
        else
            ax(im_num) = subplot(rows, columns, im_num);
        end
        if m == rows
            plot(win_range, P1{k}, 'r', 'LineWidth', 2);
            hold on
            plot(win_range, P2{k}, 'b', 'LineWidth', 2);
            hold off
            ylim([0, 105]);
        else
            % plot the tau information
            errorbar(win_range, T1{k}(1,:), (T1{k}(2,:)), 'r', 'LineWidth', 2);
            hold on
            errorbar(win_range, T2{k}(1,:), (T2{k}(2,:)), 'b', 'LineWidth', 2);
            hold off
            ylim([-1, 1]);
        end
        xlim([win_range(1), win_range(end)]);
        if k == 1
            ylabel(ylabels{m}, 'Interpreter', 'latex', 'fontsize', 28);
        end
        if m == 1
            title(EWSignals{k}, 'Interpreter', 'latex', 'fontsize', 22);
        end
        pbaspect([1,1,1]);
    end
end

% additional labelling info
han=axes(fig2,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel(han,'Window Size (\%)', 'Interpreter', 'latex', 'fontsize', 26);
han.XLabel.Position = [0.5, 0.13, 0];
annotation('textbox',[0.3, 0.82, 0, 0],'string', 'Temporal EWS','FitBoxToText','on', 'FontSize', 20,'EdgeColor','white', 'Interpreter', 'latex');
annotation('textbox',[0.73, 0.82, 0, 0],'string', 'Multivariate EWS','FitBoxToText','on', 'FontSize', 20,'EdgeColor','white', 'Interpreter', 'latex');
h = 0.79;
a1 = annotation('line', [0.1, 0.62], [h, h]);
a2 = annotation('line', [0.66, 0.905], [h, h]);
a1.LineWidth = 0.5;
a2.LineWidth = 0.5;

exportgraphics(gcf, 'Fig2.pdf', 'ContentType', 'vector');


% figure 3
ws_min = 25;
ws_max = 50;
res = 11;
win_range = linspace(ws_min, ws_max, res);


[taus3, ps3] = extract_info(stor3, res);
[T3, P3] = mean_and_var_and_sig_percent(taus3, ps3, res);

fig3 = figure('windowstate', 'maximized');
if tight_subplot_installed
    ha = tight_subplot(rows, columns, [0, 0.05], 0.2, 0.1);
else
    ax = zeros(rows*columns, 1);
end
for m = 1:rows
    for k = 1:columns
        im_num = (m-1)*columns + k;
        % subplot axes
        if tight_subplot_installed
            axes(ha(im_num));
        else
            ax(im_num) = subplot(rows, columns, im_num);
        end
        if m == rows
            plot(win_range, P3{k}, 'k', 'LineWidth', 2);
            ylim([0, 105]);
        else
            % plot the tau information
            errorbar(win_range, T3{k}(1,:), (T3{k}(2,:)), 'k', 'LineWidth', 2);
            ylim([-1, 1]);
        end
        xlim([win_range(1), win_range(end)]);
        if k == 1
            ylabel(ylabels{m}, 'Interpreter', 'latex', 'fontsize', 28);
        end
        if m == 1
            title(EWSignals{k}, 'Interpreter', 'latex', 'fontsize', 22);
        end
        pbaspect([1,1,1]);
    end
end

% additional labelling info
han=axes(fig3,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel(han,'Window Size (\%)', 'Interpreter', 'latex', 'fontsize', 26);
han.XLabel.Position = [0.5, 0.13, 0];
annotation('textbox',[0.3, 0.82, 0, 0],'string', 'Temporal EWS','FitBoxToText','on', 'FontSize', 20,'EdgeColor','white', 'Interpreter', 'latex');
annotation('textbox',[0.73, 0.82, 0, 0],'string', 'Multivariate EWS','FitBoxToText','on', 'FontSize', 20,'EdgeColor','white', 'Interpreter', 'latex');
h = 0.79;
a1 = annotation('line', [0.1, 0.62], [h, h]);
a2 = annotation('line', [0.66, 0.905], [h, h]);
a1.LineWidth = 0.5;
a2.LineWidth = 0.5;

exportgraphics(gcf, 'Fig3.pdf', 'ContentType', 'vector');


ws_min = 25;
ws_max = 50;
res = 10;

win_range = linspace(ws_min, ws_max, res);


% figure 4
[taus4, ps4] = extract_info(stor4, res);
[T4, P4] = mean_and_var_and_sig_percent(taus4, ps4, res);

fig4 = figure('windowstate', 'maximized');
ylabels = {'$\tau$', '$p$'};
if tight_subplot_installed
    ha = tight_subplot(rows, columns, [0, 0.05], 0.2, 0.1);
else
    ax = zeros(rows*columns, 1);
end
for m = 1:rows
    for k = 1:columns
        im_num = (m-1)*columns + k;
        % subplot axes
        if tight_subplot_installed
            axes(ha(im_num));
        else
            ax(im_num) = subplot(rows, columns, im_num);
        end
        if m == rows
            plot(win_range, ps4{k}, 'k', 'LineWidth', 2);
            hold on;
            yl = yline(0.05, "LineStyle",":", "Color","r", "LineWidth", 2);
            if k < 6
                ylim([0, 0.06]);
            end
        else
            % plot the tau information
            plot(win_range, T4{k}(1,:), 'k', 'LineWidth', 2);
            ylim([-1, 1]);
        end
        xlim([win_range(1), win_range(end)]);
        if k == 1
            ylabel(ylabels{m}, 'Interpreter', 'latex', 'fontsize', 28);
        end
        if m == 1
            title(EWSignals{k}, 'Interpreter', 'latex', 'fontsize', 22);
        end
        pbaspect([1,1,1]);
    end
end

% additional labelling info
han=axes(fig4,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel(han,'Window Size (\%)', 'Interpreter', 'latex', 'fontsize', 26);
han.XLabel.Position = [0.5, 0.13, 0];
annotation('textbox',[0.3, 0.82, 0, 0],'string', 'Temporal EWS','FitBoxToText','on', 'FontSize', 20,'EdgeColor','white', 'Interpreter', 'latex');
annotation('textbox',[0.73, 0.82, 0, 0],'string', 'Multivariate EWS','FitBoxToText','on', 'FontSize', 20,'EdgeColor','white', 'Interpreter', 'latex');
h = 0.79;
a1 = annotation('line', [0.1, 0.62], [h, h]);
a2 = annotation('line', [0.66, 0.905], [h, h]);
a1.LineWidth = 0.5;
a2.LineWidth = 0.5;

exportgraphics(gcf, 'Fig4.pdf', 'ContentType', 'vector');



% GET VALS FOR THE TABLE
table_entries = zeros(3, 12);
for k = 7:9
    table_entries(k-6, 1) = T1{k}(1,1); % this is the MEAN tau value for model 1 for the window invariant EWS
    table_entries(k-6, 2) = T1{k}(2,1); % this is the VARIANCE of the tau value for model 1 
    table_entries(k-6, 3) = P1{k}(1); % this is the percentage of significant tau values
    table_entries(k-6, 4) = T2{k}(1,1);
    table_entries(k-6, 5) = T2{k}(2,1);
    table_entries(k-6, 6) = P2{k}(1);
    table_entries(k-6, 7) = T3{k}(1,1);
    table_entries(k-6, 8) = T3{k}(2,1);
    table_entries(k-6, 9) = P3{k}(1);
    table_entries(k-6, 10) = T4{k}(1,1); % this just returns the tau val
    table_entries(k-6, 12) = ps4{k}(1); % this is just the p val (repeated for all ws)
end

table_entries = round(table_entries .* 10^3) / 10^3;


function [tau_results_per_EWS, p_results_per_EWS] = mean_and_var_and_sig_percent(taus, ps, res)
    % need a function to compute the variance and mean of the taus for the res
    
    % the input for this 
    alpha = 0.05;
    
    tau_results_per_EWS = {};
    p_results_per_EWS = {};
    num_EWS = 9;
    for i = 1:num_EWS

        tau_mean_vars = zeros(2, res);
        p_sig_percent = zeros(1, res);
    
        for j = 1:res
    
            % for each res (for a given EWS) work out the mean tau and the
            % variance of the taus
        
            tau_mean_vars(1, j) = mean(taus{i}(:,j));
            tau_mean_vars(2, j) = std(taus{i}(:,j));

            p_range_jth_res_ith_EWS = ps{i}(:,j);
            place_holder = p_range_jth_res_ith_EWS;

            p_sig_percent(j) = 100 * (numel(place_holder(place_holder <= alpha)) / numel(place_holder));
    
        end
    
        tau_results_per_EWS{i} = tau_mean_vars;
        p_results_per_EWS{i} = p_sig_percent;
    end

end

function [taus, ps] = extract_info(stor, res)
    % these outputs contain for each EWS, the taus and ps arranged according to
    % res and simulation (i.e. a row will correspond taus for all simulations
    % for a window size, and the columns will contain the taus for all window
    % sizes for a given simulation
    taus = {};
    ps = {};
    num_sims = numel(stor);

    num_EWS = 9;
    for i = 1:num_EWS
    
        t_sims_X_res_for_ith_EWS = zeros(num_sims, res);
        p_sims_X_res_for_ith_EWS = zeros(num_sims, res);
    
        for j = 1:num_sims
        
            output = stor{j};
            sens_data = output.sens_data;
            sig_data = output.sig_data;
    
            % get the taus and ps for the ith EWS
            % these are both row vectors 1(row)xres(columns) in size
            tau_ith_EWS = sens_data(i, :);
            p_ith_EWS = sig_data(i, :);
    
            % store them
            t_sims_X_res_for_ith_EWS(j, :) = tau_ith_EWS;
            p_sims_X_res_for_ith_EWS(j, :) = p_ith_EWS;
    
        end
        
        % store the taus and ps for the ith EWS (each contains the tau per
        % window and simulation
        taus{i} = t_sims_X_res_for_ith_EWS;
        ps{i} = p_sims_X_res_for_ith_EWS;
    
    end
end

end

