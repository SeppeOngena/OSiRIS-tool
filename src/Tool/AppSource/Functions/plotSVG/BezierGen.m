function P = BezierGen(p,n)
% Approximate a bézier curve with 
%   control points p (rows = points, cols = x,y)
%   for n curve points 

% Adapted from Lakshmi Narasimhan (2024). Generalised bezier curve matlab code (https://www.mathworks.com/matlabcentral/fileexchange/33828-generalised-bezier-curve-matlab-code), MATLAB Central File Exchange. Retrieved June 13, 2024. 
% Reworked code to avoid for loops as this would increase calculation time significantly

nc = size(p,1); % number of control points

i=0:1:(nc-1); 
sigma=factorial(nc-1)./(factorial(i).*factorial(nc-1-i));  % for calculating (x!/(y!(x-y)!)) values 

U = 0:(1/n):1; % n
D=1:nc; % nc
l=sigma.*((1-U)'.^(nc-D)).*(U'.^(D-1));
P=l*p;
end