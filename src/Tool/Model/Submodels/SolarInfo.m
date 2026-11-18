function [DataSolar, dt_sun] = SolarInfo(Time_rain, kWp_panels, eta_inverter,eta_heat, csvname, TimeZone, delimiter, decimal,tformat)
% Gives a timetable of the CSV, Metadata of the weather station and the
% number of datapoints

opts = detectImportOptions(csvname, ...
    'Delimiter',delimiter,...
    'DecimalSeparator', decimal,...
    'ReadVariableNames',false, ...
    'EmptyLineRule','read');
opts = setvaropts(opts,opts.VariableNames{1}, ...
                       'Type','datetime',...
                       'InputFormat',tformat,...
                       'TimeZone', TimeZone);
opts.DataLines = [1 inf];
DataSolar = readtimetable(csvname,opts);
DataSolar.Properties.DimensionNames{1} = 'Time';
varname_ind = find(~isnat(DataSolar.Time), 1 )-1;

opts = detectImportOptions(csvname, ...
    'Delimiter',delimiter,...
    'DecimalSeparator', decimal,...
    'ReadVariableNames',false);
opts.DataLines = [varname_ind varname_ind];
opts = setvartype(opts, opts.VariableNames, 'string');

vnames = cellstr(readmatrix(csvname,opts));
DataSolar.Properties.VariableNames = vnames(2:end);
DataSolar(isnat(DataSolar.Time),:) = [];
DataSolar.("G(i)")(isnan(DataSolar.("G(i)")))=0;

dt_sun      = seconds(DataSolar.Time(2)-DataSolar.Time(1));  % s/tstep
dt          = seconds(Time_rain(2)-Time_rain(1));  % s/tstep

DataSolar = retime(DataSolar,Time_rain,'linear');
DataSolar.('G(i)') = DataSolar.('G(i)')*dt/dt_sun; % Wh/kWp
DataSolar.E_solar = DataSolar.('G(i)')*kWp_panels/1e3*eta_inverter*eta_heat; % kWh/tstep;

end

