YCMD:dm(playerid, params[], help)
{
	if(pdm[playerid][pdm_id]!=-1)return SendClientMessage(playerid,COLOR_WARNING,"����������DM������");
	ShowAllDMMap(playerid,1);
	return 1;
}
YCMD:dmclose(playerid, params[], help)
{
	DestroyDmRoom(pdm[playerid][pdm_id]);
	return 1;
}
YCMD:dminfo(playerid, params[], help)
{
    if(pdm[playerid][pdm_id]==-1)return SendClientMessage(playerid,COLOR_WARNING,"�㲻��DM������");
    new string[80];
	format(string,sizeof(string),"%s DM����",dm[pdm[playerid][pdm_id]][dm_name]);
	Dialog_Show(playerid,dl_dm_room_info,DIALOG_STYLE_MSGBOX,string,ShowDMRecordStr(pdm[playerid][pdm_id]),"�˳�����","�رմ���");
	return 1;
}
YCMD:dmroom(playerid, params[], help)
{
    if(pdm[playerid][pdm_id]!=-1)return SendClientMessage(playerid,COLOR_WARNING,"����������DM������");
	ShowAllDMroom(playerid,1);
	return 1;
}
YCMD:dmscore(playerid, params[], help)
{
	Dialog_Show(playerid,dl_dm_room_sort,DIALOG_STYLE_MSGBOX,"��������",ShowDMRoomSortStr(pdm[playerid][pdm_id]),"OK","");
	return 1;
}

