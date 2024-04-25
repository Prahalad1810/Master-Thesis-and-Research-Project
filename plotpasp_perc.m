%99cases %43is100 %45is101

% x = [0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6];
% y = [4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14];
% z4 = [0.2125,0,0,0,0,0,0,0,0,0.3125,0.065,0,0,0,0,0,0,0,0.4375,0.1125,0,0,0,0,0,0,0,0.625,0.2,0,0,0,0,0,0,0,0.8,0.28125,0.0575,0,0,0,0,0,0,0.95,0.35,0.07125,0,0,0,0,0,0,1.125,0.4375,0.09,0.031875,0,0,0,0,0,1.25,0.5875,0.13,0.0575,0,0,0,0,0,1.375,0.6625,0.19,0.07125,0.01575,0,0,0,0,1.5,0.75,0.26875,0.09,0.0475,0,0,0,0,1.675,0.8,0.31875,0.0975,0.065,0,0,0,0];
% x_vals = reshape(x, 9, [])';
% y_vals = reshape(y, 9, [])';
% z_vals = reshape(z4, 9, [])';
% 
% % Create a 3D bar plot
% figure;
% bar3(z_vals);
% xlabel('Speed (m/s)');
% ylabel('Specific Pressure (bar)');
% zlabel('Asperity contact pressure area (%)');
% xticks([1:9]);
% xticklabels({0.025,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.6});
% yticks([1:14]);
% yticklabels({4,5,6,7,8,9,10,11,12,13,14});
% zticks([0,0.2,0.625,0.8,1.125,1.375,1.675]);
% zticklabels({0,0.2,0.625,0.8,1.125,1.375,1.675});
% colormap(default);
% x = q(:,1:132);
% y = press(:,1:132);
% z4 =PASP_percv6(:,1:132);
% 
% 
% % Adjust the reshaping for the larger dataset
% x_vals = reshape(x, 12, [])'; % 134/10 = 13.4, we use 10 for each row
% y_vals = reshape(y, 12, [])';
% z_vals = reshape(z4, 12, [])';
% 
% % Create a 3D bar plot
% figure;
% bar3(z_vals);
% xlabel('Speed (m/s)');
% ylabel('Specific Pressure (bar)');
% zlabel('Asperity contact pressure area (%)');
% 
% % Update the ticks for x, y, and z axes
% xticks([1:14]); 
% xticklabels({0.043,0.085,0.128,0.171,0.213,0.256,0.299,0.341,0.384,0.427,0.469,0.512,0.555,0.597});
% yticks([1:15]); 
% yticklabels({1,2.3,5,6,7,8,9,10,11,12,13}); 
% % zticks([1:30]); 
% zticks([1:12]);
% zticklabels({0,0.07,0.23,1.92,2.39,2.67,3.95,5.05,7.41});
% 
% colormap(default);

% Example data (replace these with your actual data)
% Example data (replace these with your actual data)
% Example data (replace these with your actual data)
% Example data (replace these with your actual data)
% moftv6new = [0.00187940770000000,0.00195769410000000,0.00203638240000000,0.00211930510000000,0.00193287130000000,0.00203021570000000,0.00213381900000000,0.00223957440000000,0.00187729780000000,0.00198814230000000,0.00210784930000000,0.00222246950000000,0.00234079690000000,0.00191304470000000,0.00203389120000000,0.00216407100000000,0.00230278420000000,0.00243598760000000,0.00196846250000000,0.00210258850000000,0.00224632050000000,0.00239679050000000,0.0025536388];
% 
% 
% speed = q(:,1:23); % Replace rand(1, 134) with your actual speed data
% pressure = press(:,1:23); % Replace rand(1, 134) with your actual pressure data
% moft = maxMOFT; % Replace rand(1, 134) with your actual moft data
% 
% % Define the bins for speed and pressure
% speed_bins = linspace(min(speed), max(speed), 10); % Adjust the number of bins as needed
% pressure_bins = linspace(min(pressure), max(pressure), 10); % Adjust the number of bins as needed
% 
% % Digitize speed and pressure data
% speed_digitized = discretize(speed, speed_bins);
% pressure_digitized = discretize(pressure, pressure_bins);
% 
% % Calculate mean moft for each combination of speed and pressure
% moft_mean = accumarray([speed_digitized', pressure_digitized'], moft', [], @mean);
% 
% % Generate grid for bar3 plot
% [x, y] = meshgrid(1:size(moft_mean, 2), 1:size(moft_mean, 1));
% 
% % Plotting
% figure;
% bar3(moft_mean);
% set(gca, 'XTickLabel', speed_bins);
% set(gca, 'YTickLabel', pressure_bins);
% xlabel('Speed [m/s]');
% ylabel('Sepcific Pressure [bar]');
% zlabel('MOFT [µm]');
% moftv6new = [0.00187940770000000,0.00195769410000000,0.00203638240000000,0.00211930510000000,0.00193287130000000,0.00203021570000000,0.00213381900000000,0.00223957440000000,0.00187729780000000,0.00198814230000000,0.00210784930000000,0.00222246950000000,0.00234079690000000,0.00191304470000000,0.00203389120000000,0.00216407100000000,0.00230278420000000,0.00243598760000000,0.00196846250000000,0.00210258850000000,0.00224632050000000,0.00239679050000000,0.0025536388];

speed = q(:,1:23); % Replace with your actual input speed data
pressure= press(:,1:23); % Replace with your actual pressure data
output = ; % Replace with your actual output data

% Create a 3D bar plot
bar3(output);

% Set labels and titles
xlabel('Input Speed');
ylabel('Pressure');
zlabel('Output');
title('Output for Different Speed-Pressure Pairs');

% Customize tick labels
set(gca,'XTickLabel',input_speed);
set(gca,'YTickLabel',pressure);

% Rotate X-axis labels for better readability
set(gca,'XTickLabelRotation',45);

