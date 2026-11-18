 function SaveTransparentPNG(obj,filename,dpi)
             % Save a transparent png file of the figure "obj".

             % No r, g, or b value of 'col1' can be the same as the r, g, or b value of 'col2' (pairwise),
             % otherwise the given solution for the system 
             %      u = im*a+col1*(1-a)
             %      v = im*a+col2*(1-a)
             % with im the original image and a the alpha value will be invalid

             % Color definition
             col1 = [0.1 0.9 0.9];
             col2 = [0.9 0.1 0.8];
             lineWidth = 1;

             % Add white box around figure, panel, or tab!!
                annotation(obj,'line', [0, 0], [0, 1], 'LineWidth', lineWidth, 'Color', [1 1 1]);
                annotation(obj,'line', [1, 1], [0, 1], 'LineWidth', lineWidth, 'Color', [1 1 1]);
                annotation(obj,'line', [1, 0], [0, 0], 'LineWidth', lineWidth, 'Color', [1 1 1]);
                annotation(obj,'line', [1, 0], [1, 1], 'LineWidth', lineWidth, 'Color', [1 1 1]);

             drawnow;

             % Save figure with the 2 backgrounds
             exportgraphics(obj, [filename '1.png'], 'BackgroundColor', col1,'Resolution',dpi); % cyan background
             exportgraphics(obj, [filename '2.png'], 'BackgroundColor', col2,'Resolution',dpi); % magenta background
             
             delete(findall(obj,'type','annotation'))

             % Read figures in and delete temporary ones
             u = imread([filename '1.png']);
             delete([filename '1.png'])
             u = double(u) / 255;
             v = imread([filename '2.png']);
             delete([filename '2.png'])
             v = double(v) / 255;
             
             % Create color arrays for matrix multiplication
             col2_arr = ones([size(u,1) size(u,2), size(u,3)]);
             col2_arr(:,:,1) = col2(1);
             col2_arr(:,:,2) = col2(2);
             col2_arr(:,:,3) = col2(3);

             col1_arr = ones([size(u,1) size(u,2), size(u,3)]);
             col1_arr(:,:,1) = col1(1);
             col1_arr(:,:,2) = col1(2);
             col1_arr(:,:,3) = col1(3);

             % Solve system of equations for alpha and im
             im = (col1_arr.*v-col2_arr.*u)./(v-u+col1_arr-col2_arr);
             a = (u-col1_arr)./(im-col1_arr);
             a = mean(a,3);

             % Bind values below numerical precision to 0
             a(a<eps)=0;
             im(im<eps)=0;

             % Alpha and rgb can be max 1
             a(a>1)=1;
             im(im>1)=1;

             % Find margin and thickness of white box around figure
             yt=0;
             skip = 0;
             for i=1:size(im,1)
                 if yt==0&&all(im(i,round(size(im,2)/2),:)==1)&&a(i,round(size(im,2)/2))>0
                     yt=1; % white is found
                     marg = i-1;
                 end
                 if skip==0&&yt==1&&all(im(i,round(size(im,2)/2),:)~=1)
                     wdth = i-marg-1;
                     skip = 1;
                 end
             end

             % Store final image
             imwrite(uint8(im(marg+wdth+1:size(im,1)-marg-wdth,marg+wdth+1:size(im,2)-marg-wdth,:)*255), [filename '.png'], 'Alpha', a(marg+wdth+1:size(im,1)-marg-wdth,marg+wdth+1:size(im,2)-marg-wdth));
        end
 