function[] = createTdfile()

subNum=input('Enter participant number: ');

if subNum < 10
    placeholder = '00';
elseif subNum < 100
    placeholder = '0';
else
    placeholder = '';
end

subjectCode = ['PROP' placeholder num2str(subNum)];

tdfile_instrux = 'PROP_instrux.txt';
tdfile_trialParams = 'PROP_trialParams.txt';
tdfile_trialText = 'PROP_trialText.txt';
tdfile_ratings = 'PROP_ratings.txt';

nVignTypes = 2;
vignPerType = 10;
vignCodeLength = 5;
nRuns = 2;

tdfile_complete = cell(1,2);
for r=1:nRuns
    tdfile_complete{r} = [subjectCode '_run' num2str(r) '.txt'];
end

DIR.task = '~/Desktop/PROP/';
DIR.input = [DIR.task 'input' filesep];
DIR.output = [DIR.task 'output' filesep];

if exist([DIR.input filesep subjectCode '_run1.txt'])
    error('You already have tdfiles for subject %d.',subNum)
end

rng('default')
rng('shuffle')
%%%%%%%%%

cd(DIR.input)
%make sure that the input script (tdfile) is actually a file
if ~exist(tdfile_instrux,'file')
    fprintf('Your input script %s does not exist.  Make sure you have the right path and filename.\n',tdfile_instrux);
elseif ~exist(tdfile_trialParams,'file')
    fprintf('Your input script %s does not exist.  Make sure you have the right path and filename.\n',tdfile_trialParams);
elseif ~exist(tdfile_trialText,'file')
    fprintf('Your input script %s does not exist.  Make sure you have the right path and filename.\n',tdfile_trialText);
elseif ~exist(tdfile_ratings,'file')
    fprintf('Your input script %s does not exist.  Make sure you have the right path and filename.\n',tdfile_ratings);
