if isa(opened_uifig(ktab),'matlab.ui.Figure')
    close(opened_uifig(ktab))
end
buttadd=20;
switch ktab
    case 1
        tab1_nco        
    case 2
        tab2_ind
    case 3
        tab3_ens
    case 4
        tab4_mat
    case 5
        tab5_sec
    case 6
        tab6_not
    case 7
        tab7_ori
    case 8
        tab8_ext
    case 9
        tab9_rea
    case 10
        tab10_int
    case 11
        tab11_uvw
    case 12
        tab12_stm
    case 13
        tab13_stn
    case 14
        tab14_etm
    case 15
        tab15_etn
    case 16
        tab16_eta 
    case 17
        tab17_fat 
end
if exist('tab_fig','var')
    opened_uifig(ktab)=tab_fig;
end