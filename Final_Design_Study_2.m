 
%Script Study 2 (Version 1)                                             %
%Gwijde Maegherman 02/11/2017                                             %
%Based largely on code from various designs,including Study 1, and Basic  %
%Based in part on code by Dan Kennedy-Higgins and others (unknown)        %

%Changelog:
%Version 1.0 - final version with modified colours and final refs to 
%              new instructions
%Version 0.4 - Near-final version with colours modified, comments added
%where useful and infolog entries refined. Use this to test on lab members.
%Version 0.3 - Modified further to work out kinks with stimuli presentation
%and break timings, as well as break time description.
%Version 0.2 - Modified majority of script to reflect new task
%Version 0.1 - Modified some of setup questions to reflect Hand vs Lip    %  
%Version 0 - Straight copy of Study 1.3.5.A - Nothing changed yet!        %






%Preamble

close all;
clear all;
clc;

%%
%list = '';                                                                % Defines the list of random letter strings that is read in from a corresponding excel file. There are 4 separate lists, each with 48 pairs of letters, 24 pairs are identical, 24 differ.
list = 1;
list1 = num2str(list);                                                     % Largely an irrelevant line of code. Simply takes the list number and turns it into a string variable so that the cell array containing all of the relevant information on each trial can be saved with the list number added to the name of the file.
info = cell(255,10);                                                       % Creates a cell array called "info" which eventually records all relevant information from each test session
TMS = 1;                                                                   % Unless you are running a study where TMS pulses are sometimes withheld this (so called catch trials) variable should/will always be set to 1.
trial = 1;                                                                 % This creates a variable named "trial" which increases with every trial. Information is entered in the 'info' cell array depending in the corresponding row of whatever value 'trial' equals.

%R = 0.8;                                                                  % The R G B values are used to set the colour of the text. Values can range from zero to one. If all three are assigned a value of 1 then the text will be white; if all three are assigned a value of 0 then the text will be black; variations create text of different hues.
%G = 0.8;
%B = 0.8;

%% Define Cogent variables and general preparatory tasks
config_keyboard(100, 1, 'nonexclusive');                                   % Keyboard configurations - 100 = max. number of recorded key reads, 1 = timing resolution in mseconds, nonexclusive = allows keyboard control in other programs
config_display(0, 5, [0.5,0.5,0.5], [1,1,1], 'Helvetica', 48, 4, 0, 4);    % Cogent window configuration - 1 = full screen, 3 = 1024x768, [0.5,0.5,0.5] = background colour, Helvetica, 32 = font type, font size
config_sound(1, 16, 22050, 100);                                           % Cogent sound configurations - 1 = mono, 16 = number of bits, 22050 = number of samples per second, 100 = number of possible buffers)

%% Setup experiment by asking basic input info
stimFolder = strcat('stimuli',filesep);
practice_welcome = strcat(stimFolder,'practice_welcome.jpg');
maintask_welcome = strcat(stimFolder,'maintask_welcome.jpg');
hand_instruction_1 = strcat(stimFolder,'hand_instruction_1.jpg');
lip_instruction_1 = strcat(stimFolder,'lip_instruction_1.jpg');
hand_instruction_2 = strcat(stimFolder,'hand_instruction_2.jpg');
lip_instruction_2 = strcat(stimFolder,'lip_instruction_2.jpg');

% Ask subject name
participant = '';                                                          % This creates the variable subjName as an empty variable
while isequal(participant,'');
    participant = input('Participant number: ', 's');                      % This allows you to enter the participant number
end

% Ask subject name
subjName = '';                                                             % This creates the variable subjName as an empty variable
while isequal(subjName,'');
    subjName = input('Subject Identification? ', 's');                     % This allows you to enter the specific identification to be used for participants (generally Year,Month,Day,Initial e.g. 170220DKH)
end

% Determine subject folder
subjFolder = '';                                                           % As above this line simply creates a variable called 'subjFolder' which is an empty variable for the time being
folderName = '';
while isequal(subjFolder,'')
    if isequal(folderName,'')
        folderName = strcat('subjects/',subjName);                         % This creates a 'subjects' folder (if not already in existence) and moves the above created subjFolder variable into this folder and renames it with the specific subject ID as entered on line 40.
    end
    if exist(folderName,'dir')
        folderName = strcat(folderName,'_1');                              % If the subject folder name already exists then this line of code simply adds a '_1' to end of the name and creates a new folder e.g. is 170220DKH already exists then this line will create a new folder called 160929DKHd. This avoids the risk of data being overwritten and lost.
        subjFolder = '';
    else
        mkdir(folderName)
        subjFolder = folderName;
    end
end

%Ask Audio or Visual

testCondition = '';                                                        % audioVisual takes A or V for audio or visual, and converts it to 1 or 2 respectively
while isequal(testCondition,'');
    testCondition = input('Hand or Lip? ', 's');
        if strcmp('Hand',testCondition) == 1;                              % Set to Hand
        condition = 'Hand';
        testCondition = 1;
        elseif strcmp('Lip',testCondition) == 1;                           % Set to Lip
        condition = 'Lip';
        testCondition = 2;
        end
