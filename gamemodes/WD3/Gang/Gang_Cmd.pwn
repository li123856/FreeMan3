YCMD:gs(playerid, params[], help)
{
	if(pdate[playerid][gid]==-1)return Dialog_Show(playerid,dl_player_gang_none,DIALOG_STYLE_MSGBOX,"��˾","�㻹û���Լ��Ĺ�˾�������˵Ĺ�˾,��ѡ��һ������","������˾","Ѱ�ҹ�˾");
	else SetPPos(playerid,gang[pdate[playerid][gid]][g_zb_x],gang[pdate[playerid][gid]][g_zb_y],gang[pdate[playerid][gid]][g_zb_z],90,gang[pdate[playerid][gid]][g_zb_in],gang[pdate[playerid][gid]][g_zb_wl],1.5,0);
	return 1;
}

