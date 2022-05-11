function yen = yen_LEO_test(varin,s_c)
variable = varin;
[var_l,var_w] = size(variable);

y_count = s_c;

% Add path
addpath('E:\NgocTa_K57\HFSS\API\3dmodeler');
addpath('E:\NgocTa_K57\HFSS\API\analysis');
addpath('E:\NgocTa_K57\HFSS\API\general');
addpath('E:\NgocTa_K57\HFSS\API\radiation');
addpath('E:\NgocTa_K57\HFSS\API\reporter');
addpath('E:\NgocTa_K57\HFSS\API\boundary');

for i = 1:var_l
%    HFSS Executable Path
hfssExePath = 'C:\"Program Files"\Ansoft\HFSS14.0\Win64\hfss.exe';

% Temporary File
tmpPrjFile = [pwd,'\LEO.hfss'];
tmpDataFile = [pwd,'\data_LEO.m']; 
tmpScriptFile = [pwd,'\LEO.vbs'];

%% Parameters

% Frequency 
c = 3e8;
f_leo = 0.15e9;
f_gps = 1.5e9;
lamda_leo = 1000*c/f_leo;
lamda_gps = 1000*c/f_gps;
sub_z = 3.2;

%%      LEO Parameter
% Rt
Rt_wide = 3;
Rt_cx = 0;
Rt_cy = 0;
Rt_r = variable(i,1);
% cRt
cRt_cx = Rt_cx;
cRt_cy = Rt_cy;
cRt_r = Rt_r - Rt_wide;
% Lt1
Lt1_x = 60;
Lt1_y = 20;
Lt1_cx = cRt_r;
Lt1_cy = -Lt1_y/2;
% Ltbu
Ltbu_cx = Rt_cx;
Ltbu_cy = Lt1_cy;
Ltbu_x = cRt_r;
Ltbu_y = Lt1_y;
% T
T_cx = Rt_cx;
T_cy = Rt_cy;
T_r = Lt1_y/2;
% ctop
ctop_cx = Lt1_cy + Lt1_y;
ctop_cy = ctop_cx;
ctop_x = Rt_r - Lt1_y/2;
ctop_y = ctop_x;

% Meander line
meander_wide = 1;
meander_space = variable(i,3);
meander_high = variable(i,2);
% m1
m1_cx = Lt1_cx + Lt1_x; 
m1_cy = Lt1_cy + Lt1_y;
m1_x = meander_wide;
m1_y = -(meander_high + Lt1_y)/2;
% m2
m2_x = meander_wide;
m2_y = meander_high;
m2_cx = m1_cx + m1_x + meander_space;
m2_cy = -m2_y/2;
% m3
m3_cx = m1_cx + 4*meander_wide + 4*meander_space;
m3_cy = Lt1_cy;
m3_x = meander_wide;
m3_y = -m1_y;
% mt
mt_cx = m2_cx + m2_x;
mt_cy = m2_cy + m2_y;
mt_x = meander_space;
mt_y = meander_wide;
% md
md_cx = m1_cx + m1_x;
md_cy = m1_cy + m1_y;
md_x = meander_space;
md_y = meander_wide;

% Arrow
arrow_wide = 16;
% rect1
rect1_x = 150;
rect1_y = rect1_x;
rect1_cx = 0;
rect1_cy = -rect1_y;
% crect1
crect1_x = rect1_x - arrow_wide;
crect1_y = rect1_y - arrow_wide;
crect1_cx = 0;
crect1_cy = -crect1_y;
% rect2
rect2_x = variable(i,4);
rect2_y = 2*rect2_x;
rect2_cx = Rt_cx;
rect2_cy = -rect2_y/2;
% cma
cma_x = sqrt(2)*crect1_x - (m3_cx + m3_x) + 1;
cma_y = Lt1_y;
cma_cx = m3_cx + m3_x;
cma_cy = -cma_y/2;

