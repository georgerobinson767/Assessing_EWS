function [spat_data, temp_data, raw_data] = course_grain(course_grain_div, slide_int)

% commments on function inputs
% these are the two inputs two the function

% CONTROLS THE 'TEMPORAL' RESOLUTION (NUMBER OF SNAPSHOTS)
% slide_int = 80;, (80 works well)
% this variable is the sliding window along the spatial dimension

% CONTROLS THE SPATIAL RESOLUTION (WIDTH OF SNAPSHOTS)
% course_grain_div = 10;, (10 works well)
% this variable divides the total width (250) into the course grained
% matrix (i.e 10x10 -> 1, when the divior = 10).

% This will preprocess a spatio-spatial data set into a course grained
% spatio-'temporal' data set

% read/import data
raw_data = readmatrix("tran5_veg_30m.csv");

% make snapshot data
sizes = size(raw_data);
N = sizes(2);
indexes = 1 : slide_int : sizes(1) - N;
num_snaps = numel(indexes);
snapshot_data = zeros(N, N, num_snaps);
counter = 0;
for ii = indexes
    counter = counter + 1;
    snapshot_data(:,:, counter) = raw_data(ii : ii +  N - 1, :);
end

% replace -9999 with zeros.
snapshot_data(snapshot_data == -9999) = 0;

% use first 250 entries (because the snapshot data is 251 x 251 for some
% reason?)
snapshot_data = snapshot_data(1:250, 1:250, :);

% mean
snapshot_means = mean(snapshot_data, [1,2]);
snapshot_means = squeeze(snapshot_means);
temp_data = snapshot_means;

% figure;
% plot(0:num_snaps-1, snapshot_means);
% xlim([0 num_snaps-1]);

% course graining
num_cells = floor(N/course_grain_div);
% if ~isint64(N/course_grain_div)
%     warning("The course grain divisor does not divide the width of the transect, please consider another divisor");
% end
course_grained_data = zeros(num_cells, num_cells, num_snaps);
for ii = 1:num_snaps
    grid = snapshot_data(:,:,ii);
    course_grained = zeros(num_cells, num_cells);
    for jj = 1:num_cells
        for kk = 1:num_cells
            subgrid = grid((jj-1)*course_grain_div+1 : jj*course_grain_div, ... 
                (kk-1)*course_grain_div+1 : kk*course_grain_div);
            course_grained(jj, kk) = sum(sum(subgrid))/course_grain_div^2;
        end
    end
    course_grained_data(:,:,ii) = course_grained;
end
spat_data = course_grained_data;

end