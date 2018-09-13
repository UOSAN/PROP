DIR.bx = '~/Desktop/PROP_BxData/';
DIR.out = [DIR.bx filesep 'output'];

subList = [1:9 13];
nRuns = 2;
studyCode = 'PROP';
taskCode = 'PROP';
masterMat = [];
filenames.respCheck = [DIR.bx filesep 'compiled' filesep 'responseComparison'];

for s = subList
    
    if s<10
        placeholder = '00';
    elseif s<100
        placeholder = '0';
    else
        placeholder = '';
    end
    subjectCode = [studyCode placeholder num2str(s)];
    
    for r=1:nRuns
        
        filenames.out =  [DIR.out filesep 'sub-' subjectCode(end-2:end) '_ses-1_task-' taskCode '_run-' num2str(r) '_beh.mat'];
        
        if ~exist(filenames.out,'file')
            warning('No output file found for subject %d, run %d.\n',s,r);% import input file to determine eventIndices DO THIS
        else
            
            % import output file to determine actual onsets/duration
            load(filenames.out)
            
            relIdx = cell2mat(cellfun(@(x) strcmp(x,'relevance'),run_info.tag,'UniformOutput',false));
            likeIdx = cell2mat(cellfun(@(x) strcmp(x,'liking'),run_info.tag,'UniformOutput',false));
            helpIdx = cell2mat(cellfun(@(x) strcmp(x,'helpfulness'),run_info.tag,'UniformOutput',false));
            ratingIdx = relIdx | likeIdx | helpIdx;
            
            for i=2:length(key_presses.time)
                if key_presses.time(i)-key_presses.time(i-1)<.5
                    key_presses.time(i)=0;
                end
            end
            keyLog = key_presses.time(key_presses.time>0)';
            rateLog = run_info.onsets(ratingIdx)';
            fixLog = run_info.onsets(logical([0;ratingIdx(1:end-1)]))'; % fixations that mark the end of rating
            
            fullLog = [[ones(length(rateLog),1) rateLog]; [2*ones(length(keyLog),1) keyLog]; [zeros(length(fixLog),1) fixLog]];
            fullLog = sortrows(fullLog,2);
            
            isRating = fullLog(:,1)==1;
            isFix = fullLog(:,1)==0;
            isFixNext = [isFix(2:end);0];
            isMissingRating = isRating & isFixNext;
            
            keypressesLogged = sum(key_presses.time>0);
            responsesWithinRunInfo = length(run_info.responses)-sum(cellfun('isempty',run_info.responses));
            
%             fprintf('Key presses logged: %d\n',keypressesLogged)
%             fprintf('Responses logged within run_info: %d\n',responsesWithinRunInfo)
            
            masterMat(end+1,:) = [s r keypressesLogged responsesWithinRunInfo keypressesLogged-responsesWithinRunInfo];
        end
    end
end

fid = fopen([filenames.respCheck '.txt'],'w');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\n','sub','run','keys logged','run_info.responses','missing');
for l=1:size(masterMat,1)
    fprintf(fid,'%d\t%d\t%d\t%d\t%d\n', masterMat(l,1),masterMat(l,2),masterMat(l,3),masterMat(l,4),30-masterMat(l,4));
end
fclose(fid);