public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(Login[playerid])
	{
	    if(PRESSED(KEY_NO))
		{
		    new index=GetAreaID(playerid);
            if(index!=-1)
            {
				new caption[80];
				format(caption,sizeof(caption),"%s  创建者 %s",gang[index][g_name],GetUidName(gang[index][g_uid]));
				Dialog_Show(playerid,dl_gang_main,DIALOG_STYLE_TABLIST,caption,GangMenuStr(playerid,index), "确定", "返回");
            }
		}
	}
	return CallLocalFunction("Gang_OnPlayerKeyStateChange","iii",playerid, newkeys, oldkeys);
}
#if defined _ALS_OnPlayerKeyStateChange
   #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange Gang_OnPlayerKeyStateChange
forward Gang_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);

public OnPlayerConnect(playerid)
{
    SetPVarInt(playerid,"Gang_Join_ID",-1);
    PGA[playerid]=-1;
	return CallLocalFunction("Gang_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Gang_OnPlayerConnect
forward Gang_OnPlayerConnect(playerid);


public OnPlayerDisconnect(playerid, reason)
{
    SetPVarInt(playerid,"Gang_Join_ID",-1);
    PGA[playerid]=-1;
	return CallLocalFunction("Gang_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Gang_OnPlayerDisconnect
forward Gang_OnPlayerDisconnect(playerid,reason);

public OnGameModeInit()
{
	LoadGangs();
	return CallLocalFunction("Gang_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Gang_OnGameModeInit
forward Gang_OnGameModeInit();

ACT::GetAreaID(playerid)
{
	if(pdate[playerid][gid]==-1)return -1;
	if(!IsPlayerInAnyDynamicArea(playerid))return -1;
	foreach(new i:gang)
	{
	    if(IsPlayerInDynamicArea(playerid,gang[i][g_area]))return i;
	}
	return -1;
}

ACT::SendGangMsg(index,strys[])
{
	new string[256];
	format(string,sizeof(string),"[公司]%s",strys);
    foreach(new i:Player)
    {
        if(Login[i])
        {
            if(pdate[i][gid]!=-1)
            {
            	if(gang[pdate[i][gid]][g_id]==gang[index][g_id])SendClientMessage(i,-1,string);
            }
        }
    }
	return 1;
}
ACT::GlobalSendGangMsg(index,strys[])
{
	new string[256];
	format(string,sizeof(string),"[%s 公司]%s",gang[index][g_name],strys);
	SendClientMessageToAll(-1,string);
	return 1;
}
ACT::GetGangID(index)
{
	foreach(new i:gang)if(index==gang[i][g_id])return i;
	return -1;
}
ACT::LoadGangs()
{
    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_GANG"`");
    mysql_tquery(mysqlid, Querys, "OnGangsLoad");
	return 1;
}
ACT::OnGangsLoad()
{
	new rows=cache_get_row_count(mysqlid),str[32];
	for(new i=0;i<rows;i++)
	{
		if(i<MAX_GANGS)
		{
		    gang[i][g_id]=cache_get_field_content_int(i,"g_id");
		    gang[i][g_cash]=cache_get_field_content_int(i,"g_cash");
		    gang[i][g_maxplayer]=cache_get_field_content_int(i,"g_maxplayer");
		    gang[i][g_uid]=cache_get_field_content_int(i,"g_uid");
		    gang[i][g_color]=cache_get_field_content_int(i,"g_color");
		    gang[i][g_level]=cache_get_field_content_int(i,"g_level");
		    gang[i][g_score]=cache_get_field_content_int(i,"g_score");
		    gang[i][g_pic_model]=cache_get_field_content_int(i,"g_pic_model");
		    gang[i][g_map_model]=cache_get_field_content_int(i,"g_map_model");
		    gang[i][g_zb_x]=cache_get_field_content_float(i,"g_zb_x");
		    gang[i][g_zb_y]=cache_get_field_content_float(i,"g_zb_y");
		    gang[i][g_zb_z]=cache_get_field_content_float(i,"g_zb_z");
		    gang[i][g_zb_in]=cache_get_field_content_int(i,"g_zb_in");
		    gang[i][g_zb_wl]=cache_get_field_content_int(i,"g_zb_wl");
		    gang[i][g_areadis]=cache_get_field_content_float(i,"g_areadis");
		    gang[i][g_areaenter]=cache_get_field_content_int(i,"g_areaenter");
		    gang[i][g_areagun]=cache_get_field_content_int(i,"g_areagun");
		    gang[i][g_areacar]=cache_get_field_content_int(i,"g_areacar");
		    gang[i][g_areafurn]=cache_get_field_content_int(i,"g_areafurn");
		    cache_get_field_content(i,"g_name",gang[i][g_name],mysqlid,80);
		    cache_get_field_content(i,"g_createdate",gang[i][g_createdate],mysqlid,80);
		    cache_get_field_content(i,"g_opendate",gang[i][g_opendate],mysqlid,64);
		    cache_get_field_content(i,"g_music",gang[i][g_music],mysqlid,256);
		    gang[i][g_open]=false;
		    for(new x=0;x<MAX_GANGS_LEVEL;x++)
			{
			    format(str, sizeof(str),"glevelname_%i",x);
				cache_get_field_content(i,str,glevelname[i][x],mysqlid,80);
				format(str, sizeof(str),"glevelcolour_%i",x);
				glevelcolour[i][x]=cache_get_field_content_int(i,str);
			}
		    Iter_Add(gang,i);
		}
		else printf("公司读取达到上限 %i",MAX_GANGS);
	}
	foreach(new c:gang)CreateGang(c);
    return 1;
}
ACT::CreateGang(index)
{
	gang[index][g_3d]=CreateDynamic3DTextLabel(Gang3DreturnStr(index),colors[gang[index][g_color]],gang[index][g_zb_x],gang[index][g_zb_y],gang[index][g_zb_z],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,gang[index][g_zb_wl],gang[index][g_zb_in],-1,STREAMER_3D_TEXT_LABEL_SD);
	gang[index][g_area]=CreateDynamicSphere(gang[index][g_zb_x],gang[index][g_zb_y],gang[index][g_zb_z],gang[index][g_areadis],gang[index][g_zb_wl],gang[index][g_zb_in]);
	gang[index][g_pic]=CreateDynamicPickup(gang[index][g_pic_model],1,gang[index][g_zb_x],gang[index][g_zb_y],gang[index][g_zb_z]+2,gang[index][g_zb_wl],gang[index][g_zb_in]);
	gang[index][g_map]=CreateDynamicMapIcon(gang[index][g_zb_x],gang[index][g_zb_y],gang[index][g_zb_z],gang[index][g_map_model],-1,gang[index][g_zb_wl],gang[index][g_zb_in],-1,500,MAPICON_LOCAL);
    return 1;
}
ACT::AddGang(playerid,named[],Float:xx,Float:yy,Float:zz,iin,wwl)
{
    new i=Iter_Free(gang);
    gang[i][g_cash]=0;
    gang[i][g_uid]=pdate[playerid][uid];
    gang[i][g_color]=1;
    gang[i][g_level]=1;
    gang[i][g_pic_model]=14467;
    gang[i][g_map_model]=58;
    gang[i][g_zb_x]=xx;
    gang[i][g_zb_y]=yy;
    gang[i][g_zb_z]=zz;
    gang[i][g_zb_in]=iin;
    gang[i][g_zb_wl]=wwl;
    gang[i][g_areadis]=5.0;
	gang[i][g_areaenter]=0;
	gang[i][g_areagun]=0;
	gang[i][g_areacar]=0;
	gang[i][g_areafurn]=0;
    gang[i][g_maxplayer]=10;
    gang[i][g_score]=0;
    format(gang[i][g_name],80,"%s",named);
    format(gang[i][g_music],256,"NULL");
    
    format(glevelname[i][0],80,"实习");
    format(glevelname[i][1],80,"员工");
    format(glevelname[i][2],80,"主任");
    format(glevelname[i][3],80,"经理");
    format(glevelname[i][4],80,"董事长");
    for(new x=0;x<MAX_GANGS_LEVEL;x++)glevelcolour[i][x]=1;
    
	new time[3], date[3];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(gang[i][g_createdate],80,"%d/%d/%d-%d:%d:%d",date[0],date[1],date[2], time[0], time[1], time[2]);
	

	format(Querys, sizeof(Querys),"INSERT INTO `"SQL_GANG"`(`g_name`,`g_uid`,`g_zb_x`,`g_zb_y`,`g_zb_z`,`g_createdate`)VALUES ('%s','%i','%0.3f','%0.3f','%0.3f','%s','%s')",gang[i][g_name],gang[i][g_uid],gang[i][g_zb_x],gang[i][g_zb_y],gang[i][g_zb_z],gang[i][g_createdate]);
	mysql_query(mysqlid,Querys);
	gang[i][g_id]=cache_insert_id();
    gang[i][g_open]=false;
 	Iter_Add(gang,i);
	SetGang(playerid,gang[i][g_id],4,1000);
	CreateGang(i);
    return 1;
}
ACT::UpdateGangMusic(index,musicd[])
{
	format(gang[index][g_music],256,musicd);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `g_music`='%s' WHERE  `"SQL_GANG"`.`g_id` ='%i'",gang[index][g_music],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateGangMapIcon(index,iconid)
{
	gang[index][g_map_model]=iconid;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `g_map_model`='%i' WHERE  `"SQL_GANG"`.`g_id` ='%i'",gang[index][g_map_model],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
	DestroyDynamicMapIcon(gang[index][g_map]);
	gang[index][g_map]=CreateDynamicMapIcon(gang[index][g_zb_x],gang[index][g_zb_y],gang[index][g_zb_z],gang[index][g_map_model],-1,gang[index][g_zb_wl],gang[index][g_zb_in],-1,500,MAPICON_LOCAL);
    return 1;
}
ACT::UpdateGangName(index,named[])
{
	format(gang[index][g_name],80,named);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `g_name`='%s' WHERE  `"SQL_GANG"`.`g_id` ='%i'",gang[index][g_name],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
	UpdateGang3D(index);
    return 1;
}
ACT::UpdateGangCash(index,cashes)
{
	gang[index][g_cash]+=cashes;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `g_cash`='%i' WHERE  `"SQL_GANG"`.`g_id` ='%i'",gang[index][g_cash],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
	UpdateGang3D(index);
    return 1;
}
ACT::UpdateGangColor(index,colours)
{
	gang[index][g_color]=colours;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `g_color`='%i' WHERE  `"SQL_GANG"`.`g_id` ='%i'",gang[index][g_color],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
	UpdateGang3D(index);
    return 1;
}
ACT::UpdateGangLevelName(index,idxc,named[])
{
	format(glevelname[index][idxc],80,named);
	new string[64];
	format(string,64,"glevelname_%i",idxc);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `%s`='%s' WHERE  `"SQL_GANG"`.`g_id` ='%i'",string,glevelname[index][idxc],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateGangLevelColor(index,idxc,colours)
{
	glevelcolour[index][idxc]=colours;
	new string[64];
	format(string,64,"glevelcolour_%i",idxc);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `%s`='%i' WHERE  `"SQL_GANG"`.`g_id` ='%i'",string,glevelcolour[index][idxc],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateGangScore(index,cashes)
{
	gang[index][g_score]+=cashes;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `g_score`='%i' WHERE  `"SQL_GANG"`.`g_id` ='%i'",gang[index][g_score],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
	UpdateGang3D(index);
    return 1;
}
ACT::UpdateOpendate(index,datess[])
{
	format(gang[index][g_opendate],64,datess);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `g_opendate`='%s' WHERE  `"SQL_GANG"`.`g_id` ='%i'",gang[index][g_opendate],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateGangPos(index,Float:xx,Float:yy,Float:zz,iin,wwl)
{
    gang[index][g_zb_x]=xx;
    gang[index][g_zb_y]=yy;
    gang[index][g_zb_z]=zz;
    gang[index][g_zb_in]=iin;
    gang[index][g_zb_wl]=wwl;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `g_zb_x`='%0.3f',`g_zb_y`='%0.3f',`g_zb_z`='%0.3f',`g_zb_in`='%i',`g_zb_wl`='%i' WHERE  `"SQL_GANG"`.`g_id` ='%i'",gang[index][g_zb_x],gang[index][g_zb_y],gang[index][g_zb_z],gang[index][g_zb_in],gang[index][g_zb_wl],gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::DeleteGang(index)
{
	DestroyDynamicArea(gang[index][g_area]);
	DestroyDynamic3DTextLabel(gang[index][g_3d]);
	DestroyDynamicMapIcon(gang[index][g_map]);
	DestroyDynamicPickup(gang[index][g_pic]);
	return 1;
}
ACT::UpdateGang3D(index)return UpdateDynamic3DTextLabelText(gang[index][g_3d],colors[gang[index][g_color]],Gang3DreturnStr(index));

ACT::RemoveGang(index)
{
    DeleteGang(index);
	format(Querys,sizeof(Querys),"DELETE FROM `"SQL_GANG"` WHERE `g_id` = '%i'",gang[index][g_id]);
	mysql_query(mysqlid,Querys,false);
    Iter_Remove(gang,index);
}
Gang3DreturnStr(index)
{
	new string[1024],str[100];
	format(str, sizeof(str),"%s\n",gang[index][g_name]);
	strcat(string,str);
	format(str, sizeof(str),"创建者:%s\n",GetUidName(gang[index][g_uid]));
	strcat(string,str);
	format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ACCOUNT"` WHERE `gid` = '%i'",gang[index][g_id]);
	mysql_query(mysqlid, Querys);
	format(str, sizeof(str),"人数:%i/%i\n",cache_get_row_count(mysqlid),gang[index][g_maxplayer]);
	strcat(string,str);
	format(str, sizeof(str),"资金:%i\n",gang[index][g_cash]);
	strcat(string,str);
	format(str, sizeof(str),"积分:%i\n",gang[index][g_score]);
	strcat(string,str);
	if(!gang[index][g_open])format(str, sizeof(str),"未开业\n");
	else format(str, sizeof(str),"开业中\n");
	strcat(string,str);
	format(str, sizeof(str),"ID:%i[%i]",gang[index][g_id],index);
	strcat(string,str);
	return string;
}

Dialog:dl_player_gang_none(playerid, response, listitem, inputtext[])
{
	if(response)Dialog_Show(playerid,dl_player_add_msg,DIALOG_STYLE_INPUT,"创建公司","是否在此地创建公司公布,创建一个公司需要 $100000,请输入公司名称","确定","返回");
	else ShowAllGang(playerid,1);
	return 1;
}
Dialog:dl_player_add_msg(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strlen(inputtext)<4||strlen(inputtext)>40)return Dialog_Show(playerid,dl_player_add_msg,DIALOG_STYLE_INPUT,"字符错误","是否在此地创建公司公布,创建一个公司需要 $100000","确定","返回");
		if(pdate[playerid][cash]<100000)return SendClientMessage(playerid,COLOR_WARNING,"你的现金没有那麽多");
        if(GetPlayerVirtualWorld(playerid)!=0||GetPlayerInterior(playerid)!=0)return SendClientMessage(playerid,COLOR_WARNING,"你必须在大世界创建");
        GiveCash(playerid,-100000);
		new Float:x1x,Float:y1y,Float:z1z;
		GetPlayerPos(playerid,x1x,y1y,z1z);
        AddGang(playerid,inputtext,x1x,y1y,z1z,0,0);
	}
	return 1;
}
ACT::ShowAllGang(playerid,pages)
{
	if(!Iter_Count(gang))return SendClientMessage(playerid,COLOR_WARNING,"没有公司总记录");
    current_number[playerid]=1;
  	foreach(new i:gang)
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
	if(pages>floatround(Iter_Count(gang)/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"没有该页");
		page[playerid]=1;
	}
	new string[60];
	format(string,sizeof(string),"公司总记录-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_allgang,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_AllGang_RetrunStr(playerid,page[playerid]), "传送", "返回");
	return 1;
}
Dialog_AllGang_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "编号\t名称\t创始人\t人数\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[100],tmps[32];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"{00FF00}%i\t",gang[current_idx[playerid][i]][g_id]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"{FF00FF}%s\t",gang[current_idx[playerid][i]][g_name]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"{33FF00}%s\t",GetUidName(gang[current_idx[playerid][i]][g_uid]));
            strcat(tmp,tmps);
			format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ACCOUNT"` WHERE `gid` = '%i'",gang[current_idx[playerid][i]][g_id]);
			mysql_query(mysqlid, Querys);
            format(tmps,sizeof(tmps),"{00AAFF}%i/%i\n",cache_get_row_count(mysqlid),gang[current_idx[playerid][i]][g_maxplayer]);
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
ShowGangInfo(index)
{
	new string[1024],str[100];
	
	format(str, sizeof(str),"公司总览\n");
	strcat(string,str);
	format(str, sizeof(str),"创建时间:%s\n",gang[index][g_createdate]);
	strcat(string,str);
	format(str, sizeof(str),"公司资金:$%i\n",gang[index][g_cash]);
	strcat(string,str);
	format(str, sizeof(str),"公司积分:$%i\n",gang[index][g_score]);
	strcat(string,str);
	format(str, sizeof(str),"公司人员:\n");
	strcat(string,str);
	format(Querys, sizeof(Querys),"SELECT * FROM `"SQL_ACCOUNT"` WHERE `gid` = '%i' ORDER BY `glevel` DESC",gang[index][g_id]);
	mysql_query(mysqlid, Querys);
	new counts=cache_get_row_count(mysqlid);
	new strd[80];
    for(new i=0;i<counts;i++)
	{
		cache_get_field_content(i,"name",strd,mysqlid,80);
		format(str, sizeof(str),"姓名: %s\t职称: %s\t贡献: %i",strd,glevelname[index][cache_get_field_content_int(i,"glevel")],cache_get_field_content_int(i,"gscore"));
		strcat(string,str);
	}
	return string;
}
Dialog:dl_gang_join(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Gang_Current_ID");
		format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ACCOUNT"` WHERE `gid` = '%i'",gang[listid][g_id]);
		mysql_query(mysqlid, Querys);
		if(cache_get_row_count(mysqlid)>=gang[listid][g_maxplayer])return SendClientMessage(playerid,COLOR_WARNING,"该公司人员已满,无法加入");
		format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ACCOUNT"` WHERE `gid` = '%i' AND  `glevel` > '3'",gang[listid][g_id]);
		mysql_query(mysqlid, Querys);
		new string[128],ids=0;
		for(new i=0;i<cache_get_row_count(mysqlid);i++)
		{
		    new olid=IsUidLogin(cache_get_field_content_int(i,"uid"));
		    if(olid!=-1)
		    {
		        format(string,sizeof(string),"%s 请求加入你的公司,同意请/accpet join",Pname[playerid]);
		     	SendClientMessage(olid,COLOR_TIP,string);
		     	SetPVarInt(olid,"Gang_Join_ID",pdate[playerid][uid]);
		     	ids++;
		    }
		}
		if(ids==0)
		{
		    format(string,sizeof(string),"%s 公司没有在线的高管",gang[listid][g_name]);
		    return SendClientMessage(playerid,COLOR_TIP,string);
		}
		else return SendClientMessage(playerid,COLOR_TIP,"对方公司高管已接收到");
	}
	return 1;
}
Dialog:dl_allgang(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowAllGang(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowAllGang(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			new caption[80];
			format(caption,sizeof(caption),"%s  创建者 %s",gang[listid][g_name],GetUidName(gang[listid][g_uid]));
			Dialog_Show(playerid,dl_gang_join,DIALOG_STYLE_MSGBOX,caption,ShowGangInfo(listid),"加入","返回");
			SetPVarInt(playerid,"Gang_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
ACT::AcceptPlayerGangJoin(playerid)
{
	new listid=GetPVarInt(playerid,"Gang_Join_ID");
	new players=IsUidLogin(listid);
	if(players==-1)return SendClientMessage(playerid,COLOR_TIP,"对方没有在线");
	if(pdate[players][gid]!=-1)return SendClientMessage(playerid,COLOR_TIP,"对方已加入了你的或其它公司");
	SetGang(players,gang[pdate[players][gid]][g_id],0,0);
	return 1;
}
GangMenuStr(playerid,index)
{
	new string[1024],str[100];
	format(str, sizeof(str),"公司总览\t\n");
	strcat(string,str);
	format(str, sizeof(str),"公司资金\t$%i\n",gang[index][g_cash]);
	strcat(string,str);
	format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ACCOUNT"` WHERE `gid` = '%i'",gang[index][g_id]);
	mysql_query(mysqlid, Querys);
	format(str, sizeof(str),"公司人员\t%i/%i\n",cache_get_row_count(mysqlid),gang[index][g_maxplayer]);
	strcat(string,str);
	format(str, sizeof(str),"公司签到\t\n");
	strcat(string,str);
	format(str, sizeof(str),"退出公司\t\n");
	strcat(string,str);
	if(pdate[playerid][glevel]>3)
	{
		format(str, sizeof(str),"公司开业\t\n");
		strcat(string,str);
		format(str, sizeof(str),"公司集合\t\n");
		strcat(string,str);
		format(str, sizeof(str),"公司颜色\t\n");
		strcat(string,str);
		format(str, sizeof(str),"公司名称\t$10000\n");
		strcat(string,str);
		format(str, sizeof(str),"公司阶级\t\n");
		strcat(string,str);
		format(str, sizeof(str),"地图图标\t$50000\n");
		strcat(string,str);
		format(str, sizeof(str),"总部标志\t\n");
		strcat(string,str);
		format(str, sizeof(str),"公司地盘\t\n");
		strcat(string,str);
	}
    if(gang[index][g_uid]==pdate[playerid][uid])
    {
		format(str, sizeof(str),"解散公司\t\n");
		strcat(string,str);
    }
	return string;
}
Dialog:dl_gang_main(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new caption[80];
		format(caption,sizeof(caption),"%s  创建者 %s",gang[pdate[playerid][gid]][g_name],GetUidName(gang[pdate[playerid][gid]][g_uid]));
		switch(listitem)
		{
		    case 0:Dialog_Show(playerid,dl_gang_info,DIALOG_STYLE_MSGBOX,caption,ShowGangInfo(pdate[playerid][gid]),"关闭","");
            case 1:
			{
			    new string[128];
			    format(string, sizeof(string),"公司账户当前资金: $%i",gang[pdate[playerid][gid]][g_cash]);
				Dialog_Show(playerid,dl_gang_cash,DIALOG_STYLE_MSGBOX,string,string,"存入","取出");
			}
            case 2:GangMemberShow(playerid,1);
            case 3:
			{
                new time[3], date[3],string[80];
    			getdate(date[0],date[1],date[2]);
				gettime(time[0], time[1], time[2]);
    			format(string,sizeof(string),"%d%d%d",date[0],date[1],date[2]);
    			if(strcmp(pdate[playerid][gsign],string,false))
				{
				    SetGangSign(playerid,string);
				    UpdateGangScore(pdate[playerid][gid],1);
				    SetGang(playerid,gang[pdate[playerid][gid]][g_id],pdate[playerid][glevel],pdate[playerid][gscore]+1);
				    format(string,sizeof(string),"%s 签到了,公司积分+1,贡献+1",Pname[playerid]);
				    SendGangMsg(pdate[playerid][gid],string);
	 			}
	 			else SendClientMessage(playerid,COLOR_WARNING,"你今天已经签到了");
            }
            case 4:
			{
			    if(gang[pdate[playerid][gid]][g_uid]==pdate[playerid][uid])return SendClientMessage(playerid,COLOR_TIP,"你是创建者,你只能使用解散公司");
                new gindex=pdate[playerid][gid];
				SetGang(playerid,-1,0,0);
				UpdateGang3D(gindex);
				new string[128];
				format(string,sizeof(string),"%s 退出了公司",Pname[playerid]);
				SendGangMsg(gindex,string);
            }
            case 5:
            {
                if(!gang[pdate[playerid][gid]][g_open])
                {
                    new time[3], date[3],string[80];
    				getdate(date[0],date[1],date[2]);
					gettime(time[0], time[1], time[2]);
    				format(string,sizeof(string),"%d%d%d",date[0],date[1],date[2]);
    				if(strcmp(gang[pdate[playerid][gid]][g_opendate],string,false))
					{
						UpdateGangScore(pdate[playerid][gid],10);
						UpdateOpendate(pdate[playerid][gid],string);
						format(string,sizeof(string),"开业了,公司积分+10",Pname[playerid]);
					}
					else format(string,sizeof(string),"开业了",Pname[playerid]);
					GlobalSendGangMsg(pdate[playerid][gid],string);
					gang[pdate[playerid][gid]][g_open]=true;
					UpdateGang3D(pdate[playerid][gid]);
                }
                else
                {
                    gang[pdate[playerid][gid]][g_open]=false;
                    UpdateGang3D(pdate[playerid][gid]);
                    new string[64];
					format(string,sizeof(string),"歇业了",Pname[playerid]);
					GlobalSendGangMsg(pdate[playerid][gid],string);
                }
            }
            case 6:
            {
    			new Float:x1x,Float:y1y,Float:z1z,Float:a1a;
				GetPlayerPos(playerid,x1x,y1y,z1z);
				GetPlayerFacingAngle(playerid,a1a);
			    foreach(new i:Player)
			    {
			        if(Login[i])
			        {
			            if(pdate[i][gid]!=-1)
			            {
			            	if(pdate[i][gid]==pdate[playerid][gid])
							{
							    if(pdate[i][glevel]<pdate[playerid][glevel])SetPPos(i,x1x,y1y,z1z,a1a,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),3,0);
							}
			            }
			        }
			    }
            }
            case 7:Dialog_Show(playerid,dl_gang_color,DIALOG_STYLE_LIST,"公司颜色",ShowColorStr(),"选择","取消");
            case 8:Dialog_Show(playerid,dl_gang_change_name,DIALOG_STYLE_INPUT,"公司改名","请输入要更改的名称","选择","取消");
			case 9:Dialog_Show(playerid,dl_level_change,DIALOG_STYLE_LIST,"公司阶级",GangLevelStr(pdate[playerid][gid]),"修改","返回");
            case 10:Dialog_Show(playerid,dl_gang_change_mapicon,DIALOG_STYLE_LIST,"地图图标",GangMapIconStr(),"选择","取消");
            case 11:
            {
            }
            case 12:Dialog_Show(playerid,dl_gang_change_area,DIALOG_STYLE_TABLIST,"公司地盘",GangAreaMenuStr(pdate[playerid][gid]),"选择","取消");
            case 13:
			{
			    new index=pdate[playerid][gid];
			    foreach(new i:Player)
			    {
					if(pdate[i][gid]!=-1)
			        {
			            if(pdate[i][gid]==index)
						{
						    pdate[i][gid]=-1;
						    pdate[i][glevel]=0;
						    pdate[i][gscore]=0;
						}
					}
			    }
				format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `gid` =  '-1',`glevel` =  '0',`gscore` =  '0' WHERE  `"SQL_ACCOUNT"`.`gid` ='%i'",gang[index][g_id]);
				mysql_query(mysqlid,Querys,false);
			    RemoveGang(index);
			}
		}
	}
	return 1;
}
GangAreaMenuStr(index)
{
	new string[1024],str[100];
	format(str, sizeof(str),"升级地盘\t$%i\n",floatround(gang[index][g_areadis]*10000));
	strcat(string,str);
	if(strcmp(gang[index][g_music],"NULL",false))format(str, sizeof(str),"地盘音乐\t开启中\n");
	else format(str, sizeof(str),"地盘音乐\t关闭中\n");
	strcat(string,str);
	if(gang[index][g_areaenter])format(str, sizeof(str),"地盘禁入[成员允许]\t开启中\n");
	else format(str, sizeof(str),"地盘禁入[成员允许]\t关闭中\n");
	strcat(string,str);
	if(gang[index][g_areagun])format(str, sizeof(str),"地盘禁枪[成员允许]\t开启中\n");
	else format(str, sizeof(str),"地盘禁枪[成员允许]\t关闭中\n");
	strcat(string,str);
	if(gang[index][g_areacar])format(str, sizeof(str),"地盘禁车[成员允许]\t开启中\n");
	else format(str, sizeof(str),"地盘禁车[成员允许]\t关闭中\n");
	strcat(string,str);
	if(gang[index][g_areafurn])format(str, sizeof(str),"地盘禁止家具[成员允许]\t开启中\n");
	else format(str, sizeof(str),"地盘禁止家具[成员允许]\t关闭中\n");
	strcat(string,str);
	return string;
}
Dialog:dl_gang_area_music(playerid, response, listitem, inputtext[])
{
    if(response)
    {
		if(strlen(inputtext)<4||strlen(inputtext)>128)return Dialog_Show(playerid,dl_gang_area_music,DIALOG_STYLE_INPUT,"地盘音乐","请输入音乐链接,每次消费$10000","确定","取消音乐");
        if(gang[pdate[playerid][gid]][g_cash]<10000)return SendClientMessage(playerid,COLOR_WARNING,"公司账面上没有这么多钱");
		UpdateGangCash(pdate[playerid][gid],-10000);
		UpdateGangMusic(pdate[playerid][gid],inputtext);
    }
    else UpdateGangMusic(pdate[playerid][gid],"NULL");
	return 1;
}
Dialog:dl_gang_change_area_dis(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new index=pdate[playerid][gid];
        if(gang[index][g_cash]<floatround(gang[index][g_areadis]*10000))return SendClientMessage(playerid,COLOR_WARNING,"公司账面上没有这么多钱");
        UpdateGangCash(pdate[playerid][gid],-floatround(gang[index][g_areadis]*10000));
		gang[index][g_areadis]=gang[index][g_areadis]*2;
		format(Querys, sizeof(Querys),"UPDATE `"SQL_GANG"` SET  `g_areadis`='%0.3f' WHERE  `"SQL_GANG"`.`g_id` ='%i'",gang[index][g_areadis],gang[index][g_id]);
		mysql_query(mysqlid,Querys,false);
		DestroyDynamicArea(gang[index][g_area]);
        gang[index][g_area]=CreateDynamicSphere(gang[index][g_zb_x],gang[index][g_zb_y],gang[index][g_zb_z],gang[index][g_areadis],gang[index][g_zb_wl],gang[index][g_zb_in]);

	}
	return 1;
}
Dialog:dl_gang_change_area(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(listitem)
        {
            case 0:
            {
                new string[128];
				format(string,sizeof(string),"升级公司地盘需要$%i,是否升级？",floatround(gang[pdate[playerid][gid]][g_areadis]*10000));
				Dialog_Show(playerid,dl_gang_change_area_dis,DIALOG_STYLE_MSGBOX,"公司地盘",string,"确定","取消");
            }
            case 1:Dialog_Show(playerid,dl_gang_area_music,DIALOG_STYLE_INPUT,"地盘音乐","请输入音乐链接,每次消费$10000","确定","取消音乐");
			case 2:
			{
			    if(gang[pdate[playerid][gid]][g_areaenter])gang[pdate[playerid][gid]][g_areaenter]=0;
			    else gang[pdate[playerid][gid]][g_areaenter]=1;
				format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `g_areaenter` =  '%i' WHERE  `"SQL_ACCOUNT"`.`gid` ='%i'",gang[pdate[playerid][gid]][g_areaenter],gang[pdate[playerid][gid]][g_id]);
				mysql_query(mysqlid,Querys,false);
			}
			case 3:
			{
			    if(gang[pdate[playerid][gid]][g_areagun])gang[pdate[playerid][gid]][g_areagun]=0;
			    else gang[pdate[playerid][gid]][g_areagun]=1;
				format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `g_areaenter` =  '%i' WHERE  `"SQL_ACCOUNT"`.`gid` ='%i'",gang[pdate[playerid][gid]][g_areagun],gang[pdate[playerid][gid]][g_id]);
				mysql_query(mysqlid,Querys,false);
			}
			case 4:
			{
			    if(gang[pdate[playerid][gid]][g_areacar])gang[pdate[playerid][gid]][g_areacar]=0;
			    else gang[pdate[playerid][gid]][g_areacar]=1;
				format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `g_areaenter` =  '%i' WHERE  `"SQL_ACCOUNT"`.`gid` ='%i'",gang[pdate[playerid][gid]][g_areacar],gang[pdate[playerid][gid]][g_id]);
				mysql_query(mysqlid,Querys,false);
			}
			case 5:
			{
			    if(gang[pdate[playerid][gid]][g_areafurn])gang[pdate[playerid][gid]][g_areafurn]=0;
			    else gang[pdate[playerid][gid]][g_areafurn]=1;
				format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `g_areaenter` =  '%i' WHERE  `"SQL_ACCOUNT"`.`gid` ='%i'",gang[pdate[playerid][gid]][g_areafurn],gang[pdate[playerid][gid]][g_id]);
				mysql_query(mysqlid,Querys,false);
			}
        }
    }
	return 1;
}
Dialog:dl_gang_change_mapicon(playerid, response, listitem, inputtext[])
{
    if(response)
    {
		if(gang[pdate[playerid][gid]][g_cash]<50000)return SendClientMessage(playerid,COLOR_WARNING,"公司账面上没有这么多钱");
        UpdateGangMapIcon(pdate[playerid][gid],MapIcon[listitem][Icon_Id]);
        UpdateGangCash(pdate[playerid][gid],-50000);
    }
	return 1;
}
Dialog:dl_level_change(playerid, response, listitem, inputtext[])
{
    if(response)
    {
    	Dialog_Show(playerid,dl_level_change_main,DIALOG_STYLE_TABLIST,"修改选项","修改颜色\t2000\n修改名称\t5000\n", "确定", "返回");
        SetPVarInt(playerid,"Gang_Level_Current_ID",listitem);
    }
	return 1;
}
Dialog:dl_level_change_main(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(listitem)
        {
            case 0:Dialog_Show(playerid,dl_level_change_color,DIALOG_STYLE_LIST,"阶级颜色",ShowColorStr(),"选择","取消");
            case 1:Dialog_Show(playerid,dl_level_change_name,DIALOG_STYLE_INPUT,"阶级名称","请输入要更改的阶级名称","选择","取消");
        }
	}
	return 1;
}
Dialog:dl_level_change_color(playerid, response, listitem, inputtext[])
{
    if(response)
    {
		if(gang[pdate[playerid][gid]][g_cash]<2000)return SendClientMessage(playerid,COLOR_WARNING,"公司账面上没有这么多钱");
		new listid=GetPVarInt(playerid,"Gang_Level_Current_ID");
		UpdateGangLevelColor(pdate[playerid][gid],listid,listitem+1);
        UpdateGangCash(pdate[playerid][gid],-2000);
	}
	return 1;
}
Dialog:dl_level_change_name(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext)<4||strlen(inputtext)>40)return Dialog_Show(playerid,dl_level_change_name,DIALOG_STYLE_INPUT,"阶级名称","请输入要更改的阶级名称","选择","取消");
		if(gang[pdate[playerid][gid]][g_cash]<5000)return SendClientMessage(playerid,COLOR_WARNING,"公司账面上没有这么多钱");
        new listid=GetPVarInt(playerid,"Gang_Level_Current_ID");
		UpdateGangLevelName(pdate[playerid][gid],listid,inputtext);
        UpdateGangCash(pdate[playerid][gid],-5000);
	}
	return 1;
}
Dialog:dl_gang_change_name(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext)<4||strlen(inputtext)>40)return Dialog_Show(playerid,dl_gang_change_name,DIALOG_STYLE_INPUT,"公司改名","请输入要更改的名称","选择","取消");
		if(gang[pdate[playerid][gid]][g_cash]<10000)return SendClientMessage(playerid,COLOR_WARNING,"公司账面上没有这么多钱");
		UpdateGangName(pdate[playerid][gid],inputtext);
		UpdateGangCash(pdate[playerid][gid],-10000);
    }
 	return 1;
}
Dialog:dl_gang_color(playerid, response, listitem, inputtext[])
{
	if(response)UpdateGangColor(pdate[playerid][gid],listitem+1);
    return 1;
}
	
