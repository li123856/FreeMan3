#include WD3/Veh/Veh_Define.pwn
#include WD3/Veh/Veh_Custom.pwn
public OnGameModeInit()
{
	LoadVeh();
	return CallLocalFunction("Veh_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Veh_OnGameModeInit
forward Veh_OnGameModeInit();
ACT::LoadVeh()
{
    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_VEH"`");
    mysql_tquery(mysqlid, Querys, "OnVehLoad");
	return 1;
}
ACT::OnVehLoad()
{
	new vid,usename[80];
	new rows=cache_get_row_count(mysqlid);
	for(new i=0;i<rows;i++)
	{
		cache_get_field_content(i,"uname",usename,mysqlid,80);
		vid=LoadPlayerVeh(cache_get_field_content_int(i,"modelid"),cache_get_field_content_int(i,"uid"),usename,cache_get_field_content_int(i,"gid"),cache_get_field_content_float(i,"x"),cache_get_field_content_float(i,"y"),cache_get_field_content_float(i,"z"),cache_get_field_content_float(i,"angle"),cache_get_field_content_int(i, "world"),cache_get_field_content_int(i, "interior"),cache_get_field_content_int(i, "color_0"),cache_get_field_content_int(i, "color_1"),cache_get_field_content_int(i, "addsiren"));
	    cache_get_field_content(i,"plate",veh[vid][plate],mysqlid,80);
	    cache_get_field_content(i,"music",veh[vid][music],mysqlid,129);
		veh[vid][cid]=cache_get_field_content_int(i, "cid");
	    veh[vid][lock]=cache_get_field_content_int(i, "lock");
	    veh[vid][sellmoney]=cache_get_field_content_int(i, "sellmoney");
	    veh[vid][paintjob]=cache_get_field_content_int(i, "paintjob");
	    for(new s=0;s<MAX_COM;s++)
		{
		    new string[64];
		    format(string, sizeof(string),"comp_%i",s);
			veh[vid][comp][s]=cache_get_field_content_int(i,string);
			AddVehicleComponent(vid,veh[vid][comp][s]);
		}
        if(veh[vid][lock])SetVehicleParamsEx(vid,0,0,0,1,0,0,0);
        SetVehicleNumberPlate(vid,veh[vid][plate]);
        if(veh[vid][paintjob]!=-1)ChangeVehiclePaintjob(vid,veh[vid][paintjob]);
	}
    return 1;
}
ACT::CreateVehText(carid)
{
	new string[128];
	if(veh[carid][type]==CAR_OWNER)
	{
		if(veh[carid][sellmoney]>0)
		{
		    if(veh[carid][uid]==-1)format(string,sizeof(string),VEH_SYSTEM_SALE,VehName[veh[carid][modelids]-400],veh[carid][sellmoney]);
			else format(string,sizeof(string),VEH_PLAYER_SALE,VehName[veh[carid][modelids]-400],veh[carid][uname],veh[carid][sellmoney]);
		}
		else format(string,sizeof(string),VEH_OWNER,VehName[veh[carid][modelids]-400],veh[carid][uname]);
		veh[carid][ctext]=CreateDynamic3DTextLabel(string,COLOR_RED,0.0,0.0,0.8,10,INVALID_PLAYER_ID,carid,0,veh[carid][world],veh[carid][interior],-1);
	}
	else
	{
	    format(string,sizeof(string),VEH_FREE,VehName[veh[carid][modelids]-400],Pname[veh[carid][player]]);
	    veh[carid][ctext]=CreateDynamic3DTextLabel(string,COLOR_LIGHTBLUE,0.0,0.0,0.8,10,INVALID_PLAYER_ID,carid,0,veh[carid][world],veh[carid][interior],-1);
	}
	return 1;
}
ACT::UpdateVehText(carid)
{
	new string[128];
	if(veh[carid][type]==CAR_OWNER)
	{
		if(veh[carid][sellmoney]>0)
		{
		    if(veh[carid][uid]==-1)format(string,sizeof(string),VEH_SYSTEM_SALE,VehName[veh[carid][modelids]-400],veh[carid][sellmoney]);
			else format(string,sizeof(string),VEH_PLAYER_SALE,VehName[veh[carid][modelids]-400],veh[carid][uname],veh[carid][sellmoney]);
		}
		else format(string,sizeof(string),VEH_OWNER,VehName[veh[carid][modelids]-400],veh[carid][uname]);
		UpdateDynamic3DTextLabelText(veh[carid][ctext],COLOR_RED,string);
	}
	else
	{
	    format(string,sizeof(string),VEH_FREE,VehName[veh[carid][modelids]-400],Pname[veh[carid][player]]);
		UpdateDynamic3DTextLabelText(veh[carid][ctext],COLOR_LIGHTBLUE,string);
	}
	return 1;
}
ACT::AddFreeVeh(playerid,models,Float:xx,Float:yy,Float:zz,Float:angled,worldid,interiorid,color1,color2)
{
	if(PlayerFreeCar[playerid]!=-1)
	{
		DestroyDynamic3DTextLabel(veh[PlayerFreeCar[playerid]][ctext]);
		DestroyVehicle(PlayerFreeCar[playerid]);
	    Iter_Remove(veh,PlayerFreeCar[playerid]);
	}
    PlayerFreeCar[playerid]=AddStaticVehicleEx(models,xx,yy,zz,angled,color1,color2,99999,0);
	LinkVehicleToInterior(PlayerFreeCar[playerid],interiorid);
	SetVehicleVirtualWorld(PlayerFreeCar[playerid],worldid);
	veh[PlayerFreeCar[playerid]][type]=CAR_FREE;
	veh[PlayerFreeCar[playerid]][player]=playerid;
	veh[PlayerFreeCar[playerid]][modelids]=models;
    Iter_Add(veh,PlayerFreeCar[playerid]);
	CreateVehText(PlayerFreeCar[playerid]);
    return PlayerFreeCar[playerid];
}
ACT::LoadPlayerVeh(models,uidid,usename[],groupid,Float:xx,Float:yy,Float:zz,Float:angled,worldid,interiorid,color1,color2,siren)
{
    new vid;
    if(color1==-1)color1=random(255);
    if(color2==-1)color2=random(255);
	vid=AddStaticVehicleEx(models,xx,yy,zz,angled,color1,color2,99999,siren);
	LinkVehicleToInterior(vid,interiorid);
	SetVehicleVirtualWorld(vid,worldid);
	veh[vid][addsiren]=siren;
	veh[vid][uid]=uidid;
	veh[vid][gid]=groupid;
	veh[vid][modelids]=models;
    veh[vid][color][0]=color1;
    veh[vid][color][1]=color2;
    veh[vid][cx]=xx;
    veh[vid][cy]=yy;
    veh[vid][cz]=zz;
    veh[vid][angle]=angled;
    format(veh[vid][plate],80,"NULL");
    format(veh[vid][music],129,"NULL");
	if(uidid!=-1)format(veh[vid][uname],80,"%s",usename);
    veh[vid][interior]=interiorid;
    veh[vid][world]=worldid;
    veh[vid][lock]=0;
    veh[vid][sellmoney]=0;
    veh[vid][paintjob]=-1;
	for(new s=0;s<MAX_COM;s++)veh[vid][comp][s]=-1;
	veh[vid][addsiren]=0;
	veh[vid][type]=CAR_OWNER;
	Iter_Add(veh,vid);
	CreateVehText(vid);
	return vid;
}
ACT::AddBuyVeh(models,cashs,Float:xx,Float:yy,Float:zz,Float:angled,worldid,interiorid,color1,color2,siren)
{
    new vid;
    if(color1==-1)color1=random(255);
    if(color2==-1)color2=random(255);
	vid=AddStaticVehicleEx(models,xx,yy,zz,angled,color1,color2,99999,siren);
	LinkVehicleToInterior(vid,interiorid);
	SetVehicleVirtualWorld(vid,worldid);
	veh[vid][addsiren]=siren;
	veh[vid][uid]=-1;
	veh[vid][gid]=-1;
	veh[vid][modelids]=models;
    veh[vid][color][0]=color1;
    veh[vid][color][1]=color2;
    veh[vid][cx]=xx;
    veh[vid][cy]=yy;
    veh[vid][cz]=zz;
    veh[vid][angle]=angled;
    format(veh[vid][plate],80,"NULL");
    format(veh[vid][music],129,"NULL");
	format(veh[vid][uname],80,"NULL");
    veh[vid][interior]=interiorid;
    veh[vid][world]=worldid;
    veh[vid][lock]=0;
    veh[vid][sellmoney]=cashs;
    veh[vid][paintjob]=-1;
	for(new s=0;s<MAX_COM;s++)veh[vid][comp][s]=-1;
	veh[vid][addsiren]=0;
	veh[vid][type]=CAR_OWNER;
	format(Querys, sizeof(Querys),"INSERT INTO `"SQL_VEH"`(`modelid`,`x`,`y`,`z`,`angle`,`interior`,`world`,`color_0`,`color_1` ,`sellmoney`)VALUES ('%i','%f','%f','%f','%f','%i','%i','%i','%i','%i')",models,xx,yy,zz,angled,interiorid,worldid,color1,color2,veh[vid][sellmoney]);
	mysql_query(mysqlid,Querys);
	veh[vid][cid]=cache_insert_id();
	Iter_Add(veh,vid);
	CreateVehText(vid);
	return vid;
}
ACT::AddPlayerVeh(models,uidid,usename[],groupid,Float:xx,Float:yy,Float:zz,Float:angled,worldid,interiorid,color1,color2,siren)
{
    new vid;
    if(color1==-1)color1=random(255);
    if(color2==-1)color2=random(255);
	vid=AddStaticVehicleEx(models,xx,yy,zz,angled,color1,color2,99999,siren);
	LinkVehicleToInterior(vid,interiorid);
	SetVehicleVirtualWorld(vid,worldid);
	veh[vid][addsiren]=siren;
	veh[vid][uid]=uidid;
	veh[vid][gid]=groupid;
	veh[vid][modelids]=models;
    veh[vid][color][0]=color1;
    veh[vid][color][1]=color2;
    veh[vid][cx]=xx;
    veh[vid][cy]=yy;
    veh[vid][cz]=zz;
    veh[vid][angle]=angled;
    format(veh[vid][plate],80,"NULL");
    format(veh[vid][music],129,"NULL");
	if(uidid!=-1)format(veh[vid][uname],80,"%s",usename);
    veh[vid][interior]=interiorid;
    veh[vid][world]=worldid;
    veh[vid][lock]=0;
    veh[vid][sellmoney]=0;
    veh[vid][paintjob]=-1;
	for(new s=0;s<MAX_COM;s++)veh[vid][comp][s]=-1;
	veh[vid][addsiren]=0;
	veh[vid][type]=CAR_OWNER;
	format(Querys, sizeof(Querys),"INSERT INTO `"SQL_VEH"`(`uid`,`uname`,`gid`,`modelid`,`x`,`y`,`z`,`angle`,`interior`,`world`,`color_0`,`color_1`)VALUES ('%i','%s','%i','%i','%f','%f','%f','%f','%i','%i','%i','%i')",uidid,veh[vid][uname],groupid,models,xx,yy,zz,angled,interiorid,worldid,color1,color2);
	mysql_query(mysqlid,Querys);
	veh[vid][cid]=cache_insert_id();
	Iter_Add(veh,vid);
	CreateVehText(vid);
	return vid;
}
ACT::DeleteVeh(vehicle)
{
	if(veh[vehicle][type]==CAR_OWNER)
	{
	    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_VEH"` WHERE `cid` = '%i'",veh[vehicle][cid]);
	    mysql_query(mysqlid,Querys,false);
	    DestroyDynamic3DTextLabel(veh[vehicle][ctext]);
	    DestroyVehicle(vehicle);
	    Iter_Remove(veh,vehicle);
	}
	else
	{
	    PlayerFreeCar[veh[vehicle][player]]=-1;
		DestroyDynamic3DTextLabel(veh[vehicle][ctext]);
		DestroyVehicle(vehicle);
	    Iter_Remove(veh,vehicle);
	}
	return 1;
}
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
	{
		if(veh[vehicleid][type]==CAR_OWNER)
		{
		    if(veh[vehicleid][uid]==pdate[playerid][uid])
		    {
		        veh[vehicleid][paintjob]=paintjobid;
		        format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `paintjob` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",paintjobid,veh[vehicleid][cid]);
			    mysql_query(mysqlid,Querys,false);
			}
		}
	}
    return CallLocalFunction("Veh_OnVehiclePaintjob", "iii",playerid, vehicleid, paintjobid);
}
#if defined _ALS_OnVehiclePaintjob
   #undef OnVehiclePaintjob
