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

runNum = input('What run is this? ');
tdfile = ['PROP_run' num2str(runNum) '.txt'];

cd(DIR.task)
addpath(genpath(DIR.task))

MSS_PROP([DIR.input tdfile],[DIR.input 'stimuli'],DIR)

end