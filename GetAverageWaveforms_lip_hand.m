

%% Select files
% Select subject folder
folderName = uigetdir('Z:\', 'Select the subjects folder: ');
folderPath = cd(folderName);
% Only include if folder it a Tongue data folder
testMuscle = '';                                                        % audioVisual takes A or V for audio or visual, and converts it to 1 or 2 respectively
while isequal(testMuscle,'');
    testMuscle = input('hand or lip? ', 's');
        if strcmp('hand',testMuscle) == 1;                              % Set to Hand
        muscle = 'Hand';
        testMuscle = 1;
        elseif strcmp('lip',testMuscle) == 1;                           % Set to Lip
        muscle = 'Lip';
        testMuscle = 2;
        end
end
folderInfo = dir(muscle);


%% Load initial .mat to create structure arrays for conditions/timepoints
initialParticipant = folderInfo(1).name;
initialParticipantMat = strcat('.',filesep,initialParticipant,filesep,'MEP_1.mat');
load(initialParticipantMat)

% create cell arrays and add the times (x-axis) data to the first column
if textCondition == 1
    times = Ch1.times;
elseif textCondition == 2
    times = Ch3.times;
end

if length(Ch3.times) == 5201 || length(Ch1.times) == 5201
    times(1,:)=[];
end

a50 = cell(5200,0);
a50 = [a50 num2cell(times)];
a150 = cell(5200,0);
a150 = [a150 num2cell(times)];
a250 = cell(5200,0);
a250 = [a250 num2cell(times)];
a350 = cell(5200,0);
a350 = [a350 num2cell(times)];
a450 = cell(5200,0);
a450 = [a450 num2cell(times)];
a550 = cell(5200,0);
a550 = [a550 num2cell(times)];
ai50 = cell(5200,0);
ai50 = [ai50 num2cell(times)];
ai150 = cell(5200,0);
ai150 = [ai150 num2cell(times)];
ai250 = cell(5200,0);
ai250 = [ai250 num2cell(times)];
ai350 = cell(5200,0);
ai350 = [ai350 num2cell(times)];
ai450 = cell(5200,0);
ai450 = [ai450 num2cell(times)];
ai550 = cell(5200,0);
ai550 = [ai550 num2cell(times)];
dn50 = cell(5200,0);
dn50 = [dn50 num2cell(times)];
dn150 = cell(5200,0);
dn150 = [dn150 num2cell(times)];
dn250 = cell(5200,0);
dn250 = [dn250 num2cell(times)];
dn350 = cell(5200,0);
dn350 = [dn350 num2cell(times)];
dn450 = cell(5200,0);
dn450 = [dn450 num2cell(times)];
dn550 = cell(5200,0);
dn550 = [dn550 num2cell(times)];

%overallmeans
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
    a50 = [a50 num2cell(times)];
    a150 = cell(5200,0);
    a150 = [a150 num2cell(times)];
    a250 = cell(5200,0);
    a250 = [a250 num2cell(times)];
    a350 = cell(5200,0);
    a350 = [a350 num2cell(times)];
    a450 = cell(5200,0);
    a450 = [a450 num2cell(times)];
    a550 = cell(5200,0);
    a550 = [a550 num2cell(times)];
    ai50 = cell(5200,0);
    ai50 = [ai50 num2cell(times)];
    ai150 = cell(5200,0);
    ai150 = [ai150 num2cell(times)];
    ai250 = cell(5200,0);
    ai250 = [ai250 num2cell(times)];
    ai350 = cell(5200,0);
    ai350 = [ai350 num2cell(times)];
    ai450 = cell(5200,0);
    ai450 = [ai450 num2cell(times)];
    ai550 = cell(5200,0);
    ai550 = [ai550 num2cell(times)];
    dn50 = cell(5200,0);
    dn50 = [dn50 num2cell(times)];
    dn150 = cell(5200,0);
    dn150 = [dn150 num2cell(times)];
    dn250 = cell(5200,0);
    dn250 = [dn250 num2cell(times)];
    dn350 = cell(5200,0);
    dn350 = [dn350 num2cell(times)];
    dn450 = cell(5200,0);
    dn450 = [dn450 num2cell(times)];
    dn550 = cell(5200,0);
    dn550 = [dn550 num2cell(times)];
    
    % For each trial/MEP, read timepoint and condition info
    % This should be 240 MEPs
    for y = 1:length(info)
        participant = info(y,1);
        trial = info(y,2);
        condition = info{y,3};
        condition = num2str(condition);
        timepoint = info{y,4};
        timepoint = num2str(timepoint);
        mepName = info{y,5};
        mepMat = info{y,6};
        % load MEP_x.mat file (will load as Ch3)
        load(mepMat);
        % Catch if it has 5201 data values, delete first row if so
        if testMuscle == 1
            if length(Ch1.values) == 5201 
                Ch1.values(1,:)=[];
            elseif length(Ch1.times) == 5201
                Ch1.times(1,:)=[];
            end
        elseif testMuscle == 2
            if length(Ch3.values) == 5201 
                Ch3.values(1,:)=[];
            elseif length(Ch3.times) == 5201
                Ch3.times(1,:)=[];
            end
        end
        % Depending on condition/timepoint, append values to appropriate columns
        if testMuscle == 1    
            if condition == '1'
                if timepoint == '50'
                    a50 = [a50 num2cell(Ch3.values)];
                elseif timepoint == '150'
                    a150 = [a150 num2cell(Ch3.values)];
                elseif timepoint == '250'
                    a250 = [a250 num2cell(Ch3.values)];
                elseif timepoint == '350'
                    a350 = [a350 num2cell(Ch3.values)];
                elseif timepoint == '450'
                    a450 = [a450 num2cell(Ch3.values)];
                elseif timepoint == '550'
                    a550 = [a550 num2cell(Ch3.values)];                
                end
            elseif condition == '3'
                if timepoint == '50'
                    ai50 = [ai50 num2cell(Ch3.values)];
                elseif timepoint == '150'
                    ai150 = [ai150 num2cell(Ch3.values)];
                elseif timepoint == '250'
                    ai250 = [ai250 num2cell(Ch3.values)];
                elseif timepoint == '350'
                    ai350 = [ai350 num2cell(Ch3.values)];
                elseif timepoint == '450'
                    ai450 = [ai450 num2cell(Ch3.values)];
                elseif timepoint == '550'
                    ai550 = [ai550 num2cell(Ch3.values)];                
                end
            elseif condition == '4'
                if timepoint == '50'
                    dn50 = [dn50 num2cell(Ch3.values)];
                elseif timepoint == '150'
                    dn150 = [dn150 num2cell(Ch3.values)];
                elseif timepoint == '250'
                    dn250 = [dn250 num2cell(Ch3.values)];
                elseif timepoint == '350'
                    dn350 = [dn350 num2cell(Ch3.values)];
                elseif timepoint == '450'
                    dn450 = [dn450 num2cell(Ch3.values)];
                elseif timepoint == '550'
                    dn550 = [dn550 num2cell(Ch3.values)];                
                end
            end
        elseif testMuscle == 2
            if condition == '1'
                if timepoint == '50'
                    a50 = [a50 num2cell(Ch3.values)];
                elseif timepoint == '150'
                    a150 = [a150 num2cell(Ch3.values)];
                elseif timepoint == '250'
                    a250 = [a250 num2cell(Ch3.values)];
                elseif timepoint == '350'
                    a350 = [a350 num2cell(Ch3.values)];
                elseif timepoint == '450'
                    a450 = [a450 num2cell(Ch3.values)];
                elseif timepoint == '550'
                    a550 = [a550 num2cell(Ch3.values)];                
                end
            elseif condition == '3'
                if timepoint == '50'
                    ai50 = [ai50 num2cell(Ch3.values)];
                elseif timepoint == '150'
                    ai150 = [ai150 num2cell(Ch3.values)];
                elseif timepoint == '250'
                    ai250 = [ai250 num2cell(Ch3.values)];
                elseif timepoint == '350'
                    ai350 = [ai350 num2cell(Ch3.values)];
                elseif timepoint == '450'
                    ai450 = [ai450 num2cell(Ch3.values)];
                elseif timepoint == '550'
                    ai550 = [ai550 num2cell(Ch3.values)];                
                end
            elseif condition == '4'
                if timepoint == '50'
                    dn50 = [dn50 num2cell(Ch3.values)];
                elseif timepoint == '150'
                    dn150 = [dn150 num2cell(Ch3.values)];
                elseif timepoint == '250'
                    dn250 = [dn250 num2cell(Ch3.values)];
                elseif timepoint == '350'
                    dn350 = [dn350 num2cell(Ch3.values)];
                elseif timepoint == '450'
                    dn450 = [dn450 num2cell(Ch3.values)];
                elseif timepoint == '550'
                    dn550 = [dn550 num2cell(Ch3.values)];                
                end
            end
        end
        if testMuscle == 2
            clear Ch3
        elseif testMuscle == 1
            clear Ch1
        end
    end
    %% Create averages in a separate file for each of the condition/timepoints
    % cell2mat to get underlying doubles 

    ai200 = cell2mat(ai200);
    ai500 = cell2mat(ai500);
    h200 = cell2mat(h200);
    h500 = cell2mat(h500);
    dn200 = cell2mat(dn200);
    dn500 = cell2mat(dn500);

    % get means  for each participant and add to separate variable
    mean_ai200 = mean(ai200,2);
    mean_ai500 = mean(ai500,2);
    mean_h200 = mean(h200,2);
    mean_h500 = mean(h500,2);
    mean_dn200 = mean(dn200,2);
    mean_dn500 = mean(dn500,2);

    % add per-participant mean to overall mean file
    overallmean_ai200 = [overallmean_ai200 num2cell(mean_ai200)];
    overallmean_ai500 = [overallmean_ai500 num2cell(mean_ai500)];
    overallmean_h200 = [overallmean_h200 num2cell(mean_h200)];
    overallmean_h500 = [overallmean_h500 num2cell(mean_h500)];
    overallmean_dn200 = [overallmean_dn200 num2cell(mean_dn200)];
    overallmean_dn500 = [overallmean_dn500 num2cell(mean_dn500)];

    cd ..
end

%%

overallmean_ai = ((cell2mat(overallmean_ai200) + cell2mat(overallmean_ai500))/2)
overallmean_h = ((cell2mat(overallmean_h200) + cell2mat(overallmean_h500))/2)
overallmean_dn = ((cell2mat(overallmean_dn200) + cell2mat(overallmean_dn500))/2)
overallmean_200 = ((cell2mat(overallmean_ai200) + cell2mat(overallmean_h200) + cell2mat(overallmean_dn200))/3)
overallmean_500 = ((cell2mat(overallmean_ai500) + cell2mat(overallmean_h500) + cell2mat(overallmean_dn500))/3)
% Get grand averages and add to separate variable containing times,
% mean,stdev

%ai200
grandmean_ai200 = mean(cell2mat(overallmean_ai200),2);
grandstd_ai200 = std(cell2mat(overallmean_ai200),0,2);
grandsem_ai200 = grandstd_ai200 / sqrt(x);


%ai500
grandmean_ai500 = mean(cell2mat(overallmean_ai500),2);
grandstd_ai500 = std(cell2mat(overallmean_ai500),0,2);
grandsem_ai500 = grandstd_ai500 / sqrt(x);


%h200
grandmean_h200 = mean(cell2mat(overallmean_h200),2);
grandstd_h200 = std(cell2mat(overallmean_h200),0,2);
grandsem_h200 = grandstd_h200 / sqrt(x);


%h500
grandmean_h500 = mean(cell2mat(overallmean_h500),2);
grandstd_h500 = std(cell2mat(overallmean_h500),0,2);
grandsem_h500 = grandstd_h500 / sqrt(x);


%dn200
grandmean_dn200 = mean(cell2mat(overallmean_dn200),2);
grandstd_dn200 = std(cell2mat(overallmean_dn200),0,2);
grandsem_dn200 = grandstd_dn200 / sqrt(x);


%dn500
grandmean_dn500 = mean(cell2mat(overallmean_dn500),2);
grandstd_dn500 = std(cell2mat(overallmean_dn500),0,2);
grandsem_dn500 = grandstd_dn500 / sqrt(x);

%grandestmeans per condition

%ai
grandmean_ai = ((grandmean_ai200+grandmean_ai500)/2)
grandstd_ai = std(overallmean_ai,0,2);
grandsem_ai = grandstd_ai / sqrt(x);

%h
grandmean_h = ((grandmean_h200+grandmean_h500)/2)
grandstd_h = std(overallmean_h,0,2);
grandsem_h = grandstd_h / sqrt(x);

%h
grandmean_dn = ((grandmean_dn200+grandmean_dn500)/2)
grandstd_dn = std(overallmean_dn,0,2);
grandsem_dn = grandstd_dn / sqrt(x);

%200
grandmean_200 = ((grandmean_ai200+grandmean_h200+grandmean_dn200)/3)
grandstd_200 = std(overallmean_200,0,2);
grandsem_200 = grandstd_200 / sqrt(x);

grandmean_500 = ((grandmean_ai500+grandmean_h500+grandmean_dn500)/3)
grandstd_500 = std(overallmean_500,0,2);
grandsem_500 = grandstd_500 / sqrt(x);


%SVG plots

time_1 = 5025
time_2 = 5150
xlim_min = 5
xlim_max = 30
ylim_min = -0.2
ylim_max = 0.3
x_label = ('Time(ms) post-pulse')
y_label = ('Amplitude (mV)')


%ai200
figure(1)
boundedline(times_msec(time_1:time_2), grandmean_ai200(time_1:time_2), grandsem_ai200(time_1:time_2),'-b','alpha')
title('AI200');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI 200'},'Location','northeast')

%ai500
figure(2)
boundedline(times_msec(time_1:time_2), grandmean_ai500(time_1:time_2), grandsem_ai500(time_1:time_2),'-r','alpha')
title('AI500');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI 500'},'Location','northeast')

%h200
figure(3)
boundedline(times_msec(time_1:time_2), grandmean_h200(time_1:time_2), grandsem_h200(time_1:time_2),'-b','alpha')
title('H200');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'H200'},'Location','northeast')

