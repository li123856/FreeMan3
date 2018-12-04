YCMD:dm(playerid, params[], help)
{
	if(pdm[playerid][pdm_id]!=-1)return SendClientMessage(playerid,COLOR_WARNING,"你正在其它DM房间中");
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
    if(pdm[playerid][pdm_id]==-1)return SendClientMessage(playerid,COLOR_WARNING,"你不在DM房间中");
    new string[80];
	format(string,sizeof(string),"%s DM房间",dm[pdm[playerid][pdm_id]][dm_name]);
	Dialog_Show(playerid,dl_dm_room_info,DIALOG_STYLE_MSGBOX,string,ShowDMRecordStr(pdm[playerid][pdm_id]),"退出房间","关闭窗口");
	return 1;
}
YCMD:dmroom(playerid, params[], help)
{
    if(pdm[playerid][pdm_id]!=-1)return SendClientMessage(playerid,COLOR_WARNING,"你正在其它DM房间中");
	ShowAllDMroom(playerid,1);
	return 1;
}
YCMD:dmscore(playerid, params[], help)
{
	Dialog_Show(playerid,dl_dm_room_sort,DIALOG_STYLE_MSGBOX,"积分排行",ShowDMRoomSortStr(pdm[playerid][pdm_id]),"OK","");
	return 1;
}

