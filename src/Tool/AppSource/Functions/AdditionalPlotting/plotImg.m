function plotImg(ax, imname, pos,repcol,col)
% Plots an image (imname) on the figure ax at position pos (x,y).
            
    [im, cmap, imalpha] = imread(imname);
    if repcol
        rep = ~(ismember(cmap,[0,0,0],'rows')+ismember(cmap,[1,1,1],'rows'));
        cmap(rep,:) = repmat(col,[sum(rep) 1]);
    end
    im = ind2rgb(im,cmap);

    image(ax,im,'AlphaData',imalpha,'XData',pos(1),'YData',pos(2))
end