%%      Patch Circle
% patch
patch_cx = 0;
patch_cy = 0;
patch_r = variable(i,5);
patch_wide = 10;
% Rc
Rc_cx = patch_cx;
Rc_cy = patch_cy;
Rc_r = patch_r - patch_wide;
% feed
feed_x = 2.5;
feed_y = Rc_r;
feed_cx = -feed_x/2;
feed_cy = patch_cy;
% F
F_cx = patch_cx;
F_cy = patch_cy;
F_r = feed_x/2;
% a1
a1_x = 1.6;
a1_y = variable(i,6);
a1_cx = -a1_x/2;
a1_cy = patch_r - a1_y;
% a2
a2_x = 2;
a2_y = variable(i,7);
a2_cx = -a2_x/2;
a2_cy = patch_r - a2_y;
% polyline
pd = 3;
pn = 3;
% p1
p1_cx = feed_cx + feed_x;
p1_cy = Rc_r - pd;
% p2
p2_cx = p1_cx;
p2_cy = Rc_r;
% p3
p3_cx = p2_cx + pn;
p3_cy = p2_cy;

p(1,:) = [p1_cx, p1_cy, sub_z];
p(2,:) = [p2_cx, p2_cy, sub_z];
p(3,:) = [p3_cx, p3_cy, sub_z];
p(4,:) = [p1_cx, p1_cy, sub_z];

% Ground Patch
gnd_cx = patch_cx;
gnd_cy = patch_cy;
gnd_r = 30;
move = variable(i,8);

% Ground Square
gnds_x = 50;
gnds_y = 50;
gnds_cx = -gnds_x/2;
gnds_cy = -gnds_y/2;

%% Coaxial Cable 50 ohm
coaxial_inner = 0.7;
coaxial_dielectric = 1.6;
coaxial_outer = 2;
coaxial_ho = 5;
    % Dipole
codi_cx = Rt_cx;
codi_cy = Rt_cy;
codi_cz = -coaxial_ho; 
codi_h = sub_z + coaxial_ho;

% patch
copa_cx = move;
copa_cy = move;
copa_cz = -coaxial_ho;
copa_h = sub_z + coaxial_ho;

%% Substrate
sub_x = 2*rect1_x;
sub_y = sub_x;
sub_cx = -sub_x/2;
sub_cy = -sub_y/2;

% Airbox LEO
airleo_x = sub_x + lamda_leo/2;
airleo_y = sub_y + lamda_leo/2;
airleo_z = sub_z + lamda_leo/2;
airleo_cx = -airleo_x/2;
airleo_cy = -airleo_y/2;
airleo_cz = -airleo_z/2;

% Airbox GPS
airgps_x = sub_x + lamda_gps/2;
airgps_y = sub_y + lamda_gps/2;
airgps_z = sub_z + lamda_gps/2;
airgps_cx = -airgps_x/2;
airgps_cy = -airgps_y/2;
airgps_cz = -airgps_z/2;


%%          Design Begin

fid = fopen(tmpScriptFile,'wt');

% Create new HFSS project
hfssNewProject(fid);
hfssInsertDesign(fid,'LEO_yen');

%% Create 

% Substrate
hfssBox(fid,'substrate',[sub_cx,sub_cy,0],[sub_x,sub_y,sub_z],'mm');
hfssAssignMaterial(fid,'substrate','FR4_epoxy');
hfssSetTransparency(fid,{'substrate'},0.8);
hfssRotate(fid, {'substrate'}, 'Z', 45);
hfssCylinder(fid, 'csub_di', 'Z', [Rt_cx,Rt_cy,0], coaxial_inner, sub_z, 'mm');
hfssCylinder(fid, 'csub_pa', 'Z', [move,move,0], coaxial_inner, sub_z, 'mm');
hfssSubtract(fid, {'substrate'}, {'csub_di','csub_pa'});

