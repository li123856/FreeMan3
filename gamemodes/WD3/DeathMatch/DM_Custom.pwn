enum dminfo
{
	dm_uid,
	dm_name[80],
	dm_map,
	dm_stats,
	dm_min,
	dm_now,
	dm_wl,
}
new dm[MAX_DM_ROOM][dminfo];
new Iterator:dm<MAX_DM_ROOM>;

enum dmrinfo
{
	dmr_id
}
new dmroomobj[MAX_DM_ROOM][MAX_DM_MAP_OBJ][dmrinfo];
new Iterator:dmroomobj[MAX_DM_ROOM]<MAX_DM_MAP_OBJ>;

enum teaminfo
{
	dmt_skin,
	dmt_score,
	dmt_kill,
	dmt_death,
	dmt_color
}
new dmteam[MAX_DM_ROOM][MAX_DM_ROOM_TEAM][teaminfo];
new Iterator:dmteam[MAX_DM_ROOM]<MAX_DM_ROOM_TEAM>;

enum dmweaponinfo
{
	dmw_weapon,
	dmw_ammo
}
new dmweapon[MAX_DM_ROOM][MAX_DM_ROOM_WEAPON][dmweaponinfo];

enum dmpinfo
{
	dmp_id,
	dmp_uid,
	dmp_rate,
	dmp_name[80],
	dmp_file[80],
	dmp_in
}
new dmp[MAX_DM_MAP][dmpinfo];
new Iterator:dmp<MAX_DM_MAP>;

enum dmobjinfo
{
	dmo_model,
	Float:dmo_x,
	Float:dmo_y,
	Float:dmo_z,
	Float:dmo_rx,
	Float:dmo_ry,
	Float:dmo_rz
}
new dmpobj[MAX_DM_MAP][MAX_DM_MAP_OBJ][dmobjinfo];
new Iterator:dmpobj[MAX_DM_MAP]<MAX_DM_MAP_OBJ>;

enum dmpspawninfo
{
	Float:dms_x,
	Float:dms_y,
	Float:dms_z,
	Float:dms_a,
}
new dmpspawn[MAX_DM_MAP][MAX_DM_ROOM_TEAM][dmpspawninfo];
new Iterator:dmpspawn[MAX_DM_MAP]<MAX_DM_ROOM_TEAM>;

enum pdminfo
{
	pdm_id,
	pdm_team,
	pdm_kill,
	pdm_death,
	pdm_score
}
new pdm[MAX_PLAYERS][pdminfo];


