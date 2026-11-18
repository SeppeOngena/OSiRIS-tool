% Based on Martin de La Gorce (2016) with heavy modifications

function plotSVG(ax,file,pos,nBezierPoints,colrepmat)
% Plots the SVG image in 'file' to the figure 'ax' at position 'pos' (x,y).
% If bézier curves are present, nBezierPoints defines how many points will be used to approximate the curve
% colrepmat is an nx2 cell array with the first column being the color (rgb triplet) to replace from the svg image and the second columnthe color to replace it with.
% Based on https://developer.mozilla.org/en-US/docs/Web/SVG

if isstring(file)||ischar(file) % read file
    xDoc = xmlread(file);
else
    xDoc = file;
end

A0 = [1 0 pos(1); 0 1 pos(2); 0 0 1]; % base transformation matrix

Elements=xDoc.getChildNodes;
hold(ax,'on')
PlotElements(ax,Elements,A0,nBezierPoints,colrepmat) % main function
hold(ax,'off')

set(findobj(ax.Children,'UserData',[]),'UserData',erase(file,'.svg'))
%for ChildId=1:length(ax.Children)
%    if isempty(ax.Children(ChildId).UserData)
%        ax.Children(ChildId).UserData = erase(file,'.svg');
%    end
%end

% Main Function (loops over Elements and points to relevant functions)
function PlotElements(ax,Elements,A0,nBezierPoints,colrepmat)
    for i=0:Elements.getLength-1
        elementType = char(Elements.item(i).getNodeName);
        switch elementType
            case 'text'
                At = A0*GetTransfoMatrix(Elements.item(i));
                plotText(ax,Elements.item(i),At,colrepmat)
            case 'path'
                Ap = A0*GetTransfoMatrix(Elements.item(i));
                plotPaths(ax,Elements.item(i),Ap,nBezierPoints,colrepmat)
            case 'rect'
                Ar = A0*GetTransfoMatrix(Elements.item(i));
                plotRect(ax,Elements.item(i),Ar,colrepmat)
            case {'g','svg'}
                Al = A0*GetTransfoMatrix(Elements.item(i));
                PlotElements(ax,Elements.item(i).getChildNodes,Al,nBezierPoints,colrepmat) % recursive
            case {'#text','sodipodi:namedview','defs','#comment','metadata'}
                % do nothing
            otherwise
                warning('Node type "%s" not implemented',elementType)
        end
    end
end

