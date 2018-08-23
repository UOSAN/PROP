function [] = runPROP()

experimentCode = 'PROP';

desktop = exist(['~/Desktop/' experimentCode '/']);

if desktop
    location = '~/Desktop/';
else
    location = input('Where is the PROP folder? Give path, for example, ~/Desktop/Studies/: ','s');
end

DIR.task = [location '/' experimentCode '/'];
DIR.input = [DIR.task 'input' filesep];
DIR.output = [DIR.task 'output' filesep];
DIR.dropboxOutput = '~/Dropbox (Pfeiber Lab)/' experimentCode '/output/';

subNum=input('Enter participant number: ');

if subNum < 10
    placeholder = '00';
elseif subNum < 100
    placeholder = '0';
else
    placeholder = '';
end

subjectCode = [experimentCode placeholder num2str(subNum)];

runNum = input('Enter run number: ');
tdfile = [subjectCode '_run' num2str(runNum) '.txt'];

cd(DIR.task)
addpath(genpath(DIR.task))

MSS_PROP([DIR.input tdfile],[DIR.input 'stimuli'],DIR,subjectCode)

end