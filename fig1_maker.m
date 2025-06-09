function [fig1] = fig1_maker()

% this code plots the three spatial means 

required_size_lungs = 1000;
required_size_harvest = 40;

[~, ~, temp1] = synthetic_data('MODEL1', 20, 0.01, 0.01, required_size_lungs, 1.2, 0, 0);

[~, ~, temp2] = synthetic_data('MODEL7', 20, 0.01, 0.01, required_size_lungs, 1.2, 0, 0);

[~, ~, temp3] = synthetic_data('harvest', 100, 0.001, 0.1, required_size_harvest, 3, 0, 1);

[~, temp4, ~] = course_grain(5, 83);
%%
fig1 = figure('WindowState','maximized');

ha = tight_subplot(2, 2, [0.1, 0.1], 0.05, 0.15);

spat_means = {temp1, temp2, temp3, temp4};

kappa_vals = linspace(0, 1.2, required_size_lungs);

c_vals = linspace(1, 3, required_size_harvest);

transect_time_vals = 0:numel(temp4) - 1;

titles = {'Airway SLDS', 'Airway SPDE', 'Harvest', 'Transect 5'};
for idx = 1:4

    axes(ha(idx));

    if idx < 3
        sc = scatter(kappa_vals,spat_means{idx});
        xlabel('$\kappa$', 'Interpreter','latex');
        xlim([min(kappa_vals), max(kappa_vals)]);
    elseif idx == 3
        sc = scatter(c_vals, spat_means{idx});
        xlabel('$c$', 'Interpreter','latex');
        xlim([min(c_vals), max(c_vals)]);
    else
        sc = scatter(transect_time_vals, spat_means{idx});
        xlabel('Lattice index', 'Interpreter','latex');
        xlim([min(transect_time_vals), max(transect_time_vals)]);
    end
    sc.LineWidth = 2.5;
    sc.Marker = "o";
    %sc.MarkerFaceColor = "auto";
    sc.SizeData = 60;

    hold on
    if idx == 1
        rec = rectangle(Position=[0.6,-1, 0.4,9], FaceColor='red', EdgeColor=[1,1,1] , FaceAlpha=0.1);
        xl = xline(1.03, "LineStyle",":", "Color","k", "LineWidth", 2);
 
    elseif idx == 2
        rec = rectangle(Position=[0.52,-1, 0.4,9], FaceColor='red', EdgeColor=[1 1 1], FaceAlpha=0.1);
        xl = xline(0.95, "LineStyle",":", "Color","k", "LineWidth", 2);

    elseif idx == 3
        rec = rectangle(Position=[1,-1, 1.55,11], FaceColor='red', EdgeColor=[1 1 1], FaceAlpha=0.1);
        xl = xline(2.6, "LineStyle",":", "Color","k", "LineWidth", 2);

    elseif idx == 4
        rec = rectangle(Position=[0,-1, 36,11], FaceColor='red', EdgeColor=[1 1 1], FaceAlpha=0.1);
        xl = xline(36, "LineStyle",":", "Color","k", "LineWidth", 2);

    end
    xl.LineWidth = 3.5;
    rec.EdgeColor = 'none';
    

    % xl.Label = 'Observed Tipping Point';
    % if idx < 3
    % 
    %     xl.LabelVerticalAlignment = "bottom";
    % else
    %     xl.LabelVerticalAlignment = "top";
    % end
    % xl.LabelHorizontalAlignment = "right";
    % xl.FontSize = 14;


    ylabel('Spatial Mean', 'Interpreter','latex', 'FontSize', 24);

    ylim([0 max(spat_means{idx})]);

    title(titles{idx}, 'Interpreter', 'latex', 'fontsize', 22)
    box on;
    pbaspect([1.6,1,1]);
end

han=axes(fig1,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='off';

% xlabel(han,'Bifurcation Parameter', 'Interpreter', 'latex', 'fontsize', 22);
han.XLabel.Position = [0.5, 0.1, 0];

exportgraphics(gcf, 'Fig1.pdf', 'ContentType', 'vector');

end

