YCMD:c(playerid, params[], help)
{
	new models,col1,col2;
	if(sscanf(params, "iD(0)D(0)",models,col1,col2))return ShowModelSelectionMenuEx(playerid,carlist,sizeof(carlist), "Select trailer",CUSTOM_TRAILER_MENU, 16.0, 0.0, -55.0);
    if(!IsValidVehicleModel(models))return SendClientMessage(playerid,COLOR_WARNING,"车型ID无效");
	new Float:xx,Float:yy,Float:zz,Float:angled;
	GetPlayerPos(playerid,xx,yy,zz);
	GetPlayerFacingAngle(playerid,angled);
	PutPlayerInVehicle(playerid,AddFreeVeh(playerid,models,xx,yy,zz+0.8,angled,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,-1),0);
	return 1;
}
YCMD:buyit(playerid, params[], help)
{
	if(!IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid,COLOR_WARNING,"你没有在任何一辆车上");
	if(GetPlayerVehicleSeat(playerid)!=0)return SendClientMessage(playerid,COLOR_WARNING,"你没有在驾驶位置");
	new vid=GetPlayerVehicleID(playerid);
	if(veh[vid][type]!=CAR_OWNER)return SendClientMessage(playerid,COLOR_WARNING,"这不是一辆可购买的车");
	if(veh[vid][uid]==pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"干嘛要买自己的爱车");
	if(veh[vid][sellmoney]<=0)return SendClientMessage(playerid,COLOR_WARNING,"这不是一辆可购买的爱车");
	if(pdate[playerid][cash]<veh[vid][sellmoney])return SendClientMessage(playerid,COLOR_WARNING,"你的现金不足");
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
		format(string, sizeof(string),"你成功购买了一辆 %s 爱车",VehName[veh[vid][modelids]-400]);
		SendClientMessage(playerid,COLOR_WARNING,string);
		format(string, sizeof(string),"%s 购买了系统爱车 CID:",Pname[playerid],veh[vid][cid]);
		AddLog(LOG_TYPE_DEAL,string);
	}
	else
	{
		new string[100];
		format(string, sizeof(string),"你成功%s的爱车 %s",veh[vid][uname],VehName[veh[vid][modelids]-400]);
		SendClientMessage(playerid,COLOR_WARNING,string);
		format(string, sizeof(string),"%s 购买了 %s 的爱车 CID:",Pname[playerid],veh[vid][uname],veh[vid][cid]);
		AddLog(LOG_TYPE_DEAL,string);
		
	    GiveCash(playerid,-veh[vid][sellmoney]);
	    format(string, sizeof(string),"%s 购买了你的爱车 %s CID:%i",Pname[playerid],VehName[veh[vid][modelids]-400],veh[vid][cid]);
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


