function copySVG(ax1,ax2,obj)
copyobj(findobj(ax1.Children,'UserData',obj), ax2);
end