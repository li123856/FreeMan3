enum racemapinfo
{	
	Text3D:r_3d,
	r_cp,
	r_id,
	r_uid,
	r_name[80],
	r_createtime[80],
	r_in,
	r_wl,
	Float:r_x,
	Float:r_y,
	Float:r_z,
	Float:r_a,
	r_stat,
	r_rate,
}
new racemap[MAX_RACE_MAPS][racemapinfo];
new Iterator:racemap<MAX_RACE_MAPS>;

enum racechackinfo
{
	Float:rc_x,
	Float:rc_y,
	Float:rc_z,
	Float:rc_size
}
new racechack[MAX_RACE_MAPS][MAX_RACE_CHACKS][racechackinfo];
new Iterator:racechack[MAX_RACE_MAPS]<MAX_RACE_CHACKS>;

enum racerankinfo
{
	rr_uid,
	rr_veh,
	rr_time,
	rr_createtime[80]
}
new racerank[MAX_RACE_MAPS][MAX_RACE_RANKS][racerankinfo];


enum rroominfo
{
	ro_uid,
	ro_map,
	ro_stat,
	ro_rank,
	ro_count,
	Timer:ro_ctime
}
new raceroom[MAX_RACE_ROOM][rroominfo];
new Iterator:raceroom<MAX_RACE_ROOM>;

enum raceinfo
{
	race_room,
	race_cp,
	race_map,
	race_cp_index,
	race_stime,
	race_ftime,
	race_time
}
new prace[MAX_PLAYERS][raceinfo];
new Racemapindex[MAX_PLAYERS];
new Racemapid[MAX_PLAYERS];
