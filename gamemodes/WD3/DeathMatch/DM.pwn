#include WD3/DeathMatch/DM_Define.pwn
#include WD3/DeathMatch/DM_Custom.pwn
#include WD3/DeathMatch/DM_Object.pwn
#include WD3/DeathMatch/DM_Cmd.pwn
public OnGameModeInit()
{
    Iter_Init(dmteam);
    Iter_Init(dmpobj);
    Iter_Init(dmpspawn);
    Iter_Init(dmroomobj);
    LoadDMMAP();
	return CallLocalFunction("DM_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit DM_OnGameModeInit
forward DM_OnGameModeInit();

public OnPlayerConnect(playerid)
{
	pdm[playerid][pdm_id]=-1;
	pdm[playerid][pdm_team]=-1;
	pdm[playerid][pdm_kill]=0;
	pdm[playerid][pdm_death]=0;
	pdm[playerid][pdm_score]=0;
	return CallLocalFunction("DM_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect DM_OnPlayerConnect
forward DM_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	pdm[playerid][pdm_id]=-1;
	pdm[playerid][pdm_team]=-1;
	pdm[playerid][pdm_kill]=0;
	pdm[playerid][pdm_death]=0;
	pdm[playerid][pdm_score]=0;
	return CallLocalFunction("DM_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect DM_OnPlayerDisconnect
forward DM_OnPlayerDisconnect(playerid,reason);


public OnPlayerSpawn(playerid)
{
	if(pdm[playerid][pdm_id]!=-1)
	{
 		ResetPlayerWeapons(playerid);
		for(new s=0;s<MAX_DM_ROOM_WEAPON;s++)
		{
		 	if(dmweapon[pdm[playerid][pdm_id]][s][dmw_weapon]!=0)
			{
		 		dmweapon[pdm[playerid][pdm_id]][s][dmw_ammo]=999999;
				GivePlayerWeapon(playerid,WEAPON[dmweapon[pdm[playerid][pdm_id]][s][dmw_weapon]][W_WID],dmweapon[pdm[playerid][pdm_id]][s][dmw_ammo]);
			}
		}
	}
    return CallLocalFunction("DM_OnPlayerSpawn", "i",playerid);
}
#if defined _ALS_OnPlayerSpawn
   #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn DM_OnPlayerSpawn
forward DM_OnPlayerSpawn(playerid);

ACT::LoadDMMAP()
{
    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_DMMP"`");
    mysql_tquery(mysqlid, Querys, "OnDMMAPLoad");
	return 1;
}
ACT::OnDMMAPLoad()
{
	new rows=cache_get_row_count(mysqlid);
	for(new i=0;i<rows;i++)
	{
		if(i<MAX_DM_MAP)
		{
		    dmp[i][dmp_id]=cache_get_field_content_int(i,"dmp_id");
		    dmp[i][dmp_in]=cache_get_field_content_int(i,"dmp_in");
		    dmp[i][dmp_uid]=cache_get_field_content_int(i,"dmp_uid");
		    dmp[i][dmp_rate]=cache_get_field_content_int(i,"dmp_rate");
		    cache_get_field_content(i,"dmp_name",dmp[i][dmp_name],mysqlid,80);
		    cache_get_field_content(i,"dmp_file",dmp[i][dmp_file],mysqlid,80);
		    Iter_Add(dmp,i);
		}
		else printf("DM��ͼ��ȡ�ﵽ���� %i",MAX_DM_MAP);
	}
	foreach(new c:dmp)
	{
		switch(LoadDMTemplate(c,dmp[c][dmp_file]))
		{
			case 0:printf("��DM��ͼ %s.pwn ģ���ļ�",dmp[c][dmp_file]);
			case 1:printf("����DM��ͼ, %s.pwn �ɹ�",dmp[c][dmp_file]);
			case 2:printf("����DM��ͼ, %s.pwn δ���ֳ�����λ����",dmp[c][dmp_file]);
		}
	}
    return 1;
}
ACT::GetWeaponSlot(index)
{
	for(new i=0;i<sizeof(WEAPON);i++)
	{
	    if(WEAPON[i][W_WID]==index)return WEAPON[i][W_SLOT];
	}
	return -1;
}
ACT::GetDMRoomPlayerAmouts(index)
{
	new count=0;
	foreach(new i:Player)
    {
        if(pdm[i][pdm_id]==index)count++;
    }
    return count;
}
ACT::GetDMRoomTeamPlayerAmouts(index,teamd)
{
	new count=0;
	foreach(new i:Player)
    {
        if(pdm[i][pdm_id]==index)
		{
		    if(pdm[i][pdm_team]==teamd)count++;
		}
    }
    return count;
}
ACT::SelectDMTeam(index)
{
	if(GetDMRoomTeamPlayerAmouts(index,0)>GetDMRoomTeamPlayerAmouts(index,1))return 1;
	if(GetDMRoomTeamPlayerAmouts(index,0)<GetDMRoomTeamPlayerAmouts(index,1))return 0;
	else return random(2);
}
ACT::LeaveDMRoom(playerid)
{
	new index=pdm[playerid][pdm_id];
	Dialog_Show(playerid,dl_dm_room_sort,DIALOG_STYLE_MSGBOX,"��������",ShowDMRoomSortStr(index),"OK","");
	pdm[playerid][pdm_id]=-1;
	pdm[playerid][pdm_team]=-1;
	pdm[playerid][pdm_kill]=0;
	pdm[playerid][pdm_death]=0;
	pdm[playerid][pdm_score]=0;
	ResetPlayerWeapons(playerid);
	SetPlayerSkin(playerid,pdate[playerid][skinid]);
	SetPlayerColor(playerid,colors[pdate[playerid][colorid]]);
	SpawningPlayer(playerid);
	new string[128];
	if(GetDMRoomPlayerAmouts(index)<2)return DestroyDmRoom(index);
	if(dm[index][dm_uid]==pdate[playerid][uid])
	{
 		foreach(new i:Player)
		{
	        if(pdm[i][pdm_id]==index)
	        {
	            dm[index][dm_uid]=pdate[i][uid];
  				format(string,sizeof(string),"���ڷ����뿪,�������Ϊ%s",GetUidName(dm[index][dm_uid]));
				SendDMRoomMsg(index,string);
	            break;
	        }
		}
	}
	return 1;
}
ACT::SendDMRoomMsg(index,strys[])
{
	new string[256];
	format(string,sizeof(string),"[DM]%s",strys);
    foreach(new i:Player)
    {
        if(pdm[i][pdm_id]==index)SendClientMessage(i,-1,string);
    }
	return 1;
}
ACT::JoinDMRoom(playerid,index)
{
	new string[128];
	switch(dm[index][dm_stats])
	{
	    case DM_ROOM_WAIT:
	    {
			pdm[playerid][pdm_id]=index;
			pdm[playerid][pdm_team]=SelectDMTeam(index);
			pdm[playerid][pdm_kill]=0;
			pdm[playerid][pdm_death]=0;
			pdm[playerid][pdm_score]=0;
			format(string,sizeof(string),"%s �����μ���[DM]%s ����%i",Pname[playerid],dm[index][dm_name],pdm[playerid][pdm_team]+1);
			SendDMRoomMsg(index,string);
	    }
	    case DM_ROOM_START:
	    {
			pdm[playerid][pdm_id]=index;
			pdm[playerid][pdm_team]=SelectDMTeam(index);
			SetPlayerSkin(playerid,dmteam[index][pdm[playerid][pdm_team]][dmt_skin]);
			SetPlayerColor(playerid,dmteam[index][pdm[playerid][pdm_team]][dmt_color]);
			pdm[playerid][pdm_kill]=0;
			pdm[playerid][pdm_death]=0;
			pdm[playerid][pdm_score]=0;
			new mapid=dm[index][dm_map];
			SetPPos(playerid,dmpspawn[mapid][pdm[playerid][pdm_team]][dms_x],dmpspawn[mapid][pdm[playerid][pdm_team]][dms_y],dmpspawn[mapid][pdm[playerid][pdm_team]][dms_z],dmpspawn[mapid][pdm[playerid][pdm_team]][dms_a],dmp[mapid][dmp_in],dm[index][dm_wl],1.5,3);
			format(string,sizeof(string),"%s ������[DM]%s ����%i",Pname[playerid],dm[index][dm_name],pdm[playerid][pdm_team]+1);
			SendDMRoomMsg(index,string);
	    }
	    case DM_ROOM_FINISH:
	    {
	    }
	}
	return 1;
}
ACT::AddDMRoom(playerid,mapid,named[])
{
	new i=Iter_Free(dm);
    if(i==-1)return 0;
    dm[i][dm_uid]=pdate[playerid][uid];
    dm[i][dm_map]=mapid;
    dm[i][dm_min]=10;
    dm[i][dm_now]=0;
    dm[i][dm_stats]=DM_ROOM_WAIT;
    dm[i][dm_wl]=MAX_DM_LIMTS+i;
    format(dm[i][dm_name],80,named);
    Iter_Add(dm,i);
    Iter_Clear(dmteam[i]);
    dmteam[i][0][dmt_kill]=0;
    dmteam[i][0][dmt_score]=0;
    dmteam[i][0][dmt_death]=0;
    dmteam[i][0][dmt_color]=random(sizeof(colors));
    dmteam[i][1][dmt_kill]=0;
    dmteam[i][1][dmt_score]=0;
    dmteam[i][1][dmt_death]=0;
    dmteam[i][1][dmt_color]=random(sizeof(colors));
	Iter_Add(dmteam[i],0);
	Iter_Add(dmteam[i],1);
	Iter_Clear(dmroomobj[i]);
	for(new s=0;s<MAX_DM_ROOM_WEAPON;s++)
	{
	    dmweapon[i][s][dmw_weapon]=0;
	    dmweapon[i][s][dmw_ammo]=0;
	}
	new string[128];
	format(string,sizeof(string),"%s ������[DM]%s",Pname[playerid],dm[i][dm_name]);
	SendClientMessageToAll(-1,string);
    return i;
}
ACT::StartDmRoom(index)
{
    dm[index][dm_stats]=DM_ROOM_START;
    dm[index][dm_now]=0;
    new mapid=dm[index][dm_map];
    CreateDMTemplate(index);
	foreach(new i:Player)
    {
        if(pdm[i][pdm_id]==index)
        {
			pdm[i][pdm_team]=SelectDMTeam(index);
			SetPlayerTeam(i,pdm[i][pdm_team]);
			SetPlayerSkin(i,dmteam[index][pdm[i][pdm_team]][dmt_skin]);
			SetPlayerColor(i,dmteam[index][pdm[i][pdm_team]][dmt_color]);
			pdm[i][pdm_kill]=0;
			pdm[i][pdm_death]=0;
			pdm[i][pdm_score]=0;
  			SetPPos(i,dmpspawn[mapid][pdm[i][pdm_team]][dms_x],dmpspawn[mapid][pdm[i][pdm_team]][dms_y],dmpspawn[mapid][pdm[i][pdm_team]][dms_z],dmpspawn[mapid][pdm[i][pdm_team]][dms_a],dmp[mapid][dmp_in],dm[index][dm_wl],1.5,3);
            ResetPlayerWeapons(i);
			for(new s=0;s<MAX_DM_ROOM_WEAPON;s++)
			{
			    if(dmweapon[index][s][dmw_weapon]!=0)
				{
				    dmweapon[index][s][dmw_ammo]=999999;
					GivePlayerWeapon(i,WEAPON[dmweapon[index][s][dmw_weapon]][W_WID],dmweapon[index][s][dmw_ammo]);
				}
			}
        }
	}
	new string[128];
	format(string,sizeof(string),"���� %s ������[DM]%s ����",GetUidName(dm[index][dm_uid]),dm[index][dm_name]);
	SendDMRoomMsg(index,string);
    return 1;
}
ACT::DestroyDmRoom(index)
{
	dm[index][dm_stats]=DM_ROOM_FINISH;
    new string[128];
	format(string,sizeof(string),"[DM]%s ����ر���",dm[index][dm_name]);
	SendDMRoomMsg(index,string);
	foreach(new i:Player)
    {
        if(pdm[i][pdm_id]==index)
        {
			pdm[i][pdm_id]=-1;
			pdm[i][pdm_team]=-1;
			pdm[i][pdm_kill]=0;
			pdm[i][pdm_death]=0;
			pdm[i][pdm_score]=0;
			ResetPlayerWeapons(i);
			SetPlayerSkin(i,pdate[i][skinid]);
			SetPlayerColor(i,colors[pdate[i][colorid]]);
			SpawningPlayer(i);
        }
	}
    DestroyDMTemplate(index);
    Iter_Clear(dmteam[index]);
    Iter_Clear(dmroomobj[index]);
    Iter_Remove(dm,index);
	for(new s=0;s<MAX_DM_ROOM_WEAPON;s++)
	{
	    dmweapon[index][s][dmw_weapon]=0;
	    dmweapon[index][s][dmw_ammo]=0;
	}
    return 1;
}
ACT::OnDmRoomUpdate()
{
  	foreach(new i:dm)
	{
	    if(Iter_Contains(dm,i))
	    {
		    if(dm[i][dm_stats]==DM_ROOM_START)
		    {
	  			dm[i][dm_now]++;
	  			if(dm[i][dm_now]>=dm[i][dm_min])DestroyDmRoom(i);
		    }
	    }
	}
    return 1;
}
ACT::OnDmRoomAntiChack()
{
  	foreach(new i:dm)
	{
	    if(dm[i][dm_stats]==DM_ROOM_START)
	    {
			foreach(new s:Player)
		    {
		        if(pdm[s][pdm_id]==i)
		        {
                    new weapons,amouts;
					for(new c=0;c<=12;c++)
					{
					    weapons=0;
					    GetPlayerWeaponData(s,c,weapons,amouts);
					    printf("%i,%i,%i",c,weapons,WEAPON[dmweapon[i][c][dmw_weapon]][W_WID]);
					    if(weapons!=WEAPON[dmweapon[i][c][dmw_weapon]][W_WID]&&weapons!=0)
						{
				            ResetPlayerWeapons(s);
							for(new f=0;f<MAX_DM_ROOM_WEAPON;f++)
							{
							    if(dmweapon[i][f][dmw_weapon]!=0)
								{
								    dmweapon[i][f][dmw_ammo]=999999;
									GivePlayerWeapon(s,WEAPON[dmweapon[i][f][dmw_weapon]][W_WID],dmweapon[i][f][dmw_ammo]);
								}
							}
							SendClientMessage(s,COLOR_WARNING,"�������� ,�ѳ�ʼ������");
						}
					}
		        }
		    }
	    }
	}
    return 1;
}
ShowDMRecordStr(index)
{
	new string[2048],str[100];
	format(str, sizeof(str),"[DM]%s ������:%i ʣ��ʱ��:%i����\t\t\n",dm[index][dm_name],GetDMRoomPlayerAmouts(index),dm[index][dm_min]-dm[index][dm_now]);
	strcat(string,str);
	strcat(string,"------------------------------------------------\n");
	format(str, sizeof(str),"\t����1:%i�� �Ŷӻ���:%i\n",GetDMRoomTeamPlayerAmouts(index,0),dmteam[index][0][dmt_score]);
	strcat(string,str);
	foreach(new i:Player)
    {
        if(pdm[i][pdm_id]==index)
		{
		    if(pdm[i][pdm_team]==0)
		    {
		    	format(str, sizeof(str),"��� %s\t��ɱ:%i\t����:%i\t����:%i\n",Pname[i],pdm[i][pdm_kill],pdm[i][pdm_death],pdm[i][pdm_score]);
				strcat(string,str);
		    }
		}
	}
	strcat(string,"*************************************************\n");
	format(str, sizeof(str),"\t����2:%i�� �Ŷӻ���:%i\n",GetDMRoomTeamPlayerAmouts(index,1),dmteam[index][1][dmt_score]);
	strcat(string,str);
	foreach(new i:Player)
    {
        if(pdm[i][pdm_id]==index)
		{
		    if(pdm[i][pdm_team]==1)
		    {
		    	format(str, sizeof(str),"��� %s\t��ɱ:%i\t����:%i\t����:%i\n",Pname[i],pdm[i][pdm_kill],pdm[i][pdm_death],pdm[i][pdm_score]);
				strcat(string,str);
		    }
		}
	}
	strcat(string,"------------------------------------------------\n");
	return string;
}
/*****************************************************************************************/
ACT::ShowAllDMroom(playerid,pages)
{
	if(!Iter_Count(dm))return SendClientMessage(playerid,COLOR_WARNING,"û��DM����");
    current_number[playerid]=1;
  	foreach(new i:dm)
	{
        current_idx[playerid][current_number[playerid]]=i;
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"û����һҳ");
	}
	else page[playerid]=pages;
	if(pages>floatround(Iter_Count(dm)/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"û�и�ҳ");
		page[playerid]=1;
	}
	new string[60];
	format(string,sizeof(string),"DM�����ܼ�¼-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_alldmroom,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_AllDmroom_RetrunStr(playerid,page[playerid]), "����", "����");
	return 1;
}
Dialog_AllDmroom_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "����\t����\t��ͼ��\t����\n");
	strcat(string,caption);
	strcat(string,"{FF8000}��һҳ\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[100],tmps[32];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"%s\t",dm[current_idx[playerid][i]][dm_name]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%s\t",GetUidName(dm[current_idx[playerid][i]][dm_uid]));
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%s\t",dmp[dm[current_idx[playerid][i]][dm_map]][dmp_name]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%i/%i\t",GetDMRoomPlayerAmouts(current_idx[playerid][i]),MAX_DM_ROOM_PLAYERS);
            strcat(tmp,tmps);
            
            /*switch(dm[current_idx[playerid][i]][dm_stats])
            {
                case DM_ROOM_WAIT:format(tmps,sizeof(tmps),"�Ⱥ���\n");
                case DM_ROOM_START:format(tmps,sizeof(tmps),"��Ϸ��\n");
                case DM_ROOM_FINISH:format(tmps,sizeof(tmps),"����\n");
            }
            strcat(tmp,tmps);*/
		}
	    if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
	    else strcat(string,tmp);
	}
	if(!isover)strcat(string, "{FF8000}��һҳ\n");
    return string;
}
Dialog:dl_alldmroom(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowAllDMroom(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowAllDMroom(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			if(GetDMRoomPlayerAmouts(listid)>=MAX_DM_ROOM_PLAYERS)return SendClientMessage(playerid,COLOR_WARNING,"����Ϸ������Ա����");
			switch(dm[listid][dm_stats])
            {
                case DM_ROOM_WAIT:JoinDMRoom(playerid,listid);
                case DM_ROOM_START:JoinDMRoom(playerid,listid);
                case DM_ROOM_FINISH:SendClientMessage(playerid,COLOR_WARNING,"����Ϸ�����ѽ���");
            }
		}
	}
	else
	{

	}
	return 1;
}
/*****************************************************************************************/
ACT::GetDMMapId(rsid)
{
  	foreach(new i:dmp)
	{
	    if(dmp[i][dmp_id]==rsid)return i;
	}
	return -1;
}
ACT::ShowAllDMMap(playerid,pages)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_DMMP"` ORDER BY dmp_rate DESC");
    mysql_tquery(mysqlid, Querys, "OnAllDMMap", "ii",playerid,pages);
	return 1;
}
ACT::OnAllDMMap(playerid,pages)
{
	new rows=cache_get_row_count(mysqlid);
	if(!rows)return SendClientMessage(playerid,COLOR_WARNING,"û��DM��ͼ");
    current_number[playerid]=1;
  	for(new i=0;i<rows;i++)
	{
        current_idx[playerid][current_number[playerid]]=cache_get_field_content_int(i, "dmp_id");
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"û����һҳ");
	}
	else page[playerid]=pages;
	if(pages>floatround(rows/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"û�и�ҳ");
		page[playerid]=1;
	}

    new string[2048],caption[64];
    new pager = (page[playerid]-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	new index;
	format(caption,sizeof(caption), "����\tʹ��Ƶ��\t�ṩ��\n");
	strcat(string,caption);
	strcat(string,"{FF8000}��һҳ\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST;i++)
	{
	    new tmp[128],tmps[60];
		if(i<current_number[playerid])
		{
		    index=GetDMMapId(current_idx[playerid][i]);
		    if(index==-1)return 0;
            format(tmps,sizeof(tmps),"%s\t",dmp[index][dmp_name]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%i\t",dmp[index][dmp_rate]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%s\n",GetUidName(dmp[index][dmp_uid]));
            strcat(tmp,tmps);
		}
	    if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
	    else strcat(string,tmp);
	}
	if(!isover)strcat(string, "{FF8000}��һҳ\n");

	new str[128];
	format(str,sizeof(str),"DM��ͼ�б�-����[%i]",rows);
	Dialog_Show(playerid,dl_all_dmmap_show,DIALOG_STYLE_TABLIST_HEADERS,str,string, "ʹ��", "����");
	return 1;
}

Dialog:dl_all_dmmap_show(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowAllDMMap(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowAllDMMap(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
		    new index=GetDMMapId(listid);
		    if(index==-1)return 0;
			Dialog_Show(playerid,dl_dmroom_create,DIALOG_STYLE_INPUT,"����DM����","�����뷿������","ȷ��","����");
            SetPVarInt(playerid,"DMMap_Current_ID",index);
		}
	}
	else
	{

	}
	return 1;
}
Dialog:dl_dmroom_create(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strlen(inputtext)<4||strlen(inputtext)>40)return Dialog_Show(playerid,dl_dmroom_create,DIALOG_STYLE_INPUT,"����DM����","�����뷿������","ȷ��","����");
		new index=GetPVarInt(playerid,"DMMap_Current_ID");
        JoinDMRoom(playerid,AddDMRoom(playerid,index,inputtext));
        Dialog_Show(playerid,dl_dmroom_show,DIALOG_STYLE_TABLIST,"DM����",ShowDMRoomWaitStr(playerid,pdm[playerid][pdm_id]), "ȷ��", "����");
 	}
	return 1;
}
Dialog:dl_dmroom_show(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    switch(listitem)
	    {
	        case 0:Dialog_Show(playerid,dl_dmroom_show,DIALOG_STYLE_TABLIST,"DM����",ShowDMRoomWaitStr(playerid,pdm[playerid][pdm_id]), "ȷ��", "����");
	        case 1:Dialog_Show(playerid,dl_dmroom_show,DIALOG_STYLE_TABLIST,"DM����",ShowDMRoomWaitStr(playerid,pdm[playerid][pdm_id]), "ȷ��", "����");
	        case 2:Dialog_Show(playerid,dl_dmroom_show,DIALOG_STYLE_TABLIST,"DM����",ShowDMRoomWaitStr(playerid,pdm[playerid][pdm_id]), "ȷ��", "����");
	        case 3:Dialog_Show(playerid,dl_dmroom_show,DIALOG_STYLE_TABLIST,"DM����",ShowDMRoomWaitStr(playerid,pdm[playerid][pdm_id]), "ȷ��", "����");
	        case 4:Dialog_Show(playerid,dl_dmroom_weapon,DIALOG_STYLE_TABLIST,"��������",ShowDMRoomWeaponStr(pdm[playerid][pdm_id]), "ȷ��", "����");
	        case 5:Dialog_Show(playerid,dl_dmroom_skin,DIALOG_STYLE_TABLIST,"Ƥ������",ShowDMRoomSkinStr(pdm[playerid][pdm_id]), "ȷ��", "����");
	        case 6:
	        {
	            /*if(GetDMRoomPlayerAmouts(pdm[playerid][pdm_id])<2)
	            {
	                SendClientMessage(playerid,COLOR_WARNING,"�÷����������2��,�޷�����");
	                Dialog_Show(playerid,dl_dmroom_show,DIALOG_STYLE_TABLIST,"DM����",ShowDMRoomWaitStr(playerid,pdm[playerid][pdm_id]), "ȷ��", "����");
	            }
	            else */StartDmRoom(pdm[playerid][pdm_id]);
	        }
	        case 7:DestroyDmRoom(pdm[playerid][pdm_id]);
	    }
	}
	else Dialog_Show(playerid,dl_dmroom_show,DIALOG_STYLE_TABLIST,"DM����",ShowDMRoomWaitStr(playerid,pdm[playerid][pdm_id]), "ȷ��", "����");
	return 1;
}
Dialog:dl_dmroom_skin(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    SetPVarInt(playerid,"skin_slot_select",listitem);
		ShowModelSelectionMenuEx(playerid,skinlist,sizeof(skinlist), "Select Skin",CUSTOM_DM_SKIN_MENU, 16.0, 0.0, -55.0);
	}
	else Dialog_Show(playerid,dl_dmroom_show,DIALOG_STYLE_TABLIST,"DM����",ShowDMRoomWaitStr(playerid,pdm[playerid][pdm_id]), "ȷ��", "����");
	return 1;
}
Dialog:dl_dmroom_weapon(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		SetPVarInt(playerid,"weapon_slot_select",listitem);
		Dialog_Show(playerid,dl_dmroom_select,DIALOG_STYLE_TABLIST,"ѡ������",WeaponSlotShow(playerid,listitem), "ȷ��", "����");
	}
	else Dialog_Show(playerid,dl_dmroom_show,DIALOG_STYLE_TABLIST,"DM����",ShowDMRoomWaitStr(playerid,pdm[playerid][pdm_id]), "ȷ��", "����");
	return 1;
}
Dialog:dl_dmroom_select(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new vart[64];
	    format(vart, sizeof(vart),"weapon_slot_%i",listitem);
	    dmweapon[pdm[playerid][pdm_id]][GetPVarInt(playerid,"weapon_slot_select")][dmw_weapon]=GetPVarInt(playerid,vart);
	    Dialog_Show(playerid,dl_dmroom_weapon,DIALOG_STYLE_TABLIST,"��������",ShowDMRoomWeaponStr(pdm[playerid][pdm_id]), "ȷ��", "����");
	}
	else Dialog_Show(playerid,dl_dmroom_weapon,DIALOG_STYLE_TABLIST,"��������",ShowDMRoomWeaponStr(pdm[playerid][pdm_id]), "ȷ��", "����");
	return 1;
}
ShowDMRoomSkinStr(index)
{
	new string[2048],str[100];
    format(str, sizeof(str),"����1\t%i\n",dmteam[index][0][dmt_skin]);
	strcat(string,str);
    format(str, sizeof(str),"����2\t%i\n",dmteam[index][1][dmt_skin]);
	strcat(string,str);
	return string;
}
ShowDMRoomWeaponStr(index)
{
	new string[2048],str[100];
	for(new s=0;s<MAX_DM_ROOM_WEAPON;s++)
	{
	    format(str, sizeof(str),"������\t%s\n",WEAPON[dmweapon[index][s][dmw_weapon]][W_NAME]);
		strcat(string,str);
	}
	return string;
}
WeaponSlotShow(playerid,slots)
{
	new string[2048],str[100],count=0,vart[64];
	for(new s=0;s<sizeof(WEAPON);s++)
	{
	    if(WEAPON[s][W_SLOT]==slots)
	    {
			format(str, sizeof(str),"%s\n",WEAPON[s][W_NAME]);
			strcat(string,str);
			format(vart, sizeof(vart),"weapon_slot_%i",count);
			SetPVarInt(playerid,vart,s);
			count++;
	    }
	}
	return string;
}
ShowDMRoomWaitStr(playerid,index)
{
	new string[2048],str[100];
	format(str, sizeof(str),"��������\t%s\n",dm[index][dm_name]);
	strcat(string,str);
	format(str, sizeof(str),"����\t%s\n",GetUidName(dm[index][dm_uid]));
	strcat(string,str);
	format(str, sizeof(str),"��ͼ����\t%s\n",dmp[dm[index][dm_map]][dmp_name]);
	strcat(string,str);
	format(str, sizeof(str),"����ʱ��\t%i����\n",dm[index][dm_min]);
	strcat(string,str);
	format(str, sizeof(str),"��������\t\n");
	strcat(string,str);
	format(str, sizeof(str),"Ƥ������\t\n");
	strcat(string,str);
	if(dm[index][dm_uid]==pdate[playerid][uid])
	{
		format(str, sizeof(str),"��������\t\n");
		strcat(string,str);
	}
	if(dm[index][dm_uid]==pdate[playerid][uid])
	{
		format(str, sizeof(str),"�رշ���\t\n");
		strcat(string,str);
	}
	return string;
}
Dialog:dl_dm_room_info(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(pdm[playerid][pdm_id]==-1)return SendClientMessage(playerid,COLOR_WARNING,"�㲻��DM������");
		LeaveDMRoom(playerid);
	}
	return 1;
}
ShowDMRoomSortStr(index)
{
	new string[2048],str[100];
	new	Player_ID[MAX_DM_ROOM_PLAYERS],Top_Info[MAX_DM_ROOM_PLAYERS],counts=0;
	for(new i;i<MAX_DM_ROOM_PLAYERS;i++)Top_Info[i]=-1;
	foreach(new i:Player)
    {
        if(pdm[i][pdm_id]==index)
        {
        	Sorting(i,pdm[i][pdm_score],Player_ID,Top_Info,MAX_DM_ROOM_PLAYERS);
        	counts++;
        }
    }
	if(counts>0)
	{
		for(new i;i<MAX_DM_ROOM_PLAYERS;i++)
		{
			if(Top_Info[i]!=-1) continue;
			format(str,sizeof(str),"����:%i  ����:%s  ����:%i\n ����%i",i+1,Pname[Player_ID[i]],pdm[Player_ID[i]][pdm_score],pdm[Player_ID[i]][pdm_team]+1);
			strcat(string,str);
		}
	}
	return string;
}
