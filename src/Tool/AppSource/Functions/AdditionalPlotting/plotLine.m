function plotLine(ax, pos,col,arrowend,linespec,linewidth)
    % Plots a line on the figure 'ax' at position 'pos' (x,y) with color
    % 'col' (rgb triplet)
    % if arrowend = true, adds an arrow to the end of the line

    % Plot line
    line(ax, pos(:,1),pos(:,2),'Color',col,'LineStyle',linespec,'LineWidth',linewidth)

    % Plot arrow
    if arrowend
        delt  = pos(end,:)-pos(end-1,:);
        w = 12.5*linewidth;
        h = 25*linewidth;
        if abs(delt(1))>abs(delt(2)) % last line is horizontal
            patch(ax,[pos(end,1),pos(end,1)-h*sign(delt(1)),pos(end,1)-h*sign(delt(1))], ...
                             [pos(end,2),pos(end,2)-w,pos(end,2)+w], ...
                             col,'EdgeColor','none');
                       
        else
            patch(ax,[pos(end,1),pos(end,1)-w,pos(end,1)+w], ...
                             [pos(end,2),pos(end,2)-h*sign(delt(2)),pos(end,2)-h*sign(delt(2))], ...
                             col,'EdgeColor','none');
        end
    end
 end