#else
    #define _ALS_OnVehiclePaintjob
#endif
#define OnVehiclePaintjob Veh_OnVehiclePaintjob
forward OnVehiclePaintjob(playerid, vehicleid, paintjobid);

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
	{
		if(veh[vehicleid][type]==CAR_OWNER)
		{
		    if(veh[vehicleid][uid]==pdate[playerid][uid])
		    {
		        veh[vehicleid][color][0]=color1;
		        veh[vehicleid][color][0]=color2;
		        format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `color_0` =  '%i'  `color_1` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",color1, color2,veh[vehicleid][cid]);
			    mysql_query(mysqlid,Querys,false);
			}
		}
	}
    return CallLocalFunction("Veh_OnVehicleRespray", "iiii",playerid, vehicleid, color1, color2);
}
#if defined _ALS_OnVehicleRespray
   #undef OnVehicleRespray
#else
    #define _ALS_OnVehicleRespray
#endif
#define OnVehicleRespray Veh_OnVehicleRespray
forward Veh_OnVehicleRespray(playerid, vehicleid, color1, color2);

public OnVehicleMod(playerid, vehicleid, componentid)
{
	if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
	{
		if(veh[vehicleid][type]==CAR_OWNER)
		{
		    if(veh[vehicleid][uid]==pdate[playerid][uid])
		    {
				if(IsVehicleComponentLegal(vehicleid, componentid))SaveComp(vehicleid,componentid);
				else
				{
					RemoveVehicleComponent(vehicleid, componentid);
					return 0;
				}
			}
		}
	}
	else
	{
  		RemoveVehicleComponent(vehicleid, componentid);
		return 0;
	}
	return CallLocalFunction("Veh_OnVehicleMod", "iii",playerid, vehicleid, componentid);
}
#if defined _ALS_OnVehicleMod
   #undef OnVehicleMod
