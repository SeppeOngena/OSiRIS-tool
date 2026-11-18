function str = EscapeSingleBackslash(str)
    singlebackID = regexp(str,"[^\\][\\]")+1;
    replacedcount = 0;
    if ~isempty(singlebackID)
        doublebackID = regexp(str,"\\\\");
        for j = 1:length(singlebackID)
            if ~any(doublebackID==singlebackID(j))
                str = [str(1:(singlebackID(j)+replacedcount)) '\' str((singlebackID(j)+replacedcount+1):end)];
                replacedcount = replacedcount + 1;
            end
        end
    end
end