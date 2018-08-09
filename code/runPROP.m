function [] = runPROP()

desktop = exist('~/Desktop/PROP/');

if desktop
    location = '~/Desktop/';
else
    location = input('Where is the PROP folder? Give path, for example, ~/Desktop/Studies/: ','s');
end

DIR.task = [location '/PROP/'];
DIR.input = [DIR.task 'input' filesep];
DIR.output = [DIR.task 'output' filesep];
DIR.dropboxOutput = '~/Dropbox (Pfeiber Lab)/PROP/output/';

subNum=input('Enter participant number: ');

if subNum < 10
    placeholder = '00';
elseif subNum < 100
    placeholder = '0';
else
    placeholder = '';
end

subjectCode = ['PROP' placeholder num2str(subNum)];

runNum = input('Enter run number: ');
tdfile = [subjectCode '_run' num2str(runNum) '.txt'];

cd(DIR.task)
addpath(genpath(DIR.task))

MSS_PROP([DIR.input tdfile],[DIR.input 'stimuli'],DIR,subjectCode)

end