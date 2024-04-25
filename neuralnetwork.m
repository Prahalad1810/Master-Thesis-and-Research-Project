a = [q;press;width;diameter;S];
t = [maxPOFP; maxPASP; maxMOFT; maxPASP_perc];
trainFcn = 'trainlm'; 
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize,trainFcn);
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};
net.divideFcn = 'dividerand';
net.divideMode = 'sample'; 
net.divideParam.trainRatio = 60/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 20/100;
net.performFcn = 'mse';
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
                      'plotregression', 'plotfit'};
[net,tr] = train(net,a,t);
 y = net(a);
 e = gsubtract(t,y);
 performance = perform(net,t,y);
 trainTargets = t .* tr.trainMask{1};
 valTargets = t .* tr.valMask{1};
 testTargets = t .* tr.testMask{1};
 trainPerformance = perform(net,trainTargets,y);
 valPerformance = perform(net,valTargets,y);
 testPerformance = perform(net,testTargets,y);

 
