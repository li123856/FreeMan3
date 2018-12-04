YCMD:stats(playerid, params[], help)
{
    ShowPlayerStats(playerid);
	return 1;
}
YCMD:skin(playerid, params[], help)
{
	new skinidx;
	if(sscanf(params, "i",skinidx))return ShowModelSelectionMenuEx(playerid,skinlist,sizeof(skinlist), "Select SKIN",CUSTOM_SKIN_MENU, 16.0, 0.0, -55.0);
    if(IsValidSkin(skinidx))return SendClientMessage(playerid,COLOR_WARNING,"皮肤ID无效");
	SetSkin(playerid,skinidx);
	return 1;
}
YCMD:kill(playerid, params[], help)
{
	SetPlayerHealth(playerid,0.0);
	return 1;
}
YCMD:gopos(playerid, params[], help)
{
	new Float:xyz[3];
	if(sscanf(params, "p<,>fff",xyz[0],xyz[1],xyz[2]))return SendClientMessage(playerid,COLOR_WARNING,"用法:/gopos ");
	SetPPos(playerid,xyz[0],xyz[1],xyz[2],0,0,0,0.5,1);
	return 1;
}


