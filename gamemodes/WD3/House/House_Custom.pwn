enum houseinfo
{
	Text3D:h_i3d,
	Text3D:h_o3d,
	h_opic,
	h_ipic,
	h_map,
	h_oarea,
	h_iarea,
	Float:h_ox,
	Float:h_oy,
	Float:h_oz,
	Float:h_oa,
	Float:h_ix,
	Float:h_iy,
	Float:h_iz,
	Float:h_ia,
	h_oin,
	h_iin,
	h_owl,
	h_iwl,
	h_uid,
	h_sellmoney,
	h_hid,
	h_name[80],
	h_lock,
	h_pass[129],
	h_music[256],
	h_decid,
}
new house[MAX_HOUSES][houseinfo];
new Iterator:house<MAX_HOUSES>;
new bool:pEnter[MAX_PLAYERS];

enum hobjinfo
{
	ho_type,
	ho_id,
	ho_model,
	ho_area,
	ho_speed,
	Float:ho_dis,
	Float:ho_x,
	Float:ho_y,
	Float:ho_z,
	Float:ho_rx,
	Float:ho_ry,
	Float:ho_rz,
	Float:ho_mx,
	Float:ho_my,
	Float:ho_mz,
	Float:ho_mrx,
	Float:ho_mry,
	Float:ho_mrz
}
new hobj[MAX_HOUSES][MAX_HOUSES_OBJ][hobjinfo];
new Iterator:hobj[MAX_HOUSES]<MAX_HOUSES_OBJ>;
new Float:hobjdoor[MAX_HOUSES][4];