% Ring
hfssCircle(fid,'Rt','Z',[Rt_cx,Rt_cy,sub_z],Rt_r,'mm');
hfssCircle(fid,'cRt','Z',[cRt_cx,cRt_cy,sub_z],cRt_r,'mm');
hfssRectangle(fid,'ctop','Z',[ctop_cx,ctop_cy,sub_z],ctop_x,ctop_y,'mm');
hfssSubtract(fid, {'Rt'}, {'cRt','ctop'});
% Lt
hfssRectangle(fid,'Lt1','Z',[Lt1_cx,Lt1_cy,sub_z],Lt1_x,Lt1_y,'mm');
hfssRectangle(fid,'Ltbu','Z',[Ltbu_cx,Ltbu_cy,sub_z],Ltbu_x,Ltbu_y,'mm');
hfssCircle(fid,'T','Z',[T_cx,T_cy,sub_z],T_r,'mm');
% Meander Line
hfssRectangle(fid,'m1','Z',[m1_cx,m1_cy,sub_z],m1_x,m1_y,'mm');
hfssRectangle(fid,'m2','Z',[m2_cx,m2_cy,sub_z],m2_x,m2_y,'mm');
hfssDuplicateAlongLine(fid,{'m2'},[meander_space + meander_wide,0,0],3,'mm');
hfssRectangle(fid,'m3','Z',[m3_cx,m3_cy,sub_z],m3_x,m3_y,'mm');
hfssRectangle(fid,'mt','Z',[mt_cx,mt_cy,sub_z],mt_x,-mt_y,'mm');
hfssDuplicateAlongLine(fid,{'mt'},[2*meander_space + 2*meander_wide,0,0],2,'mm');
hfssRectangle(fid,'md','Z',[md_cx,md_cy,sub_z],md_x,md_y,'mm');
hfssDuplicateAlongLine(fid,{'md'},[2*meander_space + 2*meander_wide,0,0],2,'mm');

hfssUnite(fid,{'m1','m2','m3','mt','md'});
% Arrow
hfssRectangle(fid,'rect1','Z',[rect1_cx,rect1_cy,sub_z],rect1_x,rect1_y,'mm');
hfssRectangle(fid,'crect1','Z',[crect1_cx,crect1_cy,sub_z],crect1_x,crect1_y,'mm');
hfssSubtract(fid, {'rect1'}, {'crect1'});
hfssRotate(fid, {'rect1'}, 'Z', 45);
hfssRectangle(fid,'rect2','Z',[rect2_cx,rect2_cy,sub_z],rect2_x,rect2_y,'mm');
hfssSubtract(fid, {'rect1'}, {'rect2'});
% cma
hfssRectangle(fid,'cma','Z',[cma_cx,cma_cy,sub_z],cma_x,cma_y,'mm');
% Unite
hfssUnite(fid,{'Lt1','m1','cma','rect1'});
hfssDuplicateRotate(fid,'Lt1','Z',90,2);
hfssUnite(fid,{'T','Ltbu','Lt1','Rt'});


%% Bottom
hfssDuplicateMirror(fid,{'T'},[0,0,sub_z/2],[0,0,-1],'mm');
hfssRename(fid,'T_1','B');
hfssRotate(fid, {'B'}, 'Z', 180);
hfssCircle(fid,'cB','Z',[Rt_cx,Rt_cy,0],coaxial_dielectric,'mm');
hfssSubtract(fid, {'B'}, {'cB'});

hfssAssignPE(fid,'Top',{'T'});
hfssAssignPE(fid,'Bottom',{'B'});



% Coaxial Cable for Dipole
hfssCylinder(fid, 'Inner_Di', 'Z', [codi_cx,codi_cy,codi_cz], coaxial_inner, codi_h, 'mm');
hfssCylinder(fid, 'Dielectric_Di', 'Z', [codi_cx,codi_cy,codi_cz], coaxial_dielectric, coaxial_ho, 'mm');
hfssCylinder(fid, 'Outer_Di', 'Z', [codi_cx,codi_cy,codi_cz], coaxial_outer, coaxial_ho, 'mm');
hfssCylinder(fid, 'cOuter_Di', 'Z', [codi_cx,codi_cy,codi_cz], coaxial_dielectric, coaxial_ho, 'mm');
hfssCylinder(fid, 'cDielectric_Di', 'Z', [codi_cx,codi_cy,codi_cz], coaxial_inner, coaxial_ho, 'mm');
hfssSubtract(fid, {'Outer_Di'}, {'cOuter_Di'});
hfssSubtract(fid, {'Dielectric_Di'}, {'cDielectric_Di'});
hfssAssignMaterial(fid,'Inner_Di','copper');
hfssAssignMaterial(fid,'Outer_Di','copper');