end


% Ask list
listyList = '';                                                            % This creates the variable listList as an empty variable
while isequal(listyList,'');
    listyList = input('List? ');                                           % Input list number
end

listList = strcat(condition,'_', num2str(listyList));                      % Converts entered listyList variable into string
mainList = strcat('stimlists',filesep,listList,'.xlsx');                   % mainList depends on user input                            
pracList = strcat('stimlists',filesep,'praclist.xlsx');                    % pracList is always the practice list (praclist.xlsx)

% Set order of blocks
if testCondition == 1
    testList = [8,1,9,2,9,1,8,2];                                          % AudSRT, AIT,VisSRT,HLT,VisSRT,AIT,AudSRT,HLT
    practiceList = [9,8,1,2];                                              % VisSRT, AudSRT, AIT,HLT
elseif testCondition == 2               
    testList = [9,2,8,1,8,2,9,1];                                          % VisSRT,HLT,AudSRT,AIT,AudSRT,HLT,VisSRT,AIT
    practiceList = [8,9,2,1];                                              % AudSRT, VisSRT, HLT, AIT
end

%% Begin Main Experiment
start_cogent;%Start Cogent Module

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TMS Config
if TMS
    % Prepare TMS system
    % Create an instance of the io64 object
    %ioObj = io64(); % CH win 7
    ioObj = io64(); % BW win XP

    % Initialize the inpout64.dll system driver
    % If status = 0, you are now ready to write and read to a hardware port
    status = io64(ioObj);
    if status ~= 0
        str = sprintf('ERROR: There is a problem initializing the TMS output port (error %d)\n', status);
        disp(str);
        return;
    end

    % Specify the port addresses
    address1 = hex2dec('378');                                             %standard LPT1 output port address
    address3 = hex2dec('DCF8');                                            %standard LPT3 output port address
                                                                           %note: Most times LPT1 is used.  LPT3 is included in case the
                                                                           %the information is ever needed.    
    io64(ioObj,address1,0);                                                %reset LPT1 to 2
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Set up key maps
keys = getkeymap;                                                          % getkeymap command outputs a list of codes assigned to each key by cogent
controlKeys = [keys.Space keys.Escape ];                                   % Define key codes for space and escape for controlling program
    
% Main Task
[num] = xlsread(mainList);                                                 % Use main user input for list
%Display welcome frame and explanation of study
clearpict(1);                                                              % Clear buffer 1         
clearpict(2);                                                              % Clear buffer 2
preparestring('',1)

A = loadpict(maintask_welcome);

if testCondition == 1
    B = loadpict(hand_instruction_1);
    C = loadpict(hand_instruction_2);
elseif testCondition == 2
    B = loadpict(lip_instruction_1);                                         % Puts instructions in a MATLAB matrix specified by B
    C = loadpict(lip_instruction_2);
end

preparepict(A,2);                                                          % Puts 'maintask_welcome in buffer 2
preparepict(B,3);
preparepict(C,4);
drawpict(1);                                                               % Display frame only for 200ms
wait(400);                                                                 
drawpict(2);                                                               % Display 'maintask_welcome' until space is pressed
waitkeydown(inf, controlKeys);                                             % Wait forever ('inf') until one of the control keys is pressed
drawpict(1);
wait(400);                                                                 
drawpict(3);                                                               % Display 'maintask_welcome' until space is pressed
waitkeydown(inf, controlKeys);                                             % Wait forever ('inf') until one of the control keys is pressed
drawpict(1);
wait(400);                                                                 
drawpict(4);                                                               % Display 'maintask_welcome' until space is pressed
waitkeydown(inf, controlKeys);                                             % Wait forever ('inf') until one of the control keys is pressed
wait(1000); 
clearpict(3);
clearpict(2);
setforecolour(1,1,1);
preparestring('Begin experiment',2); 
% Display fixation cross for 1000ms
drawpict(2); 
% Wait 1000 to show fixcross
wait(1000);
drawpict(1);
wait(1000);
clearpict(2);


