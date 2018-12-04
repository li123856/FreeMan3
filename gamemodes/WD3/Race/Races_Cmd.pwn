YCMD:addrace(playerid, params[], help)
{
	new rnamed[128],nanmes[80],idx;
	rnamed = strtok(params,idx);
	nanmes = strtok(params,idx);
 	if(!strlen(rnamed))
	{
	    SendClientMessage(playerid,COLOR_WARNING,"/addrace map ����������ͼ");
	    SendClientMessage(playerid,COLOR_WARNING,"/addrace add �������");
	    SendClientMessage(playerid,COLOR_WARNING,"/addrace del ɾ����һ������");
	    SendClientMessage(playerid,COLOR_WARNING,"/addrace fin ��ɱ�����ͼ");
	    return 1;
	}
    if(!strcmp(rnamed,"map",false))
    {
        if(!strlen(nanmes))return SendClientMessage(playerid,COLOR_WARNING,"/addrace map ����������ͼ");
        if(Racemapid[playerid]!=-1)return SendClientMessage(playerid,COLOR_WARNING,"���ڱ༭��������");
		Racemapid[playerid]=AddRaceMap(playerid,nanmes);
		Racemapindex[playerid]=0;
		return 1;
    }
    if(!strcmp(rnamed,"add",false))
    {
	    if(Racemapid[playerid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"û�б༭����");
		if(racemap[Racemapid[playerid]][r_stat]==RACE_MAP_FINISH)return SendClientMessage(playerid,COLOR_WARNING,"�����������");
        if(Racemapindex[playerid]>=MAX_RACE_CHACKS)
        {
           SendClientMessage(playerid,COLOR_WARNING,"�����ѵ�����,��ʹ��/addrace fin�����༭");
           return 1;
        }
		AddRaceChackPoint(playerid,Racemapid[playerid],Racemapindex[playerid],5.0);
        Racemapindex[playerid]++;
        return 1;
    }
    if(!strcmp(rnamed,"del",false))
    {
		if(Racemapid[playerid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"û�б༭����");
	    if(racemap[Racemapid[playerid]][r_stat]==RACE_MAP_FINISH)return SendClientMessage(playerid,COLOR_WARNING,"�����������");
       	Racemapindex[playerid]--;
      	if(Racemapid[playerid]>=0)RemoveRaceChackPoint(Racemapid[playerid],Racemapindex[playerid]);
        else
        {
            Racemapindex[playerid]=0;
            SendClientMessage(playerid,COLOR_WARNING,"�Ѿ�û�м�����");
        }
      	return 1;
    }
    if(!strcmp(rnamed,"fin",false))
    {
		if(Racemapid[playerid]==-1)return SendClientMessage(playerid,COLOR_WARNING,"û�б༭����");
	    if(racemap[Racemapid[playerid]][r_stat]==RACE_MAP_FINISH)return SendClientMessage(playerid,COLOR_WARNING,"�����������");
		if(!Iter_Count(racechack[Racemapid[playerid]]))return SendClientMessage(playerid,COLOR_WARNING,"������û�м���,������ɱ༭");
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
	    SendClientMessage(playerid,COLOR_WARNING,"/r ID ��һ������");
	    SendClientMessage(playerid,COLOR_WARNING,"/r start ��ʼ����");
	    SendClientMessage(playerid,COLOR_WARNING,"/r close �رձ���");
	    SendClientMessage(playerid,COLOR_WARNING,"/r join ID ����һ������");
	    SendClientMessage(playerid,COLOR_WARNING,"/r exit �뿪����");
		return 1;
	}
    if(!strcmp(nanmes,"room",false))return ShowGlobalRaceRoom(playerid,1);
    if(!strcmp(nanmes,"start",false))
    {
        new roomd=prace[playerid][race_room];
        if(roomd==-1)return SendClientMessage(playerid,COLOR_WARNING,"��û���ڱ�����");
        if(raceroom[roomd][ro_stat]!=RACE_ROOM_WAIT)return SendClientMessage(playerid,COLOR_WARNING,"�����Ѿ���ʼ��");
        if(raceroom[roomd][ro_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�㲻�Ƿ���");
        StartRaceRoom(roomd);
        new string[128];
		format(string,sizeof(string),"%s ��ʼ�˱���",Pname[playerid]);
		SendRaceMsg(roomd,string);
        return 1;
    }
    if(!strcmp(nanmes,"close",false))
    {
        new roomd=prace[playerid][race_room];
        if(roomd==-1)return SendClientMessage(playerid,COLOR_WARNING,"��û���ڱ�����");
        if(raceroom[roomd][ro_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�㲻�Ƿ���");
        RaceRoomOver(roomd);
        new string[128];
		format(string,sizeof(string),"%s �ر��˱���",Pname[playerid]);
		SendRaceMsg(roomd,string);
        return 1;
    }
    if(!strcmp(nanmes,"join",false))
    {
    	if(!strlen(named))return SendClientMessage(playerid,COLOR_WARNING,"�������������ID");
		new roomd=prace[playerid][race_room];
		if(roomd!=-1)return SendClientMessage(playerid,COLOR_WARNING,"��������������");
    	new index=strval(named);
		if(!Iter_Contains(raceroom,index))return SendClientMessage(playerid,COLOR_WARNING,"��������ID������");
		if(raceroom[index][ro_stat]!=RACE_ROOM_WAIT)return SendClientMessage(playerid,COLOR_WARNING,"�ñ����ѿ�ʼ��,�޷�����");
	    JoinRaceRoom(playerid,index);
        new string[128];
		format(string,sizeof(string),"%s �����˱���",Pname[playerid]);
		SendRaceMsg(roomd,string);
	    return 1;
    }
    if(!strcmp(nanmes,"exit",false))
    {
        new roomd=prace[playerid][race_room];
        if(roomd==-1)return SendClientMessage(playerid,COLOR_WARNING,"��û���ڱ�����");
        RaceRoomQuit(playerid);
        new string[128];
		format(string,sizeof(string),"%s �뿪�˱���",Pname[playerid]);
		SendRaceMsg(roomd,string);
        return 1;
    }
 	if(strlen(nanmes))
	{
	    new roomd=prace[playerid][race_room];
        if(roomd!=-1)return SendClientMessage(playerid,COLOR_WARNING,"��������������");
	    new index=strval(nanmes);
		if(!Iter_Contains(racemap,index))return SendClientMessage(playerid,COLOR_WARNING,"������ID������");
		if(racemap[index][r_stat]!=RACE_MAP_FINISH)return SendClientMessage(playerid,COLOR_WARNING,"��������û�����");
		new string[128];
		format(string,sizeof(string),"[RACE]%s ������һ������,/r join %i ���Լ���",Pname[playerid],AddRaceRoom(playerid,index));
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


