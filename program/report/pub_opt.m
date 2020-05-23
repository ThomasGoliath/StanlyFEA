function [opt,finPath,temPath,yp,jjj]=pub_opt(file)
j=find(file=='.'); jjj=1; tname='report.';
def_path=file(1:j-1);
[name,ppath,pfk]=uiputfile({'*.doc','Microsoft Word Document (*.doc)';...
    '*.pdf','Portable Document Format (*.pdf)';...
    '*.html','HyperText Markup Language Document (*.html)';...
    '*.xml','eXtensible Markup Language Document (*.xml)';...
    '*.tex','LaTex Document (*.tex)';},...
    'Publish report',def_path);
if ppath~=0
    yp=1;
    form={'doc','pdf','html','xml','latex'};
    form=char(form(pfk));
    im_form='tiff';
    if strcmp(form,'pdf'), im_form='bmp'; tname='reportPDF.'; jjj=0; end
    k=find(name=='.');
    if strcmp(form,'html')||strcmp(form,'xml')||strcmp(form,'latex')
        out_dir=strcat(ppath,name(1:k-1));
        temPath=out_dir;
        finPath=[];
        if exist(out_dir,'dir'), rmdir(out_dir,'s'), end
    else
        out_dir='.\report\';
        temPath=strcat(out_dir,tname,form);
        finPath=strcat(ppath,name);
    end
    opt=struct('format',form,'outputDir',out_dir,'showCode',false,...
        'imageFormat',im_form,'useNewFigure',false);
else
    opt=[];
    finPath=[];
    temPath=[];
    yp=0;
end