#else
    #define _ALS_OnVehicleMod
#endif
#define OnVehicleMod Veh_OnVehicleMod
forward Veh_OnVehicleMod(playerid, vehicleid, componentid);
ACT::SaveComp(vehicleid,componentid)
{
	for(new s=0; s<20; s++)
	{
		if(componentid == spoiler[s][0])
		{
       		veh[vehicleid][comp][0]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_0` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<3; s++)
	{
     	if(componentid == nitro[s][0])
        {
       		veh[vehicleid][comp][1]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_1` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<23; s++)
	{
     	if(componentid == fbumper[s][0])
		{
       		veh[vehicleid][comp][2]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_2` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<22; s++)
	{
     	if(componentid == rbumper[s][0])
		{
       		veh[vehicleid][comp][3]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_3` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<28; s++)
	{
     	if(componentid == exhaust[s][0])
		{
       		veh[vehicleid][comp][4]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_4` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<2; s++)
	{
     	if(componentid == bventr[s][0])
		{
       		veh[vehicleid][comp][5]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_5` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<2; s++)
	{
     	if(componentid == bventl[s][0])
		{
       		veh[vehicleid][comp][6]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_6` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<4; s++)
	{
     	if(componentid == bscoop[s][0])
		{
       		veh[vehicleid][comp][7]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_7` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<17; s++)
	{
		if(componentid == rscoop[s][0])
		{
			veh[vehicleid][comp][8]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_8` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
		}
	}
	for(new s=0; s<21; s++)
	{
     	if(componentid == lskirt[s][0])
		{
       		veh[vehicleid][comp][9]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_9` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<21; s++)
	{
     	if(componentid == rskirt[s][0])
		{
       		veh[vehicleid][comp][10]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_10` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
		}
	}
	for(new s=0; s<1; s++)
	{
     	if(componentid == hydraulics[s][0])
		{
       		veh[vehicleid][comp][11]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_11` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<1; s++)
	{
     	if(componentid == bases[s][0])
		{
       		veh[vehicleid][comp][12]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_12` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<4; s++)
	{
     	if(componentid == rbbars[s][0])
		{
       		veh[vehicleid][comp][13]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_13` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<2; s++)
	{
     	if(componentid == fbbars[s][0])
		{
       		veh[vehicleid][comp][14]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_14` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<17; s++)
	{
     	if(componentid == wheels[s][0])
		{
       		veh[vehicleid][comp][15]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_15` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	for(new s=0; s<2; s++)
	{
     	if(componentid == lights[s][0])
		{
       		veh[vehicleid][comp][16]=componentid;
			format(Querys, sizeof(Querys),"UPDATE `"SQL_VEH"` SET  `comp_16` =  '%i' WHERE  `SQL_VEH`.`cid` ='%i'",componentid,veh[vehicleid][cid]);
			mysql_query(mysqlid,Querys,false);
   	    }
	}
	return 1;
}
public OnPlayerConnect(playerid)
{
    PlayerFreeCar[playerid]=-1;
	return CallLocalFunction("Veh_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Veh_OnPlayerConnect
forward Veh_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	if(PlayerFreeCar[playerid]!=-1)
	{
	    DestroyDynamic3DTextLabel(veh[PlayerFreeCar[playerid]][ctext]);
		DestroyVehicle(PlayerFreeCar[playerid]);
	    Iter_Remove(veh,PlayerFreeCar[playerid]);
		PlayerFreeCar[playerid]=-1;
	}
	return CallLocalFunction("Veh_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Veh_OnPlayerDisconnect
forward Veh_OnPlayerDisconnect(playerid, reason);

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(Login[playerid])
	{
		if(newstate==PLAYER_STATE_DRIVER)
		{
		    new carid=GetPlayerVehicleID(playerid);
		    new string[100];
			if(veh[carid][type]==CAR_OWNER)
			{
			    if(veh[carid][uid]==pdate[playerid][uid])
			    {
			        format(string,sizeof(string),"你进入了你的爱车 %s,请安全驾驶",VehName[veh[carid][modelids]-400]);
			        SendClientMessage(playerid,COLOR_TIP,string);
			    }
			    else
				{
					if(veh[carid][lock])
				    {
				        SetVehicleParamsEx(carid,0,0,0,1,0,0,0);
				        format(string,sizeof(string),"%的爱车 %s已上锁,无法进入",veh[carid][uname],VehName[veh[carid][modelids]-400]);
				        SendClientMessage(playerid,COLOR_TIP,string);
				    }
				    else
				    {
					    format(string,sizeof(string),"你进入了 %s 的爱车 %s,请安全驾驶",veh[carid][uname],VehName[veh[carid][modelids]-400]);
						SendClientMessage(playerid,COLOR_WARNING,string);
					}
				}
			}
			else
			{
			    if(carid==PlayerFreeCar[playerid])
			    {
					format(string,sizeof(string),"你进入了你的临时载具 %s ,请安全驾驶",VehName[veh[carid][modelids]-400]);
					SendClientMessage(playerid,COLOR_WARNING,string);
			    }
			    else
			    {
					format(string,sizeof(string),"你进入了 %s 的临时载具 %s,请安全驾驶",Pname[veh[carid][player]],VehName[veh[carid][modelids]-400]);
					SendClientMessage(playerid,COLOR_WARNING,string);
			    }
			}
		}
	}
	return CallLocalFunction("Veh_OnPlayerStateChange", "iii",playerid, newstate, oldstate);
}
#if defined _ALS_OnPlayerStateChange
   #undef OnPlayerStateChange
#else
    #define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange Veh_OnPlayerStateChange
forward Veh_OnPlayerStateChange(playerid, newstate, oldstate);

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(Login[playerid])
	{

	}
	return CallLocalFunction("Veh_OnPlayerEnterVehicle", "iii",playerid, vehicleid, ispassenger);
}
#if defined _ALS_OnPlayerEnterVehicle
   #undef OnPlayerEnterVehicle
#else
    #define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle Veh_OnPlayerEnterVehicle
forward Veh_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(Login[playerid])
	{

	}
    return CallLocalFunction("Veh_OnPlayerExitVehicle", "ii",playerid, vehicleid);
}
#if defined _ALS_OnPlayerExitVehicle
   #undef OnPlayerExitVehicle
#else
    #define _ALS_OnPlayerExitVehicle
#endif
#define OnPlayerExitVehicle Veh_OnPlayerExitVehicle
forward Veh_OnPlayerExitVehicle(playerid, vehicleid);

ACT::ShowAllVeh(playerid,pages)
{
	if(!Iter_Count(veh))return SendClientMessage(playerid,COLOR_WARNING,"没有载具总记录");
    current_number[playerid]=1;
  	foreach(new i:veh)
	{
        current_idx[playerid][current_number[playerid]]=i;
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"没有上一页");
	}
	else page[playerid]=pages;
	if(pages>floatround(Iter_Count(veh)/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"没有该页");
		page[playerid]=1;
	}
	new string[60];
	format(string,sizeof(string),"载具总记录-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_allveh,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_AllVeh_RetrunStr(playerid,page[playerid]), "传送", "返回");
	return 1;
}
Dialog_AllVeh_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "编号\t模型\t类型\t车主\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[100],tmps[32];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"{00FF00}%i\t",current_idx[playerid][i]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"{FF00FF}%i\t",veh[current_idx[playerid][i]][modelids]);
            strcat(tmp,tmps);
            if(veh[current_idx[playerid][i]][type]==CAR_OWNER)format(tmps,sizeof(tmps),"{33FF00}爱车\t");
            else format(tmps,sizeof(tmps),"{33FF00}临时载具\t");
            strcat(tmp,tmps);
            if(veh[current_idx[playerid][i]][type]==CAR_OWNER)format(tmps,sizeof(tmps),"{00AAFF}%s\n",veh[current_idx[playerid][i]][uname]);
            else format(tmps,sizeof(tmps),"{00AAFF}%s\n",Pname[veh[current_idx[playerid][i]][player]]);
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
Dialog:dl_allveh(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowAllVeh(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowAllVeh(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			LetVehHere(playerid,listid);
		}
	}
	else
	{

	}
	return 1;
}
ACT::ShowVehMain(playerid)
{
/*	new vid=GetPlayerVehicleID();
	if(veh[vid][type]==CAR_OWNER)
	{
	    if(veh[vid][uid]!=pdate[playerid][uid])return 1;
	    
	}
	else
	{
	    if(veh[vid][player]!=playerid)return 1;
	    
	}
	SetPVarInt(playerid,"Veh_Current_ID",vid);
	new caption[64],string[512],str[100],engine,lights,alarm,doors,boonet,boot,objective;
	format(caption,sizeof(caption), "ID[%]载具管理");
	strcat(str,"车门控制/n");
	strcat(str,"车窗控制/n");
	GetVehicleParamsEx(vid,engine,lights,alarm,doors,boonet,boot,objective);
	format(str,sizeof(str),"{00FF00}%i\t",current_idx[playerid][i]);
	Dialog_Show(i,dl_veh_main,DIALOG_STYLE_LIST,caption,"车门控制/n车窗控制/n车灯[]/n后备箱[]/车锁[]","OK","NO");*/
	return 1;
}
#include WD3/Veh/Veh_Cmd.pwn

