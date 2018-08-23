for i=2:length(key_presses.time)
    if key_presses.time(i)-key_presses.time(i-1)<.5
        key_presses.time(i)=0
    end
end

fprintf('Key presses logged: %d\n',sum(key_presses.time>0))

fprintf('Responses logged within run_info: %d\n',length(run_info.responses)-sum(cellfun('isempty',run_info.responses)))