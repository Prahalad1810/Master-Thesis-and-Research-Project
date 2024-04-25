inputs = [q; press; width; diameter];
outputs = [z2; z1; z3; z4];
% inputs = [torque; drehzahl; width; d2];
% outputs = [POFPv6; PASPv6; MOFTv6; PASP_pecv6];
outputNames = {'POFP', 'PASP', 'MOFT', 'PASPperc'};
gprModels = cell(4, 1);
predictedOutputs = zeros(4, size(inputs, 2));
mse = zeros(4, 1);
mae = zeros(4, 1);
rmse = zeros(4, 1);
r2 = zeros(4, 1);
for i = 1:4
    gprModels{i} = fitrgp(inputs', outputs(i, :));
    predictedOutputs(i, :) = predict(gprModels{i}, inputs');
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