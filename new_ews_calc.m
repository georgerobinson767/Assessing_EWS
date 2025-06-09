function EWS = new_ews_calc(spat_data, temp_data, window_percent)

% This 'new_ews_simple' computes all the EWS without the complications of
% the SpaTEWS package.

ws = floor(window_percent/100 * numel(temp_data));

temp_EWS = zeros(4, numel(temp_data));
for i = ws : numel(temp_data)

    % window indices
    window = i-ws+1 : i;
    % select a data of window
    window_data = temp_data(window);
    % fit a linear regression to the window
    out = fitlm(window, window_data);
    % difference between data in window and fitted model
    res = window_data - out.Fitted;

    % NOW COMPUTE THE TEMP EWS FOR THE RES IN THE WINDOW
    % standard deviation
    standard_div = std(res);
    temp_EWS(1,i) = standard_div;

    % skewness
    skew = skewness(res);
    temp_EWS(2,i) = skew;

    % Autocorrelation function coefficient
    n = numel(res);
    lag = 1;
    Xt = res(1+lag:end);
    Xt_lagged = res(1:end-lag);
    mu = mean(res);
    sigma = std(res);
    rho = (1/(n-1)) * (sum((Xt - mu).*(Xt_lagged - mu))/sigma^2);
    temp_EWS(3, i) = rho;

    % AR(1) coefficient 
    % Perform linear regression 
    model = fitlm(Xt_lagged, Xt); 
    % Extract the AR(1) coefficient 
    a1 = model.Coefficients.Estimate(2);
    temp_EWS(4, i) = a1;
end

% spatial EWS
spat_EWS = zeros(5, numel(temp_data));
N = size(spat_data, 1);
T = numel(temp_data);

% Make the adjacency matrix W for the Moran's I computation
[ii,jj] = meshgrid(1:N,1:N);
A = zeros(N,N);
B = zeros(N,N);
C = zeros(N,N);
diagonal = (ii==jj);
neighbours = (ii==jj+1) | (ii==jj-1);
corners = ((ii==1) & (jj==N)) | ((ii==N) & (jj==1));
A(diagonal) = 0;
A(neighbours) = 1;
A(corners) = 1;
B(diagonal) = 1;
% Create row of W
W_row = [];
for ii = 1:N
    if ii == 1
        element = A;
    elseif ii == 2 || ii == N
        element = B;
    else
        element = C;
    end
    W_row = [W_row, element];
end
% Make W
W = W_row;
for ii = 1:N-1
    W_row = circshift(W_row, [0 N]);
    W = [W; W_row];
end

detrended_spatial_data = zeros(size(spat_data));
for i = 1:T
    % detrend (remove spatial mean - uniformely)
    spat_mean = sum(sum(spat_data(:,:,i)))/N^2;
    spat_data_i = spat_data(:,:,i) - spat_mean;

    % store the detrended spatial data for when computing the eigs of cov
    % matrix
    detrended_spatial_data(:,:,i) = spat_data_i;

    % spatial variance
    spat_EWS(3, i) = std(std(spat_data_i));

    % spatial skewness
    spat_EWS(4, i) = skewness(skewness(spat_data_i));

    % Moran's I / Spatial correlation (@ lag 1)
    % re-index using linear subscripts (NxN -> N^2 x 1) (into a COLUMN
    % vector
    s_data_i_lin = reshape(spat_data_i, [N^2, 1]);
    mean_i = mean(s_data_i_lin);

    % matrix product of vectors (gets all possible products)
    product = (s_data_i_lin - mean_i) * (s_data_i_lin - mean_i)';

    % dot product adjancency with product divided by something
    unnormalized_spat_corr = sum(sum(W .* product)) / sum((s_data_i_lin - mean_i).^2);
    spatial_corr = (N^2 / sum(sum(W))) * unnormalized_spat_corr;
    spat_EWS(5, i) = spatial_corr;
end

for i = ws : T
    spat_window = detrended_spatial_data(:,:, i-ws+1 : i);
    spat_window_reshaped = reshape(spat_window, [N^2, ws]);
    covariance_matrix = cov(spat_window_reshaped);
    [~, D] = eig(covariance_matrix);
    largest_eig = max(diag(D));
    spat_EWS(1, i) = largest_eig;
    spat_EWS(2, i) = max(diag(D))/ sqrt(sum( diag(D).^2 ));
end

EWS = [temp_EWS; spat_EWS];
EWS(isnan(EWS)) = 0;

end