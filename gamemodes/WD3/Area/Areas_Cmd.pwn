YCMD:myarea(playerid, params[], help)
{
    ShowMyArea(playerid,1);
	return 1;
}
YCMD:addarea(playerid, params[], help)
{
	new named[80];
	if(sscanf(params, "s[80]",named))return SendClientMessage(playerid,COLOR_WARNING,"/addarea Ãû³Æ");
	new Float:x1x,Float:y1y,Float:z1z;
	GetPlayerPos(playerid,x1x,y1y,z1z);
	AddPlayerArea(playerid,named,x1x-10,y1y-10,z1z-10,x1x+10,y1y+10,z1z+40);
	return 1;
}
