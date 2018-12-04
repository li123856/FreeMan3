#include <a_samp>
#include <a_http>
#include <crashdetect>
#include <YSI\y_iterate>
#include <YSI\y_areas>
#include <YSI\y_groups>
#include <YSI\y_timers>
#include <YSI\y_commands>
#include <streamer>
#include <a_mysql>
#include <sscanf2>
#include <IsKeyDown>
#include <easyDialog>
#include <mSelection>

#include WD3/Public/Define.pwn
#include WD3/Public/Custom.pwn
#include WD3/Public/Common.pwn
#include WD3/Public/Function.pwn
#include WD3/Public/Cmd.pwn


public OnGameModeInit()
{
	//MapAndreas_Init(MAP_ANDREAS_MODE_FULL);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL );
 	ShowNameTags(1);
	LimitPlayerMarkerRadius(99999.0);
	LimitGlobalChatRadius(99999.0);
	DisableInteriorEnterExits();
	AllowInteriorWeapons(1);
	EnableStuntBonusForAll(0);
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT,1000);
	return 1;
}
public OnGameModeExit()
{
    //MapAndreas_Unload();
	return 1;
}

public OnPlayerConnect(playerid)
{
    Login[playerid]=false;
	return 1;
}

public OnPlayerRequestClass(playerid, classid)return 1;



public OnPlayerRequestSpawn(playerid)return 0;

public OnPlayerDisconnect(playerid, reason)
{
    Pname[playerid]=" ";
	Reg[playerid]=false;
	Duty[playerid]=false;
	WrongPass[playerid]=0;
	for(new i;userinfo:i<userinfo;i++)pdate[playerid][userinfo:i]=0;
    Login[playerid]=false;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(Login[playerid])
	{
	    if(pdm[playerid][pdm_id]==-1)
	    {
			if(!pdate[playerid][location])
		 	{
		 		new rand=random(sizeof(RandomSpawns));
		 		SetSpawnInfo(playerid,NO_TEAM,pdate[playerid][skinid],RandomSpawns[rand][0],RandomSpawns[rand][1],RandomSpawns[rand][2],RandomSpawns[rand][3],0,0,0,0,0,0);
		    }
		    else
		    {
				SetPlayerVirtualWorld(playerid,pdate[playerid][world]);
				SetPlayerInterior(playerid,pdate[playerid][interior]);
				SetSpawnInfo(playerid,NO_TEAM,pdate[playerid][skinid],pdate[playerid][spawn][0],pdate[playerid][spawn][1],pdate[playerid][spawn][2],pdate[playerid][spawn][3],0,0,0,0,0,0);
			}
		}
		else
		{
		    new index=pdm[playerid][pdm_id];
		    new mapid=dm[index][dm_map];
		    SetSpawnInfo(playerid,pdm[playerid][pdm_team],dmteam[index][pdm[playerid][pdm_team]][dmt_skin],dmpspawn[mapid][pdm[playerid][pdm_team]][dms_x],dmpspawn[mapid][pdm[playerid][pdm_team]][dms_y],dmpspawn[mapid][pdm[playerid][pdm_team]][dms_z],dmpspawn[mapid][pdm[playerid][pdm_team]][dms_a],0,0,0,0,0,0);
			if(killerid!=INVALID_PLAYER_ID&&killerid!=playerid&&pdm[killerid][pdm_id]==pdm[playerid][pdm_id]&&pdm[killerid][pdm_team]!=pdm[playerid][pdm_team])
			{
				pdm[playerid][pdm_death]++;
    			dmteam[pdm[playerid][pdm_id]][pdm[playerid][pdm_team]][dmt_death]++;
				pdm[killerid][pdm_kill]++;
				pdm[killerid][pdm_score]++;
				dmteam[pdm[killerid][pdm_id]][pdm[killerid][pdm_team]][dmt_kill]++;
    			dmteam[pdm[killerid][pdm_id]][pdm[killerid][pdm_team]][dmt_score]++;
    			new string[128];
    			format(string,sizeof(string),"[%s 房间]队伍%i 的%s 击杀了队伍%i 的%s ,个人积分+1,团队积分+1",dm[index][dm_name],pdm[killerid][pdm_team]+1,Pname[killerid],pdm[playerid][pdm_team]+1,Pname[playerid]);
    			SendDMRoomMsg(index,string);
			}
		}
	}
	return 1;
}
public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(Login[playerid])
	{
	    new pText[1024];
	    if(pdm[playerid][pdm_id]==-1)
	    {
		    new string[384],str[256];
		    if(pdate[playerid][gid]!=-1)
		    {
	    		format(pText,sizeof(pText),"%s[%s]%s[%s]",colorstr[gang[pdate[playerid][gid]][g_color]],gang[pdate[playerid][gid]][g_name],colorstr[glevelcolour[pdate[playerid][gid]][pdate[playerid][glevel]]],glevelname[pdate[playerid][gid]][pdate[playerid][glevel]]);
				strcat(pText,str);
		    }
		    format(str,sizeof(str),"%s%s:",colorstr[pdate[playerid][colorid]],Pname[playerid]);
		    strcat(pText,str);
		    format(string,sizeof(string),"{FFFFFF}%s",text);
		    strcat(pText,string);
		    if(pdate[playerid][depictcolorid]!=-1)
			{
				format(string,sizeof(string)," %s%s",colorstr[pdate[playerid][depictcolorid]],pdate[playerid][depict]);
			    strcat(pText,string);
		    }
		    SendClientMessageToAll(-1,pText);
	    }
	    else
	    {
  			format(pText,sizeof(pText),"[%s 房间]队伍%i %s:%s",dm[pdm[playerid][pdm_id]][dm_name],pdm[playerid][pdm_team]+1,Pname[playerid],text);
  			SendDMRoomMsg(pdm[playerid][pdm_id],pText);
	    }
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}


