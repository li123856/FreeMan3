enum attinfo
{
    aused,
    amodelid,
    abone,
	Float:afOffsetX,
	Float:afOffsetY,
	Float:afOffsetZ,
	Float:afRotX,
	Float:afRotY,
	Float:afRotZ,
	Float:afScaleX,
	Float:afScaleY,
	Float:afScaleZ,
	amaterialcolor1,
	amaterialcolor2,
    aname[80],
}
new att[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS-1][attinfo];
new Iterator:att[MAX_PLAYERS]<MAX_PLAYER_ATTACHED_OBJECTS-1>;

