function coords = getCoords(obj1, orient1, obj2, orient2,varargin)
p_start = SchemeGetConnector(obj1,orient1);
p_end   = SchemeGetConnector(obj2,orient2);

if nargin==4
    if any(p_start == p_end) % straight line
        coords  = [p_start; p_end];
    else % simple elbow
        if startsWith(orient1,{'top','bottom'})
            coords = [p_start; p_start(1) p_end(2); p_end];
        else
            coords = [p_start; p_end(1) p_start(2); p_end];
        end
    end
else % complex routing
    levels = varargin{1};
    if nargin==6
        next = varargin{2};
    else
        next = 'y'; % first level adjustment is y level
    end
    
    coords = zeros([1+length(levels)+2,2]);
    coords(1,:) = p_start;
    for i=2:(2+length(levels)-1)
        if next == 'y'
            coords(i,:) = [coords(i-1,1) levels(i-1)];
            next = 'x';
        else
            coords(i,:) = [levels(i-1) coords(i-1,2)];
            next = 'y';
        end

        %coords = [p_start;p_start(1) levels(1);p_end(1) levels(1); p_end];
    end
    if any(coords(end-2,:) == p_end) % straight line
        coords(end-1,:)  = p_end;
    else % simple elbow
        if startsWith(orient2,{'top','bottom'})
            coords(end-1,:) = [p_end(1) coords(end-2,2)];
        else
            coords(end-1,:) = [coords(end-2,1) p_end(2)];
        end
    end
    coords(end,:) = p_end;
    if all(coords(end,:)==coords(end-1,:))
        coords(end,:) = [];
    end
end
end
