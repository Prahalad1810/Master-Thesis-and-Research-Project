% inputs = [x; y];
% outputs = [z2; z1; z3; z4];
inputs = [x; y; newwidth; newdiameter];
outputs = [z2; z1; z3; z4];
treeModels = cell(4, 1);
predictedOutputs = zeros(4, size(inputs, 2));
mse = zeros(4, 1);
mae = zeros(4, 1);
rmse = zeros(4, 1);
r2 = zeros(4, 1);
for i = 1:4
    treeModels{i} = fitrtree(inputs', outputs(i, :));
    predictedOutputs(i, :) = predict(treeModels{i}, inputs');
    mse(i) = mean((outputs(i, :) - predictedOutputs(i, :)).^2);
    mae(i) = mean(abs(outputs(i, :) - predictedOutputs(i, :)));
    rmse(i) = sqrt(mse(i));
    r2(i) = 1 - sum((outputs(i, :) - predictedOutputs(i, :)).^2) / sum((outputs(i, :) - mean(outputs(i, :))).^2);
end
figure;
for i = 1:4
    subplot(2, 2, i);
    scatter(outputs(i, :), predictedOutputs(i, :));
    xlabel('Actual Output');
    ylabel('Predicted Output');
    title([outputNames{i}, ' (MSE: ', num2str(mse(i)), ')']);
    grid on;
end