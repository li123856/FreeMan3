YCMD:addrace(playerid, params[], help)
{
	new rnamed[128],nanmes[80],idx;
	rnamed = strtok(params,idx);
	nanmes = strtok(params,idx);
 	if(!strlen(rnamed))
	{
	    SendClientMessage(playerid,COLOR_WARNING,"/addrace map 创建比赛地图");
	    SendClientMessage(playerid,COLOR_WARNING,"/addrace add 加入检查点");
	    SendClientMessage(playerid,COLOR_WARNING,"/addrace del 删除上一个检查点");
	    SendClientMessage(playerid,COLOR_WARNING,"/addrace fin 完成比赛地图");
	    return 1;
	}
    if(!strcmp(rnamed,"map",false))
    {
        if(!strlen(nanmes))return SendClientMessage(playerid,COLOR_WARNING,"/addrace map 创建比赛地图");
        if(Racemapid[playerid]!=-1)return SendClientMessage(playerid,COLOR_WARNING,"正在编辑其它赛道");
		Racemapid[playerid]=AddRaceMap(playerid,nanmes);
		Racemapindex[playerid]=0;
		return 1;
    }
    if(!strcmp(rnamed,"add",false))
    {
	    if(Racemapid[playerid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"没有编辑赛道");
		if(racemap[Racemapid[playerid]][r_stat]==RACE_MAP_FINISH)return SendClientMessage(playerid,COLOR_WARNING,"该赛道已完成");
        if(Racemapindex[playerid]>=MAX_RACE_CHACKS)
        {
           SendClientMessage(playerid,COLOR_WARNING,"检查点已到上限,请使用/addrace fin结束编辑");
           return 1;
        }
		AddRaceChackPoint(playerid,Racemapid[playerid],Racemapindex[playerid],5.0);
        Racemapindex[playerid]++;
        return 1;
    }
    if(!strcmp(rnamed,"del",false))
    {
		if(Racemapid[playerid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"没有编辑赛道");
	    if(racemap[Racemapid[playerid]][r_stat]==RACE_MAP_FINISH)return SendClientMessage(playerid,COLOR_WARNING,"该赛道已完成");
       	Racemapindex[playerid]--;
      	if(Racemapid[playerid]>=0)RemoveRaceChackPoint(Racemapid[playerid],Racemapindex[playerid]);
        else
        {
            Racemapindex[playerid]=0;
            SendClientMessage(playerid,COLOR_WARNING,"已经没有检查点了");
        }
      	return 1;
    }
    if(!strcmp(rnamed,"fin",false))
    {
		if(Racemapid[playerid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"没有编辑赛道");
	    if(racemap[Racemapid[playerid]][r_stat]==RACE_MAP_FINISH)return SendClientMessage(playerid,COLOR_WARNING,"该赛道已完成");
		if(!Iter_Count(racechack[Racemapid[playerid]]))return SendClientMessage(playerid,COLOR_WARNING,"该赛道没有检查点,不能完成编辑");
		UpdateRaceFinish(Racemapid[playerid],RACE_MAP_FINISH);
  		Racemapid[playerid]=-1;
    	Racemapindex[playerid]=0;
    	return 1;
    }
	return 1;
}
YCMD:r(playerid, params[], help)
{
	new nanmes[80],named[80],idx;
	nanmes = strtok(params,idx);
	named = strtok(params,idx);
 	if(!strlen(nanmes))
	{
	    SendClientMessage(playerid,COLOR_WARNING,"/r ID 开一场赛事");
	    SendClientMessage(playerid,COLOR_WARNING,"/r start 开始比赛");
	    SendClientMessage(playerid,COLOR_WARNING,"/r close 关闭比赛");
	    SendClientMessage(playerid,COLOR_WARNING,"/r join ID 加入一场比赛");
	    SendClientMessage(playerid,COLOR_WARNING,"/r exit 离开比赛");
		return 1;
	}
    if(!strcmp(nanmes,"room",false))return ShowGlobalRaceRoom(playerid,1);
    if(!strcmp(nanmes,"start",false))
    {
        new roomd=prace[playerid][race_room];
        if(roomd==-1)return SendClientMessage(playerid,COLOR_WARNING,"你没有在比赛中");
        if(raceroom[roomd][ro_stat]!=RACE_ROOM_WAIT)return SendClientMessage(playerid,COLOR_WARNING,"比赛已经开始了");
        if(raceroom[roomd][ro_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"你不是房主");
        StartRaceRoom(roomd);
        new string[128];
		format(string,sizeof(string),"%s 开始了比赛",Pname[playerid]);
		SendRaceMsg(roomd,string);
        return 1;
    }
    if(!strcmp(nanmes,"close",false))
    {
        new roomd=prace[playerid][race_room];
        if(roomd==-1)return SendClientMessage(playerid,COLOR_WARNING,"你没有在比赛中");
        if(raceroom[roomd][ro_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"你不是房主");
        RaceRoomOver(roomd);
        new string[128];
		format(string,sizeof(string),"%s 关闭了比赛",Pname[playerid]);
		SendRaceMsg(roomd,string);
        return 1;
    }
    if(!strcmp(nanmes,"join",false))
    {
    	if(!strlen(named))return SendClientMessage(playerid,COLOR_WARNING,"请输入比赛房间ID");
		new roomd=prace[playerid][race_room];
		if(roomd!=-1)return SendClientMessage(playerid,COLOR_WARNING,"你在其他比赛中");
    	new index=strval(named);
		if(!Iter_Contains(raceroom,index))return SendClientMessage(playerid,COLOR_WARNING,"比赛房间ID不存在");
		if(raceroom[index][ro_stat]!=RACE_ROOM_WAIT)return SendClientMessage(playerid,COLOR_WARNING,"该比赛已开始了,无法加入");
	    JoinRaceRoom(playerid,index);
        new string[128];
		format(string,sizeof(string),"%s 加入了比赛",Pname[playerid]);
		SendRaceMsg(roomd,string);
	    return 1;
    }
    if(!strcmp(nanmes,"exit",false))
    {
        new roomd=prace[playerid][race_room];
        if(roomd==-1)return SendClientMessage(playerid,COLOR_WARNING,"你没有在比赛中");
        RaceRoomQuit(playerid);
        new string[128];
		format(string,sizeof(string),"%s 离开了比赛",Pname[playerid]);
		SendRaceMsg(roomd,string);
        return 1;
    }
 	if(strlen(nanmes))
	{
	    new roomd=prace[playerid][race_room];
        if(roomd!=-1)return SendClientMessage(playerid,COLOR_WARNING,"你在其他比赛中");
	    new index=strval(nanmes);
		if(!Iter_Contains(racemap,index))return SendClientMessage(playerid,COLOR_WARNING,"该赛道ID不存在");
		if(racemap[index][r_stat]!=RACE_MAP_FINISH)return SendClientMessage(playerid,COLOR_WARNING,"该赛道还没有完成");
		new string[128];
		format(string,sizeof(string),"[RACE]%s 发起了一场比赛,/r join %i 可以加入",Pname[playerid],AddRaceRoom(playerid,index));
		SendClientMessageToAll(-1,string);
		return 1;
	}
	return 1;
}
YCMD:myrace(playerid, params[], help)
{
	ShowMyRace(playerid,1);
	return 1;
}
YCMD:race(playerid, params[], help)
{
	ShowGlobalRaceMenu(playerid,1);
	return 1;
}


