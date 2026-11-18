function StructOut = FlattenStructOfStruct(StructIn)

StructOut = struct();
fnames = fieldnames(StructIn);

% for i=1:length(fnames)    
%     if isstruct(StructIn.(fnames{i}))
%         if strcmp(fnames{i},'ClouddataTable')
%             StructOut.(fnames{i}) = struct2table(StructIn.(fnames{i}));
%         else
%             tmp = FlattenStructOfStruct(StructIn.(fnames{i}));
%             fnames_tmp = fieldnames(tmp);
%             for j=1:length(fnames_tmp)
%                 StructOut.(fnames_tmp{j}) = tmp.(fnames_tmp{j});                        
%             end
%         end
%     else
%         StructOut.(fnames{i}) = StructIn.(fnames{i});
%     end    
% end

for i=1:length(fnames)    
    try fieldnames(StructIn.(fnames{i}));
        if strcmp(fnames{i},'ClouddataTable')
            StructOut.(fnames{i}) = struct2table(StructIn.(fnames{i}));
        else
            tmp = FlattenStructOfStruct(StructIn.(fnames{i}));
            fnames_tmp = fieldnames(tmp);
            for j=1:length(fnames_tmp)
                StructOut.(fnames_tmp{j}) = tmp.(fnames_tmp{j});                        
            end
        end
    catch
        StructOut.(fnames{i}) = StructIn.(fnames{i});
    end    
end
end
