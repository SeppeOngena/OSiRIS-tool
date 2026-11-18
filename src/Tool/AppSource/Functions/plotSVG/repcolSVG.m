function repcolSVG(ax, obj, col1, col2)
if ischar(col1)
    set(findobj(ax.Children,'UserData',obj,'-not','FaceColor',[1 1 1]),'FaceColor', col2);
else
    set(findobj(ax.Children,'UserData',obj,'FaceColor',col1),'FaceColor', col2);    
end

%ChildInd = getObjInd(ax,obj);

%if ischar(col1)
%   for i=ChildInd
%      if all(ax.Children(i).FaceColor ~= [1 1 1])
%         ax.Children(i).FaceColor = col2;
%      end
%   end
%else
%   for i=ChildInd
%      if all(ax.Children(i).FaceColor == col1)
%         ax.Children(i).FaceColor = col2;
%      end
%   end
%end

end