inputs = [x; y; newwidth; newdiameter];
outputs = [z2; z1; z3; z4];
svmModels = cell(4, 1);
predictedOutputs = zeros(4, size(inputs, 2));
metrics = cell(4, 1);
for i = 1:4
    svmModels{i} = fitrsvm(inputs', outputs(i, :)');
    predictedOutputs(i, :) = predict(svmModels{i}, inputs');
    mse = mean((predictedOutputs(i, :) - outputs(i, :)).^2);
    mae = mean(abs(predictedOutputs(i, :) - outputs(i, :)));
    rmse = sqrt(mse);
    r2 = 1 - sum((outputs(i, :) - predictedOutputs(i, :)).^2) / sum((outputs(i, :) - mean(outputs(i, :))).^2);
    metrics{i} = struct('MSE', mse, 'MAE', mae, 'RMSE', rmse, 'R2', r2);
end
combinedOutputs = mean(outputs, 1); 
combinedPredictedOutputs = mean(predictedOutputs, 1);
mseCombined = mean((combinedOutputs - combinedPredictedOutputs).^2);
maeCombined = mean(abs(combinedOutputs - combinedPredictedOutputs));
rmseCombined = sqrt(mseCombined);
r2Combined = 1 - sum((combinedOutputs - combinedPredictedOutputs).^2) / sum((combinedOutputs - mean(combinedOutputs)).^2);
for i = 1:4
    disp(['Metrics for Model ', num2str(i)]);
    disp(['Mean Squared Error (MSE): ', num2str(metrics{i}.MSE)]);
    disp(['Mean Absolute Error (MAE): ', num2str(metrics{i}.MAE)]);
    disp(['Root Mean Squared Error (RMSE): ', num2str(metrics{i}.RMSE)]);
    disp(['R-squared (R2): ', num2str(metrics{i}.R2)]);
    disp(' ');
end
disp('Combined Metrics');
disp(['Mean Squared Error (MSE) for Combined Outputs: ', num2str(mseCombined)]);
disp(['Mean Absolute Error (MAE) for Combined Outputs: ', num2str(maeCombined)]);
disp(['Root Mean Squared Error (RMSE) for Combined Outputs: ', num2str(rmseCombined)]);
disp(['R-squared (R2) for Combined Outputs: ', num2str(r2Combined)]);
figure;
scatter(combinedOutputs, combinedPredictedOutputs);
hold on;
plot(combinedOutputs, combinedOutputs, 'r'); 
xlabel('Combined Actual Output');
ylabel('Combined Predicted Output');
title('Combined Outputs');
legend('Predictions', 'Diagonal', 'Location', 'best');
grid on;
hold off;