ACT::GangMemberShow(playerid,pages)
{
	format(Querys, sizeof(Querys),"SELECT * FROM `"SQL_ACCOUNT"` WHERE `gid` = '%i' ORDER BY `glevel` DESC",gang[pdate[playerid][gid]][g_id]);
    mysql_tquery(mysqlid, Querys, "OnPlayerGangMemberMenu", "ii",playerid,pages);
	return 1;
}
ACT::OnPlayerGangMemberMenu(playerid,pages)
{
	new rows=cache_get_row_count(mysqlid);
	if(!rows)return SendClientMessage(playerid,COLOR_WARNING,"没有成员");
    current_number[playerid]=1;
  	for(new i=0;i<rows;i++)
	{
        current_idx[playerid][current_number[playerid]]=cache_get_field_content_int(i, "uid");
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
	format(caption,sizeof(caption), "成员名\t阶级\t贡献\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST;i++)
	{
	    new tmp[128],tmps[80],senders[80];
		if(i<current_number[playerid])
		{
			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",current_idx[playerid][i]);
    		mysql_query(mysqlid, Querys);
    		new players=IsUidLogin(current_idx[playerid][i]);
    		if(players!=-1)
    		{
			    cache_get_field_content(0,"name",senders,mysqlid,80);
	            format(tmps,sizeof(tmps),"{00FF00}%s\t",senders);
	            strcat(tmp,tmps);
	           	format(tmps,sizeof(tmps),"{00FF00}%s\t",glevelname[pdate[playerid][gid]][cache_get_field_content_int(0,"glevel")]);
	            strcat(tmp,tmps);
	            format(tmps,sizeof(tmps),"{00FF00}%i\n",cache_get_field_content_int(0,"gscore"));
	            strcat(tmp,tmps);
			}
			else
			{
			    cache_get_field_content(0,"name",senders,mysqlid,80);
	            format(tmps,sizeof(tmps),"{33AA33}%s\t",senders);
	            strcat(tmp,tmps);
	           	format(tmps,sizeof(tmps),"{33AA33}%s\t",glevelname[pdate[playerid][gid]][cache_get_field_content_int(0,"glevel")]);
	            strcat(tmp,tmps);
	            format(tmps,sizeof(tmps),"{33AA33}%i\n",cache_get_field_content_int(0,"gscore"));
	            strcat(tmp,tmps);
			}
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
	format(str,sizeof(str),"%s 公司成员[%i],{00FF00}黄色:在线,{33AA33}绿色:离线",gang[pdate[playerid][gid]][g_name],rows);
	Dialog_Show(playerid,dl_gang_member_show,DIALOG_STYLE_TABLIST_HEADERS,str,string, "操作", "返回");
	return 1;
}
Dialog:dl_gang_member_show(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    GangMemberShow(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            GangMemberShow(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
            Dialog_Show(playerid,dl_gang_member_doing,DIALOG_STYLE_LIST,"成员操作","拉TA过来\n传送到TA\n提升阶级\nT出帮派","操作","返回");
            SetPVarInt(playerid,"Gang_Member_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
GangMapIconStr()
{
	new string[1024],str[100];
    for(new x=0;x<sizeof(MapIcon);x++)
	{
		format(str, sizeof(str), "%s\n",MapIcon[x][Icon_name]);
        strcat(string,str);
 	}
	return string;
}
GangLevelStr(index)
{
	new string[1024],str[100];
    for(new x=0;x<MAX_GANGS_LEVEL;x++)
	{
		format(str, sizeof(str), "%s%s\n",colorstr[glevelcolour[index][x]],glevelname[index][x]);
        strcat(string,str);
 	}
	return string;
}
Dialog:dl_gang_member_doing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Gang_Member_Current_ID");
	    if(pdate[playerid][uid]==listid)return SendClientMessage(playerid,COLOR_WARNING,"不能选择自己");
		format(Querys, sizeof(Querys), "SELECT `glevel` FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",listid);
    	mysql_query(mysqlid, Querys);
    	if(cache_get_field_content_int(0,"glevel")>pdate[playerid][glevel])return SendClientMessage(playerid,COLOR_WARNING,"对方阶级比你高,你没有权限操作");
	    switch(listitem)
	    {
	        case 0:
	        {
	            new players=IsUidLogin(listid);
    			if(players!=-1)return SendClientMessage(playerid,COLOR_WARNING,"对方没有在线");
    			new Float:x1x,Float:y1y,Float:z1z,Float:a1a;
				GetPlayerPos(playerid,x1x,y1y,z1z);
				GetPlayerFacingAngle(playerid,a1a);
				SetPPos(players,x1x,y1y,z1z,a1a,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),1,0);
	        }
	        case 1:
	        {
	            new players=IsUidLogin(listid);
    			if(players!=-1)return SendClientMessage(playerid,COLOR_WARNING,"对方没有在线");
    			new Float:x1x,Float:y1y,Float:z1z,Float:a1a;
				GetPlayerPos(players,x1x,y1y,z1z);
				GetPlayerFacingAngle(players,a1a);
				SetPPos(playerid,x1x,y1y,z1z,a1a,GetPlayerInterior(players),GetPlayerVirtualWorld(players),1,0);
	        }
	        case 2:
			{
	            if(pdate[playerid][glevel]>3)Dialog_Show(playerid,dl_gang_member_level_do,DIALOG_STYLE_LIST,"成员操作",GangLevelStr(pdate[playerid][gid]),"操作","返回");
				else return SendClientMessage(playerid,COLOR_WARNING,"你没有权限这样做");
			}
			case 3:
	        {
	            if(pdate[playerid][glevel]>3)
				{
				    new players=IsUidLogin(listid);
				    if(players!=-1)SetGang(players,-1,0,0);
				    else
				    {
						format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `gid` =  '%i',`glevel` =  '%i',`gscore` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",-1,0,0,listid);
						mysql_query(mysqlid,Querys,false);
				    }
				    UpdateGang3D(pdate[playerid][gid]);
				    new string[128];
	    			format(string, sizeof(string),"%s 把你T出了公司 %s",Pname[playerid],gang[pdate[playerid][gid]][g_name]);
	    			SystemSendMsgToPlayer(listid,string,0);
	    			
					format(Querys, sizeof(Querys), "SELECT `name` FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",listid);
			    	mysql_query(mysqlid, Querys);
			    	new str[80];
			    	cache_get_field_content(0,"name",str,mysqlid,80);
				    format(string, sizeof(string),"%s 把 %s T出了公司 %s",Pname[playerid],str,gang[pdate[playerid][gid]][g_name]);
				    SendGangMsg(pdate[playerid][gid],string);
				}
				else return SendClientMessage(playerid,COLOR_WARNING,"你没有权限这样做");
	        }
	    }
	}
	return 1;
}
Dialog:dl_gang_member_level_do(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Gang_Member_Current_ID");
		new players=IsUidLogin(listid);
		if(players!=-1)SetGang(players,gang[pdate[playerid][gid]][g_id],listitem,pdate[players][gscore]);
		else
		{
			format(Querys, sizeof(Querys),"UPDATE `"SQL_ACCOUNT"` SET  `gid` =  '%i',`glevel` =  '%i',`gscore` =  '%i' WHERE  `"SQL_ACCOUNT"`.`uid` ='%i'",gang[pdate[playerid][gid]][g_id],listitem,pdate[players][gscore],listid);
			mysql_query(mysqlid,Querys,false);
		}
		new string[128];
	    format(string, sizeof(string),"%s 调整你的阶级为 %s",Pname[playerid],glevelname[gang[pdate[playerid][gid]][g_id]][listitem]);
	    SystemSendMsgToPlayer(listid,string,0);
	    
		format(Querys, sizeof(Querys), "SELECT `name` FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",listid);
    	mysql_query(mysqlid, Querys);
    	new str[80];
    	cache_get_field_content(0,"name",str,mysqlid,80);
	    format(string, sizeof(string),"%s 调整 %s 的阶级为 %s",Pname[playerid],str,glevelname[gang[pdate[playerid][gid]][g_id]][listitem]);
	    SendGangMsg(pdate[playerid][gid],string);
	}
	return 1;
}
Dialog:dl_gang_cash_give(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strval(inputtext)<1)return Dialog_Show(playerid,dl_gang_cash_give, DIALOG_STYLE_INPUT,"存入","请输入存入金额","确定","取消");
		if(pdate[playerid][cash]<strval(inputtext))return Dialog_Show(playerid,dl_gang_cash_give, DIALOG_STYLE_INPUT,"你没有那么多钱","请输入存入金额","确定","取消");
    	GiveCash(playerid,-strval(inputtext));
    	UpdateGangCash(pdate[playerid][gid],strval(inputtext));
    	SetGang(playerid,gang[pdate[playerid][gid]][g_id],pdate[playerid][glevel],pdate[playerid][gscore]+floatround(strval(inputtext)/100));
    }
    return 1;
}
Dialog:dl_gang_cash(playerid, response, listitem, inputtext[])
{
	if(response)Dialog_Show(playerid,dl_gang_cash_give, DIALOG_STYLE_INPUT,"存入","请输入存入金额","确定","取消");
	else
	{
	    if(gang[pdate[playerid][gid]][g_uid]==pdate[playerid][uid])Dialog_Show(playerid,dl_gang_cash_get, DIALOG_STYLE_INPUT,"取出","请输入取出的金额","确定","取消");
		else SendClientMessage(playerid,COLOR_WARNING,"你没有权限操作");
	}
	return 1;
}
GangAreaEnterStr(playerid,index)
{
	if(strcmp(gang[index][g_music],"NULL",false))PlayAudioStreamForPlayer(playerid,gang[index][g_music]);
	new string[1024],str[100];
	if(pdate[playerid][gid]==index)format(str, sizeof(str),"你进入了你的公司 %s 范围内,按N键 公司菜单\n",gang[index][g_name]);
    else format(str, sizeof(str),"你进入了公司 %s 范围内\n",gang[index][g_name]);
    strcat(string,str);
	if(gang[index][g_areaenter])
	{
		format(str, sizeof(str),"地盘禁入[成员允许]\n");
		strcat(string,str);
	}
	if(gang[index][g_areagun])
	{
		format(str, sizeof(str),"地盘禁枪[成员允许]\n");
		strcat(string,str);
	}
	if(!gang[index][g_areacar])
	{
		format(str, sizeof(str),"地盘禁车[成员允许]\n");
		strcat(string,str);
	}
	if(!gang[index][g_areafurn])
	{
		format(str, sizeof(str),"地盘禁止家具[成员允许]\n");
		strcat(string,str);
	}
	return SendClientMessage(playerid,COLOR_WARNING,string);
}
ACT::OnplayerEnterGangArea(playerid,areaid)
{
	foreach(new i:gang)
	{
	    if(gang[i][g_area]==areaid)
	    {
	        if(pdate[playerid][gid]!=i)
	        {
		        if(gang[i][g_areaenter])
				{
	   				SetPlayerWorldBounds(playerid,20.0, 0.0, 20.0, 0.0);
	   				PGA[playerid]=i;
				}
			}
			GangAreaEnterStr(playerid,i);
	        /*if(!gang[i][g_areagun])SetPlayerArmedWeapon(playerid,0);
	        if(!gang[i][g_areacar])SetPlayerArmedWeapon(playerid,0);
	        if(!gang[i][g_areacar])SetPlayerArmedWeapon(playerid,0);*/
	    }
	}
	return 1;
}
ACT::OnplayerLeaveGangArea(playerid,areaid)
{
	if(areaid==PGA[playerid])SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
	return 1;
}
#include WD3/Gang/Gang_Cmd.pwn

