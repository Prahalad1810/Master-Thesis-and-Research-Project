inputs = [torque; drehzahl];
outputs = [maxPOFP; maxPASP; maxMOFT; maxPASP_perc];
outputNames = {'POFP', 'PASP', 'MOFT', 'PASPperc'};
svmModels = cell(4, 1);
for i = 1:4
    svmModels{i} = fitrsvm(inputs', outputs(i, :));
end
predictedOutputs = zeros(4, size(inputs, 2));
mse = zeros(4, 1); 
for i = 1:4
    predictedOutputs(i, :) = predict(svmModels{i}, inputs');
    mse(i) = mean((outputs(i, :) - predictedOutputs(i, :)).^2);  
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







