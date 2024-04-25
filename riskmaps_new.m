load('PASPbar_perc.mat')
load('PASPbar.mat')
load('POFPbar.mat')
load('PROBbar.mat')
load('MOFTbar.mat')
load('Vbar.mat')
load('Vbar_red.mat')

Vbar(11,2)=0;
PASPbar(11,2)=0;
MOFTbar(10,1)=0;
POFPbar(10,1)=4.4910;
PASPbar_perc(11,2)=0;

B = 190/1000;
D = 178/1000;
A = pi*D*B;

% Normalized asperity contact pressure
norm_PASPbar = PASPbar./max(max(PASPbar));
norm_MOFTbar = MOFTbar./max(max(MOFTbar));
% Normalized asperity contact pressure area
norm_PASPbar_perc = PASPbar_perc./max(max(PASPbar_perc));
% Normalized oil film pressure 

lVbar=log(Vbar);
lVbar(lVbar==-inf)=0;
minlVbar=min(lVbar,[],'all');
lVbar=log(Vbar)-minlVbar;
lVbar(lVbar==-inf)=0;

norm_Vbar = lVbar./max(lVbar,[],'all');


%% Darstellung Simulationsergebnisse
a = -47;
d = 25;
font = 18;

PROBbar_ori=PROBbar;

PASPbar_perc(PROBbar == 0) = nan;
PASPbar(PROBbar == 0) = nan;
MOFTbar(PROBbar == 0) = nan;
POFPbar(PROBbar == 0) = nan;

PROBbar(PROBbar == 0) = nan;
norm_Vbar(PROBbar == 0) = nan;


f1 = figure(1);
b=bar3(MOFTbar);hold on;
yticks(linspace(1,14,7));
yticklabels({'2','6','10','14','18','22','26'});
ylabel('Rotational speed [rpm]');
zlabel({'Min. oil film','height [\mum]'});
xticks([1 5 9 13 17 ]);
xticklabels({'40','120','200','280','360'});
xlabel('Torque [kNm]');
   [r,c] = find(isnan(MOFTbar));
    for i=1:numel(r)
    r_ = r(i);
    c_ = c(i);
    b(c_).CData(6*(r_-1)+1:6*r_, :) = nan;
    end
view([a+180 d]);
set(f1.Children, ...
    'FontName',     'Times', ...
    'FontSize',     font);
f1.Units               = 'centimeters';
f1.Position(3)         = 16;
f1.Position(4)         = 11;
savefig(f1,'EHD_oil_film_height.fig');
saveas(f1,'EHD_oil_film_height.png');
saveas(f1,'EHD_oil_film_height.svg');
saveas(f1,'EHD_oil_film_height','epsc');
exportgraphics(gcf,'Oilfilm.eps','BackgroundColor','none','ContentType','vector')

f2 = figure(2);
b=bar3(PASPbar); hold on;
% bar3(PASPbar(1,1));
% bar3(PASPbar(11,19));
zlabel({'Max. asperity contact','pressure [MPa]'});
yticks(linspace(1,14,7));
yticklabels({'0.0850','0.1280','0.2130','0.3410','0.4270','0.5120','0.5550'});
ylabel('speed [m/s]');
xticks([1 5 9 13 17 ]);
xticklabels({'1','1.7','4','9','13'});
xlabel('Specific Pressure [bar]');

   [r,c] = find(isnan(PASPbar));
    for i=1:numel(r)
    r_ = r(i);
    c_ = c(i);
    b(c_).CData(6*(r_-1)+1:6*r_, :) = nan;
    end
view([a d]);
set(f2.Children, ...
    'FontName',     'Times', ...
    'FontSize',     font);
f2.Units               = 'centimeters';
f2.Position(3)         = 16;
f2.Position(4)         = 11;
savefig(f2,'EHD_asperity_contact_pressure_new.fig');
saveas(f2,'EHD_asperity_contact_pressure_new.png');
saveas(f2,'EHD_asperity_contact_pressure_new.svg');
exportgraphics(gcf,'asperitypressure_new.eps','BackgroundColor','none','ContentType','vector')

