inputs_original = [q; press; width; diameter];
outputs_original = [maxPOFP; maxPASP; maxMOFT; maxPASP_perc];
netModels = cell(4, 1);
predictedOutputs_original = zeros(4, size(inputs_original, 2));
metrics_original = cell(4, 1);


pretrainedNet = fitnet(10); 
% pretrainedNet.trainParam.epochs = 10;
rng(0);

for i = 1:4
    net = train(pretrainedNet, inputs_original, outputs_original(i, :));
    netModels{i} = net;
    predictedOutputs_original(i, :) = net(inputs_original);
    metrics_original{i} = computeMetrics(outputs_original(i, :), predictedOutputs_original(i, :));
end

outputs_new = [pofpnewv6; paspnewv6; moftv6new; pasp_percnewv6];
% inputs_new = [x,q; y,press; newwidth,width; newdiameter,diameter];
% outputs_new = [z2,maxPOFP; z1,maxPASP; z3,maxMOFT; z4,maxPASP_perc];
inputs_new = [q(:,1:23); press(:,1:23); width(:,1:23); d2(:,1:23)];
predictedOutputs_new = zeros(4, size(inputs_new, 2));
metrics_new = cell(4, 1);

for i = 1:4
    
    netTransfer = train(netModels{i}, inputs_new, outputs_new(i, :));
    
    
    predictedOutputs_new(i, :) = netTransfer(inputs_new);
    metrics_new{i} = computeMetrics(outputs_new(i, :), predictedOutputs_new(i, :));
end



disp('Metrics for New Dataset');
for i = 1:4
    disp(['Metrics for Model ', num2str(i)]);
    disp(['Mean Squared Error (MSE): ', num2str(metrics_new{i}.MSE)]);
    disp(['Mean Absolute Error (MAE): ', num2str(metrics_new{i}.MAE)]);
    disp(['Root Mean Squared Error (RMSE): ', num2str(metrics_new{i}.RMSE)]);
    disp(['R-squared (R2): ', num2str(metrics_new{i}.R2)]);
    disp(' ');
end


combinedOutputs_new = mean(outputs_new, 1);
mseCombined_new = mean((combinedOutputs_new - mean(predictedOutputs_new)).^2);
maeCombined_new = mean(abs(combinedOutputs_new - mean(predictedOutputs_new)));
rmseCombined_new = sqrt(mseCombined_new);
r2Combined_new = 1 - sum((combinedOutputs_new - mean(predictedOutputs_new)).^2) / sum((combinedOutputs_new - mean(combinedOutputs_new)).^2);


disp('Combined Metrics for New Dataset');
disp(['Mean Squared Error (MSE) for Combined Outputs: ', num2str(mseCombined_new)]);
disp(['Mean Absolute Error (MAE) for Combined Outputs: ', num2str(maeCombined_new)]);
disp(['Root Mean Squared Error (RMSE) for Combined Outputs: ', num2str(rmseCombined_new)]);
disp(['R-squared (R2) for Combined Outputs: ', num2str(r2Combined_new)]);


figure;
scatter(combinedOutputs_new, mean(predictedOutputs_new, 1));
xlabel('Combined Actual Output');
ylabel('Combined Predicted Output');
title('Trained by splitting the dataset');
grid on;
function metrics = computeMetrics(actual, predicted)
    mse = mean((predicted - actual).^2);
    mae = mean(abs(predicted - actual));
    rmse = sqrt(mse);
    r2 = 1 - sum((actual - predicted).^2) / sum((actual - mean(actual)).^2);
    
    metrics = struct('MSE', mse, 'MAE', mae, 'RMSE', rmse, 'R2', r2);
end







