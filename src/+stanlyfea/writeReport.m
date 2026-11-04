function writeReport(result,filename)
%WRITEREPORT Portable HTML report with tables; no publish or extra toolbox.
[fid,message] = fopen(filename,'wt');
if fid < 0, error('Stanly:Report','%s',message); end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid,'<!doctype html><html lang="en"><meta charset="utf-8"><title>STANLY FEA</title>');
fprintf(fid,['<style>body{font:14px system-ui;margin:3em;max-width:1200px}' ...
    'table{border-collapse:collapse;font:12px monospace}th,td{border:1px solid #ccc;' ...
    'padding:5px;text-align:right}th{background:#eef2f7}section{overflow:auto}' ...
    '@media print{body{margin:0}h2{break-after:avoid}}</style><body>']);
fprintf(fid,'<h1>STANLY FEA</h1><p>%s</p><p>Source: %s</p>', ...
    escape(result.Model.Title),escape(result.Model.Filename));
fprintf(fid,['<p>Linear 3-D frame analysis. Values use the consistent unit system of the input model. ' ...
    'Stress values are section envelopes; torsion uses J = Iv + Iw. ' ...
    'Transverse shear stress and buckling are not evaluated.</p>']);
fprintf(fid,'<p>Constraint residual: %.6g; reciprocal condition estimate: %.6g.</p>', ...
    result.Diagnostics.ConstraintResidual,result.Diagnostics.ReciprocalConditionEstimate);
tables = {'Nodes','Elements','Displacements','Reactions','Applied loads', ...
    'Internal forces','Stress','Nominal stress','Strain','Safety factors'};
if isfield(result,'Fatigue')
    fprintf(fid,['<p>Fatigue uses the original STANLY empirical formulae. ' ...
        'Cycles are capped at 10^7. See the numerical-method notes before interpreting these estimates.</p>']);
    tables{end+1} = 'Fatigue';
end
for k = 1:numel(tables)
    data = stanlyfea.resultTable(result,tables{k});
    fprintf(fid,'<h2>%s</h2><section><table><thead><tr>',escape(tables{k}));
    for j = 1:width(data), fprintf(fid,'<th>%s</th>',escape(data.Properties.VariableNames{j})); end
    fprintf(fid,'</tr></thead><tbody>');
    values = table2array(data);
    for i = 1:size(values,1)
        fprintf(fid,'<tr>'); fprintf(fid,'<td>%.10g</td>',values(i,:)); fprintf(fid,'</tr>');
    end
    fprintf(fid,'</tbody></table></section>');
end
fprintf(fid,'</body></html>');
end

function value = escape(value)
value = strrep(char(value),'&','&amp;'); value = strrep(value,'<','&lt;');
value = strrep(value,'>','&gt;'); value = strrep(value,'"','&quot;');
end