%h500
figure(4)
boundedline(times_msec(time_1:time_2), grandmean_h500(time_1:time_2), grandsem_h500(time_1:time_2),'-r','alpha')
title('H500');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'H500'},'Location','northeast')

%dn200
figure(5)
boundedline(times_msec(time_1:time_2), grandmean_dn200(time_1:time_2), grandsem_dn200(time_1:time_2),'-b','alpha')
title('DN200');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'DN200'},'Location','northeast')

%dn500
figure(7)
boundedline(times_msec(time_1:time_2), grandmean_dn500(time_1:time_2), grandsem_dn500(time_1:time_2),'-r','alpha')
title('DN500');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'DN500'},'Location','northeast')


%%COMBOS
%ai200 vs ai500
figure(8)
boundedline(times_msec(time_1:time_2), grandmean_ai200(time_1:time_2), grandsem_ai200(time_1:time_2),'-b',times_msec(time_1:time_2), grandmean_ai500(time_1:time_2), grandsem_ai500(time_1:time_2),'-r','alpha')
title('AI200(b) vs AI500(r)');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI200','AI500'},'Location','northeast')

%h200 vs h500
figure(9)
boundedline(times_msec(time_1:time_2), grandmean_h200(time_1:time_2), grandsem_h200(time_1:time_2),'-b',times_msec(time_1:time_2), grandmean_h500(time_1:time_2), grandsem_h500(time_1:time_2),'-r','alpha')
title('H200(b) vs H500(r)');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'H200','H500'},'Location','northeast')

