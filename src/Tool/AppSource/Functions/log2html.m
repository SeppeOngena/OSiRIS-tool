function html = log2html(log)
html = char();
html = [html '<head><style>p{margin:2 2 0 0;}</style></head><body>'];
html = [html '<body style="background-color:white;font-family:helvetica;font-size:80%;">'];
for i=1:length(log)
    if contains(log{i},'[WARNING]')
        html = [html '<p style="color:orange;">' log{i} '</p>'];
    elseif contains(log{i},'[ERROR]')
        html = [html '<p style="color:red;">' log{i} '</p>'];
    elseif contains(log{i},'[DEBUG]')
        html = [html '<p style="color:green;">' log{i} '</p>'];
    else
        html = [html '<p> ' log{i} '</p>'];
    end
end
html = [html '</body><script>window.scrollTo(0, document.body.scrollHeight);</script>'];
end