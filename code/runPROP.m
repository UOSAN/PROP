function [] = runPROP()
% function [] = runPROP(tdfile,resource_path)

runNum = input('What run is this? ');
tdfile = ['PROP' num2str(runNum) '.txt'];
% tdfile = 'PROP_combined.txt';

DIR.task = '~/Desktop/PROP/';
DIR.input = [DIR.task 'input' filesep];
DIR.output = [DIR.task 'output' filesep];

cd(DIR.task)
addpath(genpath(DIR.task))

% createTdfile(DIR, 'PROP_instrux.txt','PROP_trialParams.txt','PROP_trialText.txt','PROP_ratings.txt');

MSS_PROP([DIR.input tdfile],[DIR.input 'stimuli'],DIR)

end