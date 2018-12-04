enum areainfo
{	
	a_id,
	a_area,
	a_zone,
	a_uid,
	a_color,
	a_name[80],
	a_music[129],
	a_createtime[80],
	a_des[128],
	Float:a_minx,
	Float:a_miny,
	Float:a_minz,
	Float:a_maxx,
	Float:a_maxy,
	Float:a_maxz,
	a_in,
	a_wl,
	a_furn,
	a_car,
	a_comein
}
new arear[MAX_GLOBAL_AREAS][areainfo];
new Iterator:arear<MAX_GLOBAL_AREAS>;

enum eainfo
{
	area_id,
	Float:area_minx,
	Float:area_miny,
	Float:area_minz,
	Float:area_maxx,
	Float:area_maxy,
	Float:area_maxz,
	Timer:area_timer
}
new editarea[MAX_PLAYERS][eainfo];
new AAA[MAX_PLAYERS];