f3 = figure(3);
b=bar3(POFPbar);
yticks(linspace(1,14,7));
zlabel({'Max. oil film','pressure [MPa]'});
yticklabels({'2','6','10','14','18','22','26'});
ylabel('Rotational speed [rpm]');
xticks([1 5 9 13 17 ]);
xticklabels({'40','120','200','280','360'});
xlabel('Torque [kNm]');
   [r,c] = find(isnan(POFPbar));
    for i=1:numel(r)
    r_ = r(i);
    c_ = c(i);
    b(c_).CData(6*(r_-1)+1:6*r_, :) = nan;
    end
view([a d]);
set(f3.Children, ...
    'FontName',     'Times', ...
    'FontSize',     font);
f3.Units               = 'centimeters';
f3.Position(3)         = 16;
f3.Position(4)         = 11;
savefig(f3,'EHD_results_oil_film_pressure.fig');
saveas(f3,'EHD_results_oil_film_pressure.png');
saveas(f3,'EHD_results_oil_film_pressure.svg');
saveas(f3,'EHD_results_oil_film_pressure','epsc');
exportgraphics(gcf,'oilpressure.eps','BackgroundColor','none','ContentType','vector')

% f4 = figure(4);
% b=bar3(norm_Vbar);
% zlabel({'Normalized Wear Criticality'});
% yticks(linspace(1,14,7));
% yticklabels({'2','6','10','14','18','22','26'});
% ylabel('Rotational speed [rpm]');
% xticks([1 5 9 13 17 ]);
% xticklabels({'40','120','200','280','360'});
% xlabel('Torque [kN]');
% view([a d]);
%    [r,c] = find(isnan(PASPbar));
%     for i=1:numel(r)
%     r_ = r(i);
%     c_ = c(i);
%     b(c_).CData(6*(r_-1)+1:6*r_, :) = nan;
%     end
% set(f4.Children, ...
%     'FontName',     'Times', ...
%     'FontSize',     font);
% f4.Units               = 'centimeters';
% f4.Position(3)         = 16;
% f4.Position(4)         = 11;
% savefig(f4,'EHD_results_wear.fig');
% saveas(f4,'EHD_results_wear.png');
% saveas(f4,'EHD_results_wear.svg');

f5 = figure(5);
b=bar3(PASPbar_perc);
zlabel({'Asperity contact','pressure area [%]'});
yticks(linspace(1,14,7));
yticklabels({'2','6','10','14','18','22','26'});
ylabel('Rotational speed [rpm]');
xticks([1 5 9 13 17 ]);
xticklabels({'40','120','200','280','360'});
xlabel('Torque [kNm]');
view([a d]);
   [r,c] = find(isnan(PASPbar_perc));
    for i=1:numel(r)
    r_ = r(i);
    c_ = c(i);
    b(c_).CData(6*(r_-1)+1:6*r_, :) = nan;
    end
set(f5.Children, ...
    'FontName',     'Times', ...
    'FontSize',     font);
f5.Units               = 'centimeters';
f5.Position(3)         = 16;
f5.Position(4)         = 11;
savefig(f5,'EHD_asperity_contact_pressure_area.fig');
saveas(f5,'EHD_asperity_contact_pressure_area.png');
saveas(f5,'EHD_asperity_contact_pressure_area.svg');
exportgraphics(gcf,'asperityarea.eps','BackgroundColor','none','ContentType','vector')

f6 = figure(6);
b=bar3(PROBbar*100);
zlabel({'Probability of','occurrence [%]'});
yticks(linspace(1,14,7));
yticklabels({'2','6','10','14','18','22','26'});
ylabel('Rotational speed [rpm]');
xticks([1 5 9 13 17 ]);
xticklabels({'40','120','200','280','360'});
xlabel('Torque [kNm]');
view([a d]);
   [r,c] = find(isnan(PROBbar));
    for i=1:numel(r)
    r_ = r(i);
    c_ = c(i);
    b(c_).CData(6*(r_-1)+1:6*r_, :) = nan;
    end
set(f6.Children, ...
    'FontName',     'Times', ...
    'FontSize',     font);
