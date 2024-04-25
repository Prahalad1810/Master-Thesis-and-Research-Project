inputs_original = [q; press; width; diameter];
outputs_original = [maxPASP; maxPOFP; maxMOFT; maxPASP_perc];
% inputs_original = [q; press; width; diameter];
% outputs_original = [maxPOFP; maxPASP; maxMOFT; maxPASP_perc];
% inputs_original = [q; press; width; d2];
% outputs_original = [PASPv6;POFPv6;MOFTv6;PASP_percv6];

outputNames = {'PASP', 'POFP', 'MOFT', 'PASPperc'};
netModels = cell(4, 1);
predictedOutputs_original = zeros(4, size(inputs_original, 2));
metrics_original = cell(4, 1);
for i = 1:4
    net = fitnet(10); 
    net = train(net, inputs_original, outputs_original(i, :));    
    netModels{i} = net;
    predictedOutputs_original(i, :) = net(inputs_original);
    mse = mean((predictedOutputs_original(i, :) - outputs_original(i, :)).^2);
    mae = mean(abs(predictedOutputs_original(i, :) - outputs_original(i, :)));
    rmse = sqrt(mse);
    r2 = 1 - sum((outputs_original(i, :) - predictedOutputs_original(i, :)).^2) / sum((outputs_original(i, :) - mean(outputs_original(i, :))).^2);    
    metrics_original{i} = struct('MSE', mse, 'MAE', mae, 'RMSE', rmse, 'R2', r2);
end
inputs_new = [q; press; width; d2];
outputs_new = [PASPv6;POFPv6;MOFTv6;PASP_percv6];
% inputs_new = [q(:,1:23); press(:,1:23); width(:,1:23); d2(:,1:23)];
% outputs_new = [paspnewv6;pofpnewv6;moftnewv6;pasp_percnewv6];
predictedOutputs_new = zeros(4, size(inputs_new, 2));
metrics_new = cell(4, 1);
for i = 1:4
    netTransfer = adapt(netModels{i}, inputs_new, outputs_new(i, :));
    predictedOutputs_new(i, :) = netTransfer(inputs_new);
    mse = mean((predictedOutputs_new(i, :) - outputs_new(i, :)).^2);
    mae = mean(abs(predictedOutputs_new(i, :) - outputs_new(i, :)));
    rmse = sqrt(mse);
    r2 = 1 - sum((outputs_new(i, :) - predictedOutputs_new(i, :)).^2) / sum((outputs_new(i, :) - mean(outputs_new(i, :))).^2);
    metrics_new{i} = struct('MSE', mse, 'MAE', mae, 'RMSE', rmse, 'R2', r2);
end

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