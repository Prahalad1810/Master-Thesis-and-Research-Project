inputs_original = [q(:,1:23); press(:,1:23); width(:,1:23); d2(:,1:23)];
outputs_original = [maxPOFP(:,1:23); maxPASP(:,1:23); maxMOFT(:,1:23); maxPASP_perc(:,1:23)l];
netModels = cell(4, 1);
predictedOutputs_original = zeros(4, size(inputs_original, 2));

pretrainedNet = fitnet(10);

for i = 1:4
    
    net = train(pretrainedNet, inputs_original, outputs_original(i, :));
    netModels{i} = net;
    
   
    predictedOutputs_original(i, :) = net(inputs_original);
end


q_test = 1.2*q(:,1:4);
press_test = 1.2*press(:,1:4);
width_test = width(:,1:4);
diameter_test = d2(:,1:4);
test_inputs = [q_test; press_test; width_test; diameter_test];

predicted_outputs_test = zeros(4, size(test_inputs, 2));

for i = 1:4
    
    predicted_outputs_test(i, :) = netModels{i}(test_inputs);
end


disp('Predicted Outputs for Test Data (Extrapolation)');
for i = 1:4
    disp(['Predicted Outputs for Model ', num2str(i)]);
    disp(predicted_outputs_test(i, :));
    disp(' ');
end

% import numpy as np
% from sklearn.model_selection import train_test_split
% from sklearn.linear_model import LogisticRegression
% from sklearn.metrics import accuracy_score
% X = np.random.rand(100,2)
% Y = (X[:,0]+X[:,1]>1).astype(int)
% X_train, X_test, y_train, y_test = train_test_split(X,y,test_size}0.2,random_state=42)
% clf = LogisticRegression()
% clf.fit(X_train,y_train)
% y_pred = clf.predict(x_test)
% accuracy = accuracy_score(y_test,y_pred)
% np.arange(10).reshape((5,2)),range(5)

% % Plotting the predicted outputs for the test data
% figure;
% for i = 1:4
%     subplot(2, 2, i);
%     scatter(1:size(predicted_outputs_test, 2), predicted_outputs_test(i, :));
%     xlabel('Data Point');
%     ylabel(['Predicted Output for Model ', num2str(i)]);
%     title(['Predicted Outputs for Model ', num2str(i)]);
%     grid on;
% end
% 
% % Define the computeMetrics function
% function metrics = computeMetrics(actual, predicted)
%     mse = mean((predicted - actual).^2);
%     mae = mean(abs(predicted - actual));
%     rmse = sqrt(mse);
%     r2 = 1 - sum((actual - predicted).^2) / sum((actual - mean(actual)).^2);
%     
%     metrics = struct('MSE', mse, 'MAE', mae, 'RMSE', rmse, 'R2', r2);
% end