% Element functions
function plotPaths(ax,thisElement,A,nBezierPoints,colrepmat)
  
    dStr=char(thisElement.getAttribute('d')); % get d attribute

    if thisElement.hasAttribute('fill')
        fill_col = char(thisElement.getAttribute('fill'));
        if ~strcmp(fill_col,'none')
            fill_col=hex2rgb(fill_col);
            fill_col = colrep(fill_col,colrepmat);
        end
    elseif thisElement.hasAttribute('style')
          style=char(thisElement.getAttribute('style'));
          mapObj = containers.Map;
          C = strsplit(style,{';'});
          for k =1:length(C)
            D = strsplit(C{k},{':'});           
            mapObj(D{1}) = D{2};
          end
          if ~isKey(mapObj,'fill')
              fill_col = [0 0 0];
          else
              fill_col = hex2rgb(mapObj('fill'));
          end
          fill_col = colrep(fill_col,colrepmat);
    else
        fill_col='none';
    end
    %if mapObj.isKey('opacity')
    %    opacity=str2double(mapObj('opacity'));
    %else
    opacity=1;
    %end

    if thisElement.hasAttribute('stroke')
        stroke_col=char(thisElement.getAttribute('stroke'));
        if ~strcmp(stroke_col,'none')
            stroke_col=hex2rgb(stroke_col);
            stroke_col = colrep(stroke_col,colrepmat);
        end
    else
        stroke_col='none';
    end    

    if thisElement.hasAttribute('stroke-width')
        stroke_wdth=str2double(thisElement.getAttribute('stroke-width'))/5;
    else
        stroke_wdth=0.5;
    end   

    poly = dStr2Poly(dStr,nBezierPoints);

    poly = A*[poly'; ones(1,height(poly))];
    poly = poly(1:2,:)';
    if size(poly,1)==2 % line
        plot(ax,poly(:,1)',poly(:,2)','Color',stroke_col,'LineWidth',stroke_wdth)
    else % area
        warning('off','all')
        ps=polyshape(poly(:,1)',poly(:,2)','Simplify',false);
        warning('on','all')
        plot(ax,ps,'FaceColor',fill_col,'EdgeColor',stroke_col,'FaceAlpha',opacity,'LineWidth',stroke_wdth)

    end
    
end

function plotText(ax,thisElement,A,colrepmat)
    textval = char(thisElement.getChildNodes.getTextContent);
    %fontfamily = thisElement.getAttribute('font-family');
    fontsize = str2double(thisElement.getAttribute('font-size'));
    %fontweight = str2double(thisElement.getAttribute('font-weight'));
    fill_col = hex2rgb(char(thisElement.getAttribute('fill')));
    fill_col = colrep(fill_col,colrepmat);
    
    txt_pos = A*[0;0;1];

    %if mapObj.isKey('opacity')
    %    opacity=str2double(mapObj('opacity'));
    %else
    %opacity=1;
    %end

    TextZoomable(ax,txt_pos(1), txt_pos(2),textval,'FontSize',fontsize*0.61,'Color',fill_col);
end

function plotRect(ax,thisElement,A,colrepmat)
    xpos = str2double(thisElement.getAttribute('x'));
    ypos = str2double(thisElement.getAttribute('y'));
    wdth = str2double(thisElement.getAttribute('width'));
    hght = str2double(thisElement.getAttribute('height'));
    rect_pos = [xpos,ypos; xpos+wdth,ypos; xpos+wdth,ypos+hght; xpos, ypos+hght];
    fill_col = hex2rgb(char(thisElement.getAttribute('fill')));
    fill_col = colrep(fill_col,colrepmat);

    rect_pos = A*[rect_pos';repelem(1,size(rect_pos,1))];
    rect_pos = rect_pos(1:2,:)';
    opacity = 1;

    if thisElement.hasAttribute('stroke')
        stroke_col=char(thisElement.getAttribute('stroke'));
        if ~strcmp(stroke_col,'none')
            stroke_col=hex2rgb(stroke_col);
            stroke_col = colrep(stroke_col,colrepmat);

        end
    else
        stroke_col='none';
    end    

    if thisElement.hasAttribute('stroke-width')
        stroke_wdth=str2double(thisElement.getAttribute('stroke-width'))/5;
    else
        stroke_wdth=0.5;
    end    
    warning('off','all')
    ps=polyshape(rect_pos(:,1)',rect_pos(:,2)','Simplify',false);
    warning('on','all')
    plot(ax,ps,'FaceColor',fill_col,'EdgeColor',stroke_col,'FaceAlpha',opacity,'LineWidth',stroke_wdth)
end

% Transformation Matrix function
function A = GetTransfoMatrix(thisElement)
    %https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform
    if thisElement.hasAttribute('transform')
        trsf = char(thisElement.getAttribute('transform'));
        if contains(trsf,'matrix')
            A = eval(['[' erase(trsf,{'matrix(',')'}) ']']);
            A = [reshape(A, [2 3]); 0 0 1];
        elseif contains(trsf,'translate')
            A = eval(['[' erase(trsf,{'translate(',')'}) ']']);
            A = [1 0 A(1); 0 1 A(2); 0 0 1];
        else
            A = [1 0 0; 0 1 0; 0 0 1]; % Unity matrix
        end
    else
        A = [1 0 0; 0 1 0; 0 0 1]; % Unity matrix
    end
end

% Color replace function
function col = colrep(col,colrepmat)
    if~isempty(colrepmat)
        [~,~,ind] = intersect(col, vertcat(colrepmat{:,1}),'rows');
        if ~isempty(ind)
            col = colrepmat{ind,2};
        end
    end
end

% Get coordinates from path's d-argument string after the path commands.
function Coords = getcoords(Str,varargin)
    Coords = str2double(regexp(Str(2:end),'[-0-9e\.]*','match'));
    % Depending on the type of command, a different shape of the coordinate
    % array is necessary
    if nargin == 3 % e.g., n (row) sets of x y coordinates (col = 2)
        row = varargin{1};
        col = varargin{2};
        Coords = reshape(Coords,row,col);
    else % e.g., "hi" bezier curves with "row" control points of x y coordinates (col = 2)
        row = varargin{1};
        col = varargin{2};
        hi = varargin{3};
        Coords = reshape(Coords,row,col,hi);
    end
end

% Convert the string of the d-argument to a list of x-y coordinates for
% poly plotting
function poly = dStr2Poly(dStr,nBezierPoints)

    dStr = regexp(dStr,'[A-Za-z]{1}[0-9e\.\s,-]*','match');
    poly = [];

    %https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d

    for j=1:length(dStr)
        Str = dStr{j};
        islo = lower(Str(1))==Str(1); % is lowercase -> cumulative
        switch lower(Str(1))
            case 'm'
                if islo
                    vals = getcoords(Str,1,2,[]);
                else
                    vals = getcoords(Str,2,[])';
                end
                poly = addPolyM(poly,vals,islo);
            case 'l'
                vals = getcoords(Str,1,2,[]);
                poly = addPolyL(poly,vals,islo);
            case 'h'
                vals = getcoords(Str,[],1);
                poly = addPolyH(poly,vals,islo);
            case 'v'
                vals = getcoords(Str,[],1);
                poly = addPolyV(poly,vals,islo);
            case 'c'
               vals = pagetranspose(getcoords(Str,2,3,[]));
               poly = addPolyC(poly,vals,islo,nBezierPoints);
            case 'q'
                vals = pagetranspose(getcoords(Str,2,2,[]));
                poly = addPolyQ(poly,vals,islo,nBezierPoints);
            case 'z'
                poly = addPolyZ(poly);
            otherwise
                warning('Path type "%s" not implemented yet',Str(1))
        end
    end
end

% Functions to add the derived coordinates to the poly coordinate list
% for each path command
function poly = addPolyM(poly,vals,cum)
    if ~cum
        if ~isempty(poly)
            poly = [poly; poly(end,:); nan nan]; 
        end
        poly = [poly; vals];
    else
        if ~isempty(poly)
            poly = [poly; nan nan; poly(end,:)+vals(:,:,1)];
        else
            poly = vals(:,:,1);
        end  
        if size(vals,3)>1
           for k=2:size(vals,3)
               poly = [poly; poly(end,:)+vals(:,:,k)];                   
           end 
        end
    end
    
end

function poly = addPolyL(poly,vals,cum)
    if ~cum
        for k=1:size(vals,3)
           poly = [poly; vals(:,:,k)];
        end
    else
        for k=1:size(vals,3)
           poly = [poly; poly(end,:) + vals(:,:,k)];
        end
    end 
end

function poly = addPolyH(poly,vals,cum)
    if ~cum
        vals = [vals repelem(poly(end,2),length(vals))];
        poly = [poly; vals];
    else
        for k=1:height(vals)
            poly = [poly; poly(end,1) + vals(k) poly(end,2)];
        end

    end   
end

function poly = addPolyV(poly,vals,cum)
    if ~cum
        vals = [repelem(poly(end,1),length(vals)) vals];
        poly = [poly; vals];
    else
        for k=1:height(vals)
            poly = [poly; poly(end,1) vals(k)+poly(end,2)];
        end
    end
    
end

function poly = addPolyC(poly,vals,cum,nBezierPoints)
    if ~cum
        for k=1:size(vals,3)
                    pc = [poly(end,:); vals(:,:,k)];
                    p = BezierGen(pc,nBezierPoints);
                    poly = [poly; p];
        end
    else
        for k=1:size(vals,3)
                    pc = [poly(end,:); poly(end,:)+vals(:,:,k)];
                    p = BezierGen(pc,nBezierPoints);
                    poly = [poly; p];
        end
    end
end

function poly = addPolyQ(poly,vals,cum,nBezierPoints)
    if ~cum
       for k=1:size(vals,3)
                    pc = [poly(end,:); vals(:,:,k)];
                    p = BezierGen(pc,nBezierPoints);
                    poly = [poly; p];
       end
    else
        for k=1:size(vals,3)
                    pc = [poly(end,:); poly(end,:)+vals(:,:,k)];
                    p = BezierGen(pc,nBezierPoints);
                    poly = [poly; p];
        end
    end
    
end

function poly = addPolyZ(poly)
    if any(isnan(poly(:,1)))
                    ind = find(isnan(poly(:,1)),1,'last')+1;
                    poly = [poly; poly(ind,:)];
                else
                    poly = [poly; poly(1,:)];
                end
end
end