else
    
    fid = fopen('PROP_instrux.txt','r');
    instruxCell = textscan(fid,'%c %d %f %f %f %d %s %c %c %s %s %d %d %s','Delimiter', '\t', 'CommentStyle', '%');
    fclose(fid);
    
    fid = fopen('PROP_ratings.txt','r');
    ratingCell = textscan(fid,'%c %d %f %f %f %d %s %c %c %s %s %d %d %s','Delimiter', '\t', 'CommentStyle', '%');
    fclose(fid);
    
    fid = fopen('PROP_trialParams.txt','r');
    trialParamsCell = textscan(fid,'%c %d %f %f %f %d %s %c %c %s %s %d %d %s','Delimiter', '\t', 'CommentStyle', '%');
    fclose(fid);
    
    fid = fopen('PROP_trialText.txt','r');
    trialTextCell = textscan(fid,'%s %s','Delimiter', '\t', 'CommentStyle', '%');
    fclose(fid);
    
    
    for c=1:length(instruxCell)
        colContent = instruxCell{1,c};
        if isnumeric(colContent)
            instruxCell_flat{:,c} = num2cell(colContent);
        elseif ischar(colContent)
            instruxCell_flat{:,c} = mat2cell(colContent,ones(1,size(colContent,1)),size(colContent,2));
        elseif iscell(colContent)
            instruxCell_flat{:,c} = colContent;
        else fprintf('column %d is of type %s; not converted\n',c,class(colContent))
        end
    end
    instruxCell_flat = [instruxCell_flat{:}];
    
    for c=1:length(ratingCell)
        colContent = ratingCell{1,c};
        if isnumeric(colContent)
            ratingCell_flat{:,c} = num2cell(colContent);
        elseif ischar(colContent)
            ratingCell_flat{:,c} = mat2cell(colContent,ones(1,size(colContent,1)),size(colContent,2));
        elseif iscell(colContent)
            ratingCell_flat{:,c} = colContent;
        else fprintf('column %d is of type %s; not converted\n',c,class(colContent))
        end
    end
    ratingCell_flat = [ratingCell_flat{:}];
    
    
    for c=1:length(trialParamsCell)
        colContent = trialParamsCell{1,c};
        if isnumeric(colContent)
            trialParamsCell_flat{:,c} = num2cell(colContent);
        elseif ischar(colContent)
            trialParamsCell_flat{:,c} = mat2cell(colContent,ones(1,size(colContent,1)),size(colContent,2));
        elseif iscell(colContent)
            trialParamsCell_flat{:,c} = colContent;
        else fprintf('column %d is of type %s; not converted\n',c,class(colContent))
        end
    end
    trialParamsCell_flat = [trialParamsCell_flat{:}];
    
    for c=1:length(trialTextCell)
        colContent = trialTextCell{1,c};
        if isnumeric(colContent)
            trialTextCell_flat{:,c} = num2cell(colContent);
        elseif ischar(colContent)
            trialTextCell_flat{:,c} = mat2cell(colContent,ones(1,size(colContent,1)),size(colContent,2));
        elseif iscell(colContent)
            trialTextCell_flat{:,c} = colContent;
        else fprintf('column %d is of type %s; not converted\n',c,class(colContent))
        end
    end
      
    trialTextCell_flat = [trialTextCell_flat{:}];
    
    
    % create list of vignette codes (e.g. cbt01, cbt02)
    allVignettes = unique(cellfun(@(x) x(1:vignCodeLength),trialTextCell{:,2},'UniformOutput',false));
    vignetteTypes = unique(cellfun(@(x) x(1:3),trialTextCell{:,2},'UniformOutput',false));
    
    % First shuffle within cbt/pst
    cbtOrder = Shuffle((1:vignPerType)');
    pstOrder = Shuffle((vignPerType+1:vignPerType*2)');
    shuffOrder = [cbtOrder;pstOrder];
    vignettes_shuffWithin = allVignettes(shuffOrder);
    
    % Then choose 5 of each, randomly
    isCbtRun1 = Shuffle([zeros(vignPerType/2,1);ones(vignPerType/2,1)]);
    isPstRun1 = Shuffle([zeros(vignPerType/2,1);ones(vignPerType/2,1)]);
    isRun1 = logical([isCbtRun1;isPstRun1]);
    
    vignettes_shuffWithin_r1 = allVignettes(isRun1);
    vignettes_shuffWithin_r2 = allVignettes(~isRun1);
    
    vignettes = cell(vignPerType,nVignTypes);
    
    OK = 0;
    while ~OK
        vignettes(:,1) = Shuffle(vignettes_shuffWithin_r1);
        vignettes(:,2) = Shuffle(vignettes_shuffWithin_r2);
    
        disp(vignettes)
        OK = input('Is this order acceptable? [1=yes, 0=no] ');
    end
    
    TRcount = nan(1,nRuns);
    for r = 1:nRuns
        masterCell = {};
        for v = 1:vignPerType
            currentVignetteIdx = cellfun(@(x) strcmp(x(1:vignCodeLength),vignettes{v,r}),trialTextCell{:,2});
            vignetteText = trialTextCell_flat(logical(currentVignetteIdx),1);
            
            nSentences = size(vignetteText,1);
            % Create trial content:
            trialContentCell = cell(nSentences*size(trialParamsCell_flat,1),size(trialParamsCell_flat,2));
            
            for s = 1:nSentences
                trialContentCell(2*s-1:2*s,:) = trialParamsCell_flat;
            end
            
            trialContentCell(1:2:end,11) = vignetteText(1:end);
            trialContentCell(1:2:end,14) = vignettes(v);
            
            masterCell = vertcat(masterCell,instruxCell_flat,trialContentCell,ratingCell_flat);
            % instrux; repeat params x times; insert text for VignetteText and tags
            % ratings
        end
        
        runTime = sum(cell2mat(masterCell(:,5)));
        TRcount(r) = ceil(runTime/2);
        
        fid = fopen(tdfile_complete{r},'w');
        
        % Print header to file:
        headerSpec = '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n';
        fprintf(fid,headerSpec,'%type','num','pre','maxTime','totTime','rep','stpEvt','bg','st','bgFile','stFile','hshift','vshift','tag');
        
        % Print task params to file:
        formatSpec = '%c\t%d\t%f\t%f\t%f\t%d\t%s\t%c\t%c\t%s\t%s\t%d\t%d\t%s\n';
        [nrows,ncols] = size(masterCell);
        for row = 1:nrows
            fprintf(fid,formatSpec,masterCell{row,:});
        end
        fclose(fid);
    end
    fprintf('Run 1: %d TRs\nRun 2: %d TRs\n', TRcount(1),TRcount(2))
end;

cd([DIR.task '/code'])

end