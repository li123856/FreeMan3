YCMD:savepos(playerid, params[], help)
{
	new cmds[80],named[80];
	if(sscanf(params, "s[80]s[80]",cmds,named))return SendClientMessage(playerid,COLOR_WARNING,"/savepos ָ�� ����");
    if(strlen(cmds)<1||strlen(cmds)>50)return SendClientMessage(playerid,COLOR_WARNING,"/savepos ָ�� ����");
    if(strlen(named)<1||strlen(named)>50)return SendClientMessage(playerid,COLOR_WARNING,"/savepos ָ�� ����");
    if(GetSameTeles(cmds))return SendClientMessage(playerid,COLOR_WARNING,"���д˴���ָ��,�뻻һ��");
	AddTele(playerid,cmds,named);
	return 1;
}
YCMD:myteles(playerid, params[], help)
{
	ShowMyTele(playerid,1);
	return 1;
}
YCMD:teles(playerid, params[], help)
{
	ShowGlobalTeleMenu(playerid,1);
	return 1;
}

