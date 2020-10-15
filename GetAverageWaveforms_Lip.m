%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   GetAverageWaveforms_Lip                                               %
%                                                                         %
%   By Gwijde Maegherman, 17/05/2019                                      %
%                                                                         %
%   This script is custom-built to get average waveforms of MEPs across   %
%   conditions and participants for Study 2 - Lip. A lot of it is poorly  %
%   optimised so alter with caution. Email g.maegherman@ucl.ac.uk if you  %
%   are unsure.                                                           %
%                                                                         %
%   This script requires the boundedline.m script and packages ( see      %
%   uk.mathworks.com/matlabcentral/fileexchange/27485-boundedline-m )to   %
%   be in the MATLAB path so add it before running the script.            %
%                                                                         %
%   In terms of file structure, ensure that you have a subjects folder in %
%   which each subject has their own MEP folder denoted by the muscle of  %
%   interest, e.g. 190517GM_Lip. The script specifically looks for        %
%   folders denoted with the specific muscle, so be sure to name it as    %
%   above or it will not be counted. Upon running the script, select the  %
%   subjects folder rather than the individual folders, so that the       %
%   script can crawl through all participants. When you select the        %   
%   subjects folder the running script should tell you how many subjects  %
%   were found - if you expected a different number check your folder     %
%   names. Selecting the subjects folder is the only input.               %
%                                                                         %
%   Mean, SD and SEM calculations are currently (and probably forever)    %
%   hardcoded, as are the graphs. You can play with the graphs once they  %
%   show up in the figure window.                                         %
%                                                                         %
%   To run the same analysis on the hand data, run                        %
%   GetAverageWaveforms_Hand.                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

%% Select files

