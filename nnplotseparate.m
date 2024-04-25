% inputs = [q,x;press,y;width,newwidth;diameter,newdiameter;sommerfeld_number,sommer];
% outputs = [maxPASP,z2;maxPOFP,z1;maxMOFT,z3;maxPASP_perc,z4];
% inputs = [torque; drehzahl; width; d2];
% outputs = [POFPv6; PASPv6; MOFTv6; PASP_percv6];
inputs= [q, q(:,1:23); press,press(:,1:23); width,width(:,1:23); diameter,d2(:,1:23)];
outputs = [maxPASP,paspnewv6; maxPOFP,pofpnewv6; maxMOFT,moftnewv6; maxPASP_perc, pasp_percnewv6];
outputNames = {'PASP', 'POFP', 'MOFT', 'PASPperc'};
netModels = cell(4, 1);
predictedOutputs = zeros(4, size(inputs, 2));
metrics = cell(4, 1);
for i = 1:4
    net = fitnet(10); 
    net = train(net, inputs, outputs(i, :));    
    predictedOutputs(i, :) = net(inputs);
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
figure;
for i = 1:4
    subplot(2, 2, i);
    scatter(outputs(i, :), predictedOutputs(i, :));
    xlabel('Actual Output');
    ylabel('Predicted Output');
%     title([outputNames{i}, ' - MSE: ', num2str(metrics{i}.MSE)]);  % Display only MSE in the title
    title([outputNames{i}, ' (MSE: ', num2str(metrics{i}.MSE), ')']);
    grid on;    
end