% Main Loop begins here
for a = 1:225
    % Creates variable containing the value of the first-column cell in string format (for strcat, info)
    stimNum = num(a,1);
    % Takes the trial number and derives real(1)/imagined(2) (for info)
    stimType = num(a,2);                                   
    % Read in TMS wait time here
    waitTime = num(a,3);
    extraWait = (3000 - waitTime);                                         % Timing between trials is always 3000ms, so waitTime is subtracted from 3000
    % Create MEP name for automatic extraction later (may be useful in automatically ordering by condition)
    MEP = strcat('MEP_',num2str(a));
    MEPMAT = strcat (MEP,'.mat');
    % Clear buffer 3
    clearpict(3);                                                      
    clearpict(4);
    % Prepare fixation cross
    setforecolour(1,1,1);
    preparestring('+',3); 
    % Display fixation cross for 1000ms
    drawpict(3); 
    % Wait 1000 to show fixcross
    wait(1000);                                                               
    clearkeys;   
    if testCondition == 1
        if stimType == 1
            setforecolour(0,0,1);
            preparestring('%%',4);
        elseif stimType == 2
            setforecolour(1,0,0);
            preparestring('%%',4);
        elseif stimType == 3
            setforecolour(0,0,0);
            preparestring('%%',4);
        end
    elseif testCondition == 2
        if stimType == 1
            setforecolour(0,0,1);
            preparestring('&&',4);
        elseif stimType == 2
            setforecolour(1,0,0);
            preparestring('&&',4);
        elseif stimType == 3
            setforecolour(0,0,0);
            preparestring('&&',4);
        end  
    end     
    t0 = time;
    drawpict(4);
    if TMS
        wait(waitTime)
        % prepare TMS trigger and fire
         io64(ioObj,address1,255);                                         % send trigger to TMS%             logstring('TMS fired');
         fireTime = time;
         io64(ioObj,address1,0);                                           % reset LPT1 to 2
         
    end
    MEPWait = (fireTime-t0);
    wait(extraWait)
    drawpict(1);
    wait(2000); 
    
    %% The aftermath: this section records some of the relevant information into a cell array named 'info'. 
    %  The information contained in the variable to the right of the equals sign is entered into the cell array named 'info' on the row which corresponds to the trial number and in the colum defined by the number inside the brackets {trial, 1} for example would be column 1.

    info{trial,1} = participant;                                           % Participant number
    info{trial,2} = a;                                                     % Records trial number
    info{trial,3} = testCondition;                                         % testCondition (1 = hand, 2 = lip)
    info{trial,4} = stimNum;                                               % stimNum (first row in xlsx)
    info{trial,5} = stimType;                                              % stimType (1 = Real, 2 = Imagined, 3 = Do Nothing)
    info{trial,6} = waitTime;                                              % stores intended waitTime (50,150,250,350,450,550)
    info{trial,7} = MEPWait;                                               % stores actual time between stim presentation and TMS fire
    info{trial,8} = MEP;                                                   % stores MEP_a, so that when you order xlsx by condition the correct MEPs can be easily found
    info{trial,9} = MEPMAT;                                                % stores MEP_a.mat, so that when you order xlsx by condition the correct MEPs can be easily found and this file can be used directly to order MEPs if so desired

    
    %End of trial - check if a break is needed
    if a == 25 || a == 50 || a == 75 || a == 100 ||  a == 125 || a == 150 || a == 175 || a == 200 
        clearpict(3);
        t1 = (time + 45000);                                               % Get the time 3/4 of the way through break
        t2 = (time + 60000);                                               % Get the time 1 min after break start - time to start again
        while time < t1                                                    % While time is within 45 secs, display break message (which depends on break no.)
            setforecolour(1,1,1);
            if a == 25
                preparestring('Break 1 - 8 blocks remaining',3);
            elseif a == 50
                preparestring('Break 2 - 7 blocks remaining',3);                
            elseif a == 75
                preparestring('Break 3 - 6 blocks remaining',3);                
            elseif a == 100
                preparestring('Break 4 - 5 blocks remaining',3);                
            elseif a == 125
                preparestring('Break 5 - 4 blocks remaining',3);                
            elseif a == 150
                preparestring('Break 6 - 3 blocks remaining',3);                
            elseif a == 175
                preparestring('Break 7 - 2 blocks remaining',3);                
            elseif a == 200
                preparestring('Break 8 - 1 block remaining',3);                
            end
            drawpict(3);
            wait(45001);
        end
        while time > t1 && time < t2                                       % When time is greater than 45 secs but still within the 1 min mark, show preparation message. Timed so that TMS machine resets during this period.
            clearpict(2);                                                  % If you are in BW you can add a bit of code here automatically priming the BiStim!
            setforecolour(1,1,1);
            preparestring('Please return to position',2);
            drawpict(2);
            clearpict(3);
            wait(15001);
        end
        setforecolour(1,1,1);
        preparestring('Ready?',3);
        drawpict(3);
        waitkeydown(inf,controlKeys);
    end

    trial = trial + 1;                                                     % Adds one to the value of the variable 'trial'. This ensures the data already written in the cell array 'info' is not overwritten on each trial but add to the next row in the cell array.
end

%% The grand finale

    clearpict(1);
    preparestring('Thank you for taking part!',1);
    drawpict(1)
    wait(4000)
    %%
    save(strcat(subjFolder,'/info','_',listList,'.mat'),('info'));         % This saves the created cell array named 'info' into each participants individually created folder.
    xlswrite(strcat(subjFolder,'_',listList),info);   
    %%
    stop_cogent;                                                           % Stop Cogent module
% End of Cogent Section

% End Experiment
    

    
    
    
    
    