% Select subject folder
folderName = uigetdir('Z:\', 'Select the subjects folder: ');
folderPath = cd(folderName);
% Only include if folder it a Tongue data folder
muscle = '*_Lip';
testMuscle = 2;                                                        % audioVisual takes A or V for audio or visual, and converts it to 1 or 2 respectively
folderInfo = dir(muscle);

disp('Number of participant folders found: ')
disp(length(folderInfo))

%% Load initial .mat to create structure arrays for conditions/timepoints
initialParticipant = folderInfo(1).name;
initialParticipantMat = strcat('.',filesep,initialParticipant,filesep,'MEP_1.mat');
load(initialParticipantMat)

% create cell arrays and add the times (x-axis) data to the first column

times = Ch3.times;
if length(Ch3.times) == 5201
    times(1,:)=[];
end

% This bit is poorly coded but at least you should be able to see what is 
% happening - just sets up cell arrays for each condition.

% Similarly set up cell arrays for means across participants (each per-
% participant mean will be appended to this (currently empty) array
overallmean_a50 = cell(5200,0);
overallmean_a150 = cell(5200,0);
overallmean_a250 = cell(5200,0);
overallmean_a350 = cell(5200,0);
overallmean_a450 = cell(5200,0);
overallmean_a550 = cell(5200,0);
overallmean_ai50 = cell(5200,0);
overallmean_ai150 = cell(5200,0);
overallmean_ai250 = cell(5200,0);
overallmean_ai350 = cell(5200,0);
overallmean_ai450 = cell(5200,0);
overallmean_ai550 = cell(5200,0);
overallmean_dn50 = cell(5200,0);
overallmean_dn150 = cell(5200,0);
overallmean_dn250 = cell(5200,0);
overallmean_dn350 = cell(5200,0);
overallmean_dn450 = cell(5200,0);
overallmean_dn550 = cell(5200,0);

%% Select individual participant folder based on folderInfo

for x = 1:length(folderInfo)
    currentParticipant = folderInfo(x).name;
    currentParticipant = strcat('.',filesep,currentParticipant);
    disp('Current participant is ')
    disp(currentParticipant)
    % cd to current participant folder
    cd(currentParticipant)

    %%
    % Get info file
    infoFile = dir('info*');
    infoFile = infoFile.name;
    load(infoFile);

    a50 = cell(5200,0);
    a150 = cell(5200,0);
    a250 = cell(5200,0);
    a350 = cell(5200,0);
    a450 = cell(5200,0);
    a550 = cell(5200,0);
    ai50 = cell(5200,0);
    ai150 = cell(5200,0);
    ai250 = cell(5200,0);
    ai350 = cell(5200,0);
    ai450 = cell(5200,0);
    ai550 = cell(5200,0);
    dn50 = cell(5200,0);
    dn150 = cell(5200,0);
    dn250 = cell(5200,0);
    dn350 = cell(5200,0);
    dn450 = cell(5200,0);
    dn550 = cell(5200,0);
    
    % For each trial/MEP, read timepoint and condition info
    % This should be 225 MEPs
    info([226:end],:) = [];
    for y = 1:length(info)
        participant = info(y,1);
        trial = info(y,2);
        condition = info{y,5};
        condition = num2str(condition);
        timepoint = info{y,6};
        timepoint = num2str(timepoint);
        mepName = info{y,8};
        mepMat = info{y,9};
        % load MEP_x.mat file (will load as Ch3)
        load(mepMat);
        % Catch if it has 5201 data values, delete first row if so
        if length(Ch3.values) == 5201 
            Ch3.values(1,:)=[];
        elseif length(Ch3.times) == 5201
            Ch3.times(1,:)=[];
        end
        
        % Depending on condition/timepoint, append values to appropriate columns
        if strcmp(condition, '1') == 1
            if strcmp(timepoint, '50') == 1
                a50 = [a50 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '150') == 1
                a150 = [a150 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '250') == 1
                a250 = [a250 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '350') == 1
                a350 = [a350 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '450') == 1
                a450 = [a450 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '550') == 1
                a550 = [a550 num2cell(Ch3.values)];                
            end
        elseif strcmp(condition, '2') == 1
            if strcmp(timepoint, '50') == 1
                ai50 = [ai50 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '150') == 1
                ai150 = [ai150 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '250') == 1
                ai250 = [ai250 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '350') == 1
                ai350 = [ai350 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '450') == 1
                ai450 = [ai450 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '550') == 1
                ai550 = [ai550 num2cell(Ch3.values)];                
            end
        elseif strcmp(condition, '3') == 1
            if strcmp(timepoint, '50') == 1
                dn50 = [dn50 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '150') == 1
                dn150 = [dn150 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '250') == 1
                dn250 = [dn250 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '350') == 1
                dn350 = [dn350 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '450') == 1
                dn450 = [dn450 num2cell(Ch3.values)];
            elseif strcmp(timepoint, '550') == 1
                dn550 = [dn550 num2cell(Ch3.values)];                
            end
        end
        clear Ch3

    end
    %% Create averages in a separate file for each of the condition/timepoints
    % cell2mat to get underlying doubles 

    a50 = cell2mat(a50);
    a150 = cell2mat(a150);
    a250 = cell2mat(a250);
    a350 = cell2mat(a350);
    a450 = cell2mat(a450);
    a550 = cell2mat(a550);
    ai50 = cell2mat(ai50);
    ai150 = cell2mat(ai150);
    ai250 = cell2mat(ai250);
    ai350 = cell2mat(ai350);
    ai450 = cell2mat(ai450);
    ai550 = cell2mat(ai550);
    dn50 = cell2mat(dn50);
    dn150 = cell2mat(dn150);
    dn250 = cell2mat(dn250);
    dn350 = cell2mat(dn350);
    dn450 = cell2mat(dn450);
    dn550 = cell2mat(dn550);

    % get means  for each participant and add to separate variable
    mean_a50 = mean(a50,2);
    mean_a150 = mean(a150,2);
    mean_a250 = mean(a250,2);    
    mean_a350 = mean(a350,2);    
    mean_a450 = mean(a450,2);    
    mean_a550 = mean(a550,2);    
    mean_ai50 = mean(ai50,2);
    mean_ai150 = mean(ai150,2);
    mean_ai250 = mean(ai250,2);    
    mean_ai350 = mean(ai350,2);    
    mean_ai450 = mean(ai450,2);    
    mean_ai550 = mean(ai550,2);    
    mean_dn50 = mean(dn50,2);
    mean_dn150 = mean(dn150,2);
    mean_dn250 = mean(dn250,2);    
    mean_dn350 = mean(dn350,2);    
    mean_dn450 = mean(dn450,2);    
    mean_dn550 = mean(dn550,2);

    % add per-participant mean to overall mean file
    overallmean_a50 = [overallmean_a50 num2cell(mean_a50)];
    overallmean_a150 = [overallmean_a150 num2cell(mean_a150)];
    overallmean_a250 = [overallmean_a250 num2cell(mean_a250)];    
    overallmean_a350 = [overallmean_a350 num2cell(mean_a350)];    
    overallmean_a450 = [overallmean_a450 num2cell(mean_a450)];    
    overallmean_a550 = [overallmean_a550 num2cell(mean_a550)];
    overallmean_ai50 = [overallmean_ai50 num2cell(mean_ai50)];
    overallmean_ai150 = [overallmean_ai150 num2cell(mean_ai150)];
    overallmean_ai250 = [overallmean_ai250 num2cell(mean_ai250)];    
    overallmean_ai350 = [overallmean_ai350 num2cell(mean_ai350)];    
    overallmean_ai450 = [overallmean_ai450 num2cell(mean_ai450)];    
    overallmean_ai550 = [overallmean_ai550 num2cell(mean_ai550)];
    overallmean_dn50 = [overallmean_dn50 num2cell(mean_dn50)];
    overallmean_dn150 = [overallmean_dn150 num2cell(mean_dn150)];
    overallmean_dn250 = [overallmean_dn250 num2cell(mean_dn250)];    
    overallmean_dn350 = [overallmean_dn350 num2cell(mean_dn350)];    
    overallmean_dn450 = [overallmean_dn450 num2cell(mean_dn450)];    
    overallmean_dn550 = [overallmean_dn550 num2cell(mean_dn550)];
    
    cd ..
end

%%

%Overall means per condition
overallmean_a = ((cell2mat(overallmean_a50) + cell2mat(overallmean_a150)... 
                + cell2mat(overallmean_a250) + cell2mat(overallmean_a350)...
                + cell2mat(overallmean_a450) + cell2mat(overallmean_a550))/6);
overallmean_ai = ((cell2mat(overallmean_ai50) + cell2mat(overallmean_ai150)... 
                + cell2mat(overallmean_ai250) + cell2mat(overallmean_ai350)...
                + cell2mat(overallmean_ai450) + cell2mat(overallmean_ai550))/6);
overallmean_dn = ((cell2mat(overallmean_dn50) + cell2mat(overallmean_dn150)... 
                + cell2mat(overallmean_dn250) + cell2mat(overallmean_dn350)...
                + cell2mat(overallmean_dn450) + cell2mat(overallmean_dn550))/6);         
      
%Overall means per timepoint            
overallmean_50 = ((cell2mat(overallmean_a50) + cell2mat(overallmean_ai50) + cell2mat(overallmean_dn50))/3);
overallmean_150 = ((cell2mat(overallmean_a150) + cell2mat(overallmean_ai150) + cell2mat(overallmean_dn150))/3);
overallmean_250 = ((cell2mat(overallmean_a250) + cell2mat(overallmean_ai250) + cell2mat(overallmean_dn250))/3);
overallmean_350 = ((cell2mat(overallmean_a350) + cell2mat(overallmean_ai350) + cell2mat(overallmean_dn350))/3);
overallmean_450 = ((cell2mat(overallmean_a450) + cell2mat(overallmean_ai450) + cell2mat(overallmean_dn450))/3);
overallmean_550 = ((cell2mat(overallmean_a550) + cell2mat(overallmean_ai550) + cell2mat(overallmean_dn550))/3);

% Get grand averages (across participants) and add to separate variable 
% containing times, means, SD and SEM

%a50
grandmean_a50 = mean(cell2mat(overallmean_a50),2);
grandstd_a50 = std(cell2mat(overallmean_a50),0,2);
grandsem_a50 = grandstd_a50 / sqrt(x);

%a150
grandmean_a150 = mean(cell2mat(overallmean_a150),2);
grandstd_a150 = std(cell2mat(overallmean_a150),0,2);
grandsem_a150 = grandstd_a150 / sqrt(x);

%a250
grandmean_a250 = mean(cell2mat(overallmean_a250),2);
grandstd_a250 = std(cell2mat(overallmean_a250),0,2);
grandsem_a250 = grandstd_a250 / sqrt(x);

%a350
grandmean_a350 = mean(cell2mat(overallmean_a350),2);
grandstd_a350 = std(cell2mat(overallmean_a350),0,2);
grandsem_a350 = grandstd_a350 / sqrt(x);

%a450
grandmean_a450 = mean(cell2mat(overallmean_a450),2);
grandstd_a450 = std(cell2mat(overallmean_a450),0,2);
grandsem_a450 = grandstd_a450 / sqrt(x);

%a550
grandmean_a550 = mean(cell2mat(overallmean_a550),2);
grandstd_a550 = std(cell2mat(overallmean_a550),0,2);
grandsem_a550 = grandstd_a550 / sqrt(x);

%ai50
grandmean_ai50 = mean(cell2mat(overallmean_ai50),2);
grandstd_ai50 = std(cell2mat(overallmean_ai50),0,2);
grandsem_ai50 = grandstd_ai50 / sqrt(x);

%ai150
grandmean_ai150 = mean(cell2mat(overallmean_ai150),2);
grandstd_ai150 = std(cell2mat(overallmean_ai150),0,2);
grandsem_ai150 = grandstd_ai150 / sqrt(x);

%ai250
grandmean_ai250 = mean(cell2mat(overallmean_ai250),2);
grandstd_ai250 = std(cell2mat(overallmean_ai250),0,2);
grandsem_ai250 = grandstd_ai250 / sqrt(x);

%ai350
grandmean_ai350 = mean(cell2mat(overallmean_ai350),2);
grandstd_ai350 = std(cell2mat(overallmean_ai350),0,2);
grandsem_ai350 = grandstd_ai350 / sqrt(x);

%ai450
grandmean_ai450 = mean(cell2mat(overallmean_ai450),2);
grandstd_ai450 = std(cell2mat(overallmean_ai450),0,2);
grandsem_ai450 = grandstd_ai450 / sqrt(x);

%ai550
grandmean_ai550 = mean(cell2mat(overallmean_ai550),2);
grandstd_ai550 = std(cell2mat(overallmean_ai550),0,2);
grandsem_ai550 = grandstd_ai550 / sqrt(x);

%dn50
grandmean_dn50 = mean(cell2mat(overallmean_dn50),2);
grandstd_dn50 = std(cell2mat(overallmean_dn50),0,2);
grandsem_dn50 = grandstd_dn50 / sqrt(x);

%a150
grandmean_dn150 = mean(cell2mat(overallmean_dn150),2);
grandstd_dn150 = std(cell2mat(overallmean_dn150),0,2);
grandsem_dn150 = grandstd_dn150 / sqrt(x);

%a250
grandmean_dn250 = mean(cell2mat(overallmean_dn250),2);
grandstd_dn250 = std(cell2mat(overallmean_dn250),0,2);
grandsem_dn250 = grandstd_dn250 / sqrt(x);

%a350
grandmean_dn350 = mean(cell2mat(overallmean_dn350),2);
grandstd_dn350 = std(cell2mat(overallmean_dn350),0,2);
grandsem_dn350 = grandstd_dn350 / sqrt(x);

%a450
grandmean_dn450 = mean(cell2mat(overallmean_dn450),2);
grandstd_dn450 = std(cell2mat(overallmean_dn450),0,2);
grandsem_dn450 = grandstd_dn450 / sqrt(x);

%a550
grandmean_dn550 = mean(cell2mat(overallmean_dn550),2);
grandstd_dn550 = std(cell2mat(overallmean_dn550),0,2);
grandsem_dn550 = grandstd_dn550 / sqrt(x);

%grandestmeans per condition

%a
grandmean_a = ((grandmean_a50 + grandmean_a150 + grandmean_a250...
                + grandmean_a350 + grandmean_a450 + grandmean_a550)/6);
grandstd_a = std(overallmean_a,0,2);
grandsem_a = grandstd_a / sqrt(x);

%ai
grandmean_ai = ((grandmean_ai50 + grandmean_ai150 + grandmean_ai250...
                + grandmean_ai350 + grandmean_ai450 + grandmean_ai550)/6);
grandstd_ai = std(overallmean_ai,0,2);
grandsem_ai = grandstd_ai / sqrt(x);

%dn
grandmean_dn = ((grandmean_dn50 + grandmean_dn150 + grandmean_dn250...
                + grandmean_dn350 + grandmean_dn450 + grandmean_dn550)/6);
grandstd_dn = std(overallmean_dn,0,2);
grandsem_dn = grandstd_dn / sqrt(x);

%50
grandmean_50 = ((grandmean_a50+grandmean_ai50+grandmean_dn50)/3);
grandstd_50 = std(overallmean_50,0,2);
grandsem_50 = grandstd_50 / sqrt(x);

%150
grandmean_150 = ((grandmean_a150+grandmean_ai150+grandmean_dn150)/3);
grandstd_150 = std(overallmean_150,0,2);
grandsem_150 = grandstd_150 / sqrt(x);

%250
grandmean_250 = ((grandmean_a250+grandmean_ai250+grandmean_dn250)/3);
grandstd_250 = std(overallmean_250,0,2);
grandsem_250 = grandstd_250 / sqrt(x);

%350
grandmean_350 = ((grandmean_a350+grandmean_ai350+grandmean_dn350)/3);
grandstd_350 = std(overallmean_350,0,2);
grandsem_350 = grandstd_350 / sqrt(x);

%450
grandmean_450 = ((grandmean_a450+grandmean_ai450+grandmean_dn450)/3);
grandstd_450 = std(overallmean_450,0,2);
grandsem_450 = grandstd_450 / sqrt(x);

%550
grandmean_550 = ((grandmean_a550+grandmean_ai550+grandmean_dn550)/3);
grandstd_550 = std(overallmean_550,0,2);
grandsem_550 = grandstd_550 / sqrt(x);

%SVG plots
times_msec = (times - 1)*1000;
time_1 = 5025;
time_2 = 5150;
xlim_min = 5;
xlim_max = 30;
ylim_min = -0.2;
ylim_max = 0.3;
x_label = ('Time(ms) post-pulse');
y_label = ('Amplitude (mV)');


%a50
figure(1)
boundedline(times_msec(time_1:time_2), grandmean_a50(time_1:time_2), grandsem_a50(time_1:time_2),'-b','alpha')
title('A50');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'A50'},'Location','northeast')

