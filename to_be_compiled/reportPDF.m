fclose all;
fprintf('\n\n')
fprintf('#\tnode number\n##\telement number\n')
fprintf('[fu]\tforce unit\n[lu]\tlength unit\n[tu]\ttemperature unit\n\n')
fsize=get(GUI,'position');
XLIM=get(UIax,'XLim');
YLIM=get(UIax,'YLim');
ZLIM=get(UIax,'ZLim');
[AZ,EL]=view;
fprintf('\nNodes\t\t%i\nElements\t%i\nDoFs\t\t%i\nDoBs\t\t%i\n\n',...
	nn,ne,ndof,ndob)
rep_fig=gobjects(1,sum(fig_choice));
ifg=1;
format shorte

%% Model
if fig_choice(1), rep_fig(ifg)=figure('Position',fsize); meshstr(rep_fig(ifg)), ifg=ifg+1; adjustment; end
if fig_choice(2), rep_fig(ifg)=figure('Position',fsize); materials_mesh(rep_fig(ifg)), ifg=ifg+1; adjustment; end
if fig_choice(3), rep_fig(ifg)=figure('Position',fsize); csection_mesh(rep_fig(ifg)), ifg=ifg+1; adjustment; end
if fig_choice(4), rep_fig(ifg)=figure('Position',fsize); orient(rep_fig(ifg)), ifg=ifg+1; adjustment; end
fprintf('\n')
if tab_choice(1), fprintf('\nNODAL COORDINATES\n'), disp(tab.nco), fprintf('\n'), end
if tab_choice(2), fprintf('\nINDEX MATRIX\n'), disp(tab.ind(:,1:4)), disp(tab.ind(:,[1 5])), fprintf('\n'), end
if ~isempty(axx)
    if tab_choice(3), fprintf('\nENSLAVEMENTS\n'), disp(tab.ens(:,1:4)), disp(tab.ens(:,[1:2 5:6])), disp(tab.ens(:,[1:2 7:8])), fprintf('\n'), end
end
if tab_choice(4), fprintf('\nMATERIALS\n'), disp(tab.mat(:,1:5)), disp(tab.mat(:,[1 6:end])), fprintf('\n'), end
if tab_choice(5), fprintf('\nSECTION PROPERTIES\n'), disp(tab.sec(:,1:5)), disp(tab.sec(:,[1 6:end])), fprintf('\n'), end
if tab_choice(6), fprintf('\nSTRESS CONCENTRATION FACTORS\n'), disp(tab.not), fprintf('\n'), end
if tab_choice(7), fprintf('\nBEAMS ORIENTATION\n'), disp(tab.ori), fprintf('\n'), end


%% Loads
if fig_choice(5), rep_fig(ifg)=figure('Position',fsize); boundaries(ext_f,int_f,rep_fig(ifg)), ifg=ifg+1; adjustment; end
fprintf('\n')
if tab_choice(8), fprintf('\nEXTERNAL LOADS\n'), disp(tab.ext(:,1:4)), disp(tab.ext(:,[1 5:end])), fprintf('\n'), end
if tab_choice(9), fprintf('\nREACTION LOADS\n'), disp(tab.rea(:,1:4)), disp(tab.rea(:,[1 5:end])), fprintf('\n'), end


%% Internal forces
if fig_choice(6), rep_fig(ifg)=figure('Position',fsize); axial(int_act,iasca,rep_fig(ifg),1), adjustment; ifg=ifg+1; end
if fig_choice(7), rep_fig(ifg)=figure('Position',fsize); shear(int_act,iasca,rep_fig(ifg),1), adjustment; ifg=ifg+1; end
if fig_choice(8), rep_fig(ifg)=figure('Position',fsize); torque(int_act,iasca,rep_fig(ifg),1), adjustment; ifg=ifg+1; end
if fig_choice(9), rep_fig(ifg)=figure('Position',fsize); bending(int_act,iasca,rep_fig(ifg),1), adjustment; ifg=ifg+1; end
fprintf('\n')
if tab_choice(10), fprintf('\nINTERNAL ACTIONS\n'), disp(tab.int(:,1:4)), disp(tab.int(:,[1:2 5:6])), disp(tab.int(:,[1:2 7:8])), fprintf('\n'), end


%% Displacement
for i=1:13
    if fig_choice(9+i), rep_fig(ifg)=figure('Position',fsize); deform(defmat,maxd,i,rep_fig(ifg),1), adjustment; ifg=ifg+1; end
end
fprintf('\n')
if tab_choice(11), fprintf('\nNODAL DISPLACEMENTS\n'), disp(tab.uvw(:,1:2)), disp(tab.uvw(:,[1 3:5])), disp(tab.uvw(:,[1 6:end])), fprintf('\n'), end


%% Stresses
for k=1:8
    if fig_choice(22+k), rep_fig(ifg)=figure('Position',fsize); sigmass(k,SS,SSnom,rep_fig(ifg),1); adjustment; ifg=ifg+1; end
end
fprintf('\n')
if tab_choice(12), fprintf('\nMAXIMUM STRESSES\n'), disp(tab.stm(:,1:4)), disp(tab.stm(:,[1:2 5:6])), disp(tab.stm(:,[1:2 7:8])), disp(tab.stm(:,[1:2 9:end])), fprintf('\n'), end
if tab_choice(13), fprintf('\nNOMINAL STRESSES\n'), disp(tab.stn(:,1:4)), disp(tab.stn(:,[1:2 5:6])), disp(tab.stn(:,[1:2 7:8])), disp(tab.stn(:,[1:2 9:end])), fprintf('\n'), end


%% Strains
for k=1:6
    if fig_choice(30+k), rep_fig(ifg)=figure('Position',fsize); epsilon(k,EE,EEnom,rep_fig(ifg),1); adjustment; ifg=ifg+1; end
end
fprintf('\n')
if tab_choice(14), fprintf('\nMAXIMUM STRAINS\n'), disp(tab.etm(:,1:4)), disp(tab.etm(:,[1:2 5:6])), disp(tab.etm(:,[1:2 7:8])), fprintf('\n'), end
if tab_choice(15), fprintf('\nNOMINAL STRAINS\n'), disp(tab.etn(:,1:4)), disp(tab.etn(:,[1:2 5:6])), disp(tab.etn(:,[1:2 7:8])), fprintf('\n'), end


%% Fatigue
if filetype==2
    for k=1:4
        if fig_choice(36+k), rep_fig(ifg)=figure('Position',fsize); fatigue_plot(k,FF,FFnom,rep_fig(ifg),1); adjustment; ifg=ifg+1; end
    end
    if tab_choice(17), fprintf('\nFATIGUE PARAMETERS\n'), disp(tab.fat(:,1:4)), disp(tab.fat(:,[1 2 5 6])), fprintf('\n'), end
end


%% Assessment
if tab_choice(16)
    fprintf('\nSAFETY FACTORS\n'), disp(tab.eta(:,1:4)), disp(tab.eta(:,[1:2 5:6]))
    if filetype==1
        disp(tab.eta(:,[1:2 7]))
    else
        disp(tab.eta(:,[1:2 7:8]))
        disp(tab.eta(:,[1:2 9]))
    end
    fprintf('\n')
end

