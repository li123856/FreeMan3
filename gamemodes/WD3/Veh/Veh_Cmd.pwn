YCMD:c(playerid, params[], help)
{
	new models,col1,col2;
	if(sscanf(params, "iD(0)D(0)",models,col1,col2))return ShowModelSelectionMenuEx(playerid,carlist,sizeof(carlist), "Select trailer",CUSTOM_TRAILER_MENU, 16.0, 0.0, -55.0);
    if(!IsValidVehicleModel(models))return SendClientMessage(playerid,COLOR_WARNING,"����ID��Ч");
	new Float:xx,Float:yy,Float:zz,Float:angled;
	GetPlayerPos(playerid,xx,yy,zz);
	GetPlayerFacingAngle(playerid,angled);
	PutPlayerInVehicle(playerid,AddFreeVeh(playerid,models,xx,yy,zz+0.8,angled,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,-1),0);
	return 1;
}
YCMD:buyit(playerid, params[], help)
{
	if(!IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid,COLOR_WARNING,"��û�����κ�һ������");
	if(GetPlayerVehicleSeat(playerid)!=0)return SendClientMessage(playerid,COLOR_WARNING,"��û���ڼ�ʻλ��");
	new vid=GetPlayerVehicleID(playerid);
	if(veh[vid][type]!=CAR_OWNER)return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ��һ���ɹ���ĳ�");
	if(veh[vid][uid]==pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"����Ҫ���Լ��İ���");
	if(veh[vid][sellmoney]<=0)return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ��һ���ɹ���İ���");
	if(pdate[playerid][cash]<veh[vid][sellmoney])return SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
	if(veh[vid][uid]==-1)
	{
	    veh[vid][uid]=pdate[playerid][uid];
	    format(veh[vid][uname],80,"%s",Pname[playerid]);
	    veh[vid][sellmoney]=0;
		format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `uid` =  '%i' `uname` =  '%s' `sellmoney` =  '0' WHERE `SQL_VEH`.`cid` ='%i'",pdate[playerid][uid],Pname[playerid],veh[vid][cid]);
		mysql_query(mysqlid,Querys,false);
		UpdateVehText(vid);
		GiveCash(playerid,-veh[vid][sellmoney]);
		new string[100];
		format(string, sizeof(string),"��ɹ�������һ�� %s ����",VehName[veh[vid][modelids]-400]);
		SendClientMessage(playerid,COLOR_WARNING,string);
		format(string, sizeof(string),"%s ������ϵͳ���� CID:",Pname[playerid],veh[vid][cid]);
		AddLog(LOG_TYPE_DEAL,string);
	}
	else
	{
		new string[100];
		format(string, sizeof(string),"��ɹ�%s�İ��� %s",veh[vid][uname],VehName[veh[vid][modelids]-400]);
		SendClientMessage(playerid,COLOR_WARNING,string);
		format(string, sizeof(string),"%s ������ %s �İ��� CID:",Pname[playerid],veh[vid][uname],veh[vid][cid]);
		AddLog(LOG_TYPE_DEAL,string);
		
	    GiveCash(playerid,-veh[vid][sellmoney]);
	    format(string, sizeof(string),"%s ��������İ��� %s CID:%i",Pname[playerid],VehName[veh[vid][modelids]-400],veh[vid][cid]);
	    SystemSendMsgToPlayer(veh[vid][uid],string,veh[vid][sellmoney]);
	    
        veh[vid][uid]=pdate[playerid][uid];
	    format(veh[vid][uname],80,"%s",Pname[playerid]);
	    veh[vid][sellmoney]=0;
		format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `uid` =  '%i' `uname` =  '%s' `sellmoney` =  '0' WHERE `SQL_VEH`.`cid` ='%i'",pdate[playerid][uid],Pname[playerid],veh[vid][cid]);
		mysql_query(mysqlid,Querys,false);
		UpdateVehText(vid);
	}
	return 1;
}