%a150
figure(2)
boundedline(times_msec(time_1:time_2), grandmean_a150(time_1:time_2), grandsem_a150(time_1:time_2),'-b','alpha')
title('A150');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'A150'},'Location','northeast')

%a250
figure(3)
boundedline(times_msec(time_1:time_2), grandmean_a250(time_1:time_2), grandsem_a250(time_1:time_2),'-b','alpha')
title('A250');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'A350'},'Location','northeast')

%a350
figure(4)
boundedline(times_msec(time_1:time_2), grandmean_a350(time_1:time_2), grandsem_a350(time_1:time_2),'-b','alpha')
title('A350');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'A350'},'Location','northeast')

%a450
figure(5)
boundedline(times_msec(time_1:time_2), grandmean_a450(time_1:time_2), grandsem_a450(time_1:time_2),'-b','alpha')
title('A450');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'A450'},'Location','northeast')

%a550
figure(6)
boundedline(times_msec(time_1:time_2), grandmean_a50(time_1:time_2), grandsem_a50(time_1:time_2),'-b','alpha')
title('A550');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'A550'},'Location','northeast')


%ai50
figure(7)
boundedline(times_msec(time_1:time_2), grandmean_ai50(time_1:time_2), grandsem_ai50(time_1:time_2),'-r','alpha')
title('AI50');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI50'},'Location','northeast')

