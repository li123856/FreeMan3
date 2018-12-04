YCMD:gs(playerid, params[], help)
{
	if(pdate[playerid][gid]==-1)return Dialog_Show(playerid,dl_player_gang_none,DIALOG_STYLE_MSGBOX,"公司","你还没有自己的公司或加入别人的公司,请选择一下内容","创建公司","寻找公司");
	else SetPPos(playerid,gang[pdate[playerid][gid]][g_zb_x],gang[pdate[playerid][gid]][g_zb_y],gang[pdate[playerid][gid]][g_zb_z],90,gang[pdate[playerid][gid]][g_zb_in],gang[pdate[playerid][gid]][g_zb_wl],1.5,0);
	return 1;
}