f6.Units               = 'centimeters';
f6.Position(3)         = 16;
f6.Position(4)         = 11;
savefig(f6,'EHD_probability.fig');
saveas(f6,'EHD_probability.png');
saveas(f6,'EHD_probability.svg');
exportgraphics(gcf,'probability.eps','BackgroundColor','none','ContentType','vector')

%% Konturplot Risk Map
xvalues_fine=2:0.1:28;
yvalues_fine=40:0.1:400;
xvalues=2:2:28;
yvalues=40:20:400;

xvalues2=4:4:28;
yvalues2=50:40:370;

font = 16;               
norm_Vbar=flipud(norm_Vbar');

[X,Y] = meshgrid(xvalues_fine,yvalues_fine);
[Xfit,Yfit] = meshgrid(xvalues_fine,yvalues_fine);

Vq = interp2(xvalues,yvalues,norm_Vbar,X,Y,'linear');
flip=flipud(PROBbar_ori');
% norm_Vbar(flip == 0) = nan;

y_fit=3.521.*exp(0.2072.*xvalues_fine)+129;
y_end=0.05683.*exp(0.3006.*xvalues_fine)-7.181;

y_fit=round(y_fit,1);
y_end=round(y_end,1);


Vq=flipud(Vq);
for i=1:1:length(y_fit);
    id=find(y_fit(i)<=Yfit(:,i));
    ide=find(y_end(i)>=Yfit(:,i));
    Vq(id,i)=nan;
    Vq(ide,i)=nan;
end

V_contour = flipud(norm_Vbar);
% f8 = figure(8);
% X = 2:2:28;
% Y = 40:20:400;
% [x,y] = meshgrid(X,Y);
% contourf(x,y,V_contour,'--');
% colormap(c);
% colorbar
% set(f8.Children, ...
%     'FontName',     'Times', ...
%     'FontSize',     font);
% xlabel('Rotational speed [1/min]');
% ylabel('Torque [kNm]');
% 
% savefig(f8,'EHD_results_risk_map_contourplot.fig');
% saveas(f8,'EHD_results_risk_map_contourplot.png');
% saveas(f8,'EHD_results_risk_map_contourplot.svg');


%save('CustomColormap.mat','CustomColormap')

load('cmap.mat');

xpoint=6;
ypoint=110;

f9 = figure(9);
contourf(xvalues_fine,yvalues_fine,Vq,'--'); hold on;
plot(xvalues_fine,y_fit,'k','linewidth',0.7);
plot(xvalues_fine,y_end,'k','linewidth',0.7);
scatter(xpoint,ypoint,100,'*','k')
axis([xvalues2(1) xvalues2(end) yvalues2(1) yvalues2(end)]);
colormap(cmap);
colorbar
set(f9.Children, ...
    'FontName',     'Times', ...
    'FontSize',     font);
xlabel('Rotational speed [1/min]');
ylabel('Torque [kNm]');
savefig(f9,'Paper_RISK_full_point.fig');
saveas(f9,'Paper_RISK_full_point.png');
saveas(f9,'Paper_RISK_full_point.svg');
saveas(f9,'Paper_RISK_full_point','epsc');
exportgraphics(gcf,'Risk_full_point.eps','BackgroundColor','none','ContentType','vector')

f10 = figure(10);
contourf(xvalues_fine,yvalues_fine,Vq,'--'); hold on;
plot(xvalues_fine,y_fit,'k','linewidth',0.7);
plot(xvalues_fine,y_end,'k','linewidth',0.7);
%scatter(xpoint,ypoint,100,'*','k')
axis([xvalues2(1) xvalues2(end) yvalues2(1) yvalues2(end)]);
colormap(cmap);
colorbar
set(f10.Children, ...
    'FontName',     'Times', ...
    'FontSize',     font);
xlabel('Rotational speed [1/min]');
ylabel('Torque [kNm]');
% savefig(f9,'Paper_RISK_full_point.fig');
% saveas(f9,'Paper_RISK_full_point.png');
% saveas(f9,'Paper_RISK_full_point.svg');
% saveas(f9,'Paper_RISK_full_point','epsc');
exportgraphics(gcf,'Risk_full.eps','BackgroundColor','none','ContentType','vector')




