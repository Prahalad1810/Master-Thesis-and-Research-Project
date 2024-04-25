% inputs_original = [q; press; width; diameter];
% outputs_original = [maxPASP; maxPOFP; maxMOFT; maxPASP_perc];
% inputs_original = [drehzahl; torque; width; diameter];
% outputs_original = [maxPASP; maxPOFP; maxMOFT; maxPASP_perc];
inputs_original = [q; press; width; diameter];
outputs_original = [maxPOFP; maxPASP; maxMOFT; maxPASP_perc];
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

combinedOutputs_original = mean(outputs_original, 1);
% inputs_new = [1.07878787879*q(:,1:23); newpress(:,1:23); width(:,1:23); d2(:,1:23)];
% outputs_new = [paspnewv6;pofpnewv6;moftnewv6;pasp_percnewv6];

% inputs_new = [q; press; width; d2];
outputs_new = [pofpnewv6; paspnewv6; moftv6new; pasp_percnewv6];
% inputs_new = [x,q; y,press; newwidth,width; newdiameter,diameter];
% outputs_new = [z2,maxPOFP; z1,maxPASP; z3,maxMOFT; z4,maxPASP_perc];
inputs_new = [q(:,1:23); press(:,1:23); width(:,1:23); d2(:,1:23)];
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
combinedOutputs_new = mean(outputs_new, 1);

for i = 1:4
    disp(['Metrics for Model ', num2str(i)]);
    disp(['Mean Squared Error (MSE): ', num2str(metrics_new{i}.MSE)]);
    disp(['Mean Absolute Error (MAE): ', num2str(metrics_new{i}.MAE)]);
    disp(['Root Mean Squared Error (RMSE): ', num2str(metrics_new{i}.RMSE)]);
    disp(['R-squared (R2): ', num2str(metrics_new{i}.R2)]);
    disp(' ');
end
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
title("profile changed again and adapted to smaller dataset");
grid on;
