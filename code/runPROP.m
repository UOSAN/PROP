function [] = runPROP()
% function [] = runPROP(tdfile,resource_path)

DIR.task = '~/Desktop/PROP/';
DIR.input = [DIR.task filesep 'input' filesep];
DIR.output = [DIR.task filesep 'output' filesep];

cd(DIR.task)
addpath(genpath(DIR.task))

MSS_PROP([DIR.input 'PROP.txt'],[DIR.input 'stimuli'],DIR)
% MSS_PROP([DIR.input tdfile],[DIR.input resource_path])

end