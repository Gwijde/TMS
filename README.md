# TMS
Resources for TMS studies generally, and specifically the experiment as published in Motor Imagery of Speech: The Involvement of Primary Motor Cortex in Manual and Articulatory Motor Imagery (https://doi.org/10.3389/fnhum.2019.00195).  

## Stimuli and stimlists
Stimuli and stimuli lists (randomised) for the published experiment. Includes all files necessary to run the experiment, save the MATLAB code.

## Final_Design_Study_2 and Practice_Design_Study_2
Respectively the full study code and practice session code. Note that the Cogent Toolbox is required to run this experiment, as is a TMS stimulator connected in a particular way (using the io64 object). If you want to run the experiment without a stimulator, set the variable `TMS = 0`.

## Get AverageWaveforms
Takes 225 Spike2 MEP waveforms (following their extraction) and determines the average per conditions per timepoint, then return an average waveform graph. **CAUTION:** this script is extremely useful only if certain specific conditions (those in the Chandler House TMS lab and setup) are met. For instance, the extracted MEP should be contained in a 5200 tic Spike file, be in the correct channel (1 for Hand and 3 for lip as set up), the info file for each participant must be coded as in Final_Design_Study_2 in order to ensure conditions are correctly assigned, etc. **This script is unlikely to be useful as-is, so email gwijde.maegherman@gmail.com if you want to use it effectively.** 

However, if you are interested in getting nice-looking MEP graphs for publications, I highly recommend using the bounded_line package (https://www.mathworks.com/matlabcentral/fileexchange/27485-boundedline-m) in combination with the CED MATLAB SON interface (http://ced.co.uk/upgrades/spike2matson), courtesy of CED. Feel free to email me if you have questions.

 
