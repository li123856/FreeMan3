enum furninfo
{
	f_objid,
	Text3D:f_text,
    f_uid,
	f_id,
	f_model,
	Float:f_x,
	Float:f_y,
	Float:f_z,
	Float:f_rx,
	Float:f_ry,
	Float:f_rz,
	f_in,
	f_wl,
	f_name[80],
	f_Key[129],
	f_move,
	Float:f_movex,
	Float:f_movey,
	Float:f_movez,
	Float:f_moverx,
	Float:f_movery,
	Float:f_moverz,
	f_sellmoney,
	f_txd,
	f_color
}
new Furn[MAX_FURN][furninfo];
new Iterator:Furn<MAX_FURN>;
new PlayerFurn[MAX_PLAYERS];


