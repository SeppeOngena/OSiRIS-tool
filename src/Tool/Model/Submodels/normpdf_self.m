function output = normpdf_self(dates, mu, sd)
output = 1/(sd*sqrt(2*pi))*exp(1).^(-1/2*(dates-mu).^2/sd^2);
end