%ai150
figure(8)
boundedline(times_msec(time_1:time_2), grandmean_ai150(time_1:time_2), grandsem_ai150(time_1:time_2),'-r','alpha')
title('AI150');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI150'},'Location','northeast')

%ai250
figure(9)
boundedline(times_msec(time_1:time_2), grandmean_ai250(time_1:time_2), grandsem_ai250(time_1:time_2),'-r','alpha')
title('AI250');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI250'},'Location','northeast')

%ai350
figure(10)
boundedline(times_msec(time_1:time_2), grandmean_ai350(time_1:time_2), grandsem_ai350(time_1:time_2),'-r','alpha')
title('AI350');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI350'},'Location','northeast')

%ai450
figure(11)
boundedline(times_msec(time_1:time_2), grandmean_ai450(time_1:time_2), grandsem_ai450(time_1:time_2),'-r','alpha')
title('AI450');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI450'},'Location','northeast')

%ai550
figure(12)
boundedline(times_msec(time_1:time_2), grandmean_ai550(time_1:time_2), grandsem_ai550(time_1:time_2),'-r','alpha')
title('AI550');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI550'},'Location','northeast')

%dn50
figure(13)
boundedline(times_msec(time_1:time_2), grandmean_dn50(time_1:time_2), grandsem_dn50(time_1:time_2),'-y','alpha')
title('DN50');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'DN50'},'Location','northeast')

