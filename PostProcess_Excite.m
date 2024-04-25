% -------------------------------- Auswertung Excite --------------------------------
%                             Ergebnisse Excite Auswerten
%   Alte Versionen:
%   Version v1.0    Stand: 19.09.2022   Bearbeitet: lucma
% --------------------------------------------------------------------------------------------------

clc; clear; close all;
% Change the current folder to the folder of this m-file. (m-file is
% located in excite model .ex folder)
if(~isdeployed)
  cd(fileparts(which('PostProcess_Excite.m')));
end

%   Geometrieparameter
l_s = 0.317;        %   [m] Länge des Stegs
n_planeten = 3;     %   [-] Anzahl Planeten
i_PL = 2.47;        % Übersetzung von Hauptwelle auf Planet

%Look in all case results folders for specific result file
Folder   = cd;
FileList = dir(fullfile(Folder, '**', 'Hauptlager-POFP.GID'));

MOFT=[];
POFP=[];
PASP=[];
PASP_perc=[];
opts = fixedWidthImportOptions("NumVariables", 6);
opts_PASP = fixedWidthImportOptions("NumVariables", 7);

% Specify range and delimiter
opts.DataLines = [26, Inf]; %26 text lines before results start
opts.VariableWidths=[17 16 16 16 16 16];
opts.VariableTypes=["double", "double", "double", "double", "double", "double"];
opts_PASP.DataLines = [27, Inf]; %27 text lines before results start
opts_PASP.VariableWidths=[17 16 16 16 16 16 16];
opts_PASP.VariableTypes=["double", "double", "double", "double", "double", "double", "double"];

for i=1:1:size(FileList,1) 
    fid_POFP=fullfile(FileList(i).folder, FileList(i).name);
    fid_PASP=fullfile(FileList(i).folder, 'Hauptlager-PASP.GID');
    fid_MOFT=fullfile(FileList(i).folder, 'Hauptlager-MOFT.GID');
    data=readtable(fid_POFP,opts);
    data=data{:,2:3}; %Angle & Peak pressure
    data_PASP=readtable(fid_PASP,opts_PASP);
    data_MOFT=readtable(fid_MOFT,opts);
    data_MOFT=data_MOFT{:,2:3};
    
    POFP=[POFP, data(:,2)];
    MOFT=[MOFT, data_MOFT(:,2)];
    PASP=[PASP, data_PASP{:,3}];
    PASP_perc=[PASP_perc, data_PASP{:,7}];
    
    scale(i)=round(data_PASP{end,3},6)/round(data_PASP{21,3},6);
    
    figure(1)
    plot(data(:,1),data(:,2)); 
    hold on
    xlabel('Ang [deg]'); ylabel('Peak Oil Film Pressure [MPa]');
end

maxPOFP=max(POFP);
maxMOFT=min(MOFT);
maxPASP=max(PASP);
maxPASP_perc=max(PASP_perc);

