#include WD3/Attach/Att_Define.pwn
#include WD3/Attach/Att_Custom.pwn

public OnGameModeInit()
{
	Iter_Init(att);
	return CallLocalFunction("Att_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Att_OnGameModeInit
forward Att_OnGameModeInit();

ACT::LoadPlayerAttachs(playerid)
{
	format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_ATT"` WHERE `uid` = '%i' LIMIT 1",pdate[playerid][uid]);
    mysql_tquery(mysqlid, Querys, "OnPlayerAttachLoad", "i", playerid);
	return 1;
}

ACT::OnPlayerAttachLoad(playerid)
{
	new string[80],str[1024],wused,wmodelid,wbone,Float:wfOffsetX,Float:wfOffsetY,Float:wfOffsetZ,Float:wfRotX,Float:wfRotY,Float:wfRotZ,Float:wfScaleX,Float:wfScaleY,Float:wfScaleZ,wmaterialcolor1,wmaterialcolor2,anames[80];
	for(new i=0;i<MAX_PLAYER_ATTACHED_OBJECTS-1;i++)
	{
	    format(string, sizeof(string),"slot_%i",i);
	    cache_get_field_content(0,string,str,mysqlid,1024);
	    sscanf(str, "p<&>iiifffffffffiis[80]",wused,wmodelid,wbone,wfOffsetX,wfOffsetY,wfOffsetZ,wfRotX,wfRotY,wfRotZ,wfScaleX,wfScaleY,wfScaleZ,wmaterialcolor1,wmaterialcolor2,anames);
	    if(wused==1)
	    {
	        att[playerid][i][aused]=wused;
	        att[playerid][i][amodelid]=wmodelid;
	        att[playerid][i][abone]=wbone;
	        att[playerid][i][afOffsetX]=wfOffsetX;
	        att[playerid][i][afOffsetY]=wfOffsetY;
	        att[playerid][i][afOffsetZ]=wfOffsetZ;
	        att[playerid][i][afRotX]=wfRotX;
	        att[playerid][i][afRotY]=wfRotY;
	        att[playerid][i][afRotZ]=wfRotZ;
	        att[playerid][i][afScaleX]=wfScaleX;
	        att[playerid][i][afScaleY]=wfScaleY;
	        att[playerid][i][afScaleZ]=wfScaleZ;
	        att[playerid][i][amaterialcolor1]=wmaterialcolor1;
	        att[playerid][i][amaterialcolor2]=wmaterialcolor2;
	        format(att[playerid][i][aname],80,anames);
	        Iter_Add(att[playerid],i);
	    }
	}
	return 1;
}
ACT::LoadPlayerAtt(playerid)
{
    foreach(new i:att[playerid])
    {
		SetPlayerAttachedObject(playerid,i
		,att[playerid][i][amodelid]
		,att[playerid][i][abone]
		,att[playerid][i][afOffsetX]
		,att[playerid][i][afOffsetY]
		,att[playerid][i][afOffsetZ]
		,att[playerid][i][afRotX]
		,att[playerid][i][afRotY]
		,att[playerid][i][afRotZ]
		,att[playerid][i][afScaleX]
		,att[playerid][i][afScaleY] 
		,att[playerid][i][afScaleZ]
		,ARGB(colors[att[playerid][i][amaterialcolor1]])
		,ARGB(colors[att[playerid][i][amaterialcolor2]])
		);
		printf("%i",i);
	}
	return 1;
}
ACT::AddAttToPlayer(playerid,modelid,bone,Float:fOffsetX,Float:fOffsetY,Float:fOffsetZ,Float:fRotX,Float:fRotY,Float:fRotZ,Float:fScaleX,Float:fScaleY,Float:fScaleZ,materialcolor1,materialcolor2,anames[])
{
	new i=Iter_Free(att[playerid]);
	if(i!=-1)
	{
        att[playerid][i][aused]=1;
        att[playerid][i][amodelid]=modelid;
        att[playerid][i][abone]=bone;
        att[playerid][i][afOffsetX]=fOffsetX;
        att[playerid][i][afOffsetY]=fOffsetY;
        att[playerid][i][afOffsetZ]=fOffsetZ;
        att[playerid][i][afRotX]=fRotX;
        att[playerid][i][afRotY]=fRotY;
        att[playerid][i][afRotZ]=fRotZ;
        att[playerid][i][afScaleX]=fScaleX;
        att[playerid][i][afScaleY]=fScaleY;
        att[playerid][i][afScaleZ]=fScaleZ;
        att[playerid][i][amaterialcolor1]=materialcolor1;
        att[playerid][i][amaterialcolor2]=materialcolor2;
        format(att[playerid][i][aname],80,anames);
        Iter_Add(att[playerid],i);
		UpdatePlayerAttDate(playerid,i);
 	}
 	else return 0;
	return 1;
}
ACT::RemoveAttToPlayer(playerid,index)
{
    att[playerid][index][aused]=0;
    att[playerid][index][amodelid]=0;
    att[playerid][index][abone]=0;
    att[playerid][index][afOffsetX]=0;
    att[playerid][index][afOffsetY]=0;
    att[playerid][index][afOffsetZ]=0;
    att[playerid][index][afRotX]=0;
    att[playerid][index][afRotY]=0;
    att[playerid][index][afRotZ]=0;
    att[playerid][index][afScaleX]=0;
    att[playerid][index][afScaleY]=0;
    att[playerid][index][afScaleZ]=0;
    att[playerid][index][amaterialcolor1]=0;
    att[playerid][index][amaterialcolor2]=0;
    format(att[playerid][index][aname],80,"NULL");
    UpdatePlayerAttDate(playerid,index);
    RemovePlayerAttachedObject(playerid,index);
    Iter_Remove(att[playerid],index);
    return 1;
}
ACT::UpdatePlayerAttDate(playerid,index)
{
	new string[64],str[1024];
 	format(string, sizeof(string),"slot_%i",index);
	format(str, sizeof(str),"%i&%i&%i&%0.4f&%0.4f&%0.4f&%0.4f&%0.4f&%0.4f&%0.4f&%0.4f&%0.4f&%i&%i&%s"
	,att[playerid][index][aused] 
	,att[playerid][index][amodelid] 
	,att[playerid][index][abone] 
	,att[playerid][index][afOffsetX] 
	,att[playerid][index][afOffsetY] 
	,att[playerid][index][afOffsetZ] 
	,att[playerid][index][afRotX] 
	,att[playerid][index][afRotY] 
	,att[playerid][index][afRotZ] 
	,att[playerid][index][afScaleX] 
	,att[playerid][index][afScaleY] 
	,att[playerid][index][afScaleZ] 
	,att[playerid][index][amaterialcolor1] 
	,att[playerid][index][amaterialcolor2] 
	,att[playerid][index][aname]);
 	format(Querys, sizeof(Querys),"UPDATE `"SQL_ATT"` SET  `%s` =  '%s' WHERE  `"SQL_ATT"`.`uid` ='%i'",string,str,pdate[playerid][uid]);
	mysql_query(mysqlid,Querys,false);
	SetPlayerAttachedObject(playerid,index,att[playerid][index][amodelid],att[playerid][index][abone] \
		,att[playerid][index][afOffsetX],att[playerid][index][afOffsetY],att[playerid][index][afOffsetZ],att[playerid][index][afRotX] \
		,att[playerid][index][afRotY],att[playerid][index][afRotZ],att[playerid][index][afScaleX],att[playerid][index][afScaleY] \
		,att[playerid][index][afScaleZ],ARGB(colors[att[playerid][index][amaterialcolor1]]),ARGB(colors[att[playerid][index][amaterialcolor2]]));
	return 1;
}
Dialog:dl_att_add(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Bag_Current_ID");
	    new models=bag[playerid][listid][model];
	    new names[80];
	    format(names, sizeof(names),"%s",bag[playerid][listid][name]);
	    if(RemoveBagItem(playerid,bag[playerid][listid][type],bag[playerid][listid][model],1))
	    {
	        if(AddAttToPlayer(playerid,models,listitem,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0,0,names))GiveCash(playerid,-100);
	        else SendClientMessage(playerid,COLOR_WARNING,"你的装扮槽已满");
	    }
	}
	return 1;
}

