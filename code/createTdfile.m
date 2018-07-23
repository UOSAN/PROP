function[varFile] = createTdfile(DIR, tdfile_instrux,tdfile_trialParams,tdfile_trialContent,tdfile_ratings)

varFile = 'inputVars.mat';

cd(DIR.input)
%make sure that the input script (tdfile) is actually a file
if ~exist(tdfile_instrux,'file')
    fprintf('Your input script %s does not exist.  Make sure you have the right path and filename.\n',tdfile_instrux);
elseif ~exist(tdfile_trialParams,'file')
    fprintf('Your input script %s does not exist.  Make sure you have the right path and filename.\n',tdfile_trialParams);
elseif ~exist(tdfile_trialContent,'file')
    fprintf('Your input script %s does not exist.  Make sure you have the right path and filename.\n',tdfile_trialContent);
elseif ~exist(tdfile_ratings,'file')
    fprintf('Your input script %s does not exist.  Make sure you have the right path and filename.\n',tdfile_ratings);
else
    %read in tab delimited file set up like MacStim (textread will read in as col vectors)
    
    %set up instrux
    [INSTRUX.typ,INSTRUX.num,INSTRUX.pre,INSTRUX.maxTime,INSTRUX.totTime,INSTRUX.rep,INSTRUX.stpEvt,INSTRUX.bg,INSTRUX.st,INSTRUX.bgFile,INSTRUX.stFile,INSTRUX.hshift,INSTRUX.vshift,INSTRUX.tag] = textread(tdfile_instrux, '%c %d %f %f %f %d %s %c %c %s %s %d %d %s','delimiter', '\t', 'whitespace', '', 'commentstyle', 'matlab' );
    instruxCell = {INSTRUX.typ,INSTRUX.num,INSTRUX.pre,INSTRUX.maxTime,INSTRUX.totTime,INSTRUX.rep,INSTRUX.stpEvt,INSTRUX.bg,INSTRUX.st,INSTRUX.bgFile,INSTRUX.stFile,INSTRUX.hshift,INSTRUX.vshift,INSTRUX.tag};
    %set up ratings
    [RATING.typ,RATING.num,RATING.pre,RATING.maxTime,RATING.totTime,RATING.rep,RATING.stpEvt,RATING.bg,RATING.st,RATING.bgFile,RATING.stFile,RATING.hshift,RATING.vshift,RATING.tag] = textread(tdfile_ratings, '%c %d %f %f %f %d %s %c %c %s %s %d %d %s','delimiter', '\t', 'whitespace', '', 'commentstyle', 'matlab' );
    ratingCell = {RATING.typ,RATING.num,RATING.pre,RATING.maxTime,RATING.totTime,RATING.rep,RATING.stpEvt,RATING.bg,RATING.st,RATING.bgFile,RATING.stFile,RATING.hshift,RATING.vshift,RATING.tag};
    
    % COMBINE!!
    colnames = {'typ','num','pre','maxTime','totTime','rep','stpEvt','bg','st','bgFile','stFile','hshift','vshift','tag'};
    for c=1:length(colnames)
        concatCommand = [colnames{c} '=vertcat(INSTRUX.' colnames{c} ',RATING.' colnames{c} ');'];
        eval(concatCommand);
    end
    masterCell = {typ,num,pre,maxTime,totTime,rep,stpEvt,bg,st,bgFile,stFile,hshift,vshift,tag};
    
    save(varFile,'typ','num','pre','maxTime','totTime','rep','stpEvt','bg','st','bgFile','stFile','hshift','vshift','tag');
    
%     fid = fopen('PROP_combined.txt','w');
%     formatSpec = '%c %d %f %f %f %d %s %c %c %s %s %d %d %s\n';
%     [nrows,ncols] = size(masterCell);
%     for row = 1:nrows
%         fprintf(fid,formatSpec,masterCell{row,:});
%     end
%     fclose(fid);

end;

end