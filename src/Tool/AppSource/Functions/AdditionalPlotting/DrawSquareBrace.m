function DrawSquareBrace(ax,x,y,height,width,linewidth,color)
% Draws a square brace on axis ax at position x,y with total height and width of
% the brace
line(ax, [x x], [y+height/2 y-height/2],'LineWidth',linewidth,'Color',color)
line(ax, [x x+width], [y+height/2 y+height/2],'LineWidth',linewidth,'Color',color)
line(ax, [x x+width], [y-height/2 y-height/2],'LineWidth',linewidth,'Color',color)
end