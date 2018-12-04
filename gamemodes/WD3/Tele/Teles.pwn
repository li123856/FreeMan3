#include WD3/Tele/Teles_Define.pwn
#include WD3/Tele/Teles_Custom.pwn
public OnGameModeInit()
{
	LoadTeles();
	return CallLocalFunction("Tele_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Tele_OnGameModeInit
forward Tele_OnGameModeInit();

ACT::LoadTeles()
{
    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_TELE"`");
    mysql_tquery(mysqlid, Querys, "OnTelesLoad");
	return 1;
}
ACT::OnTelesLoad()
{
	new rows=cache_get_row_count(mysqlid);
	for(new i=0;i<rows;i++)
	{
		if(i<MAX_TELES)
		{
		    tele[i][t_id]=cache_get_field_content_int(i,"t_id");
		    tele[i][t_uid]=cache_get_field_content_int(i,"t_uid");
		    tele[i][t_int]=cache_get_field_content_int(i,"t_int");
		    tele[i][t_world]=cache_get_field_content_int(i,"t_world");
		    tele[i][t_rate]=cache_get_field_content_int(i,"t_rate");
		    tele[i][t_color]=cache_get_field_content_int(i,"t_color");
		    tele[i][t_open]=cache_get_field_content_int(i,"t_open");
		    tele[i][t_daly]=cache_get_field_content_int(i,"t_daly");
		    tele[i][t_x]=cache_get_field_content_float(i,"t_x");
		    tele[i][t_y]=cache_get_field_content_float(i,"t_y");
		    tele[i][t_z]=cache_get_field_content_float(i,"t_z");
		    tele[i][t_a]=cache_get_field_content_float(i,"t_a");
		    tele[i][t_dis]=cache_get_field_content_float(i,"t_dis");
		    cache_get_field_content(i,"t_create",tele[i][t_create],mysqlid,80);
		    cache_get_field_content(i,"t_cmd",tele[i][t_cmd],mysqlid,80);
		    cache_get_field_content(i,"t_name",tele[i][t_name],mysqlid,80);
		    Iter_Add(tele,i);
		}
		else printf("传送读取达到上限 %i",MAX_TELES);
	}
    return 1;
}
ACT::AddTele(playerid,cmds[],named[])
{
    new i=Iter_Free(tele);
    if(i==-1)return 0;
    tele[i][t_uid]=pdate[playerid][uid];
	GetPlayerPos(playerid,tele[i][t_x],tele[i][t_y],tele[i][t_z]);
	GetPlayerFacingAngle(playerid,tele[i][t_a]);
	tele[i][t_int]=GetPlayerInterior(playerid);
	tele[i][t_world]=GetPlayerVirtualWorld(playerid);
	tele[i][t_dis]=0.5;
	new time[3], date[3];
    getdate(date[0],date[1],date[2]);
	gettime(time[0], time[1], time[2]);
	format(tele[i][t_create],80,"%d/%d/%d-%d:%d:%d",date[0],date[1],date[2], time[0], time[1], time[2]);
	format(tele[i][t_cmd],80,cmds);
	format(tele[i][t_name],80,named);
	tele[i][t_rate]=0;
	tele[i][t_color]=1;
	tele[i][t_open]=1;
	tele[i][t_daly]=0;
	format(Querys, sizeof(Querys),"INSERT INTO `"SQL_TELE"`(`t_uid`,`t_int`,`t_world`,`t_x`,`t_y`,`t_z`,`t_a`,`t_create`,`t_cmd`,`t_name`)VALUES ('%i','%i','%i','%0.3f','%0.3f','%0.3f','%0.3f','%s','%s','%s')",tele[i][t_uid],tele[i][t_int],tele[i][t_world],tele[i][t_x],tele[i][t_y],tele[i][t_z],tele[i][t_a],tele[i][t_create],tele[i][t_cmd],tele[i][t_name]);
	mysql_query(mysqlid,Querys);
	tele[i][t_id]=cache_insert_id();
	Iter_Add(tele,i);
    return 1;
}
ACT::RemoveTele(index)
{
	format(Querys,sizeof(Querys),"DELETE FROM `"SQL_TELE"` WHERE `t_id` = '%i'",tele[index][t_id]);
	mysql_query(mysqlid,Querys,false);
    Iter_Remove(tele,index);
    return 1;
}

ACT::UpdateTeleDis(index,Float:disd)
{
	tele[index][t_dis]=disd;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_TELE"` SET  `t_dis`='%0.3f' WHERE  `"SQL_TELE"`.`t_id` ='%i'",tele[index][t_dis],tele[index][t_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateTeleDaly(index,dalyd)
{
	tele[index][t_daly]=dalyd;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_TELE"` SET  `t_daly`='%i' WHERE  `"SQL_TELE"`.`t_id` ='%i'",tele[index][t_daly],tele[index][t_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}

ACT::UpdateTeleName(index,named[])
{
	format(tele[index][t_name],80,named);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_TELE"` SET  `t_name`='%s' WHERE  `"SQL_TELE"`.`t_id` ='%i'",tele[index][t_name],tele[index][t_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateTeleCmd(index,named[])
{
	format(tele[index][t_cmd],80,named);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_TELE"` SET  `t_cmd`='%s' WHERE  `"SQL_TELE"`.`t_id` ='%i'",tele[index][t_cmd],tele[index][t_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateTeleColor(index,colours)
{
	tele[index][t_color]=colours;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_TELE"` SET  `t_color`='%i' WHERE  `"SQL_TELE"`.`t_id` ='%i'",tele[index][t_color],tele[index][t_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateTeleOpen(index,opend)
{
	tele[index][t_open]=opend;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_TELE"` SET  `t_open`='%i' WHERE  `"SQL_TELE"`.`t_id` ='%i'",tele[index][t_open],tele[index][t_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateTeleRate(index,rated)
{
	tele[index][t_rate]=rated;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_TELE"` SET  `t_rate`='%i' WHERE  `"SQL_TELE"`.`t_id` ='%i'",tele[index][t_rate],tele[index][t_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::GetTidID(tids)
{
  	foreach(new i:tele)if(tele[i][t_id]==tids)return i;
	return 0;
}
ACT::ShowMyTele(playerid,pages)
{
	if(!Iter_Count(tele))return SendClientMessage(playerid,COLOR_WARNING,"没有传送");
    current_number[playerid]=1;
    new counts=0;
  	foreach(new i:tele)
	{
	    if(tele[i][t_uid]==pdate[playerid][uid])
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
	format(string,sizeof(string),"我的传送-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_myteles,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_MyTeles_RetrunStr(playerid,page[playerid]), "选择", "返回");
	return 1;
}
Dialog_MyTeles_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "名称\t指令\t开关\t颜色\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[384],tmps[128];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"%s\t",tele[current_idx[playerid][i]][t_name]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"/%s\t",tele[current_idx[playerid][i]][t_cmd]);
            strcat(tmp,tmps);
            if(tele[current_idx[playerid][i]][t_open])format(tmps,sizeof(tmps),"启用中\t");
            else format(tmps,sizeof(tmps),"停用中\t");
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%s■■■■■\n",colorstr[tele[current_idx[playerid][i]][t_color]]);
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
TeleOwnerMenuStr(index)
{
	new string[1024],str[100];
	format(str, sizeof(str),"更改名称\t$10000\n");
	strcat(string,str);
	format(str, sizeof(str),"更改指令\t$50000\n");
	strcat(string,str);
	format(str, sizeof(str),"更改颜色\t$1000\n");
	strcat(string,str);
	format(str, sizeof(str),"更改延迟\t%i秒\n",tele[index][t_daly]);
	strcat(string,str);
	format(str, sizeof(str),"更改范围\t%0.3f米\n",tele[index][t_dis]);
	strcat(string,str);
	if(tele[index][t_open])format(str, sizeof(str),"开关传送\t启用中\n");
	else format(str, sizeof(str),"开关传送\t停用中\n");
	strcat(string,str);
	format(str, sizeof(str),"删除传送\t\n");
	strcat(string,str);
	return string;
}
Dialog:dl_myteles(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowMyTele(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowMyTele(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			new caption[100];
			format(caption,sizeof(caption), "传送 %s 操作",tele[listid][t_name]);
			Dialog_Show(playerid,dl_mytele_doing,DIALOG_STYLE_TABLIST,caption,TeleOwnerMenuStr(listid), "确定", "返回");
            SetPVarInt(playerid,"Teles_Current_ID",listid);
		}
	}
	else
	{

	}
	return 1;
}
Dialog:dl_mytele_doing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
		    case 0:Dialog_Show(playerid,dl_tele_change_name,DIALOG_STYLE_INPUT,"更改名称","请输入要更改的名称","确定","取消");
		    case 1:Dialog_Show(playerid,dl_tele_change_cmd,DIALOG_STYLE_INPUT,"更改指令","请输入要更改的指令","确定","取消");
		    case 2:Dialog_Show(playerid,dl_tele_change_color,DIALOG_STYLE_LIST,"更改颜色",ShowColorStr(),"选择","取消");
		    case 3:Dialog_Show(playerid,dl_tele_change_daly,DIALOG_STYLE_INPUT,"更改延迟","请输入数值","确定","取消");
		    case 4:Dialog_Show(playerid,dl_tele_change_dis,DIALOG_STYLE_INPUT,"更改范围","请输入数值","确定","取消");
		    case 5:
		    {
		        new index=GetPVarInt(playerid,"Teles_Current_ID");
		        if(tele[index][t_open])tele[index][t_open]=0;
		        else tele[index][t_open]=1;
		        UpdateTeleOpen(index,tele[index][t_open]);
		    }
		    case 6:RemoveTele(GetPVarInt(playerid,"Teles_Current_ID"));
		}
	}
	return 1;
}
Dialog:dl_tele_change_daly(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strval(inputtext)<0||strval(inputtext)>5)return Dialog_Show(playerid,dl_tele_change_daly,DIALOG_STYLE_INPUT,"更改延迟","请输入数值[0-5]","选择","取消");
		UpdateTeleDaly(GetPVarInt(playerid,"Teles_Current_ID"),strval(inputtext));
	}
	return 1;
}
Dialog:dl_tele_change_dis(playerid, response, listitem, inputtext[])
{
    if(response)
    {
    	if(floatstr(inputtext)<0.1||floatstr(inputtext)>10)return Dialog_Show(playerid,dl_tele_change_daly,DIALOG_STYLE_INPUT,"更改延迟","请输入数值[0.1-10.0]","选择","取消");
    	UpdateTeleDis(GetPVarInt(playerid,"Teles_Current_ID"),floatstr(inputtext));
	}
	return 1;
}
Dialog:dl_tele_change_color(playerid, response, listitem, inputtext[])
{
    if(response)
    {
		if(pdate[playerid][cash]<1000)return SendClientMessage(playerid,COLOR_WARNING,"你没有这么多现金");
		GiveCash(playerid,-10000);
		UpdateTeleColor(GetPVarInt(playerid,"Teles_Current_ID"),listitem+1);
	}
	return 1;
}
Dialog:dl_tele_change_name(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(strlen(inputtext)<1||strlen(inputtext)>50)return Dialog_Show(playerid,dl_tele_change_name,DIALOG_STYLE_INPUT,"更改名称","请输入要更改的名称","选择","取消");
		if(pdate[playerid][cash]<10000)return SendClientMessage(playerid,COLOR_WARNING,"你没有这么多现金");
        GiveCash(playerid,-10000);
        UpdateTeleName(GetPVarInt(playerid,"Teles_Current_ID"),inputtext);
	}
	return 1;
}
Dialog:dl_tele_change_cmd(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(strlen(inputtext)<1||strlen(inputtext)>50)return Dialog_Show(playerid,dl_tele_change_cmd,DIALOG_STYLE_INPUT,"更改指令","请输入要更改的指令","选择","取消");
		if(pdate[playerid][cash]<50000)return SendClientMessage(playerid,COLOR_WARNING,"你没有这么多现金");
		if(GetSameTeles(inputtext))return Dialog_Show(playerid,dl_tele_change_cmd,DIALOG_STYLE_INPUT,"已有此传送指令","请重新输入要更改的名称","选择","取消");
		GiveCash(playerid,-50000);
		UpdateTeleCmd(GetPVarInt(playerid,"Teles_Current_ID"),inputtext);
	}
	return 1;
}
ACT::GetSameTeles(named[])
{
    strlower(named);
    new str[80];
    foreach(new i:tele)
	{
		format(str,sizeof(str),"%s",tele[i][t_cmd]);
		strlower(str);
		if(!strcmp(named,str,false))return 1;
	}
	return 0;
}


ACT::ShowGlobalTeleMenu(playerid,pages)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TELE"` ORDER BY t_rate DESC");
    mysql_tquery(mysqlid, Querys, "OnGlobalTeleMenu", "ii",playerid,pages);
	return 1;
}
ACT::OnGlobalTeleMenu(playerid,pages)
{
	new rows=cache_get_row_count(mysqlid);
	if(!rows)return SendClientMessage(playerid,COLOR_WARNING,"没有传送");
    current_number[playerid]=1;
  	for(new i=0;i<rows;i++)
	{
        current_idx[playerid][current_number[playerid]]=cache_get_field_content_int(i, "t_id");
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
	format(caption,sizeof(caption), "传送名\t指令\t频率\t可用\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST;i++)
	{
	    new tmp[128],tmps[80],senders[80],sendertime[80];
		if(i<current_number[playerid])
		{
			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TELE"` WHERE `t_id` = '%i' LIMIT 1",current_idx[playerid][i]);
    		mysql_query(mysqlid, Querys);
		    cache_get_field_content(0,"t_name",senders,mysqlid,80);
            format(tmps,sizeof(tmps),"%s%s\t",colorstr[cache_get_field_content_int(0,"t_color")],senders);
            strcat(tmp,tmps);
		    cache_get_field_content(0,"t_cmd",sendertime,mysqlid,80);
            format(tmps,sizeof(tmps),"/%s\t",sendertime);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"%i\t",cache_get_field_content_int(0,"t_rate"));
            strcat(tmp,tmps);
            if(cache_get_field_content_int(0,"t_open"))format(tmps,sizeof(tmps),"可用\n");
            else format(tmps,sizeof(tmps),"不可用\n");
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
	format(str,sizeof(str),"传送列表-共计[%i]",rows);
	Dialog_Show(playerid,dl_player_teles_show,DIALOG_STYLE_TABLIST_HEADERS,str,string, "使用", "返回");
	return 1;
}

Dialog:dl_player_teles_show(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowGlobalTeleMenu(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowGlobalTeleMenu(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			new i=GetTidID(listid);
			if(tele[i][t_uid]==pdate[playerid][uid])SetPPos(playerid,tele[i][t_x],tele[i][t_y],tele[i][t_z],tele[i][t_a],tele[i][t_int],tele[i][t_world],tele[i][t_dis],tele[i][t_daly]);
			else
			{
				UpdateTeleRate(i,tele[i][t_rate]+1);
				SetPPos(playerid,tele[i][t_x],tele[i][t_y],tele[i][t_z],tele[i][t_a],tele[i][t_int],tele[i][t_world],tele[i][t_dis],tele[i][t_daly]);
			}
			new string[256];
			format(string,sizeof(string),TELE_CMD,Pname[playerid],playerid,colorstr[tele[i][t_color]],tele[i][t_name],tele[i][t_cmd],tele[i][t_rate],GetUidName(tele[i][t_uid]));
			SendClientMessageToAll(-1,string);
		}
	}
	else
	{

	}
	return 1;
}

public e_COMMAND_ERRORS:OnPlayerCommandReceived(playerid, cmdtext[], e_COMMAND_ERRORS:success)
{
	if(success==COMMAND_UNDEFINED)
	{
		if(cmdtext[0] == '/'&& cmdtext[1])
		{
		    strlower(cmdtext[1]);
		    new str[80];
			foreach(new i:tele)
			{
			    if(tele[i][t_open])
			    {
			        format(str,sizeof(str),"%s",tele[i][t_cmd]);
			        strlower(str);
					if(!strcmp(cmdtext[1],str, false))
					{
						if(tele[i][t_uid]==pdate[playerid][uid])SetPPos(playerid,tele[i][t_x],tele[i][t_y],tele[i][t_z],tele[i][t_a],tele[i][t_int],tele[i][t_world],tele[i][t_dis],tele[i][t_daly]);
						else
						{
							UpdateTeleRate(i,tele[i][t_rate]+1);
							SetPPos(playerid,tele[i][t_x],tele[i][t_y],tele[i][t_z],tele[i][t_a],tele[i][t_int],tele[i][t_world],tele[i][t_dis],tele[i][t_daly]);
						}
						new string[256];
						format(string,sizeof(string),TELE_CMD,Pname[playerid],playerid,colorstr[tele[i][t_color]],tele[i][t_name],tele[i][t_cmd],tele[i][t_rate],GetUidName(tele[i][t_uid]));
						SendClientMessageToAll(-1,string);
						return COMMAND_OK;
					}
			    }
			}
		}
		SendClientMessage(playerid,COLOR_WARNING,"没有此指令");
	}
	return COMMAND_OK;
}
public e_COMMAND_ERRORS:OnPlayerCommandPerformed(playerid, cmdtext[], e_COMMAND_ERRORS:success)
{
	return COMMAND_OK;
}
#include WD3/Tele/Teles_Cmd.pwn

