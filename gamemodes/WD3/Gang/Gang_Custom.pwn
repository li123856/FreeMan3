enum ganginfo
{
	Text3D:g_3d,
	g_area,
	bool:g_open,
	g_pic,
	g_map,
	g_id,
	g_cash,
	g_uid,
	g_color,
	g_level,
	g_score,
	g_name[80],
	g_pic_model,
	g_map_model,
	Float:g_zb_x,
	Float:g_zb_y,
	Float:g_zb_z,
	g_zb_in,
	g_zb_wl,
	Float:g_areadis,
	g_areaenter,
	g_areagun,
	g_areacar,
	g_areafurn,
	g_maxplayer,
	g_createdate[80],
	g_opendate[64],
	g_music[256]
}
new gang[MAX_GANGS][ganginfo];
new Iterator:gang<MAX_GANGS>;
new glevelname[MAX_GANGS][MAX_GANGS_LEVEL][80];
new glevelcolour[MAX_GANGS][MAX_GANGS_LEVEL];
new PGA[MAX_PLAYERS];