ACT::ShowMyAtt(playerid,pages)
{
	if(!Iter_Count(att[playerid]))return SendClientMessage(playerid,COLOR_WARNING,"没有装扮记录");
    current_number[playerid]=1;
  	foreach(new i:att[playerid])
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
	if(pages>floatround(Iter_Count(att[playerid])/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"没有该页");
		page[playerid]=1;
	}
	new string[60];
	format(string,sizeof(string),"装扮-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_myatt,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_MyAtt_RetrunStr(playerid,page[playerid]), "选择", "返回");
	return 1;
}

Dialog_MyAtt_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "物品名\t部位\t颜色1\t颜色2\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[384],tmps[128];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"{FF00FF}%s\t",att[playerid][current_idx[playerid][i]][aname]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"{FF00FF}%s\t",AttBones[att[playerid][current_idx[playerid][i]][abone]]);
            strcat(tmp,tmps);
            if(!att[playerid][current_idx[playerid][i]][amaterialcolor1])format(tmps,sizeof(tmps),"{FF00FF}%s\t",colorstr[att[playerid][current_idx[playerid][i]][amaterialcolor1]]);
			else format(tmps,sizeof(tmps),"%s■■■■■\t",colorstr[att[playerid][current_idx[playerid][i]][amaterialcolor1]]);
			strcat(tmp,tmps);
            if(!att[playerid][current_idx[playerid][i]][amaterialcolor2])format(tmps,sizeof(tmps),"{FF00FF}%s\n",colorstr[att[playerid][current_idx[playerid][i]][amaterialcolor2]]);
			else format(tmps,sizeof(tmps),"%s■■■■■\n",colorstr[att[playerid][current_idx[playerid][i]][amaterialcolor2]]);
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
Dialog:dl_myatt(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowMyAtt(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowMyAtt(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			new caption[80];
			format(caption,sizeof(caption), "装扮 %s 操作",att[playerid][listid][aname]);
			Dialog_Show(playerid,dl_myatt_doing,DIALOG_STYLE_TABLIST,caption,ShowAttMenu(playerid,listid), "选择", "返回");
            SetPVarInt(playerid,"Att_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
ShowAttMenu(playerid,attid)
{
	new string[1024],str[100];
	format(str, sizeof(str),"编辑装扮\t\n");
	strcat(string,str);
	format(str, sizeof(str),"更换部位\t%s\n",AttBones[att[playerid][attid][abone]]);
	strcat(string,str);
    if(!att[playerid][attid][amaterialcolor1])format(str, sizeof(str),"装扮颜色1\t%s\n",colorstr[att[playerid][attid][amaterialcolor1]]);
    else format(str, sizeof(str),"装扮颜色1\t%s■■■■■\n",colorstr[att[playerid][attid][amaterialcolor1]]);
    strcat(string,str);
    if(!att[playerid][attid][amaterialcolor2])format(str, sizeof(str),"装扮颜色2\t%s\n",colorstr[att[playerid][attid][amaterialcolor2]]);
    else format(str, sizeof(str),"装扮颜色2\t%s■■■■■\n",colorstr[att[playerid][attid][amaterialcolor2]]);
    strcat(string,str);
    strcat(string,"卸下装扮\t$100");
    return string;
}
Dialog:dl_att_change(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Att_Current_ID");
        att[playerid][listid][abone]=listitem;
		UpdatePlayerAttDate(playerid,listid);
	}
	return 1;
}
Dialog:dl_myatt_doing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Att_Current_ID");
	    switch(listitem)
	    {
	        case 0:EditAttachedObject(playerid,listid);
	        case 1:Dialog_Show(playerid, dl_att_change, DIALOG_STYLE_LIST,"更换部位",ShowBonesStr(),"确定","取消");
	        case 2:Dialog_Show(playerid,dl_att_color1,DIALOG_STYLE_LIST,"装扮颜色1",ShowColorStrEx(),"选择","取消");
	        case 3:Dialog_Show(playerid,dl_att_color2,DIALOG_STYLE_LIST,"装扮颜色2",ShowColorStrEx(),"选择","取消");
	        case 4:
	        {
	            if(AddBagItem(playerid,BAG_FURN,att[playerid][listid][amodelid],1,att[playerid][listid][aname]))RemoveAttToPlayer(playerid,listid);
	        }
	    }
	    
	}
	return 1;
}
Dialog:dl_att_color1(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Att_Current_ID");
	    att[playerid][listid][amaterialcolor1]=listitem;
	    UpdatePlayerAttDate(playerid,listid);
	}
	return 1;
}
Dialog:dl_att_color2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Att_Current_ID");
	    att[playerid][listid][amaterialcolor2]=listitem;
	    UpdatePlayerAttDate(playerid,listid);
	}
	return 1;
}
ACT::EditPlayerAtt(playerid,response,index,modelid,boneid,Float:fOffsetX,Float:fOffsetY,Float:fOffsetZ,Float:fRotX,Float:fRotY,Float:fRotZ,Float:fScaleX, Float:fScaleY,Float:fScaleZ)
{
	if(response)
	{
	    att[playerid][index][afOffsetX]=fOffsetX;
	    att[playerid][index][afOffsetY]=fOffsetY;
	    att[playerid][index][afOffsetZ]=fOffsetZ;
	    att[playerid][index][afRotX]=fRotX;
	    att[playerid][index][afRotY]=fRotY;
	    att[playerid][index][afRotZ]=fRotZ;
	    att[playerid][index][afScaleX]=fScaleX;
	    att[playerid][index][afScaleY]=fScaleY;
	    att[playerid][index][afScaleZ]=fScaleZ;
	    UpdatePlayerAttDate(playerid,index);
	}
    return 1;
}
public OnPlayerSpawn(playerid)
{
    LoadPlayerAtt(playerid);
    return CallLocalFunction("Att_OnPlayerSpawn", "i",playerid);
}
#if defined _ALS_OnPlayerSpawn
   #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn Att_OnPlayerSpawn
forward Att_OnPlayerSpawn(playerid);


public OnPlayerConnect(playerid)
{
	for(new i=0;i<MAX_PLAYER_ATTACHED_OBJECTS;i++)RemovePlayerAttachedObject(playerid, i);
    Iter_Clear(att[playerid]);
	return CallLocalFunction("Att_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Att_OnPlayerConnect
forward Att_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
    for(new i=0;i<MAX_PLAYER_ATTACHED_OBJECTS;i++)RemovePlayerAttachedObject(playerid, i);
	Iter_Clear(att[playerid]);
	return CallLocalFunction("Att_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Att_OnPlayerDisconnect
forward Att_OnPlayerDisconnect(playerid,reason);


#include WD3/Attach/Att_Cmd.pwn

