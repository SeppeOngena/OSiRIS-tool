function writeJSONstruct(S,filename)
% Write structure to json file with escaping \ only once
str = struct2str(S,0);
fid = fopen(filename,'w');
fwrite(fid,str);
end

function str = struct2str(S,depth)
    fn = fieldnames(S);
    if ~isempty(fn)
        str = ['{' newline];
    else
        str = '{';
    end
    for i=1:length(fn)
        if isstruct(S.(fn{i}))
            S.(fn{i}) = struct2str(S.(fn{i}),depth+1);
            wrap = '';
        elseif iscell(S.(fn{i}))
            S.(fn{i}) = cell2str(S.(fn{i}),depth+1);
            wrap = '';
        elseif isstring(S.(fn{i}))||ischar(S.(fn{i})) 
            if isstring(S.(fn{i}))
                S.(fn{i}) = char(S.(fn{i}));
            end
            wrap = '"';
        elseif islogical(S.(fn{i}))
            if S.(fn{i})
                S.(fn{i}) = 'true';
            else
                S.(fn{i}) = 'false';
            end
            wrap = '';
        elseif isnumeric(S.(fn{i}))
            S.(fn{i}) = num2str(S.(fn{i}),12);
            wrap = '';
        else
            error("Unsupported variable type")
        end
        
        if i==length(fn)
            lastchar = '';
        else
            lastchar = ',';
        end

        S.(fn{i}) = EscapeSingleBackslash(S.(fn{i}));

        str = [str repelem('    ',depth+1) '"' fn{i} '": ' wrap S.(fn{i}) wrap lastchar newline];
       
    end
    if ~isempty(fn)
        str = [ str repelem('    ',depth) '}'];
    else
        str = [ str '}'];
    end
end

function str = cell2str(C,depth)
    if ~isempty(C)
        str = ['[' newline];
    else
        str = '[';
    end
    for i=1:length(C)
        if isstruct(C{i})
            C{i} = struct2str(C{i},depth+1);
            wrap = '';
        elseif iscell(C{i})
            C{i} = cell2str(C{i},depth+1);
            wrap = '';
        elseif isstring(C{i})||ischar(C{i})  
            wrap = '"';
        elseif islogical(C{i})
            if C{i}
                C{i} = 'true';
            else
                C{i} = 'false';
            end
            wrap = '';
        elseif isnumeric(C{i})
            C{i} = num2str(C{i},12);
            wrap = '';
        else
            error("Unsupported variable type")
        end
        
        if i==length(C)
            lastchar = '';
        else
            lastchar = ',';
        end

        C{i} = EscapeSingleBackslash(C{i});

        str = [str repelem('    ',depth+1) wrap C{i} wrap lastchar newline];
    end
    if ~isempty(C)
        str = [ str repelem('    ',depth) ']'];
    else
        str = [ str ']'];
    end
end

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