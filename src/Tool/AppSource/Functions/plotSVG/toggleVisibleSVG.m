function toggleVisibleSVG(ax,obj,visible)
if visible
    visible = 'on';
else
    visible = 'off';
end
set(findobj(ax.Children,'UserData',obj),'Visible', visible);
end