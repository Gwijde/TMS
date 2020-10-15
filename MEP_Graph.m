%% This script take sthe 225 MEPs produced in Study 2 and reads their peak-to-peak values. They are added together to show mean MEP amplitude per stimtype and chronometric timepoint.
% It is a little clunky but it works! Could definitely be more efficient.

getJPG = 0;

% add path to CED code
if isempty(getenv('CEDS64ML'))
    setenv('CEDS64ML', 'C:\CEDMATLAB\CEDS64ML');
end
cedpath = getenv('CEDS64ML');
addpath(cedpath);
% load ceds64int.dll
CEDS64LoadLib( cedpath );

%Get subject name
% subjName = '';                                                             % This creates the variable subjName as an empty variable
% while isequal(subjName,'');
%     subjName = input('Subject name? ', 's');                               % This allows you to enter the specific identification to be used for participants (generally Year,Month,Day,Initial e.g. 170220DKH)
% end

% Import info.mat for participant
load('D:\Education\University\PhD\Imagery\Experiments\Study 2\MEP data extraction\Julie\info_Lip_3')
% Count number of MEPs on basis of previous info file
MEPNum = length(info);
% Create MEP arrays for chronometry purposes
MEPArrayOne = cell(MEPNum,3);

% Main loop - gets all MEPs and gets their peak to peak values into array
% MEPArrayOne (all MEPs, not averages)

for j =  1: 225
     % Read in data from info.mat
     condition = info{j,3};
     stimtype = info{j,5};
     waittime = info{j,6};
     MEP = info{j,8};
     
     
     MEPFullPath = strcat('D:\Education\University\PhD\Imagery\Experiments\Study 2\MEP data extraction\Lip\Julie',filesep,MEP,'.smr');
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
     [ fRead, fVals, fTime ] = CEDS64ReadWaveF( fhand1, 3, 100000, 0 );


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
     
     MEPValue = fPlot([220:400],2);
     
     maxVal=max(MEPValue);
     maxVal = double(maxVal);
     minVal=-(min(MEPValue));                                       % minval is negated as this will give us a positive number for addition later
     minVal = double(minVal);
     % Compute peak-to-peak by adding maxVal to minVal
     peakToPeak = maxVal + minVal;
     %Rectify MEP for AUC
     Rec_MEP = abs(MEPValue);
     %Use trapz for AUC
     AUC = trapz(Rec_MEP);
     AUC = double(AUC);   
     peakToPeak = maxVal + minVal;

     % Store info in array
     MEPArrayOne{j,1} = stimtype;
     MEPArrayOne{j,2} = waittime;
     %MEPArrayOne{j,3} = peakToPeak;
     MEPArrayOne{j,3} = AUC;
     
     % close all the files
     CEDS64CloseAll();    
end

% Create Mean Array: MEPMeanArray: (1,1) = 1,50, (1,2) = 1,150 etc.

% Delete unnecessary rows, then sort original array
MEPArrayOne([226:255],:) = [];
SortedMEPArray = sortrows(MEPArrayOne,[1 2]);

% Convert Sorted array to matrix to get means

SortedMatrix = cell2mat(SortedMEPArray);
% create single row matricec for later appending
MEPMeanArray = mean(SortedMatrix([1:15],[1:3]));
B = mean(SortedMatrix([16:30],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,B);
C = mean(SortedMatrix([31:45],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,C);
D = mean(SortedMatrix([46:60],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,D);
E = mean(SortedMatrix([61:75],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,E);
F = mean(SortedMatrix([76:90],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,F);
G = mean(SortedMatrix([91:105],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,G);
H = mean(SortedMatrix([106:120],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,H);
I = mean(SortedMatrix([121:135],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,I);
J = mean(SortedMatrix([136:150],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,J);
K = mean(SortedMatrix([151:165],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,K);
L = mean(SortedMatrix([166:180],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,L);
M = mean(SortedMatrix([181:188],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,M);
N = mean(SortedMatrix([189:196],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,N);
O = mean(SortedMatrix([197:204],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,O);
P = mean(SortedMatrix([205:211],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,P);
Q = mean(SortedMatrix([212:218],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,Q);
R = mean(SortedMatrix([219:225],[1:3])); MEPMeanArray = cat(1,MEPMeanArray,R);

% Each condition/chronometric timepoint has 15 MEPs, so average accordingly
% Graph part

Z = sortrows(MEPMeanArray,2);

GraphMatrix = [Z(2,3) Z(1,3) Z(3,3); Z(5,3) Z(4,3) Z(6,3); Z(8,3) Z(7,3) Z(9,3); Z(11,3) Z(10,3) Z(12,3); Z(14,3) Z(13,3) Z(15,3); Z(17,3) Z(16,3) Z(18,3)];
ErrorBarMatrix = []

bar(GraphMatrix)
hold on
set(gca,'XTickLabel',{'50' '150' '250' '350' '450' '550'})

% Aligning errorbar to individual bar within groups
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
groupwidth = min(0.8, 4/(4+1.5));
for i = 1:4
x = (1:6) - groupwidth/2 + (2*i-1) * groupwidth / (2*4);
errorbar(x,GraphMatrix(i,:),ci(i,:),'k', 'linestyle', 'none');
end



hold off
colormap('autumn');
legend('Real','Imagined','Do nothing')


