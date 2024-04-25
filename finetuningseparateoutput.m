inputs_original = [q; press; width; diameter];
outputs_original = [maxPOFP; maxPASP; maxMOFT; maxPASP_perc];

outputNames = {'POFP', 'PASP', 'MOFT', 'PASPperc'};
netModels = cell(4, 1);
predictedOutputs_original = zeros(4, size(inputs_original, 2));
metrics_original = cell(4, 1);

pretrainedNet = fitnet(10);

computeMetrics = @(actual, predicted) struct('MSE', mean((predicted - actual).^2), ...
                                             'MAE', mean(abs(predicted - actual)), ...
                                             'RMSE', sqrt(mean((predicted - actual).^2)), ...
                                             'R2', 1 - sum((actual - predicted).^2) / sum((actual - mean(actual)).^2));
for i = 1:4
    net = train(pretrainedNet, inputs_original, outputs_original(i, :));
    netModels{i} = net;
    predictedOutputs_original(i, :) = net(inputs_original);
    metrics_original{i} = computeMetrics(outputs_original(i, :), predictedOutputs_original(i, :));
end

inputs_new = [q(:, 1:23); press(:, 1:23); width(:, 1:23); d2(:, 1:23)];
outputs_new = [pofpnewv6; paspnewv6; moftnewv6; pasp_percnewv6];

predictedOutputs_new = zeros(4, size(inputs_new, 2));
metrics_new = cell(4, 1);

for i = 1:4
    netTransfer = train(netModels{i}, inputs_new, outputs_new(i, :));
    predictedOutputs_new(i, :) = netTransfer(inputs_new);
    metrics_new{i} = computeMetrics(outputs_new(i, :), predictedOutputs_new(i, :));
end

disp('Metrics for New Dataset (Transfer Learning)');
for i = 1:4
    disp(['Metrics for Model ', num2str(i)]);
    disp(['Mean Squared Error (MSE): ', num2str(metrics_new{i}.MSE)]);
    disp(['Mean Absolute Error (MAE): ', num2str(metrics_new{i}.MAE)]);
    disp(['Root Mean Squared Error (RMSE): ', num2str(metrics_new{i}.RMSE)]);
    disp(['R-squared (R2): ', num2str(metrics_new{i}.R2)]);
    disp(' ');
end

figure;
for i = 1:4
    subplot(2, 2, i);
    scatter(outputs_new(i, :), predictedOutputs_new(i, :));
    xlabel(['Actual Output (z', num2str(i), ')']);
    ylabel(['Predicted Output (z', num2str(i), ')']);
    title([outputNames{i}, ' (MSE: ', num2str(metrics_new{i}.MSE), ')']);
    grid on;
end