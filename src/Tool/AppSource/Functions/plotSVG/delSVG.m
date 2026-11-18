function delSVG(ax,obj)
delete(findobj(ax.Children,'UserData',obj));
end