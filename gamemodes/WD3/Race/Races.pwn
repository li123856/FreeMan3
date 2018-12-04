#include WD3/Race/Races_Define.pwn
#include WD3/Race/Races_Custom.pwn
public OnGameModeInit()
{
	Iter_Init(racechack);
	LoadRaceMap();
	return CallLocalFunction("Race_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Race_OnGameModeInit
forward Race_OnGameModeInit();

public OnPlayerConnect(playerid)
{
	Racemapid[playerid]=-1;
	Racemapindex[playerid]=0;
	prace[playerid][race_room]=-1;
	prace[playerid][race_cp_index]=0;
	prace[playerid][race_stime]=0;
	prace[playerid][race_ftime]=0;
	prace[playerid][race_time]=-1;
	return CallLocalFunction("Race_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Race_OnPlayerConnect
forward Race_OnPlayerConnect(playerid);


public OnPlayerDisconnect(playerid, reason)
{
    RaceRoomQuit(playerid);
	Racemapid[playerid]=-1;
	Racemapindex[playerid]=0;
	prace[playerid][race_room]=-1;
	prace[playerid][race_cp_index]=0;
	prace[playerid][race_stime]=0;
	prace[playerid][race_ftime]=0;
	prace[playerid][race_time]=-1;
	return CallLocalFunction("Race_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Race_OnPlayerDisconnect
forward Race_OnPlayerDisconnect(playerid,reason);

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{

	return CallLocalFunction("Race_OnPlayerKeyStateChange","iii",playerid, newkeys, oldkeys);
}
#if defined _ALS_OnPlayerKeyStateChange
   #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange Race_OnPlayerKeyStateChange
forward Race_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);

ACT::LoadRaceMap()
{
    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_RACE"`");
    mysql_tquery(mysqlid, Querys, "OnRaceMapLoad");
	return 1;
}
ACT::OnRaceMapLoad()
{
	new rows=cache_get_row_count(mysqlid),string[64],str[256],iuse;
	for(new i=0;i<rows;i++)
	{
		if(i<MAX_RACE_MAPS)
		{
		    racemap[i][r_id]=cache_get_field_content_int(i,"r_id");
		    racemap[i][r_uid]=cache_get_field_content_int(i,"r_uid");
		    racemap[i][r_stat]=cache_get_field_content_int(i,"r_stat");
		    racemap[i][r_rate]=cache_get_field_content_int(i,"r_rate");
		    racemap[i][r_in]=cache_get_field_content_int(i,"r_in");
		    racemap[i][r_wl]=cache_get_field_content_int(i,"r_wl");
		    racemap[i][r_x]=cache_get_field_content_float(i,"r_x");
		    racemap[i][r_y]=cache_get_field_content_float(i,"r_y");
		    racemap[i][r_z]=cache_get_field_content_float(i,"r_z");
		    racemap[i][r_a]=cache_get_field_content_float(i,"r_a");
		    cache_get_field_content(i,"r_name",racemap[i][r_name],mysqlid,80);
		    cache_get_field_content(i,"r_createtime",racemap[i][r_createtime],mysqlid,80);
		    for(new s=0;s<MAX_RACE_CHACKS;s++)
			{
			    format(string, sizeof(string),"racechack_%i",s);
			    cache_get_field_content(i,string,str,mysqlid,128);
			    sscanf(str, "p<&>iffff",iuse,racechack[i][s][rc_x],racechack[i][s][rc_y],racechack[i][s][rc_z],racechack[i][s][rc_size]);
	    		if(iuse!=-1)Iter_Add(racechack[i],s);
			}
		    for(new r=0;r<MAX_RACE_RANKS;r++)
			{
			    format(string, sizeof(string),"racerank_%i",r);
			    cache_get_field_content(i,string,str,mysqlid,256);
			    sscanf(str, "p<&>iiis[80]",racerank[i][r][rr_time],racerank[i][r][rr_uid],racerank[i][r][rr_veh],racerank[i][r][rr_createtime]);
			}
		    Iter_Add(racemap,i);
		}
		else printf("赛车比赛地图读取达到上限 %i",MAX_RACE_MAPS);
	}
	foreach(new c:racemap)CreateRaceMapFace(c);
    return 1;
}
ACT::RankPK(playerid,index,wctime)
{
	new ttime,id=-1;
	for(new i=0;i<MAX_RACE_RANKS;i++)
	{
		if(racerank[index][i][rr_time]==-1)ttime=999999999;
		else ttime=racerank[index][i][rr_time];
		if(wctime<ttime)
 		{
 			id=i;
 			i=MAX_RACE_RANKS+1;
 		}
	}
	if(id==-1) return id;
	for(new i=MAX_RACE_RANKS-1;i>id;i--)
	{
	    racerank[index][i][rr_time]=racerank[index][i-1][rr_time];
		racerank[index][i][rr_uid]=racerank[index][i-1][rr_uid];
		racerank[index][i][rr_veh]=racerank[index][i-1][rr_veh];
		format(racerank[index][i][rr_createtime],80,"%s",racerank[index][i-1][rr_createtime]);
	}
	racerank[index][id][rr_time]=wctime;
	racerank[index][id][rr_uid]=pdate[playerid][uid];
	racerank[index][id][rr_veh]=GetVehicleModel(GetPlayerVehicleID(playerid));
	new time[3], date[3];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(racerank[index][id][rr_createtime],80,"%d年%d月%日%d时%d分%d秒",date[0],date[1],date[2], time[0], time[1], time[2]);
	new str[256],string[64];
	for(new c=0;c<MAX_RACE_RANKS;c++)
	{
	    if(racerank[index][c][rr_time]!=-1)
	    {
	        format(string,sizeof(string),"racerank_%i",c);
	        format(str,sizeof(str),"%i&%i&%i&%s",racerank[index][c][rr_time],racerank[index][c][rr_uid],racerank[index][c][rr_veh],racerank[index][c][rr_createtime]);
			format(Querys, sizeof(Querys),"UPDATE `"SQL_RACE"` SET  `%s` =  '%s' WHERE  `"SQL_RACE"`.`r_id` ='%i'",string,str,racemap[index][r_id]);
			mysql_query(mysqlid,Querys,false);
	    }
	    else
	    {
	        format(string,sizeof(string),"racerank_%i",c);
			format(Querys, sizeof(Querys),"UPDATE `"SQL_RACE"` SET  `%s` =  '-1&-1&-1&NULL' WHERE  `"SQL_RACE"`.`r_id` ='%i'",string,racemap[index][r_id]);
			mysql_query(mysqlid,Querys,false);
	    }
	}
	UpdateRaceMap3D(index);
	return id;
}
ACT::CreateRaceMapFace(index)
{
	racemap[index][r_3d]=CreateDynamic3DTextLabel(ShowRaceMapInfo(index),-1,racemap[index][r_x],racemap[index][r_y],racemap[index][r_z],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,racemap[index][r_wl],racemap[index][r_in]);
	racemap[index][r_cp]=CreateDynamicCP(racemap[index][r_x],racemap[index][r_y],racemap[index][r_z],8.0,racemap[index][r_wl],racemap[index][r_in]);
	return 1;
}
ACT::UpdateRaceMap3D(index)return UpdateDynamic3DTextLabelText(racemap[index][r_3d],-1,ShowRaceMapInfo(index));
ShowRaceMapInfo(index)
{
	new string[2048],str[128];
	format(str, sizeof(str),"%s\n",racemap[index][r_name]);
	strcat(string,str);
	switch(racemap[index][r_stat])
	{
	    case RACE_MAP_MAKE:format(str, sizeof(str),"状态:建设中\n");
	    case RACE_MAP_FINISH:format(str, sizeof(str),"状态:已完成\n");
	    case RACE_MAP_EDIT:format(str, sizeof(str),"状态:编辑中\n");
	}
	strcat(string,str);
	format(str, sizeof(str),"创建者:%s\n",GetUidName(racemap[index][r_uid]));
	strcat(string,str);
	format(str, sizeof(str),"创建于:%s\n",racemap[index][r_createtime]);
	strcat(string,str);
	new	Hour,Min,Sec,MS,stru[80];
	for(new c=0;c<MAX_RACE_RANKS;c++)
	{
	    if(racerank[index][c][rr_time]!=-1)
	    {
	        ConvertTime(racerank[index][c][rr_time],Hour,Min,Sec,MS);
	        format(stru, sizeof(stru),"%i时%i分%i秒%i毫秒",Hour,Min,Sec,MS);
	        format(str, sizeof(str),"No.%i %s %s %s %s\n",c+1,stru,GetUidName(racerank[index][c][rr_uid]),VehName[racerank[index][c][rr_veh]-400],racerank[index][c][rr_createtime]);
	        strcat(string,str);
	    }
	}
	return string;
}
ACT::AddRaceMap(playerid,named[])
{
	new i=Iter_Free(racemap);
    if(i==-1)return -1;
	GetPlayerPos(playerid,racemap[i][r_x],racemap[i][r_y],racemap[i][r_z]);
	GetPlayerFacingAngle(playerid,racemap[i][r_a]);
	racemap[i][r_in]=GetPlayerInterior(playerid);
	racemap[i][r_wl]=GetPlayerVirtualWorld(playerid);
	format(racemap[i][r_name],80,named);
	racemap[i][r_uid]=pdate[playerid][uid];
	racemap[i][r_stat]=RACE_MAP_MAKE;
	new time[3], date[3];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(racemap[i][r_createtime],80,"%d年%d月%日%d时%d分",date[0],date[1],date[2], time[0], time[1]);
	format(Querys, sizeof(Querys),"INSERT INTO `"SQL_RACE"`(`r_uid`,`r_name`,`r_createtime`,`r_in`,`r_wl`,`r_x`,`r_y`,`r_z`,`r_a`)VALUES ('%i','%s','%s','%i','%i','%0.3f','%0.3f','%0.3f','%0.3f')"\
	,racemap[i][r_uid],racemap[i][r_name],racemap[i][r_createtime],racemap[i][r_in],racemap[i][r_wl],racemap[i][r_x],racemap[i][r_y],racemap[i][r_z],racemap[i][r_a]);
	mysql_query(mysqlid,Querys);
	racemap[i][r_id]=cache_insert_id();
	Iter_Clear(racechack[i]);
	for(new c=0;c<MAX_RACE_RANKS;c++)racerank[i][c][rr_time]=-1;
	Iter_Add(racemap,i);
	CreateRaceMapFace(i);
	return i;
}
ACT::RemoveRaceMap(index)
{
	format(Querys,sizeof(Querys),"DELETE FROM `"SQL_RACE"` WHERE `r_id` = '%i'",racemap[index][r_id]);
	mysql_query(mysqlid,Querys,false);
	DestroyDynamic3DTextLabel(racemap[index][r_3d]);
	DestroyDynamicCP(racemap[index][r_cp]);
	Iter_Clear(racechack[index]);
	Iter_Remove(racemap,index);
	return 1;
}
ACT::AddRaceChackPoint(playerid,raceid,index,Float:size)
{
	GetPlayerPos(playerid,racechack[raceid][index][rc_x],racechack[raceid][index][rc_y],racechack[raceid][index][rc_z]);
    racechack[raceid][index][rc_size]=size;
	new string[80],str[128];
	format(string, sizeof(string),"racechack_%i",index);
	format(str, sizeof(str),"%i&%0.3f&%0.3f&%0.3f&%0.3f",1,racechack[raceid][index][rc_x],racechack[raceid][index][rc_y],racechack[raceid][index][rc_z],size);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_RACE"` SET  `%s` =  '%s' WHERE  `"SQL_RACE"`.`r_id` ='%i'",string,str,racemap[raceid][r_id]);
	mysql_query(mysqlid,Querys,false);
	Iter_Add(racechack[raceid],index);
	return 1;
}
ACT::RemoveRaceChackPoint(raceid,index)
{
	new string[80],str[128];
	format(string, sizeof(string),"racechack_%i",index);
	format(str, sizeof(str),"-1&0&0&0&0");
	format(Querys, sizeof(Querys),"UPDATE `"SQL_RACE"` SET  `%s` =  '%s' WHERE  `"SQL_RACE"`.`r_id` ='%i'",string,str,racemap[raceid][r_id]);
	mysql_query(mysqlid,Querys,false);
    Iter_Remove(racechack[raceid],index);
	return 1;
}
ACT::UpdateRaceFinish(index,finishd)
{
	racemap[index][r_stat]=finishd;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_RACE"` SET  `r_stat`='%i' WHERE  `"SQL_RACE"`.`r_id` ='%i'",racemap[index][r_stat],racemap[index][r_id]);
	mysql_query(mysqlid,Querys,false);
	UpdateRaceMap3D(index);
    return 1;
}
ACT::UpdateRaceRate(index,rated)
{
	racemap[index][r_rate]+=rated;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_RACE"` SET  `r_rate`='%i' WHERE  `"SQL_RACE"`.`r_id` ='%i'",racemap[index][r_rate],racemap[index][r_id]);
	mysql_query(mysqlid,Querys,false);
	UpdateRaceMap3D(index);
    return 1;
}
ACT::UpdateRaceName(index,named[])
{
	format(racemap[index][r_name],80,named);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_RACE"` SET  `r_name`='%s' WHERE  `"SQL_RACE"`.`r_id` ='%i'",racemap[index][r_name],racemap[index][r_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::AddRaceRoom(playerid,racemapid)
{
	new i=Iter_Free(raceroom);
	if(i==-1)return -1;
    raceroom[i][ro_map]=racemapid;
    raceroom[i][ro_stat]=RACE_ROOM_WAIT;
    raceroom[i][ro_rank]=1;
    raceroom[i][ro_uid]=pdate[playerid][uid];
    raceroom[i][ro_count]=5;
    Iter_Add(raceroom,i);
    JoinRaceRoom(playerid,i);
    return i;
}
ACT::JoinRaceRoom(playerid,roomid)
{
	prace[playerid][race_room]=roomid;
	prace[playerid][race_cp_index]=0;
	prace[playerid][race_stime]=0;
	prace[playerid][race_ftime]=0;
	prace[playerid][race_time]=-1;
    return 1;
}
ACT::StartRaceRoom(roomid)
{
	raceroom[roomid][ro_ctime]=repeat RaceCountDown[1000](roomid);
	foreach(new i:Player)
	{
       	if(prace[i][race_room]==roomid)
        {
        	SetCameraBehindPlayer(i);
			TogglePlayerControllable(i,0);
			GameTextForPlayer(i,"RACE COUTDOWN!!!",850,6);
		}
	}
    return 1;
}
timer RaceCountDown[1000](roomid)
{
	if(raceroom[roomid][ro_count]==0)
	{
		foreach(new i:Player)
		{
       		if(prace[i][race_room]==roomid)
        	{
				stop raceroom[roomid][ro_ctime];
				prace[i][race_cp_index]=0;
  				prace[i][race_stime]=GetTickCount();
    			GameTextForPlayer(i,"~b~GO~GO~GO!!!",850,3);
    			TogglePlayerControllable(i,1);
    			RaceShowCp(i);
			}
		}
		raceroom[roomid][ro_stat]=RACE_ROOM_START;
		UpdateRaceRate(raceroom[roomid][ro_map],1);
	}
	else
	{
	    new str[16];
        format(str,sizeof(str),"~y~%i",raceroom[roomid][ro_count]);
		foreach(new i:Player)
		{
			if(prace[i][race_room]==roomid)
			{
			    TogglePlayerControllable(i,0);
				GameTextForPlayer(i,str,850,6);
			}
		}
		raceroom[roomid][ro_count]--;
	}
	return 1;
}

ACT::RaceShowCp(playerid)
{
	new roomid=prace[playerid][race_room];
	new index=prace[playerid][race_cp_index];
    new mapid=raceroom[roomid][ro_map];
    new nextcp=index+1;
    if(!Iter_Contains(racechack[mapid],nextcp))
	{
	    prace[playerid][race_map]=CreateDynamicMapIcon(racechack[mapid][index][rc_x],racechack[mapid][index][rc_y],racechack[mapid][index][rc_z],33,-1,racemap[mapid][r_wl],racemap[mapid][r_in],playerid,500,MAPICON_LOCAL);
		prace[playerid][race_cp]=CreateDynamicRaceCP(1,racechack[mapid][index][rc_x],racechack[mapid][index][rc_y],racechack[mapid][index][rc_z],0.0,0.0,0.0,racechack[mapid][index][rc_size],racemap[mapid][r_wl],racemap[mapid][r_in],playerid,5000.0);
	}
	else prace[playerid][race_cp]=CreateDynamicRaceCP(0,racechack[mapid][index][rc_x],racechack[mapid][index][rc_y],racechack[mapid][index][rc_z],racechack[mapid][nextcp][rc_x],racechack[mapid][nextcp][rc_y],racechack[mapid][nextcp][rc_z],racechack[mapid][index][rc_size],racemap[mapid][r_wl],racemap[mapid][r_in],playerid,5000.0);
	Streamer_Update(playerid,STREAMER_TYPE_RACE_CP);
    return 1;
}
ACT::OnplayerEnterRaceCp(playerid,checkpointid)
{
	if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
	{
		if(checkpointid==prace[playerid][race_cp])
		{
		    new mapid=raceroom[prace[playerid][race_room]][ro_map];
		    if(prace[playerid][race_cp_index]==Iter_Last(racechack[mapid]))
		    {
		        DestroyDynamicRaceCP(prace[playerid][race_cp]);
		        prace[playerid][race_ftime]=GetTickCount();
		        prace[playerid][race_time]=prace[playerid][race_ftime]-prace[playerid][race_stime];
		        new	Hour,Min,Sec,MS,string[128];
			    ConvertTime(prace[playerid][race_time],Hour,Min,Sec,MS);
			    format(string,sizeof(string),"[RACE] %s 在比赛中第 %i 个到达终点,耗时:%i时%i分%i秒%i毫秒",Pname[playerid],raceroom[prace[playerid][race_room]][ro_rank],Hour,Min,Sec,MS);
				SendClientMessageToAll(-1,string);
				raceroom[prace[playerid][race_room]][ro_rank]++;
				new top=RankPK(playerid,mapid,prace[playerid][race_time]);
				if(top!=-1)
				{
				    format(string,sizeof(string),"[RACE]恭喜 %s 登上了赛道 %s 的排行榜 No.%i!",Pname[playerid],racemap[mapid][r_name],top+1);
					SendClientMessageToAll(-1,string);
				}
				RaceRoomQuit(playerid);
		    }
		    else
		    {
		    	DestroyDynamicRaceCP(prace[playerid][race_cp]);
		    	prace[playerid][race_cp_index]++;
		    	RaceShowCp(playerid);
		    }
		}
 	}
    return 1;
}
ACT::RaceRoomQuit(playerid)
{
	new roomid=prace[playerid][race_room];
	if(roomid==-1)return 1;
    prace[playerid][race_room]=-1;
	prace[playerid][race_cp_index]=0;
	prace[playerid][race_stime]=0;
	prace[playerid][race_ftime]=0;
	prace[playerid][race_time]=-1;
	if(IsValidDynamicRaceCP(prace[playerid][race_cp]))DestroyDynamicRaceCP(prace[playerid][race_cp]);
	if(IsValidDynamicMapIcon(prace[playerid][race_map]))DestroyDynamicMapIcon(prace[playerid][race_map]);
	new index=0;
	foreach(new i:Player)if(prace[i][race_room]==roomid)index++;
	if(index==0)RaceRoomOver(roomid);
	else
	{
	    new string[128];
	    if(raceroom[roomid][ro_uid]==pdate[playerid][uid])
	    {
	        foreach(new i:Player)
			{
				if(prace[i][race_room]==roomid)
				{
				    raceroom[roomid][ro_uid]=pdate[i][uid];
				    format(string,sizeof(string),"由于房主离开,房主变更为%s",GetUidName(raceroom[roomid][ro_uid]));
				    SendRaceMsg(roomid,string);
				    break;
				}
			}
	    }
	}
    return 1;
}
ACT::RaceRoomOver(index)
{
    switch(raceroom[index][ro_stat])
    {
		case RACE_ROOM_WAIT:
		{
			foreach(new i:Player)
			{
			    if(prace[i][race_room]==index)
			    {
				    prace[i][race_room]=-1;
					prace[i][race_cp_index]=0;
					prace[i][race_stime]=0;
					prace[i][race_ftime]=0;
					prace[i][race_time]=-1;
				}
			}
		}
		case RACE_ROOM_START:
		{
			foreach(new i:Player)
			{
			    if(prace[i][race_room]==index)
			    {
				    prace[i][race_room]=-1;
					prace[i][race_cp_index]=0;
					prace[i][race_stime]=0;
					prace[i][race_ftime]=0;
					prace[i][race_time]=-1;
					if(IsValidDynamicRaceCP(prace[i][race_cp]))DestroyDynamicRaceCP(prace[i][race_cp]);
					if(IsValidDynamicMapIcon(prace[i][race_map]))DestroyDynamicMapIcon(prace[i][race_map]);
			    }
			}
		}
    }
 	Iter_Remove(raceroom,index);
    return 1;
}
ACT::OnplayerEnterRaceMap(playerid,checkpointid)
{
    foreach(new i:racemap)
	{
		if(racemap[i][r_cp]==checkpointid)
		{
		    if(racemap[i][r_stat]==RACE_MAP_FINISH)
		    {
		        new string[100];
     			format(string, sizeof(string),"/r %i",i);
     			GameTextForPlayer(playerid,string,1000,1);
     			return 1;
		    }
		}
	}
    return 1;
}
ACT::SendRaceMsg(index,strys[])
{
	new string[256];
	format(string,sizeof(string),"[RACE]%s",strys);
    foreach(new i:Player)
    {
        if(prace[i][race_room]==index)SendClientMessage(i,-1,string);
    }
	return 1;
}

ACT::ShowMyRace(playerid,pages)
{
	if(!Iter_Count(racemap))return SendClientMessage(playerid,COLOR_WARNING,"没有比赛地图");
    current_number[playerid]=1;
    new counts=0;
  	foreach(new i:racemap)
	{
	    if(racemap[i][r_uid]==pdate[playerid][uid])
	    {
        	current_idx[playerid][current_number[playerid]]=i;
        	current_number[playerid]++;
        	counts++;
        }
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"没有上一页");
	}
	else page[playerid]=pages;
	if(pages>floatround(counts/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"没有该页");
		page[playerid]=1;
	}
	new string[60];
	format(string,sizeof(string),"我的比赛地图-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_myrace,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_MyRace_RetrunStr(playerid,page[playerid]), "选择", "返回");
	return 1;
}
Dialog_MyRace_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "名称\t状态\t检查点\t使用次数\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[384],tmps[128];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"%s\t",racemap[current_idx[playerid][i]][r_name]);
            strcat(tmp,tmps);
            switch(racemap[current_idx[playerid][i]][r_stat])
			{
			    case RACE_MAP_MAKE:format(tmps,sizeof(tmps),"编辑中\t");
			    case RACE_MAP_FINISH:format(tmps,sizeof(tmps),"已完成\t");
	    		case RACE_MAP_EDIT:format(tmps,sizeof(tmps),"编辑中\t");
			}
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%i\t",Iter_Count(racechack[current_idx[playerid][i]]));
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%i\n",racemap[current_idx[playerid][i]][r_rate]);
            strcat(tmp,tmps);
		}
	    if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
	    else strcat(string,tmp);
	}
	if(!isover)strcat(string, "{FF8000}下一页\n");
    return string;
}
Dialog:dl_myrace(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowMyRace(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowMyRace(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			new caption[100];
			format(caption,sizeof(caption), "赛道 %s 操作",racemap[listid][r_name]);
			Dialog_Show(playerid,dl_myrace_doing,DIALOG_STYLE_TABLIST,caption,RaceOwnerMenuStr(), "确定", "返回");
            SetPVarInt(playerid,"MyRace_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
Dialog:dl_myrace_doing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
		    case 0:
			{
				new index=GetPVarInt(playerid,"MyRace_Current_ID");
				SetPPos(playerid,racemap[index][r_x],racemap[index][r_y],racemap[index][r_z],racemap[index][r_a],racemap[index][r_in],racemap[index][r_wl],0.5,2);
			}
 		    case 1:Dialog_Show(playerid,dl_race_change_name,DIALOG_STYLE_INPUT,"更改名称","请输入要更改的名称","确定","取消");
		    case 2:
		    {
		        if(Racemapid[playerid]!=-1)return SendClientMessage(playerid,COLOR_WARNING,"你正在编辑其他赛道");
		        foreach(new i:raceroom)if(raceroom[i][ro_map]==GetPVarInt(playerid,"MyRace_Current_ID"))return SendClientMessage(playerid,COLOR_WARNING,"有人正在使用此赛道,请稍候再编辑");
		        Racemapid[playerid]=GetPVarInt(playerid,"MyRace_Current_ID");
				Racemapindex[playerid]=0;
				UpdateRaceFinish(GetPVarInt(playerid,"MyRace_Current_ID"),RACE_MAP_EDIT);
		    }
		    case 3:
			{
			  	foreach(new i:raceroom)if(raceroom[i][ro_map]==GetPVarInt(playerid,"MyRace_Current_ID"))return SendClientMessage(playerid,COLOR_WARNING,"有人正在使用此赛道,请稍候再删除");
			    RemoveRaceMap(GetPVarInt(playerid,"MyRace_Current_ID"));
			}
		}
	}
	return 1;
}
Dialog:dl_race_change_name(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(strlen(inputtext)<1||strlen(inputtext)>50)return Dialog_Show(playerid,dl_race_change_name,DIALOG_STYLE_INPUT,"更改名称","请输入要更改的名称","确定","取消");
		if(pdate[playerid][cash]<10000)return SendClientMessage(playerid,COLOR_WARNING,"你没有这么多现金");
        GiveCash(playerid,-10000);
        UpdateRaceName(GetPVarInt(playerid,"MyRace_Current_ID"),inputtext);
	}
	return 1;
}
ACT::GetRaceMapId(rsid)
{
  	foreach(new i:racemap)
	{
	    if(racemap[i][r_id]==rsid)return i;
	}
	return -1;
}
RaceOwnerMenuStr()
{
	new string[1024],str[100];
	format(str, sizeof(str),"传送赛道\t\n");
	strcat(string,str);
	format(str, sizeof(str),"更改名称\t$10000\n");
	strcat(string,str);
	format(str, sizeof(str),"编辑赛道\t\n");
	strcat(string,str);
	format(str, sizeof(str),"删除赛道\t\n");
	strcat(string,str);
	return string;
}
ACT::ShowGlobalRaceMenu(playerid,pages)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_RACE"` ORDER BY r_rate DESC");
    mysql_tquery(mysqlid, Querys, "OnGlobalRaceMenu", "ii",playerid,pages);
	return 1;
}
ACT::OnGlobalRaceMenu(playerid,pages)
{
	new rows=cache_get_row_count(mysqlid);
	if(!rows)return SendClientMessage(playerid,COLOR_WARNING,"没有赛道");
    current_number[playerid]=1;
  	for(new i=0;i<rows;i++)
	{
        current_idx[playerid][current_number[playerid]]=cache_get_field_content_int(i, "r_id");
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"没有上一页");
	}
	else page[playerid]=pages;
	if(pages>floatround(rows/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"没有该页");
		page[playerid]=1;
	}

    new string[2048],caption[64];
    new pager = (page[playerid]-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	new index;
	format(caption,sizeof(caption), "名称\t检查点\t使用频率\t状态\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST;i++)
	{
	    new tmp[128],tmps[60];
		if(i<current_number[playerid])
		{
		    index=GetRaceMapId(current_idx[playerid][i]);
		    if(index==-1)return 0;
            format(tmps,sizeof(tmps),"%s\t",racemap[index][r_name]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%i\t",Iter_Count(racechack[index]));
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%i\t",racemap[index][r_rate]);
            strcat(tmp,tmps);
            switch(racemap[index][r_stat])
			{
			    case RACE_MAP_MAKE:format(tmps,sizeof(tmps),"NO\n");
			    case RACE_MAP_FINISH:format(tmps,sizeof(tmps),"OK\n");
	    		case RACE_MAP_EDIT:format(tmps,sizeof(tmps),"NO\n");
			}
            strcat(tmp,tmps);

		}
	    if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
	    else strcat(string,tmp);
	}
	if(!isover)strcat(string, "{FF8000}下一页\n");

	new str[128];
	format(str,sizeof(str),"赛道列表-共计[%i]",rows);
	Dialog_Show(playerid,dl_player_race_show,DIALOG_STYLE_TABLIST_HEADERS,str,string, "使用", "返回");
	return 1;
}

Dialog:dl_player_race_show(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowGlobalRaceMenu(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowGlobalRaceMenu(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
		    new index=GetRaceMapId(listid);
		    if(index==-1)return 0;
			Dialog_Show(playerid,dl_race_info,DIALOG_STYLE_MSGBOX,"赛道信息",ShowRaceMapInfo(index),"传送","取消");
            SetPVarInt(playerid,"Race_Current_ID",index);
		}
	}
	else
	{

	}
	return 1;
}
Dialog:dl_race_info(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new index=GetPVarInt(playerid,"Race_Current_ID");
    	SetPPos(playerid,racemap[index][r_x],racemap[index][r_y],racemap[index][r_z],racemap[index][r_a],racemap[index][r_in],racemap[index][r_wl],0.5,2);
	}
	return 1;
}
ACT::ShowGlobalRaceRoom(playerid,pages)
{
	if(!Iter_Count(raceroom))return SendClientMessage(playerid,COLOR_WARNING,"没有比赛房间");
    current_number[playerid]=1;
    new counts=0;
  	foreach(new i:raceroom)
	{
       	current_idx[playerid][current_number[playerid]]=i;
       	current_number[playerid]++;
       	counts++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"没有上一页");
	}
	else page[playerid]=pages;
	if(pages>floatround(counts/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"没有该页");
		page[playerid]=1;
	}
	new string[60];
	format(string,sizeof(string),"比赛房间-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_raceroom,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_RaceRoom_RetrunStr(playerid,page[playerid]), "选择", "返回");
	return 1;
}
Dialog_RaceRoom_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "地图名\t房主\t状态\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[384],tmps[128];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"%s\t",racemap[raceroom[current_idx[playerid][i]][ro_map]][r_name]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%s\t",GetUidName(raceroom[current_idx[playerid][i]][ro_uid]));
            strcat(tmp,tmps);
            switch(raceroom[current_idx[playerid][i]][ro_stat])
			{
			    case RACE_ROOM_WAIT:format(tmps,sizeof(tmps),"等待中\n");
			    case RACE_ROOM_START:format(tmps,sizeof(tmps),"已开始\n");
	    		case RACE_ROOM_FINISH:format(tmps,sizeof(tmps),"比赛完成\n");
			}
            strcat(tmp,tmps);
		}
	    if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
	    else strcat(string,tmp);
	}
	if(!isover)strcat(string, "{FF8000}下一页\n");
    return string;
}
Dialog:dl_raceroom(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowGlobalRaceRoom(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowGlobalRaceRoom(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			if(raceroom[listid][ro_stat]!=RACE_ROOM_WAIT)return SendClientMessage(playerid,COLOR_WARNING,"该比赛房间已经开始了,无法加入");
			Dialog_Show(playerid,dl_raceroom_join,DIALOG_STYLE_MSGBOX,"比赛房间","是否加入此比赛","确定","取消");
            SetPVarInt(playerid,"RaceRoom_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
Dialog:dl_raceroom_join(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new index=GetPVarInt(playerid,"RaceRoom_Current_ID");
	    new string[60];
		format(string,sizeof(string),"/r join %i",index);
	    CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,string);
	}
	return 1;
}
#include WD3/Race/Races_Cmd.pwn