%% Patch Ring
hfssCircle(fid,'Patch','Z',[patch_cx,patch_cy,sub_z],patch_r,'mm');
hfssCircle(fid,'Rc','Z',[Rc_cx,Rc_cy,sub_z],Rc_r,'mm');
hfssCircle(fid,'F','Z',[F_cx,F_cy,sub_z],F_r,'mm');
hfssRectangle(fid,'feed','Z',[feed_cx,feed_cy,sub_z],feed_x,feed_y,'mm');
hfssPolyline(fid, 'p', [p], 'mm');
hfssDuplicateMirror(fid,{'p'},[0,0,0],[-1,0,0],'mm');
hfssRectangle(fid,'a1','Z',[a1_cx,a1_cy,sub_z],a1_x,a1_y,'mm');
hfssDuplicateMirror(fid,{'a1'},[0,0,0],[0,-1,0],'mm');
hfssUnite(fid,{'a1','a1_1'});
hfssRotate(fid, {'a1'}, 'Z', 45);
hfssRectangle(fid,'a2','Z',[a2_cx,a2_cy,sub_z],a2_x,a2_y,'mm');
hfssDuplicateMirror(fid,{'a2'},[0,0,0],[0,-1,0],'mm');
hfssUnite(fid,{'a2','a2_1'});
hfssRotate(fid, {'a2'}, 'Z', -45);

hfssSubtract(fid, {'Patch'}, {'Rc','a1','a2'});
hfssUnite(fid,{'Patch','F','feed','p','p_1'});
hfssRectangle(fid,'Ground','Z',[gnds_cx,gnds_cy,0],gnds_x,gnds_y,'mm');
hfssCircle(fid,'cGround','Z',[gnd_cx,gnd_cy,0],coaxial_dielectric,'mm');
hfssSubtract(fid, {'Ground'}, {'cGround'});
hfssMove(fid, {'Patch', 'Ground'}, [move, move, 0], 'mm');

hfssAssignPE(fid,'Patch',{'Patch'});
hfssAssignPE(fid,'Ground',{'Ground'});

hfssDuplicateRotate(fid,'Patch','Z',90,4);
hfssDuplicateRotate(fid,'Ground','Z',90,4);

% Coaxial Cable for Patch
hfssCylinder(fid, 'Inner_Pa', 'Z', [move,move,copa_cz], coaxial_inner, codi_h, 'mm');
hfssCylinder(fid, 'Dielectric_Pa', 'Z', [move,move,copa_cz], coaxial_dielectric, coaxial_ho, 'mm');
hfssCylinder(fid, 'Outer_Pa', 'Z', [move,move,copa_cz], coaxial_outer, coaxial_ho, 'mm');
hfssCylinder(fid, 'cOuter_Pa', 'Z', [move,move,copa_cz], coaxial_dielectric, coaxial_ho, 'mm');
hfssCylinder(fid, 'cDielectric_Pa', 'Z', [move,move,copa_cz], coaxial_inner, coaxial_ho, 'mm');
hfssSubtract(fid, {'Outer_Pa'}, {'cOuter_Pa'});
hfssSubtract(fid, {'Dielectric_Pa'}, {'cDielectric_Pa'});
hfssAssignMaterial(fid,'Inner_Pa','copper');
hfssAssignMaterial(fid,'Outer_Pa','copper');


% Port
% LEO
hfssCircle(fid,'port_di','Z',[codi_cx,codi_cy,codi_cz],coaxial_dielectric,'mm');
hfssAssignLumpedPort(fid,'port_di','port_di',[coaxial_dielectric,0,codi_cz],[coaxial_inner,0,codi_cz],'mm');
% GPS
hfssCircle(fid,'port_pa','Z',[move,move,copa_cz],coaxial_dielectric,'mm');
hfssAssignLumpedPort(fid,'port_pa','port_pa',[move + coaxial_dielectric,move,copa_cz],[move + coaxial_inner,move,copa_cz],'mm');


