function [] = runPROP()
% function [] = runPROP(tdfile,resource_path)

DIR.task = '~/Desktop/PROP/';
DIR.input = [DIR.task 'input' filesep];
DIR.output = [DIR.task 'output' filesep];

cd(DIR.task)
addpath(genpath(DIR.task))

createTdfile(DIR, 'PROP_instrux.txt','PROP_trialParams.txt','PROP_trialText.txt','PROP_ratings.txt');

MSS_PROP([DIR.input 'PROP_combined.txt'],[DIR.input 'stimuli'],DIR)
% MSS_PROP([DIR.input 'PROP.txt'],[DIR.input 'stimuli'],DIR)


% MSS_PROP([DIR.input tdfile],[DIR.input resource_path])
% tdfile_instrux,tdfile_trialParams,tdfile_trialContent,tdfile_ratings
end