%DN300 vs DN500
figure(10)
boundedline(times_msec(time_1:time_2), grandmean_dn200(time_1:time_2), grandsem_dn200(time_1:time_2),'-b',times_msec(time_1:time_2), grandmean_dn500(time_1:time_2), grandsem_dn500(time_1:time_2),'-r','alpha')
title('DN200(b) vs DN500(r)');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'DN200','DN500'},'Location','northeast')

%ai200 vs h200 vs dn200
figure(11)
boundedline(times_msec(time_1:time_2), grandmean_ai200(time_1:time_2), grandsem_ai200(time_1:time_2),'-b',times_msec(time_1:time_2), grandmean_h200(time_1:time_2), grandsem_h200(time_1:time_2),'-r', times_msec(time_1:time_2), grandmean_dn200(time_1:time_2), grandsem_dn200(time_1:time_2),'-y','alpha')
title('AI200(b) vs H200(r) vs DN200(y)');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI200','H200','DN200'},'Location','northeast')

%ai500 vs h500 vs dn500
figure(12)
boundedline(times_msec(time_1:time_2), grandmean_ai500(time_1:time_2), grandsem_ai500(time_1:time_2),'-b',times_msec(time_1:time_2), grandmean_h500(time_1:time_2), grandsem_h500(time_1:time_2),'-r', times_msec(time_1:time_2), grandmean_dn500(time_1:time_2), grandsem_dn500(time_1:time_2),'-y','alpha')
title('AI500(b) vs H500(r) vs DN500(y)');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI500','H500','DN500'},'Location','northeast')

%ai vs h vs dn
figure(13)
boundedline(times_msec(time_1:time_2), grandmean_ai(time_1:time_2), grandsem_ai(time_1:time_2),'-b',times_msec(time_1:time_2), grandmean_h(time_1:time_2), grandsem_h(time_1:time_2),'-r', times_msec(time_1:time_2), grandmean_dn(time_1:time_2), grandsem_dn(time_1:time_2),'-y','alpha')
title('AI(b) vs H(r) vs DN(y)');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'AI','H','DN'},'Location','northeast')

%200 vs 500
figure(15)
boundedline(times_msec(time_1:time_2), grandmean_200(time_1:time_2), grandsem_200(time_1:time_2),'-k',times_msec(time_1:time_2), grandmean_500(time_1:time_2), grandsem_500(time_1:time_2),'-y','alpha')
title('200(b) vs 500(r)');
xlim([min(xlim_min) max(xlim_max)])
ylim([min(ylim_min) max(ylim_max)])
xlabel(x_label)
ylabel(y_label)
legend({'200','500'},'Location','northeast')