%dn150
figure(14)
boundedline(times_msec(time_1:time_2), grandmean_dn150(time_1:time_2), grandsem_dn150(time_1:time_2),'-y','alpha')
title('DN150');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'DN150'},'Location','northeast')

%dn250
figure(15)
boundedline(times_msec(time_1:time_2), grandmean_dn250(time_1:time_2), grandsem_dn250(time_1:time_2),'-y','alpha')
title('DN250');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'DN250'},'Location','northeast')

%dn350
figure(16)
boundedline(times_msec(time_1:time_2), grandmean_dn350(time_1:time_2), grandsem_dn350(time_1:time_2),'-y','alpha')
title('DN350');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'DN350'},'Location','northeast')

%dn450
figure(17)
boundedline(times_msec(time_1:time_2), grandmean_dn450(time_1:time_2), grandsem_dn450(time_1:time_2),'-y','alpha')
title('DN450');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'DN450'},'Location','northeast')

%dn550
figure(18)
boundedline(times_msec(time_1:time_2), grandmean_dn550(time_1:time_2), grandsem_dn550(time_1:time_2),'-y','alpha')
title('DN550');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'DN550'},'Location','northeast')


%%COMBOS

%ai vs h vs dn
figure(19)
boundedline(times_msec(time_1:time_2), grandmean_a(time_1:time_2), grandsem_a(time_1:time_2),...
            times_msec(time_1:time_2), grandmean_ai(time_1:time_2), grandsem_ai(time_1:time_2),...
            times_msec(time_1:time_2), grandmean_dn(time_1:time_2), grandsem_dn(time_1:time_2),'alpha')
title('A(b) vs AI(r) vs DN(y)');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'A','AI','DN'},'Location','northeast')

%200 vs 500
figure(20)
boundedline(times_msec(time_1:time_2), grandmean_200(time_1:time_2), grandsem_200(time_1:time_2),'-k',times_msec(time_1:time_2), grandmean_500(time_1:time_2), grandsem_500(time_1:time_2),'-y','alpha')
title('200(b) vs 500(r)');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'200','500'},'Location','northeast')


