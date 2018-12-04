#include WD3/Area/Areas_Define.pwn
#include WD3/Area/Areas_Custom.pwn
public OnGameModeInit()
{
	LoadAreasMap();
	return CallLocalFunction("Area_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Area_OnGameModeInit
forward Area_OnGameModeInit();
public OnPlayerConnect(playerid)
{
    AAA[playerid]=-1;
    editarea[playerid][area_id]=-1;
	return CallLocalFunction("Area_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Area_OnPlayerConnect
forward Area_OnPlayerConnect(playerid);


public OnPlayerDisconnect(playerid, reason)
{
    AAA[playerid]=-1;
	if(editarea[playerid][area_id]!=-1)stop editarea[playerid][area_timer];
    editarea[playerid][area_id]=-1;
	return CallLocalFunction("Area_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Area_OnPlayerDisconnect
forward Area_OnPlayerDisconnect(playerid,reason);

ACT::LoadAreasMap()
{
    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_AREA"`");
    mysql_tquery(mysqlid, Querys, "OnAreasLoad");
	return 1;
}
ACT::OnAreasLoad()
{
	new rows=cache_get_row_count(mysqlid);
	for(new i=0;i<rows;i++)
	{
		if(i<MAX_GLOBAL_AREAS)
		{
		    arear[i][a_id]=cache_get_field_content_int(i,"a_id");
		    arear[i][a_uid]=cache_get_field_content_int(i,"a_uid");
		    arear[i][a_color]=cache_get_field_content_int(i,"a_color");
		    arear[i][a_in]=cache_get_field_content_int(i,"a_in");
		    arear[i][a_wl]=cache_get_field_content_int(i,"a_wl");
		    arear[i][a_furn]=cache_get_field_content_int(i,"a_furn");
		    arear[i][a_car]=cache_get_field_content_int(i,"a_car");
		    arear[i][a_comein]=cache_get_field_content_int(i,"a_comein");
		    arear[i][a_minx]=cache_get_field_content_float(i,"a_minx");
		    arear[i][a_miny]=cache_get_field_content_float(i,"a_miny");
		    arear[i][a_minz]=cache_get_field_content_float(i,"a_minz");
		    arear[i][a_maxx]=cache_get_field_content_float(i,"a_maxx");
		    arear[i][a_maxy]=cache_get_field_content_float(i,"a_maxy");
		    arear[i][a_maxz]=cache_get_field_content_float(i,"a_maxz");
		    cache_get_field_content(i,"a_name",arear[i][a_name],mysqlid,80);
		    cache_get_field_content(i,"a_des",arear[i][a_des],mysqlid,128);
		    cache_get_field_content(i,"a_music",arear[i][a_music],mysqlid,129);
		    cache_get_field_content(i,"a_createtime",arear[i][a_createtime],mysqlid,80);
		    Iter_Add(arear,i);
		}
		else printf("领地读取达到上限 %i",MAX_GLOBAL_AREAS);
	}
	foreach(new c:arear)CreateAreaFace(c);
    return 1;
}
ACT::CreateAreaFace(index)
{
	arear[index][a_area]=CreateDynamicCube(arear[index][a_minx],arear[index][a_miny],arear[index][a_minz],arear[index][a_maxx],arear[index][a_maxy],arear[index][a_maxz],arear[index][a_wl],arear[index][a_in]);
	arear[index][a_zone]=GangZoneCreate(arear[index][a_minx],arear[index][a_miny],arear[index][a_maxx],arear[index][a_maxy]);
	GangZoneShowForAll(arear[index][a_zone],colors[arear[index][a_color]]);
    return 1;
}
ACT::DelAreaFace(index)
{
	DestroyDynamicArea(arear[index][a_area]);
	GangZoneDestroy(arear[index][a_zone]);
    return 1;
}
ACT::AddPlayerArea(playerid,named[],Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz)
{
	new i=Iter_Free(arear);
    if(i==-1)return -1;
    arear[i][a_minx]=minx;
    arear[i][a_miny]=miny;
    arear[i][a_minz]=minz;
    arear[i][a_maxx]=maxx;
    arear[i][a_maxy]=maxy;
    arear[i][a_maxz]=maxz;
    arear[i][a_in]=GetPlayerInterior(playerid);
	arear[i][a_wl]=GetPlayerVirtualWorld(playerid);
	arear[i][a_color]=1;
	arear[i][a_uid]=pdate[playerid][uid];
	format(arear[i][a_name],80,named);
	format(arear[i][a_des],128,"NULL");
	format(arear[i][a_music],128,"NULL");
	new time[3], date[3];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(arear[i][a_createtime],80,"%d年%d月%日%d时%d分",date[0],date[1],date[2], time[0], time[1]);
 	arear[i][a_furn]=1;
    arear[i][a_car]=1;
    arear[i][a_comein]=1;
	format(Querys, sizeof(Querys),"INSERT INTO `"SQL_AREA"`(`a_uid`,`a_name`,`a_createtime`,`a_in`,`a_wl`,`a_minx`,`a_miny`,`a_minz`,`a_maxx`,`a_maxy`,`a_maxz`)VALUES ('%i','%s','%s','%i','%i','%0.3f','%0.3f','%0.3f','%0.3f','%0.3f','%0.3f')"\
	,arear[i][a_uid],arear[i][a_name],arear[i][a_createtime],arear[i][a_in],arear[i][a_wl],arear[i][a_minx],arear[i][a_miny],arear[i][a_minz],arear[i][a_maxx],arear[i][a_maxy],arear[i][a_maxz]);
	mysql_query(mysqlid,Querys);
	arear[i][a_id]=cache_insert_id();
    Iter_Add(arear,i);
    CreateAreaFace(i);
    return 1;
}
ACT::RemovePlayerArea(index)
{
	DelAreaFace(index);
	format(Querys,sizeof(Querys),"DELETE FROM `"SQL_AREA"` WHERE `a_id` = '%i'",arear[index][a_id]);
	mysql_query(mysqlid,Querys,false);
	Iter_Remove(arear,index);
    return 1;
}
ACT::UpdateAreaName(index,named[])
{
	format(arear[index][a_name],80,named);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_AREA"` SET  `a_name`='%s' WHERE  `"SQL_AREA"`.`a_id` ='%i'",arear[index][a_name],arear[index][a_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateAreaColor(index,colord)
{
	arear[index][a_color]=colord;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_AREA"` SET  `a_color`='%i' WHERE  `"SQL_AREA"`.`a_id` ='%i'",arear[index][a_color],arear[index][a_id]);
	mysql_query(mysqlid,Querys,false);
	DelAreaFace(index);
	CreateAreaFace(index);
    return 1;
}
ACT::UpdateAreaRang(index,Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz)
{
    arear[index][a_minx]=minx;
    arear[index][a_miny]=miny;
    arear[index][a_minz]=minz;
    arear[index][a_maxx]=maxx;
    arear[index][a_maxy]=maxy;
    arear[index][a_maxz]=maxz;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_AREA"` SET  `a_minx`='%0.3f',`a_miny`='%0.3f',`a_minz`='%0.3f',`a_maxx`='%0.3f',`a_maxy`='%0.3f',`a_maxz`='%0.3f' WHERE  `"SQL_AREA"`.`a_id` ='%i'",arear[index][a_minx],arear[index][a_miny],arear[index][a_minz],arear[index][a_maxx],arear[index][a_maxy],arear[index][a_maxz],arear[index][a_id]);
	mysql_query(mysqlid,Querys,false);
	DelAreaFace(index);
	CreateAreaFace(index);
    return 1;
}
timer EditAreaRange[150](playerid,index)
{
	if(editarea[playerid][area_id]!=-1)
	{
		new Keys,UpDown,LeftRight;
	    GetPlayerKeys(playerid, Keys, UpDown, LeftRight);
        if(LeftRight == -128 && Keys == 8 )
        {
       		editarea[playerid][area_minx]+= 8.0;
          	GangZoneDestroy(arear[index][a_zone]);
       		arear[index][a_zone]=GangZoneCreate(editarea[playerid][area_minx],editarea[playerid][area_miny],editarea[playerid][area_maxx],editarea[playerid][area_maxy]);
         	GangZoneShowForPlayer(playerid,arear[index][a_zone],colors[arear[index][a_color]]);
        }
        else if(LeftRight == -128)
        {
            editarea[playerid][area_minx]-= 8.0;
          	GangZoneDestroy(arear[index][a_zone]);
       		arear[index][a_zone]=GangZoneCreate(editarea[playerid][area_minx],editarea[playerid][area_miny],editarea[playerid][area_maxx],editarea[playerid][area_maxy]);
         	GangZoneShowForPlayer(playerid,arear[index][a_zone],colors[arear[index][a_color]]);
        }
        else if(LeftRight==128 && Keys==8 )
        {
        	editarea[playerid][area_maxx]-= 8.0;
          	GangZoneDestroy(arear[index][a_zone]);
       		arear[index][a_zone]=GangZoneCreate(editarea[playerid][area_minx],editarea[playerid][area_miny],editarea[playerid][area_maxx],editarea[playerid][area_maxy]);
         	GangZoneShowForPlayer(playerid,arear[index][a_zone],colors[arear[index][a_color]]);
		}
        else if(LeftRight == 128)
        {
        	editarea[playerid][area_maxx]+= 8.0;
          	GangZoneDestroy(arear[index][a_zone]);
       		arear[index][a_zone]=GangZoneCreate(editarea[playerid][area_minx],editarea[playerid][area_miny],editarea[playerid][area_maxx],editarea[playerid][area_maxy]);
         	GangZoneShowForPlayer(playerid,arear[index][a_zone],colors[arear[index][a_color]]);
		}
		else if(UpDown==-128 && Keys==8 )
		{
		    editarea[playerid][area_maxy] -= 8.0;
          	GangZoneDestroy(arear[index][a_zone]);
       		arear[index][a_zone]=GangZoneCreate(editarea[playerid][area_minx],editarea[playerid][area_miny],editarea[playerid][area_maxx],editarea[playerid][area_maxy]);
         	GangZoneShowForPlayer(playerid,arear[index][a_zone],colors[arear[index][a_color]]);
		}
		else if(UpDown == -128)
		{
		    editarea[playerid][area_maxy] += 8.0;
          	GangZoneDestroy(arear[index][a_zone]);
       		arear[index][a_zone]=GangZoneCreate(editarea[playerid][area_minx],editarea[playerid][area_miny],editarea[playerid][area_maxx],editarea[playerid][area_maxy]);
         	GangZoneShowForPlayer(playerid,arear[index][a_zone],colors[arear[index][a_color]]);
		}
		else if(UpDown == 128 && Keys==8)
		{
		    editarea[playerid][area_miny] += 8.0;
          	GangZoneDestroy(arear[index][a_zone]);
       		arear[index][a_zone]=GangZoneCreate(editarea[playerid][area_minx],editarea[playerid][area_miny],editarea[playerid][area_maxx],editarea[playerid][area_maxy]);
         	GangZoneShowForPlayer(playerid,arear[index][a_zone],colors[arear[index][a_color]]);
		}
		else if(UpDown == 128)
		{
		    editarea[playerid][area_miny] -= 8.0;
          	GangZoneDestroy(arear[index][a_zone]);
       		arear[index][a_zone]=GangZoneCreate(editarea[playerid][area_minx],editarea[playerid][area_miny],editarea[playerid][area_maxx],editarea[playerid][area_maxy]);
         	GangZoneShowForPlayer(playerid,arear[index][a_zone],colors[arear[index][a_color]]);
		}
		else if(Keys == KEY_WALK)Dialog_Show(playerid,dl_areaeditwc, DIALOG_STYLE_LIST, "完成编辑", "保存编辑\n取消编辑", "确定", "取消");
	}
	return 1;
}

ACT::ShowMyArea(playerid,pages)
{
	if(!Iter_Count(arear))return SendClientMessage(playerid,COLOR_WARNING,"没有领地");
    current_number[playerid]=1;
    new counts=0;
  	foreach(new i:arear)
	{
	    if(arear[i][a_uid]==pdate[playerid][uid])
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
	format(string,sizeof(string),"我的领地-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_myarea,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_MyArea_RetrunStr(playerid,page[playerid]), "选择", "返回");
	return 1;
}
Dialog_MyArea_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "名称\t\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[384],tmps[128];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"%s\t\n",arear[current_idx[playerid][i]][a_name]);
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
Dialog:dl_myarea(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowMyArea(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowMyArea(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			new caption[100];
			format(caption,sizeof(caption), "领地 %s 操作",arear[listid][a_name]);
			Dialog_Show(playerid,dl_myarea_doing,DIALOG_STYLE_TABLIST,caption,AreaOwnerMenuStr(), "确定", "返回");
            SetPVarInt(playerid,"MyArea_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}

Dialog:dl_areaeditwc(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new index=editarea[playerid][area_id];
        stop editarea[playerid][area_timer];
		UpdateAreaRang(index,editarea[playerid][area_minx],editarea[playerid][area_miny],arear[index][a_minz],editarea[playerid][area_maxx],editarea[playerid][area_maxy],arear[index][a_maxz]);
	    editarea[playerid][area_id]=-1;
	}
	return 1;
}
Dialog:dl_myarea_doing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        switch(listitem)
        {
            case 0:
            {
                new index=GetPVarInt(playerid,"MyArea_Current_ID");
                SetPPos(playerid,arear[index][a_minx]+((arear[index][a_maxx]-arear[index][a_minx])/2),arear[index][a_miny]+((arear[index][a_maxy]-arear[index][a_miny])/2),arear[index][a_minz],0.0,arear[index][a_in],arear[index][a_wl],0.5,2);
            }
            case 1:Dialog_Show(playerid,dl_myarea_change_name,DIALOG_STYLE_INPUT,"更改名称","请输入要更改的名称","确定","取消");
            case 2:
            {
                new index=GetPVarInt(playerid,"MyArea_Current_ID");
                editarea[playerid][area_id]=index;
                editarea[playerid][area_minx]=arear[index][a_minx];
                editarea[playerid][area_miny]=arear[index][a_miny];
                editarea[playerid][area_maxx]=arear[index][a_maxx];
                editarea[playerid][area_maxy]=arear[index][a_maxy];
                editarea[playerid][area_timer]=repeat EditAreaRange[150](playerid,index);
            }
            case 3:Dialog_Show(playerid,dl_area_color,DIALOG_STYLE_LIST,"领地颜色",ShowColorStr(),"选择","取消");
            case 4:
            {
                new index=GetPVarInt(playerid,"MyArea_Current_ID");
                if(editarea[playerid][area_id]==index)return SendClientMessage(playerid,COLOR_WARNING,"你正在编辑无法删除");
				RemovePlayerArea(index);
			}
        }
	}
	return 1;
}
Dialog:dl_area_color(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new index=GetPVarInt(playerid,"MyArea_Current_ID");
		UpdateAreaColor(index,listitem+1);
	}
	return 1;
}
Dialog:dl_myarea_change_name(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(strlen(inputtext)<1||strlen(inputtext)>50)return Dialog_Show(playerid,dl_myarea_change_name,DIALOG_STYLE_INPUT,"更改名称","请输入要更改的名称","确定","取消");
		if(pdate[playerid][cash]<10000)return SendClientMessage(playerid,COLOR_WARNING,"你没有这么多现金");
        GiveCash(playerid,-10000);
        UpdateAreaName(GetPVarInt(playerid,"MyArea_Current_ID"),inputtext);
	}
	return 1;
}
AreaOwnerMenuStr()
{
	new string[1024],str[100];
	format(str, sizeof(str),"传送领地\t\n");
	strcat(string,str);
	format(str, sizeof(str),"更改名称\t$10000\n");
	strcat(string,str);
	format(str, sizeof(str),"编辑领地\t\n");
	strcat(string,str);
	format(str, sizeof(str),"更改颜色\t\n");
	strcat(string,str);
	format(str, sizeof(str),"删除领地\t\n");
	strcat(string,str);
	return string;
}
ACT::OnplayerEnterPlayerArea(playerid,areaid)
{
   	foreach(new i:arear)
	{
	    if(arear[i][a_area]==areaid)
		{
		    PlayerAreaEnterStr(playerid,i);
		    EnterAreaFun(playerid,i);
		}
	}
    return 1;
}
ACT::EnterAreaFun(playerid,index)
{
	if(arear[index][a_uid]!=pdate[playerid][uid])
	{
	    if(!arear[index][a_comein])
	    {
			SetPlayerWorldBounds(playerid,20.0, 0.0, 20.0, 0.0);
    		AAA[playerid]=index;
    	}
	}
    return 1;
}
ACT::OnplayerLeavePlayerArea(playerid,areaid)
{
	if(areaid==AAA[playerid])SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
	return 1;
}
PlayerAreaEnterStr(playerid,index)
{
	if(strcmp(arear[index][a_music],"NULL",false))PlayAudioStreamForPlayer(playerid,gang[index][g_music]);
	new string[1024],str[100];
	if(arear[index][a_uid]==pdate[playerid][uid])format(str, sizeof(str),"你进入了你的领地 %s 范围内[%iX%i],按N键 领地菜单\n",arear[index][a_name],floatround(arear[index][a_maxx]-arear[index][a_minx]),floatround(arear[index][a_maxy]-arear[index][a_miny]));
    else format(str, sizeof(str),"你进入了领地 %s 范围内[%iX%i],领主:%s\n",arear[index][a_name],floatround(arear[index][a_maxx]-arear[index][a_minx]),floatround(arear[index][a_maxy]-arear[index][a_miny]),GetUidName(arear[index][a_uid]));
    strcat(string,str);
	return SendClientMessage(playerid,COLOR_WARNING,string);
}
#include WD3/Area/Areas_Cmd.pwn

