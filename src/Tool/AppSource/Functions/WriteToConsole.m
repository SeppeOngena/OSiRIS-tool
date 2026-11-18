function msg = WriteToConsole(msg, Console_Value,repl_last)
        msg = char('['+string(datetime("now", 'Format', 'yyyy-MM-dd HH:mm:ss'))+']'+'    '+msg);
            
            if isempty(Console_Value{1})
                msg = {msg};
            else
                if repl_last
                    Console_Value{length(Console_Value)} = msg;
                    msg = Console_Value;
                else
                    Console_Value{length(Console_Value)+1} = msg;
                    msg = Console_Value;
                end
            end
        end