public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
 	if(Login[playerid])
	{
	    if(Login[clickedplayerid])
	 	{
	    	if(clickedplayerid==playerid)
			{
   				if(pdm[playerid][pdm_id]==-1)CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/stats");
	    		else CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/dminfo");
			}
	    	if(IsAdminLevel(playerid,ADMIN_SMALL))return 1;
	    	if(IsAdminLevel(clickedplayerid,ADMIN_SMALL))return 1;
	    	Dialog_Show(playerid,dl_clickedplayer_doing,DIALOG_STYLE_TABLIST,"菜单","发送邮件\t\n加为好友\t\n请求传送\t\n拉TA过来\t", "确定", "返回");
            SetPVarInt(playerid,"Clickedplayer_Current_ID",clickedplayerid);
		}
		else SendClientMessage(playerid,COLOR_WARNING,"对方不在线");
	}
	return 1;
}
public OnDialogPerformed(playerid, dialog[], response, success)
{
	return 1;
}
ACT::OnDialogShow(playerid,function[])
{
	if(Dialog_IsOpened(playerid))return 0;
	switch(Pedit[playerid])
	{
	    case PLAYER_EDIT_FURN_TXD:
	    {
			if(PlayerFurn[playerid]!=-1)
			{
				if(Editid[playerid]!=-1)
				{
				    if(strcmp("dl_furn_buy_txd",function,false))
				    {
		 				format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",Editid[playerid]);
						mysql_query(mysqlid, Querys);
						new nname[80],string[128];
						cache_get_field_content(0,"names",nname,mysqlid,80);
						format(string, sizeof(string),"是否购买此材质 %s,价格 $%i",nname,cache_get_field_content_int(0,"cash"));
						Dialog_Show(playerid,dl_furn_buy_txd,DIALOG_STYLE_MSGBOX,"购买家具材质",string,"购买","取消");
						return 0;
					}
				}
			}
			else
			{
				Pedit[playerid]=PLAYER_EDIT_NONE;
				PlayerFurn[playerid]=-1;
			}
	    }
	    case PLAYER_EDIT_HOUSE_DEC:
	    {
	        if(Editid[playerid]!=-1)
			{
				if(strcmp("dl_house_buy_dec",function,false))
				{
				    new index=GetPlayerVirtualWorld(playerid);
				    new houseidx=index-HOUSE_LIMTS;
					if(Iter_Contains(house,houseidx))
					{
					    if(house[houseidx][h_uid]==pdate[playerid][uid])
					    {
							format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_DEC"` WHERE `id` = '%i' LIMIT 1",Editid[playerid]);
	    					mysql_query(mysqlid, Querys);
	   						new nname[80],string[128];
							cache_get_field_content(0,"name",nname,mysqlid,80);
							format(string, sizeof(string),"是否购买此装潢 %s,价格 $%i",nname,cache_get_field_content_int(0,"worth"));
							Dialog_Show(playerid,dl_house_buy_dec,DIALOG_STYLE_MSGBOX,"购买装潢",string,"购买","取消");
					    }
						else
						{
							pEnter[playerid]=true;
       						SetPPos(playerid,house[houseidx][h_ix],house[houseidx][h_iy],house[houseidx][h_iz],house[houseidx][h_ia],house[houseidx][h_iin],house[houseidx][h_iwl],0.5,2);
							SendClientMessage(playerid,COLOR_WARNING,"这不是你的房子");
                            Pedit[playerid]=PLAYER_EDIT_NONE;
                            Editid[playerid]=-1;
						}
						return 0;
					}
				}
	  		}
		}
	    case PLAYER_EDIT_HOUSE_BUY:
	    {
	        if(Editid[playerid]!=-1)
			{
				if(strcmp("dl_house_in_buy",function,false))
				{
				    new index=GetPlayerVirtualWorld(playerid);
				    new houseidx=index-HOUSE_LIMTS;
					if(Iter_Contains(house,houseidx))
					{
		                if(houseidx==Editid[playerid])
		                {
		                    new string[128];
							format(string, sizeof(string),"是否购买房子 %s ？",house[houseidx][h_name]);
		                    Dialog_Show(playerid,dl_house_in_buy,DIALOG_STYLE_MSGBOX,"购买",string, "购买", "取消");
		                }
		                else
						{
						    Pedit[playerid]=PLAYER_EDIT_NONE;
						    Editid[playerid]=-1;
						}
						return 0;
					}
				}
	  		}
		}
	}
	return 1;
}
public OnPlayerModelSelectionEx(playerid, response, extraid, modelid2)
{
    if(!Login[playerid])return 1;
    switch(extraid)
    {
        case CUSTOM_TRAILER_MENU:
        {
		    if(response)
		    {
	    		if(!IsValidVehicleModel(modelid2))return SendClientMessage(playerid,COLOR_WARNING,"车型ID无效");
				new Float:xx,Float:yy,Float:zz,Float:angled;
				GetPlayerPos(playerid,xx,yy,zz);
				GetPlayerFacingAngle(playerid,angled);
				PutPlayerInVehicle(playerid,AddFreeVeh(playerid,modelid2,xx,yy,zz+0.8,angled,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,-1),0);
			}
        }
        case CUSTOM_SKIN_MENU:
        {
		    if(response)
		    {
		        if(!IsValidSkin(modelid2))return SendClientMessage(playerid,COLOR_WARNING,"皮肤ID无效");
				SetSkin(playerid,modelid2);
			}
        }
        case CUSTOM_DM_SKIN_MENU:
        {
		    if(response)
		    {
		        if(!IsValidSkin(modelid2))return SendClientMessage(playerid,COLOR_WARNING,"皮肤ID无效");
				dmteam[pdm[playerid][pdm_id]][GetPVarInt(playerid,"skin_slot_select")][dmt_skin]=modelid2;
				Dialog_Show(playerid,dl_dmroom_skin,DIALOG_STYLE_TABLIST,"皮肤配置",ShowDMRoomSkinStr(pdm[playerid][pdm_id]), "确定", "返回");
			}
            else Dialog_Show(playerid,dl_dmroom_skin,DIALOG_STYLE_TABLIST,"皮肤配置",ShowDMRoomSkinStr(pdm[playerid][pdm_id]), "确定", "返回");
        }
    }
	return 1;
}
public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(!Login[playerid])return 1;
	EditFurnPos(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
	EditFurnMove(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
	return 1;
}
public OnPlayerEditAttachedObject( playerid, response, index, modelid, boneid,Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(!Login[playerid])return 1;
    EditPlayerAtt( playerid, response, index, modelid, boneid,Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ);
	return 1;
}
public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA areaid)
{
	if(!Login[playerid])return 1;
	OnplayerEnterHouseDoor(playerid,areaid);
	OnplayerEnterHouseObjDoor(playerid,areaid);
	OnplayerEnterGangArea(playerid,areaid);
	OnplayerEnterPlayerArea(playerid,areaid);
	return 1;
}
public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA areaid)
{
    if(!Login[playerid])return 1;
	OnplayerLeaveHouseDoor(playerid,areaid);
	OnplayerLeaveHouseObjDoor(playerid,areaid);
	OnplayerLeaveGangArea(playerid,areaid);
	OnplayerLeavePlayerArea(playerid,areaid);
	return 1;
}
public OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP checkpointid)
{
	if(!Login[playerid])return 1;
	OnplayerEnterRaceMap(playerid,checkpointid);
    return 1;
}
public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	if(!Login[playerid])return 1;
	OnplayerEnterRaceCp(playerid,checkpointid);
    return 1;
}
