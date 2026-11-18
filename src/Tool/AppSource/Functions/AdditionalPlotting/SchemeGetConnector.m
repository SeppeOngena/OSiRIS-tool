function pos_conn = SchemeGetConnector(object,location)
% get the x and y coordinates of a connection to a box with width w and
% height h at position 'pos' (x,y).
% The location of the connector can be 'top','left','right','bottom' or a
% combination (topleft, leftbottom,...)
w = object.dim(1);
h = object.dim(2);
            switch location
                case 'top'
                    pos_conn = [w/2 0];
                case 'left'
                    pos_conn = [0 h/2];
                case 'right'
                    pos_conn = [w h/2];
                case 'bottom'
                    pos_conn = [w/2 h];
                case 'topleft'
                    pos_conn = [w/3 0];
                case 'topright'
                    pos_conn = [2*w/3 0];
                case 'bottomleft'
                    pos_conn = [w/3 h];
                case 'bottomright'
                    pos_conn = [2*w/3 h];
                case 'righttop'
                    pos_conn = [w h/3];
                case 'rightbottom'
                    pos_conn = [w 2*h/3];
                case 'lefttop'
                    pos_conn = [0 h/3];
                case 'leftbottom'      
                    pos_conn = [0 2*h/3];
            end
            pos_conn = pos_conn + object.pos;
        end