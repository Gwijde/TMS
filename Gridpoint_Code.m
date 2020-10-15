%{
    Copyright (C) Cambridge Electronic Design Limited 2014
    Author: Greg P. Smith
    Web: www.ced.co.uk email: greg@ced.co.uk

    This file is part of CEDS64ML, an SON MATLAB interface.

    CEDS64ML is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    CEDS64ML is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with CEDS64ML.  If not, see <http://www.gnu.org/licenses/>.
%}

% This function reads a number of MEPs in a specific folder (the script
% needs to be in the top-level domain, with a subjects folder (containing
% individual subject folders with MEPs) at the same level. 
% In addition to ExamplePeakFind, it also segments MEPs as being part of an
% orientation and then uses the mean to figure out the best orientation.
% this can also be used to find the best location.
% This function opens a file and reads the data from a waveform channel as 32-bit floats. Then iterates through the data looking for local minima and maxima. It does not alter the orignal data.
% clear workspace

% Creates graph to show best orientation. Number of stimuli is not
% hardcoded, but number of orientatinos is hardcoded at 8
% (0,45,90,135,180,225,270,315).

% MEPNum is a counter increasing with each analysis. Used in collectMEP
% array assignment
MEPNum = 1;
% Ask subject folder
disp('Begin script')

subjName = '';                                                             % This creates the variable subjName as an empty variable
while isequal(subjName,'');
    subjName = input('Subject name? ', 's');                               % This allows you to enter the specific identification to be used for participants (generally Year,Month,Day,Initial e.g. 170220DKH)
end

% Ask subject folder
MEPTotal = '';                                                             % This creates the variable subjName as an empty variable
while isequal(MEPTotal,'');
    MEPTotal = input('Total MEPs? ');                               % This allows you to enter the specific identification to be used for participants (generally Year,Month,Day,Initial e.g. 170220DKH)
end

% Ask subject folder
MEPPerGridpoint = '';                                                             % This creates the variable subjName as an empty variable
while isequal(MEPPerGridpoint,'');
    MEPPerGridpoint = input('MEPs per Gridpoint? ');                               % This allows you to enter the specific identification to be used for participants (generally Year,Month,Day,Initial e.g. 170220DKH)
end

% Ask subject folder
j = '';                                                             % This creates the variable subjName as an empty variable
while isequal(j,'');
    j = input('Hand or Lip? (1/2) ');                               % This allows you to enter the specific identification to be used for participants (generally Year,Month,Day,Initial e.g. 170220DKH)
end

% Ask subject folder
% getJPG = '';                                                             % This creates the variable subjName as an empty variable
% while isequal(getJPG,'');
%     getJPG = input('Get individual MEPs? (1/0) ');                               % This allows you to enter the specific identification to be used for participants (generally Year,Month,Day,Initial e.g. 170220DKH)
% end
getJPG = 0;


% collectMEP is a cell arrat which ends up containing the MEP number and
% the peak-to-peak amplitude
collectedMEPs = cell(MEPTotal,2);

% add path to CED code
if isempty(getenv('CEDS64ML'))
    setenv('CEDS64ML', 'C:\CEDMATLAB\CEDS64ML');
end
cedpath = getenv('CEDS64ML');
addpath(cedpath);
% load ceds64int.dll
CEDS64LoadLib( cedpath );
% for j = 1:2
%     %Set Path
%     if j == 1
%         subjFolder = strcat('MEP data extraction',filesep,'Hand',filesep,subjName,filesep,'LH',filesep);
%     elseif j ==2
%         subjFolder = strcat('MEP data extraction',filesep,'Lip',filesep,subjName,filesep,'LH',filesep);
%     end
subjFolder = strcat('MEP data extraction',filesep,'Localisation',filesep,subjName,filesep);
%Determine orientation


% Main loop
for i = 1:MEPTotal
    currentMEP = strcat('MEP_',num2str(i),'.smr');
    MEPFullPath = strcat(subjFolder,filesep,currentMEP);
    % Open a file
    fhand1 = CEDS64Open(MEPFullPath);
    if (fhand1 <= 0); unloadlibrary ceds64int; return; end
    [ iOk, TimeDate ] = CEDS64TimeDate( fhand1 );
    if iOk < 0, CEDS64ErrorMessage(iOk), return; end
    [ TimeBase ] = CEDS64TimeBase( fhand1 );
    if iOk < 0, CEDS64ErrorMessage(iOk), return; end
    [ Rate ] = CEDS64IdealRate( fhand1, 1 );
    [ Div ] = CEDS64ChanDiv( fhand1, 1 );
    % get waveform data from channel 1
    if j == 1
        [ fRead, fVals, fTime ] = CEDS64ReadWaveF( fhand1, 1, 100000, 0 );
    elseif j == 2
        [ fRead, fVals, fTime ] = CEDS64ReadWaveF( fhand1, 2, 100000, 0 );        
    end    

    L = length(fVals);
    W = 20;
    iPeak = 1;
    iTrough = 1;
    for m=1:L
        fPlot(m,2) = fVals(m);
        fPlot(m,1) = m*(TimeBase*Div);
        fint = fVals(max(m-W,1):min(m+W,L));
        if (fVals(m) == max(fint))
            Peaks(iPeak, 1) = m*(TimeBase*Div);
            Peaks(iPeak, 2) = fVals(m);
            iPeak = iPeak +1;
        else if (fVals(m) == min(fint))
            Trough(iTrough, 1) = m*(TimeBase*Div);
            Trough(iTrough, 2) = fVals(m);
            iTrough = iTrough +1;
            end
        end
    end

    if getJPG == 1
        fig = figure;
        plot(fPlot(:,1),fPlot(:,2),'-',Peaks(:,1),Peaks(:,2),'-',Trough(:,1),Trough(:,2),'-');
        %Save image of each MEP
        fileName = strcat('MEP_',num2str(MEPNum));
        saveas(fig,fileName,'jpg');
    elseif getJPG == 0
    end

    MEPValue = fPlot([1:500],2);

    maxVal=max(MEPValue);
    maxVal = double(maxVal);
    minVal=-(min(MEPValue));                                       % minval is negated as this will give us a positive number for addition later
    minVal = double(minVal);
    % Compute peak-to-peak by adding maxVal to minVal
    peakToPeak = maxVal + minVal;
%         % Delete timepoints before and including TMS pulse, then find maximum and minium values
%         Peaks([1 2 3 4],:) = [];
%         Trough([1 2 3 4 5 6],:) = [];
%         maxVal=max(max(Peaks,[],2));
%         minVal=-(min(min(Trough,[],2)));                                       % minval is negated as this will give us a positive number for addition later
%         % Compute peak-to-peak by adding maxVal to minVal
%         peakToPeak = maxVal + minVal;


    %Store peak-to-peak score in collectMEP
    collectedMEPs{MEPNum,1} = i;
    collectedMEPs{MEPNum,2} = peakToPeak;
    clc;
    disp(strcat(' MEPs collected:  ',num2str(MEPNum)))      
    MEPNum = MEPNum + 1;

    % close all the files
    CEDS64CloseAll();    
end
% end
disp('MEP collection finished')

%Save collectedMEPs for potential analysis later
save(strcat(subjFolder,'/collectedMEPs',subjName,'.mat'),('collectedMEPs'));         % This saves the created cell array named 'info' into each participants individually created folder.
xlswrite(strcat(subjFolder,'_collectedMEPs'),collectedMEPs);   

%Drop 3rd column (orientations) for cell2mat to work
overallMEPs = cell2mat(collectedMEPs);
overallMeans = cell(32,2);

disp('Averaging...')

mean0 = mean(overallMEPs(([1:(MEPPerGridpoint*1)]),2));
mean1 = mean(overallMEPs(([((MEPPerGridpoint*1)+1):(MEPPerGridpoint*2)]),2));
mean2 = mean(overallMEPs(([((MEPPerGridpoint*2)+1):(MEPPerGridpoint*3)]),2));
mean3 = mean(overallMEPs(([((MEPPerGridpoint*3)+1):(MEPPerGridpoint*4)]),2));
mean4 = mean(overallMEPs(([((MEPPerGridpoint*4)+1):(MEPPerGridpoint*5)]),2));
mean5 = mean(overallMEPs(([((MEPPerGridpoint*5)+1):(MEPPerGridpoint*6)]),2));
mean6 = mean(overallMEPs(([((MEPPerGridpoint*6)+1):(MEPPerGridpoint*7)]),2));
mean7 = mean(overallMEPs(([((MEPPerGridpoint*7)+1):(MEPPerGridpoint*8)]),2));
mean8 = mean(overallMEPs(([((MEPPerGridpoint*8)+1):(MEPPerGridpoint*9)]),2));
mean9 = mean(overallMEPs(([((MEPPerGridpoint*9)+1):(MEPPerGridpoint*10)]),2));
mean10 = mean(overallMEPs(([((MEPPerGridpoint*10)+1):(MEPPerGridpoint*11)]),2));
mean11 = mean(overallMEPs(([((MEPPerGridpoint*11)+1):(MEPPerGridpoint*12)]),2));
mean12 = mean(overallMEPs(([((MEPPerGridpoint*12)+1):(MEPPerGridpoint*13)]),2));
mean13 = mean(overallMEPs(([((MEPPerGridpoint*13)+1):(MEPPerGridpoint*14)]),2));
mean14 = mean(overallMEPs(([((MEPPerGridpoint*14)+1):(MEPPerGridpoint*15)]),2));
mean15 = mean(overallMEPs(([((MEPPerGridpoint*15)+1):(MEPPerGridpoint*16)]),2));
mean16 = mean(overallMEPs(([((MEPPerGridpoint*16)+1):(MEPPerGridpoint*17)]),2));
mean17 = mean(overallMEPs(([((MEPPerGridpoint*17)+1):(MEPPerGridpoint*18)]),2));
mean18 = mean(overallMEPs(([((MEPPerGridpoint*18)+1):(MEPPerGridpoint*19)]),2));
mean19 = mean(overallMEPs(([((MEPPerGridpoint*19)+1):(MEPPerGridpoint*20)]),2));
mean20 = mean(overallMEPs(([((MEPPerGridpoint*20)+1):(MEPPerGridpoint*21)]),2));
mean21 = mean(overallMEPs(([((MEPPerGridpoint*21)+1):(MEPPerGridpoint*22)]),2));
mean22 = mean(overallMEPs(([((MEPPerGridpoint*22)+1):(MEPPerGridpoint*23)]),2));
mean23 = mean(overallMEPs(([((MEPPerGridpoint*23)+1):(MEPPerGridpoint*24)]),2));
mean24 = mean(overallMEPs(([((MEPPerGridpoint*24)+1):(MEPPerGridpoint*25)]),2));
mean25 = mean(overallMEPs(([((MEPPerGridpoint*25)+1):(MEPPerGridpoint*26)]),2));
mean26 = mean(overallMEPs(([((MEPPerGridpoint*26)+1):(MEPPerGridpoint*27)]),2));
mean27 = mean(overallMEPs(([((MEPPerGridpoint*27)+1):(MEPPerGridpoint*28)]),2));
mean28 = mean(overallMEPs(([((MEPPerGridpoint*28)+1):(MEPPerGridpoint*29)]),2));
mean29 = mean(overallMEPs(([((MEPPerGridpoint*29)+1):(MEPPerGridpoint*30)]),2));
mean30 = mean(overallMEPs(([((MEPPerGridpoint*30)+1):(MEPPerGridpoint*31)]),2));
mean31 = mean(overallMEPs(([((MEPPerGridpoint*31)+1):(MEPPerGridpoint*32)]),2));
mean32 = mean(overallMEPs(([((MEPPerGridpoint*32)+1):(MEPPerGridpoint*33)]),2));



overallMeans{1,1} = mean0;
overallMeans{1,2} = 0;
overallMeans{2,1} = mean1;
overallMeans{2,2} = 1;
overallMeans{3,1} = mean2;
overallMeans{3,2} = 2;
overallMeans{4,1} = mean3;
overallMeans{4,2} = 3;
overallMeans{5,1} = mean4;
overallMeans{5,2} = 4;
overallMeans{6,1} = mean5;
overallMeans{6,2} = 5;
overallMeans{7,1} = mean6;
overallMeans{7,2} = 6;
overallMeans{8,1} = mean7;
overallMeans{8,2} = 7;
overallMeans{9,1} = mean8;
overallMeans{9,2} = 8;
overallMeans{10,1} = mean9;
overallMeans{10,2} = 9;
overallMeans{11,1} = mean10;
overallMeans{11,2} = 10;
overallMeans{12,1} = mean11;
overallMeans{12,2} = 11;
overallMeans{13,1} = mean12;
overallMeans{13,2} = 12;
overallMeans{14,1} = mean13;
overallMeans{14,2} = 13;
overallMeans{15,1} = mean14;
overallMeans{15,2} = 14;
overallMeans{16,1} = mean15;
overallMeans{16,2} = 15;
overallMeans{17,1} = mean16;
overallMeans{17,2} = 16;
overallMeans{18,1} = mean17;
overallMeans{18,2} = 17;
overallMeans{19,1} = mean18;
overallMeans{19,2} = 18;
overallMeans{20,1} = mean19;
overallMeans{20,2} = 19;
overallMeans{21,1} = mean20;
overallMeans{21,2} = 20;
overallMeans{22,1} = mean21;
overallMeans{22,2} = 21;
overallMeans{23,1} = mean22;
overallMeans{23,2} = 22;
overallMeans{24,1} = mean23;
overallMeans{24,2} = 23;
overallMeans{25,1} = mean24;
overallMeans{25,2} = 24;
overallMeans{26,1} = mean25;
overallMeans{26,2} = 25;
overallMeans{27,1} = mean26;
overallMeans{27,2} = 26;
overallMeans{28,1} = mean27;
overallMeans{28,2} = 27;
overallMeans{29,1} = mean28;
overallMeans{29,2} = 28;
overallMeans{30,1} = mean29;
overallMeans{30,2} = 29;
overallMeans{31,1} = mean30;
overallMeans{31,2} = 30;
overallMeans{32,1} = mean31;
overallMeans{32,2} = 31;

disp('Preparing graph...')

x = cell2mat(overallMeans(:,2)')';
y = cell2mat(overallMeans(:,1)')';
numberOfBars = length(y);
tallestTower = max(y);

disp('Displaying graph')
figure(1)
hold on
if j == 1
    for i = 1:length(y)
        h=bar(i,y(i));
        if y(i) == tallestTower
            set(h,'FaceColor','r');
        else
            set(h,'FaceColor','b');
        end
        set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32])
        set(gca, 'XTickLabel', {'(1,1)' '(1,2)' '(1,3)' '(1,4)' '(2,1)' '(2,2)' '(2,3)' '(2,4)' 
            '(3,1)' '(3,2)' '(3,3)' '(3,4)' '(4,1)' '(4,2)' '(4,3)' '(4,4)' 
            '(5,1)' '(5,2)' '(5,3)' '(5,4)' '(6,1)' '(6,2)' '(6,3)' '(6,4)'
            '7,1)' '(7,2)' '(7,3)' '(7,4)' '(8,1)' '(8,2)' '(8,3)' '(8,4)'})
    end
    hold off

    graphName = strcat(subjFolder,'CollectedMEPs_Hand',subjName);
elseif j == 2
    for i = 1:length(y)
        h=bar(i,y(i));
        if y(i) == tallestTower
            set(h,'FaceColor','g');
        else
            set(h,'FaceColor','b');
        end
        set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32])
        set(gca, 'XTickLabel', {'(1,1)' '(1,2)' '(1,3)' '(1,4)' '(2,1)' '(2,2)' '(2,3)' '(2,4)' 
            '(3,1)' '(3,2)' '(3,3)' '(3,4)' '(4,1)' '(4,2)' '(4,3)' '(4,4)' 
            '(5,1)' '(5,2)' '(5,3)' '(5,4)' '(6,1)' '(6,2)' '(6,3)' '(6,4)'
            '7,1)' '(7,2)' '(7,3)' '(7,4)' '(8,1)' '(8,2)' '(8,3)' '(8,4)'})
    end
    hold off

    graphName = strcat(subjFolder,'CollectedMEPs_Lip_',subjName);
end
saveas(figure(1),graphName,'jpg');

disp('Script finished')





% clear workspace
% clear;
% unload ceds64int.dll
unloadlibrary ceds64int;