%% Case table
%Get matching case table
[file,path] = uigetfile('*.caseTable');
 dataname = [path,'\',file];

%dataname='C:\Prahalad\excite_70mu\V52_Gleitlager_PaperCWD2023_fine.caseTable';

% Data reading options
opts = fixedWidthImportOptions("NumVariables", 4);
opts.DataLines = [92, Inf];                         %92 text lines before results start
opts.VariableWidths=[19 10 17 16];
opts.VariableNames=["Name", "Speed", "Load", "Moment"];
opts.VariableTypes=["string", "double", "double", "double"];

caseTable=readtable(dataname,opts);
%caseTable=caseTable(1:length(FileList),:); %In case not all simulations are done
drehzahl=caseTable{:,2};
lagerlast=caseTable{:,3};
torque=lagerlast.*(n_planeten*l_s)./-1000;

% % Sommerfeld Parameters
% viscosity = 0.1148; % Dynamic viscosity of lubricant [Pa.s]
% diameter = 0.165; % Journal radius [m]
% radius = 0.0825;
% clearance = 0.000091;
% length = 0.19;
% 
% omega = drehzahl * (2 * pi / 60); % Convert speed to rad/s
% 
% 
% % Calculate Sommerfeld number
% sommerfeld_number = calculate_sommerfeld_number(clearance,omega,radius,length, lagerlast, diameter, viscosity);
% 
% 
% % Sommerfeld Number Calculation Function
% function sommerfeld_number = calculate_sommerfeld_number(clearance,omega, diameter, length, lagerlast, radius, viscosity)
%     sommerfeld_number = ((radius/clearance)^2)*((viscosity*omega*length*diameter)/lagerlast);
%     sommerfeld_number = sommerfeld_number(:);
%     sommerfeld_number = abs(sommerfeld_number(1:134,:));
% end

% find unique values
lagerlast_unique=unique(-1*lagerlast);
torque_unique=unique(torque);
drehzahl_unique=unique(drehzahl);
drehzahl_gesamt=drehzahl_unique./i_PL;

[X,Y] = meshgrid(torque_unique,drehzahl_gesamt);                  % create a grid of points
[nrows,ncols] = size(X); 

POFPbar=zeros(size(X));
MOFTbar=zeros(size(X));
PASPbar=zeros(size(X));
PASPbar_perc=zeros(size(X));

load PROBbar
PROB=1:1:length(drehzahl);

for i=1:1:ncols %complex solution can probably be done quicker
   for j=1:1:nrows
       if find(drehzahl==drehzahl_unique(j) & torque==torque_unique(i))>=1
           POFPbar(j,i)=maxPOFP(:,find(drehzahl==drehzahl_unique(j) & torque==torque_unique(i)));
           MOFTbar(j,i)=maxMOFT(:,find(drehzahl==drehzahl_unique(j) & torque==torque_unique(i)));
           PASPbar(j,i)=maxPASP(:,find(drehzahl==drehzahl_unique(j) & torque==torque_unique(i)));
           PASPbar_perc(j,i)=maxPASP_perc(:,find(drehzahl==drehzahl_unique(j) & torque==torque_unique(i)));
           PROB(find(maxPOFP==POFPbar(j,i)))=PROBbar(j,i);
        end
   end
end

save('PASPbar.mat', 'PASPbar');
save('MOFTbar.mat', 'MOFTbar');
save('PASPbar_perc.mat', 'PASPbar_perc');
save('POFPbar.mat', 'POFPbar');

% Second table 
[file,path] = uigetfile('*.caseTable');
dataname = [path,'\',file];

dataname='D:\Excite\CWD2023_paper_V52_model\\V52_Gleitlager_PaperCWD2023_gathered.caseTable';
opts.VariableWidths=[19 10 17 16];

caseTable2=readtable(dataname,opts);
caseTable=caseTable(1:length(FileList),:); %In case not all simulations are done
drehzahl2=caseTable2{:,2};
lagerlast2=caseTable2{:,3};
torque2=lagerlast2.*(n_planeten*l_s)./-1000;

PROB2=1:1:length(drehzahl2);
Files={};

for p=1:1:length(drehzahl2)
   PROB2(p)=PROB(find(drehzahl==drehzahl2(p) & torque==torque2(p)));
   scale2(p)=scale(find(drehzahl==drehzahl2(p) & torque==torque2(p)));
   Files{p}=FileList(find(drehzahl==drehzahl2(p) & torque==torque2(p))).folder;
end

PROB=PROB2;
scale=scale2;
drehzahl=drehzahl2;
torque=torque2;
FileList=Files';
torque_unique=unique(torque);
drehzahl_unique=unique(drehzahl);
drehzahl_gesamt=drehzahl_unique./i_PL;
[X,Y] = meshgrid(torque_unique,drehzahl_unique); 
[nrows,ncols] = size(X); 
%% Wear

normPROB=PROB./max(PROB);

scale(scale==inf)=1;
scale(isnan(scale))=1;

for i=1:1:size(FileList,1)
     sum_V = Archard(drehzahl(i),normPROB(i),Files{i},scale(i));
     V(i)=sum_V;
end

idv=find(V==0);
idp=find(maxPASP==0);

Vbar=zeros(size(X));
for i=1:1:ncols %complex solution can probably be done quicker
    for j=1:1:nrows
        if find(drehzahl==drehzahl_unique(j) & torque==torque_unique(i))>=1
            Vbar(j,i)=V(:,find(drehzahl==drehzahl_unique(j) & torque==torque_unique(i)));
        end
    end
end

save('Vbar_red_min2.mat', 'Vbar');
%save('PASPbar_red.mat', 'PASPbar');
%save('PASPbar_perc_red.mat', 'PASPbar_perc');
%% Figures
%norm_Vbar = Vbar./max(max(Vbar));

Vbar(Vbar==0)=nan;

f4 = figure(4);
b=bar3(Vbar);
zlabel({'Normalized Wear Criticality'});
yticks(linspace(1,14,7));
yticklabels({'2','6','10','14','18','22','26'});
ylabel('Rotational speed [rpm]');
xticks([1 5 9 13 17 ]);
xticklabels({'40','120','200','280','360'});
xlabel('Torque [kN]');
   [r,c] = find(isnan(Vbar));
    for i=1:numel(r)
    r_ = r(i);
    c_ = c(i);
    b(c_).CData(6*(r_-1)+1:6*r_, :) = nan;
    end
set(f4.Children, ...
    'FontName',     'Times', ...
    'FontSize',     10);
f4.Units               = 'centimeters';
f4.Position(3)         = 16;
f4.Position(4)         = 11;
% savefig(f4,'EHD_results_wear.fig');
% saveas(f4,'EHD_results_wear.png');
% saveas(f4,'EHD_results_wear.svg');

PASPbar_save=PASPbar_perc; 
PASPbar_perc(POFPbar == 0) = nan;
f4 = figure(4);
    b=bar3(PASPbar_perc);
    ylabel('Rotational Speed [rpm]');
    xlabel('Torque [kNm]');
    zlabel('Asperity contact area [%]');
    title('All points')
    yticklabels(drehzahl_gesamt');
    xticks([1:length(torque_unique)]);
    xticklabels(torque_unique');
    saveas(f4,'Asperity_contact_percentage_all.png');   
    savefig(f4,'Asperity_contact_percentage_all.fig');    
   [r,c] = find(isnan(PASPbar_perc));
    for i=1:numel(r)
    r_ = r(i);
    c_ = c(i);
    b(c_).CData(6*(r_-1)+1:6*r_, :) = nan;
    end

%% Wear
function sum_V = Archard(n,Acc_time,Folder,scale)
% n=drehzahl(37)
% Acc_time=normPROB(37)
% Folder=FileList(41).folder


oldFolder = cd(Folder);
numfiles = 3;   %Anzahl Ergebnisdateien

Acc_time_sec = Acc_time*3600*24*365*30;

    myfilename = 'Hauptlager-PRSA_000105.GID';
    opts = detectImportOptions(myfilename, 'FileType', 'text');
    opts.DataLines=94;              %31 text lines before results start, needs to be reprogrammed to line after 'END'
    opts.Whitespace='\b';
    opts.Delimiter=' ';
    opts.ConsecutiveDelimitersRule = 'join';
    opts.LeadingDelimitersRule = 'ignore';
    data_PRSA=readtable(myfilename,opts);
    data_PRSA=data_PRSA{:,2:size(data_PRSA,2)}; 
    for i = 1:size(data_PRSA,1)
        for j = 1:size(data_PRSA,2)
            POFP2(i,j)=str2double(data_PRSA(i,j));
        end
    end

angle= size(POFP2,1);
gridline = size(POFP2,2);

k = 1; %[mm^2/N]        %Archard Verschleißkoeffizient inklusive Härte
r= 82.5;     %[mm] Radius
w= 190;      %[mm] Lagerbreite
s_1 = r*2*pi*(1/360);     %Weg für 1° Drehung [mm]
A = 2*r*w*pi/(angle*gridline);

   for x = 1:angle
        for y= 1:gridline
            h_w(x,y) = k*POFP2(x,y)*s_1*scale;
        end 
    end


H_W = h_w*Acc_time_sec;
V_W = A*H_W;
sum_V=sum(V_W,'all');

cd(oldFolder)
end
