function[] = createTdfile(DIR, tdfile_instrux,tdfile_trialParams,tdfile_trialText,tdfile_ratings)

tdfile_complete = 'PROP_combined.txt';

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
    vignettes = unique(cellfun(@(x) x(1:5),trialTextCell{:,2},'UniformOutput',false));
    vignetteIdx = nan(length(trialTextCell_flat),length(vignettes));
    masterCell = {};
    for v = 1:length(vignettes)
        vignetteIdx(:,v) = cellfun(@(x) strcmp(x(1:5),vignettes{v}),trialTextCell{:,2});
        vignetteText{v} = trialTextCell_flat(logical(vignetteIdx(:,v)),1);
        
        nSentences = size(vignetteText{v},1);
        % Create trial content:
        trialContentCell = cell(nSentences*size(trialParamsCell_flat,1),size(trialParamsCell_flat,2));
        
        for s = 1:nSentences
            trialContentCell(2*s-1:2*s,:) = trialParamsCell_flat;
        end
        
        trialContentCell(1:2:end,11) = vignetteText{v}(1:end);
        trialContentCell(1:2:end,14) = vignettes(v);
        
        masterCell = vertcat(masterCell,instruxCell_flat,trialContentCell,ratingCell_flat);
        % instrux; repeat params x times; insert text for VignetteText and tags
        % ratings
    end
    
    fid = fopen(tdfile_complete,'w');
    
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
    
end;

end