function secdetail(IA)
global xyztab sections
global index nn
nlist=cell(1,nn);
for i=1:nn
    nlist(i)={num2str(i)};
end
plist={'Circular\Pipe','Rectangular\Box','Hexagonal','Trapezoidal','I','T','L (angle)','C (channel)'};
plist(end-1:end)=[];
slist={'Normal stress Su','Shear stress Suv','Maximum principal',...
    'Minimum principal','Von Mises','Guest-Tresca','First invariant'...
    'Third invariant'};
[numnod,ok]=listdlg('PromptString',{'Node number:'},...
                'SelectionMode','single',...
                'ListString',nlist);
if ok
    selem=logical(sum(index(:,2:3)==numnod,2));
    if sum(selem)<2
        numelem=index(selem,1);
    else
        edouble=index(selem,1); elist=cell(1,sum(selem));
        for i=1:sum(selem)
            elist(i)={num2str(edouble(i))};
        end
        [numelem,ok]=listdlg('PromptString',{'Element number:'},...
                'SelectionMode','single',...
                'ListString',elist);
        numelem=str2num(cell2mat(elist(numelem)));
    end
else
    return
end

if ok
    [shape,ok]=listdlg('PromptString',{'Beam profile:'},...
        'SelectionMode','single',...
        'ListString',plist);
else
    return
end

if ok
    [k,ok]=listdlg('PromptString',{'Stress value:'},...
        'SelectionMode','single',...
        'ListString',slist);
else
    return
end
    
if ok
    status_info(sprintf('Section detail [%i %i %i %i]',numnod,numelem,shape,k),1)
    nk=(find(index(numelem,2:3)==numnod)-1)*6;
    prop=sections(index(numelem,4),2:6);
    N=IA(numelem,nk+1);
    M1=IA(numelem,nk+4);
    M2=IA(numelem,nk+5);
    M3=IA(numelem,nk+6);
    try
        fig=figure('Name',sprintf('Node %i - Element %i',numnod,numelem),...
            'NumberTitle','off');
        sigmasurf(shape,prop,N,M1,M2,M3,k,fig)
    catch ME
        errordlg('The shape of the cross section doesn''t match with properties')
        status_info('Operation failed: see message error')
        close(fig)
    end
else 
    return
end
