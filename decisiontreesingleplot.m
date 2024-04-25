inputs = [torque; drehzahl];
outputs = [maxPOFP; maxPASP; maxMOFT; maxPASP_perc];
treeModels = cell(4, 1);
predictedOutputs = zeros(4, size(inputs, 2));
for i = 1:4
    treeModels{i} = fitrtree(inputs', outputs(i, :)');
    predictedOutputs(i, :) = predict(treeModels{i}, inputs');
end
figure;
combinedOutputs = mean(outputs, 1); 
combinedPredictedOutputs = mean(predictedOutputs, 1);
scatter(combinedOutputs, combinedPredictedOutputs);
hold on;
plot(combinedOutputs, combinedOutputs, 'r'); 
xlabel('Combined Actual Output');
ylabel('Combined Predicted Output');
title('Combined Outputs');
legend('Predictions', 'Diagonal', 'Location', 'best');
grid on;
hold off;
mseCombined = mean((combinedOutputs - combinedPredictedOutputs).^2);
disp(['Mean Squared Error (MSE) for Combined Outputs: ', num2str(mseCombined)]);