%%          Insert Solution and Sweep LEO

% Airbox LEO
hfssBox(fid,'airleo_box',[airleo_cx,airleo_cy,airleo_cz],[airleo_x,airleo_y,airleo_z],'mm');
hfssRotate(fid, {'airleo_box'}, 'Z', 45);
hfssAssignRadiation(fid,'Rad_yen','airleo_box');
% Insert Farfield
hfssInsertFarFieldSphereSetup(fid,'sphere_yen',[0 360 10],[0 360 10]);

hfssInsertSolution(fid,'Setup_LEO',f_leo/1e9,[],10);
hfssFastSweep(fid,'SweepYen_LEO','Setup_LEO',0.1,0.2,101);
hfssSaveProject(fid, tmpPrjFile, true);
hfssSolveSetup(fid,'Setup_LEO');

% Create report LEO
hfssCreateReport(fid,'report_LEO', 1, 1,'Setup_LEO','SweepYen_LEO',...
                    [],'SweepYen_LEO',{'Freq'},...
                    {'Freq','dB(S(port_di,port_di))'});
Report_Axialratio_LEO;
                
% Export LEO
hfssExportToFile(fid, 'report_LEO', 'data_LEO','tab');
hfssExportToFile(fid, 'Axial_Ratio_LEO', 'data_Axialratio_LEO','tab');

%%              Insert Solution and Sweep GPS
% Delete airbox leo
hfssDeleteElement(fid, {'airleo_box'})
% Airbox GPS
hfssBox(fid,'airgps_box',[airgps_cx,airgps_cy,airgps_cz],[airgps_x,airgps_y,airgps_z],'mm');
hfssRotate(fid, {'airgps_box'}, 'Z', 45);
hfssAssignRadiation(fid,'Rad_yen','airgps_box');
% Insert Farfield
hfssInsertFarFieldSphereSetup(fid,'sphere_yen',[0 360 10],[0 360 10]);

hfssInsertSolution(fid,'Setup_GPS',f_gps/1e9,[],10);
hfssFastSweep(fid,'SweepYen_GPS','Setup_GPS',1.5,1.6,101);
hfssSaveProject(fid, tmpPrjFile, true);
hfssSolveSetup(fid,'Setup_GPS');

% Create report GPS
hfssCreateReport(fid,'report_GPS', 1, 1,'Setup_GPS','SweepYen_GPS',...
                    [],'SweepYen_GPS',{'Freq'},...
                    {'Freq','dB(S(port_pa,port_pa))'});
Report_Axialratio_GPS;                
% Export GPS
hfssExportToFile(fid, 'Axial_Ratio_GPS', 'data_Axialratio_GPS','tab');






%%              Run
fclose(fid);
hfssExecuteScript(hfssExePath, tmpScriptFile,false,false);


% evaluate
yen_data_LEO = import_file('data_LEO.tab');
yen_data_GPS = import_file('data_GPS.tab');

yen(i) = cost_LEO_GPS(yen_data_LEO,yen_data_GPS);

if yen(i) < -23
    filename = ['dulieu_', num2str(y_count)];
    xlswrite(['E:\NgocTa_K57\HFSS\API\examples\LEO\rundulieu\',filename],yen_data_LEO);
    xlswrite(['E:\NgocTa_K57\HFSS\API\examples\LEO\rundulieu\',filename],yen_data_GPS,1,'D1');
    xlswrite(['E:\NgocTa_K57\HFSS\API\examples\LEO\rundulieu\',filename],variable(i,:),1,'G1');
    y_count = y_count + 1;
end


end

%% remove path
%  remove path existed
rmpath('E:\NgocTa_K57\HFSS\API\3dmodeler');
rmpath('E:\NgocTa_K57\HFSS\API\analysis');
rmpath('E:\NgocTa_K57\HFSS\API\general');
rmpath('E:\NgocTa_K57\HFSS\API\radiation');
rmpath('E:\NgocTa_K57\HFSS\API\reporter');
rmpath('E:\NgocTa_K57\HFSS\API\boundary');

end


