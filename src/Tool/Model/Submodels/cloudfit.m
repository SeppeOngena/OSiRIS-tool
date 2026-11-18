function LogParams = cloudfit(Okta1,Okta2,Okta3)%DataSolar,DataRain,clouddata,lambda,phi,Tlk,rho,beta,alpha,A_panel,Wp_panel,eta_inverter,eta_heat)

%ys = bsxfun(@rdivide, data, sum(data,2));

%params = zeros([3,3]);
%for i=1:3
%    x = (0:11)';
%    y = ys(:,i);
%    A = (max(y)-min(y))/2;
%    B = find(y == max(y));
%    C = mean(y);
% fit = @(b,x) b(1).*cos(2*pi*(x+b(2))/12) + b(3);
% fcn = @(b) sum((fit(b,x) - y).^2);
% s = fminsearch(fcn, [A, B, C]);
% params(i,:) = s;

%Oktas = zeros([3,1]);
%fit = @(b) groupsummary(retime(SolarPower_Model_New(DataRain.Time, clouddata, lambda, phi,...
%    Tlk, rho, beta, alpha,...
%    A_panel, Wp_panel, eta_inverter,eta_heat,...
%    true, ...
%    b),"monthly",'sum'),"Time",'monthofyear','mean');
%fcn = @(b) sum( (fit(b).mean_E_solar-groupsummary(retime(DataSolar(DataSolar.E_solar>0,:),"monthly",'sum'),"Time",'monthofyear','mean').mean_E_solar).^2);%

%s = fminsearchbnd(fcn,[1,1,1],[1,1,1],[10,10,10],optimset('Display','iter','PlotFcns',@optimplotfval));
%Oktas = s;


fit = @(b,x) b(1)/(1+exp(-b(2)*(x-b(3))));
fcn = @(b) fit(b,0)^2+(fit(b,1)-Okta1)^2+(fit(b,2)-Okta2)^2+(fit(b,3)-Okta3)^2;
s = fminsearch(fcn,[1,3,1.5]);%,optimset('Display','iter','PlotFcns',@optimplotfval));
LogParams = s;
end