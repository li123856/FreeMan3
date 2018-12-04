#include WD3/Furniture/Furn_Define.pwn
#include WD3/Furniture/Furn_Custom.pwn

public OnGameModeInit()
{
	LoadFurniture();
	return CallLocalFunction("Furn_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Furn_OnGameModeInit
forward Furn_OnGameModeInit();

ACT::LoadFurniture()
{
    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_FURN"`");
    mysql_tquery(mysqlid, Querys, "OnFurnitureLoad");
	return 1;
}
ACT::OnFurnitureLoad()
{
	new rows=cache_get_row_count(mysqlid);
	for(new i=0;i<rows;i++)
	{
		if(i<MAX_FURN)
		{
		    Furn[i][f_id]=cache_get_field_content_int(i,"f_id");
		    Furn[i][f_model]=cache_get_field_content_int(i,"f_model");
		    Furn[i][f_x]=cache_get_field_content_float(i,"f_x");
		    Furn[i][f_y]=cache_get_field_content_float(i,"f_y");
		    Furn[i][f_z]=cache_get_field_content_float(i,"f_z");
		    Furn[i][f_rx]=cache_get_field_content_float(i,"f_rx");
		    Furn[i][f_ry]=cache_get_field_content_float(i,"f_ry");
		    Furn[i][f_rz]=cache_get_field_content_float(i,"f_rz");
		    Furn[i][f_in]=cache_get_field_content_int(i,"f_in");
		    Furn[i][f_wl]=cache_get_field_content_int(i,"f_wl");
		    cache_get_field_content(i,"f_name",Furn[i][f_name],mysqlid,80);
		    Furn[i][f_move]=cache_get_field_content_int(i,"f_move");
		    Furn[i][f_movex]=cache_get_field_content_float(i,"f_movex");
		    Furn[i][f_movey]=cache_get_field_content_float(i,"f_movey");
		    Furn[i][f_movez]=cache_get_field_content_float(i,"f_movez");
		    Furn[i][f_moverx]=cache_get_field_content_float(i,"f_moverx");
		    Furn[i][f_movery]=cache_get_field_content_float(i,"f_movery");
		    Furn[i][f_moverz]=cache_get_field_content_float(i,"f_moverz");
		    Furn[i][f_txd]=cache_get_field_content_int(i,"f_txd");
		    Furn[i][f_color]=cache_get_field_content_int(i,"f_color");
		    Iter_Add(Furn,i);
		}
		else printf("家具读取达到上限 %i",MAX_FURN);
	}
	foreach(new c:Furn)MkeFurn(c);
    return 1;
}
ACT::UpdateFurnTxdColorEx(furnid,txdid)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",txdid);
    mysql_query(mysqlid, Querys);
    new txdname[32],txdsname[32];
	cache_get_field_content(0,"txdname",txdname,mysqlid,32);
	cache_get_field_content(0,"texturename",txdsname,mysqlid,32);
	SetDynamicObjectMaterial(Furn[furnid][f_objid],0,cache_get_field_content_int(0,"model"),txdname,txdsname,0);
    return 1;
}
ACT::UpdateFurnTxdColor(furnid)
{
	if(!Furn[furnid][f_color])
	{
		format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",Furn[furnid][f_txd]);
	    mysql_query(mysqlid, Querys);
	    new txdname[32],txdsname[32];
		cache_get_field_content(0,"txdname",txdname,mysqlid,32);
		cache_get_field_content(0,"texturename",txdsname,mysqlid,32);
		SetDynamicObjectMaterial(Furn[furnid][f_objid],0,cache_get_field_content_int(0,"model"),txdname,txdsname,0);
	}
	else SetDynamicObjectMaterial(Furn[furnid][f_objid],0,-1,"none","none",ARGB(colors[Furn[furnid][f_color]]));
    return 1;
}
ACT::UpdateFurnTxdColorDate(furnid,txdid,colord)
{
    Furn[furnid][f_txd]=txdid;
    Furn[furnid][f_color]=colord;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_FURN"` SET  `f_txd`='%i',`f_color`='%i' WHERE `"SQL_FURN"`.`f_id` ='%i'",Furn[furnid][f_txd],Furn[furnid][f_color],Furn[furnid][f_id]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::UpdateFurnPos(furnid)
{
	DestroyDynamic3DTextLabel(Furn[furnid][f_text]);
	DestroyDynamicArea(Furn[furnid][f_area]);
	Furn[furnid][f_text]=CreateDynamic3DTextLabel("Y",COLOR_YELLOW,Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],5,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,Furn[furnid][f_wl],Furn[furnid][f_in],-1,STREAMER_3D_TEXT_LABEL_SD);
	Furn[furnid][f_area]=CreateDynamicSphere(Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],3.0,Furn[furnid][f_wl],Furn[furnid][f_in]);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_FURN"` SET  `f_x`='%0.3f',`f_y`='%0.3f',`f_z`='%0.3f',`f_rx`='%0.3f',`f_ry`='%0.3f',`f_rz`='%0.3f',`f_in`='%i',`f_wl`='%i' WHERE `"SQL_FURN"`.`f_id` ='%i'",Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz],Furn[furnid][f_in],Furn[furnid][f_wl],Furn[furnid][f_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::UpdateFurnMove(furnid,ismove)
{
	if(ismove)format(Querys, sizeof(Querys),"UPDATE `"SQL_FURN"` SET  `f_movex`='%0.3f',`f_movey`='%0.3f',`f_movez`='%0.3f',`f_moverx`='%0.3f',`f_movery`='%0.3f',`f_moverz`='%0.3f',`f_move`='%i' WHERE `"SQL_FURN"`.`f_id` ='%i'",Furn[furnid][f_movex],Furn[furnid][f_movey],Furn[furnid][f_movez],Furn[furnid][f_moverx],Furn[furnid][f_movery],Furn[furnid][f_moverz],Furn[furnid][f_move],Furn[furnid][f_id]);
	else format(Querys, sizeof(Querys),"UPDATE `"SQL_FURN"` SET  `f_movex`='%0.3f',`f_movey`='%0.3f',`f_movez`='%0.3f',`f_moverx`='%0.3f',`f_movery`='%0.3f',`f_moverz`='%0.3f',`f_move`='%i' WHERE `"SQL_FURN"`.`f_id` ='%i'",0,0,0,0,0,0,0,Furn[furnid][f_id]);
	mysql_query(mysqlid,Querys,false);
    return 1;
}
ACT::MkeFurn(furnid)
{
	Furn[furnid][f_objid]=CreateDynamicObject(Furn[furnid][f_model],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz],Furn[furnid][f_wl],Furn[furnid][f_in],-1,STREAMER_OBJECT_SD,STREAMER_OBJECT_DD);
	UpdateFurnTxdColor(furnid);
    Furn[furnid][f_text]=CreateDynamic3DTextLabel("Y",COLOR_YELLOW,Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],5,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,Furn[furnid][f_wl],Furn[furnid][f_in],-1,STREAMER_3D_TEXT_LABEL_SD);
	Furn[furnid][f_area]=CreateDynamicSphere(Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],3.0,Furn[furnid][f_wl],Furn[furnid][f_in]);
    return 1;
}
ACT::RemoveFurn(furnid)
{
	DestroyDynamicObject(Furn[furnid][f_objid]);
	DestroyDynamic3DTextLabel(Furn[furnid][f_text]);
	DestroyDynamicArea(Furn[furnid][f_area]);
	return 1;
}
ACT::DeleteFurn(furnid)
{
	format(Querys,sizeof(Querys),"DELETE FROM `"SQL_FURN"` WHERE `f_id` = '%i'",Furn[furnid][f_id]);
	mysql_query(mysqlid,Querys,false);
	DestroyDynamicObject(Furn[furnid][f_objid]);
	DestroyDynamic3DTextLabel(Furn[furnid][f_text]);
	DestroyDynamicArea(Furn[furnid][f_area]);
	Iter_Remove(Furn,furnid);
    return 1;
}
ACT::VailFurn(furnid)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_FURN"` WHERE `f_id` = '%i' LIMIT 1",Furn[furnid][f_id]);
	mysql_query(mysqlid, Querys);
	return cache_get_row_count(mysqlid);
}
ACT::AddFurn(models,Float:xx,Float:yy,Float:zz,interiors,worlds,furnname[])
{
    new furnid=Iter_Free(Furn);
	if(furnid==-1)
	{
        printf("家具数量达到上限 %i",MAX_FURN);
        return -1;
	}
    Furn[furnid][f_model]=models;
    Furn[furnid][f_x]=xx;
    Furn[furnid][f_y]=yy;
    Furn[furnid][f_z]=zz;
    Furn[furnid][f_rx]=0.0;
    Furn[furnid][f_ry]=0.0;
    Furn[furnid][f_rz]=0.0;
    Furn[furnid][f_in]=interiors;
    Furn[furnid][f_wl]=worlds;
    format(Furn[furnid][f_name],80,furnname);
    Furn[furnid][f_move]=0;
    Furn[furnid][f_movex]=0.0;
    Furn[furnid][f_movey]=0.0;
    Furn[furnid][f_movez]=0.0;
    Furn[furnid][f_moverx]=0.0;
    Furn[furnid][f_movery]=0.0;
    Furn[furnid][f_moverz]=0.0;
    Furn[furnid][f_txd]=1;
    Furn[furnid][f_color]=0;
	format(Querys, sizeof(Querys),"INSERT INTO `"SQL_FURN"`(`f_model`,`f_x`,`f_y`,`f_z`,`f_in`,`f_wl`,`f_name`)\
	VALUES ('%i','%f','%f','%f','%i','%i','%s')",Furn[furnid][f_model],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],Furn[furnid][f_in],Furn[furnid][f_wl],Furn[furnid][f_name]);
	mysql_query(mysqlid,Querys);
	Furn[furnid][f_id]=cache_insert_id();
	Iter_Add(Furn,furnid);
	MkeFurn(furnid);
	return furnid;
}

ACT::GetFurn(playerid)
{
	foreach(new c:Furn)if(IsPlayerInDynamicArea(playerid,Furn[c][f_area]))return c;
	return -1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(Login[playerid])
	{
	    if(PRESSED(KEY_YES))
	    {
	        if(HoldingFurn[playerid]!=-1)return SendClientMessage(playerid,COLOR_WARNING,"你正在搬动家具");
	        if(PlayerFurn[playerid]!=-1)return SendClientMessage(playerid,COLOR_WARNING,"你正在操作其他家具");
	        new furnid=GetFurn(playerid);
	        if(furnid!=-1)
			{
			    new caption[100];
			    format(caption, sizeof(caption),"[%i] %s",furnid,Furn[furnid][f_name]);
			    Dialog_Show(playerid,dl_furn_menu,DIALOG_STYLE_TABLIST,caption,ShowFurnMenu(furnid), "操作", "返回");
				PlayerFurn[playerid]=furnid;
			}
		}
		if(PRESSED(KEY_HANDBRAKE))
		{
  			if(HoldingFurn[playerid]!=-1)
			{
   				new string[100];
			    format(string, sizeof(string),"是否放下家具 [%i] %s",HoldingFurn[playerid],Furn[HoldingFurn[playerid]][f_name]);
				Dialog_Show(playerid,dl_furn_menu_putdown,DIALOG_STYLE_MSGBOX,"放下",string, "确定", "返回");
			}
	    }
	    if(PRESSED(KEY_NO))
		{
			if(Pedit[playerid]==PLAYER_EDIT_FURN_TXD)
			{
			    if(PlayerFurn[playerid]!=-1)
			    {
					if(Editid[playerid]!=-1)
					{
		    			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",Editid[playerid]);
    					mysql_query(mysqlid, Querys);
						new nname[80],string[128];
						cache_get_field_content(0,"names",nname,mysqlid,80);
						format(string, sizeof(string),"是否购买此材质 %s,价格 $%i",nname,cache_get_field_content_int(0,"cash"));
						Dialog_Show(playerid,dl_furn_buy_txd,DIALOG_STYLE_MSGBOX,"购买家具材质",string,"购买","取消");
					}
			    }
			    else
				{
					Pedit[playerid]=PLAYER_EDIT_NONE;
					PlayerFurn[playerid]=-1;
				}
			}
		}
	    if(PRESSED(KEY_ANALOG_LEFT))
		{
			if(Pedit[playerid]==PLAYER_EDIT_FURN_TXD)
			{
			    if(PlayerFurn[playerid]!=-1)
			    {
					if(Editid[playerid]!=-1)
					{
				        Editid[playerid]--;
				        format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",Editid[playerid]);
	    				mysql_query(mysqlid, Querys);
						if(cache_get_row_count(mysqlid))
						{
						    new string[128],nname[80];
							cache_get_field_content(0,"names",nname,mysqlid,80);
						    format(string, sizeof(string),"材质 %s ,价格 $%i",nname,cache_get_field_content_int(0,"cash"));
						    SendClientMessage(playerid,COLOR_TIP,string);
							UpdateFurnTxdColorEx(PlayerFurn[playerid],Editid[playerid]);
						}
						else
						{
						    Editid[playerid]++;
							SendClientMessage(playerid,COLOR_WARNING,"没有这个材质了");
						}
					}
			    }
			    else
				{
					Pedit[playerid]=PLAYER_EDIT_NONE;
					PlayerFurn[playerid]=-1;
				}
			}
		}
	    if(PRESSED(KEY_ANALOG_RIGHT))
		{
			if(Pedit[playerid]==PLAYER_EDIT_FURN_TXD)
			{
			    if(PlayerFurn[playerid]!=-1)
			    {
					if(Editid[playerid]!=-1)
					{
				        Editid[playerid]++;
				        format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",Editid[playerid]);
	    				mysql_query(mysqlid, Querys);
						if(cache_get_row_count(mysqlid))
						{
						    new string[128],nname[80];
							cache_get_field_content(0,"names",nname,mysqlid,80);
						    format(string, sizeof(string),"材质 %s ,价格 $%i",nname,cache_get_field_content_int(0,"cash"));
						    SendClientMessage(playerid,COLOR_TIP,string);
							UpdateFurnTxdColorEx(PlayerFurn[playerid],Editid[playerid]);
						}
						else
						{
						    Editid[playerid]--;
							SendClientMessage(playerid,COLOR_WARNING,"没有这个材质了");
						}
					}
			    }
			    else
				{
					Pedit[playerid]=PLAYER_EDIT_NONE;
					PlayerFurn[playerid]=-1;
				}
			}
		}
	}
	return CallLocalFunction("Furn_OnPlayerKeyStateChange","iii",playerid, newkeys, oldkeys);
}
#if defined _ALS_OnPlayerKeyStateChange
   #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange Furn_OnPlayerKeyStateChange
forward Furn_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);


Dialog:dl_furn_info(playerid, response, listitem, inputtext[])return PlayerFurn[playerid]=-1;

Dialog:dl_furn_buy_txd(playerid, response, listitem, inputtext[])
{
	new furnid=PlayerFurn[playerid];
	if(response)
    {
		format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",Editid[playerid]);
    	mysql_query(mysqlid, Querys);
		if(pdate[playerid][cash]<cache_get_field_content_int(0,"cash"))return SendClientMessage(playerid,COLOR_WARNING,"你的现金不足");
        GiveCash(playerid,-cache_get_field_content_int(0,"cash"));
	    UpdateFurnTxdColorDate(furnid,Editid[playerid],0);
    }
    else UpdateFurnTxdColor(furnid);
    Pedit[playerid]=PLAYER_EDIT_NONE;
    Editid[playerid]=-1;
    PlayerFurn[playerid]=-1;
    return 1;
}
ShowFurnMenu(furnid)
{
	new string[512],str[100];
	format(str, sizeof(str),"拿起家具\t\n");
	strcat(string,str);
	format(str, sizeof(str),"放入背包\t\n");
	strcat(string,str);
	format(str, sizeof(str),"编辑位置\t\n",Furn[furnid][f_name]);
	strcat(string,str);
	if(Furn[furnid][f_move])format(str, sizeof(str),"移动设置\t开\n");
	else format(str, sizeof(str),"移动设置\t关\n");
	strcat(string,str);
	if(!Furn[furnid][f_txd])format(str, sizeof(str),"材质设置\t无\n");
	else
	{
	    format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",Furn[furnid][f_txd]);
    	mysql_query(mysqlid, Querys);
    	new txdnames[32];
		cache_get_field_content(0,"names",txdnames,mysqlid,32);
		format(str, sizeof(str),"材质设置\t%s\n",txdnames);
	}
	strcat(string,str);
	if(!Furn[furnid][f_color])format(str, sizeof(str),"颜色设置\t无颜色\n");
	else format(str, sizeof(str),"颜色设置\t%s■■■■■\n",colorstr[Furn[furnid][f_color]]);
	strcat(string,str);
    return string;
}
Dialog:dl_furn_menu(playerid, response, listitem, inputtext[])
{
	if(response)
    {
        new furnid=PlayerFurn[playerid];
		if(!VailFurn(furnid))
		{
		    PlayerFurn[playerid]=-1;
		    return 1;
		}
		switch(listitem)
        {
           case 0: 
           {
             	ApplyAnimation(playerid,"CARRY","liftup",4.1,0,0,0,1,0);
			    defer Carry[1500](playerid);
           }
           case 1: 
           {
            	AddBagItem(playerid,BAG_FURN,Furn[furnid][f_model],1,Furn[furnid][f_name]);
            	DeleteFurn(furnid);
            	PlayerFurn[playerid]=-1;
           }
           case 2:
           {
                Pedit[playerid]=PLAYER_EDIT_FURN;
                Editid[playerid]=furnid;
                EditDynamicObject(playerid,Furn[furnid][f_objid]);
                DestroyDynamicArea(Furn[furnid][f_area]);
           }
           case 3:
           {
                Pedit[playerid]=PLAYER_EDIT_FURN_MOVE;
                Editid[playerid]=furnid;
                EditDynamicObject(playerid,Furn[furnid][f_objid]);
                DestroyDynamicArea(Furn[furnid][f_area]);
           }
           case 4:ShowFurnTxdBuy(playerid,1);
           case 5:Dialog_Show(playerid,dl_furn_color,DIALOG_STYLE_LIST,"家具颜色",ShowColorStrEx(),"选择","取消");
        }
    }
    else PlayerFurn[playerid]=-1;
	return 1;
}
Dialog:dl_furn_color(playerid, response, listitem, inputtext[])
{
	if(response)
    {
        new furnid=PlayerFurn[playerid];
		if(!VailFurn(furnid))
		{
		    PlayerFurn[playerid]=-1;
		    return 1;
		}
        UpdateFurnTxdColorDate(furnid,1,listitem);
        UpdateFurnTxdColor(furnid);
        PlayerFurn[playerid]=-1;
    }
    else PlayerFurn[playerid]=-1;
	return 1;
}
ACT::ShowFurnTxdBuy(playerid,pages)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TXD"`");
    mysql_tquery(mysqlid, Querys, "OnPlayerFurnTxdMenu", "ii",playerid,pages);
	return 1;
}
ACT::OnPlayerFurnTxdMenu(playerid,pages)
{
	new rows=cache_get_row_count(mysqlid);
	if(!rows)return SendClientMessage(playerid,COLOR_WARNING,"没有材质列表");
    current_number[playerid]=1;
  	for(new i=0;i<rows;i++)
	{
        current_idx[playerid][current_number[playerid]]=cache_get_field_content_int(i, "id");
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
	format(caption,sizeof(caption), "名称\t价格\n");
	strcat(string,caption);
	strcat(string,"{FF8000}上一页\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST;i++)
	{
	    new tmp[300],tmps[270],sendertime[80];
		if(i<current_number[playerid])
		{
			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",current_idx[playerid][i]);
    		mysql_query(mysqlid, Querys);
            cache_get_field_content(0,"names",sendertime,mysqlid,256);
            format(tmps,sizeof(tmps),"{33AA33}%s\t",sendertime);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"{33AA33}$%i\n",cache_get_field_content_int(0,"cash"));
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

	new str[60];
	format(str,sizeof(str),"购买装潢列表-共计[%i]",rows);
	Dialog_Show(playerid,dl_furn_txd_buy,DIALOG_STYLE_TABLIST_HEADERS,str,string, "选择", "返回");
	return 1;
}
Dialog:dl_furn_txd_buy(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowFurnTxdBuy(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowFurnTxdBuy(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
            format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_TXD"` WHERE `id` = '%i' LIMIT 1",listid);
    		mysql_query(mysqlid, Querys);
    		Pedit[playerid]=PLAYER_EDIT_FURN_TXD;
            Editid[playerid]=listid;
            SendClientMessage(playerid,COLOR_TIP,"材质预览,4和6键切换,N键购买或取消");
			new string[128],nname[80];
			cache_get_field_content(0,"names",nname,mysqlid,80);
			format(string, sizeof(string),"材质 %s ,价格 $%i",nname,cache_get_field_content_int(0,"cash"));
			SendClientMessage(playerid,COLOR_TIP,string);
            UpdateFurnTxdColorEx(PlayerFurn[playerid],Editid[playerid]);
		}
	}
	else
	{
        PlayerFurn[playerid]=-1;
	}
	return 1;
}


ACT::EditFurnMove(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(Pedit[playerid]==PLAYER_EDIT_FURN_MOVE)
	{
	    if(Furn[Editid[playerid]][f_objid]==objectid)
	    {
			if(response==EDIT_RESPONSE_FINAL)
			{
			    new furnid=Editid[playerid];
			    Furn[furnid][f_movex]=x;
    			Furn[furnid][f_movey]=y;
    			Furn[furnid][f_movez]=z;
    			Furn[furnid][f_moverx]=rx;
    			Furn[furnid][f_movery]=ry;
    			Furn[furnid][f_moverz]=rz;
    			Furn[furnid][f_move]=1;
				UpdateFurnMove(furnid,1);
				
				SetDynamicObjectPos(Furn[furnid][f_objid],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z]);
				SetDynamicObjectRot(Furn[furnid][f_objid],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz]);
				Furn[furnid][f_area]=CreateDynamicSphere(Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],3.0,Furn[furnid][f_wl],Furn[furnid][f_in]);

				Pedit[playerid]=PLAYER_EDIT_NONE;
				Editid[playerid]=-1;
    			PlayerFurn[playerid]=-1;
			}
			if(response==EDIT_RESPONSE_CANCEL)
			{
			    new furnid=Editid[playerid];
				SetDynamicObjectPos(Furn[furnid][f_objid],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z]);
				SetDynamicObjectRot(Furn[furnid][f_objid],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz]);
				Furn[furnid][f_area]=CreateDynamicSphere(Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],3.0,Furn[furnid][f_wl],Furn[furnid][f_in]);

				Furn[furnid][f_move]=0;
                UpdateFurnMove(furnid,0);
                
				Pedit[playerid]=PLAYER_EDIT_NONE;
				Editid[playerid]=-1;
    			PlayerFurn[playerid]=-1;
			}

		}
	}
	return 1;
}
ACT::EditFurnPos(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(Pedit[playerid]==PLAYER_EDIT_FURN)
	{
	    if(Furn[Editid[playerid]][f_objid]==objectid)
	    {
			if(response==EDIT_RESPONSE_FINAL)
			{
			    new furnid=Editid[playerid];
			    Furn[furnid][f_x]=x;
    			Furn[furnid][f_y]=y;
    			Furn[furnid][f_z]=z;
    			Furn[furnid][f_rx]=rx;
    			Furn[furnid][f_ry]=ry;
    			Furn[furnid][f_rz]=rz;
				UpdateFurnPos(furnid);
				Furn[furnid][f_area]=CreateDynamicSphere(Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],3.0,Furn[furnid][f_wl],Furn[furnid][f_in]);

				Pedit[playerid]=PLAYER_EDIT_NONE;
				Editid[playerid]=-1;
    			PlayerFurn[playerid]=-1;
			}
			if(response==EDIT_RESPONSE_CANCEL)
			{
			    new furnid=Editid[playerid];
				SetDynamicObjectPos(Furn[furnid][f_objid],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z]);
				SetDynamicObjectRot(Furn[furnid][f_objid],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz]);
				Furn[furnid][f_area]=CreateDynamicSphere(Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],3.0,Furn[furnid][f_wl],Furn[furnid][f_in]);

				Pedit[playerid]=PLAYER_EDIT_NONE;
				Editid[playerid]=-1;
    			PlayerFurn[playerid]=-1;
			}

		}
	}
	return 1;
}
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	if(Editid[playerid]!=-1)
	{
		switch(Pedit[playerid])
		{
		    case PLAYER_EDIT_FURN:
		    {
		        new furnid=Editid[playerid];
		        SetDynamicObjectPos(Furn[furnid][f_objid],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z]);
				SetDynamicObjectRot(Furn[furnid][f_objid],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz]);
				Pedit[playerid]=PLAYER_EDIT_NONE;
				Editid[playerid]=-1;
				PlayerFurn[playerid]=-1;
				CancelEdit(playerid);
		    }
		    case PLAYER_EDIT_FURN_TXD:
		    {
		        UpdateFurnTxdColor(PlayerFurn[playerid]);
		        Pedit[playerid]=PLAYER_EDIT_NONE;
		        Editid[playerid]=-1;
	        	PlayerFurn[playerid]=-1;
		    }
		    case PLAYER_EDIT_FURN_MOVE:
		    {
			    new furnid=Editid[playerid];
				SetDynamicObjectPos(Furn[furnid][f_objid],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z]);
				SetDynamicObjectRot(Furn[furnid][f_objid],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz]);
				Furn[furnid][f_area]=CreateDynamicSphere(Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],3.0,Furn[furnid][f_wl],Furn[furnid][f_in]);
				Furn[furnid][f_move]=0;
                UpdateFurnMove(furnid,0);
				Pedit[playerid]=PLAYER_EDIT_NONE;
				Editid[playerid]=-1;
    			PlayerFurn[playerid]=-1;
		    }
		}
	}
	PlayerFurn[playerid]=-1;
	return CallLocalFunction("Furn_OnPlayerInteriorChange", "iii",playerid, newinteriorid, oldinteriorid);
}
#if defined _ALS_OnPlayerInteriorChange
   #undef OnPlayerInteriorChange
#else
    #define _ALS_OnPlayerInteriorChange
#endif
#define OnPlayerInteriorChange Furn_OnPlayerInteriorChange
forward Furn_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid);


Dialog:dl_furn_menu_putdown(playerid, response, listitem, inputtext[])
{
	if(response)
    {
        ApplyAnimation(playerid,"CARRY","liftup",4.1,0,0,0,1,0);
        defer PutDown[1000](playerid);
    }
    return 1;
}
timer PutDown[1000](playerid)
{
    new furnid=HoldingFurn[playerid];
	RemovePlayerAttachedObject(playerid,9);
   	new Float:xx,Float:yy,Float:zz;
	GetPlayerFaceFrontPos(playerid,2,xx,yy,zz);
    Furn[furnid][f_x]=xx;
    Furn[furnid][f_y]=yy;
    Furn[furnid][f_z]=zz-0.5;
    Furn[furnid][f_in]=GetPlayerInterior(playerid);
    Furn[furnid][f_wl]=GetPlayerVirtualWorld(playerid);
	MkeFurn(furnid);
	UpdateFurnPos(furnid);
	HoldingFurn[playerid]=-1;
	Streamer_Update(playerid);
	ClearAnimations(playerid);
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
}
timer Carry[1500](playerid)
{
    new furnid=PlayerFurn[playerid];
	if(VailFurn(furnid))
	{
	    HoldingFurn[playerid]=furnid;
	    RemoveFurn(furnid);
		SetPlayerAttachedObject(playerid,9,Furn[furnid][f_model],1,0,0.6,0,0,90,0,1.000000, 1.000000, 1.000000);
	    Streamer_Update(playerid);
	    ClearAnimations(playerid);
    }
	PlayerFurn[playerid]=-1;
}
public OnPlayerConnect(playerid)
{
	PlayerFurn[playerid]=-1;
    HoldingFurn[playerid]=-1;
	Editid[playerid]=-1;
	Pedit[playerid]=PLAYER_EDIT_NONE;
	PreLoadAnim(playerid);
	return CallLocalFunction("Furn_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Furn_OnPlayerConnect
forward Furn_OnPlayerConnect(playerid);

public OnPlayerDeath(playerid, killerid, reason)
{
	if(Login[playerid])
	{
	    if(HoldingFurn[playerid]!=-1)
	    {
		    new furnid=HoldingFurn[playerid];
			RemovePlayerAttachedObject(playerid,9);
		   	new Float:xx,Float:yy,Float:zz;
			GetPlayerFaceFrontPos(playerid,2,xx,yy,zz);
		    Furn[furnid][f_x]=xx;
		    Furn[furnid][f_y]=yy;
		    Furn[furnid][f_z]=zz-0.5;
		    Furn[furnid][f_in]=GetPlayerInterior(playerid);
		    Furn[furnid][f_wl]=GetPlayerVirtualWorld(playerid);
			MkeFurn(furnid);
			UpdateFurnPos(furnid);
	    }
		if(Editid[playerid]!=-1)
		{
			switch(Pedit[playerid])
			{
			    case PLAYER_EDIT_FURN:
			    {
			        new furnid=Editid[playerid];
			        SetDynamicObjectPos(Furn[furnid][f_objid],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z]);
					SetDynamicObjectRot(Furn[furnid][f_objid],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz]);
					Pedit[playerid]=PLAYER_EDIT_NONE;
					Editid[playerid]=-1;
					PlayerFurn[playerid]=-1;
					CancelEdit(playerid);
			    }
			    case PLAYER_EDIT_FURN_TXD:
			    {
			        UpdateFurnTxdColor(PlayerFurn[playerid]);
			        Pedit[playerid]=PLAYER_EDIT_NONE;
			        Editid[playerid]=-1;
		        	PlayerFurn[playerid]=-1;
			    }
			    case PLAYER_EDIT_FURN_MOVE:
			    {
				    new furnid=Editid[playerid];
					SetDynamicObjectPos(Furn[furnid][f_objid],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z]);
					SetDynamicObjectRot(Furn[furnid][f_objid],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz]);
					Furn[furnid][f_area]=CreateDynamicSphere(Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],3.0,Furn[furnid][f_wl],Furn[furnid][f_in]);
					Furn[furnid][f_move]=0;
	                UpdateFurnMove(furnid,0);
					Pedit[playerid]=PLAYER_EDIT_NONE;
					Editid[playerid]=-1;
	    			PlayerFurn[playerid]=-1;
			    }
			}
			PlayerFurn[playerid]=-1;
		}
	}
	PlayerFurn[playerid]=-1;
    return CallLocalFunction("Furn_OnPlayerDeath", "iii",playerid,killerid,reason);
}
#if defined _ALS_OnPlayerDeath
   #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath Furn_OnPlayerDeath
forward Furn_OnPlayerDeath(playerid, killerid, reason);

public OnPlayerDisconnect(playerid, reason)
{
	if(Login[playerid])
	{
	    if(HoldingFurn[playerid]!=-1)
	    {
		    new furnid=HoldingFurn[playerid];
			RemovePlayerAttachedObject(playerid,9);
		   	new Float:xx,Float:yy,Float:zz;
			GetPlayerFaceFrontPos(playerid,2,xx,yy,zz);
		    Furn[furnid][f_x]=xx;
		    Furn[furnid][f_y]=yy;
		    Furn[furnid][f_z]=zz-0.5;
		    Furn[furnid][f_in]=GetPlayerInterior(playerid);
		    Furn[furnid][f_wl]=GetPlayerVirtualWorld(playerid);
			MkeFurn(furnid);
			UpdateFurnPos(furnid);
	    }
		if(Editid[playerid]!=-1)
		{
			switch(Pedit[playerid])
			{
			    case PLAYER_EDIT_FURN:
			    {
			        new furnid=Editid[playerid];
			        SetDynamicObjectPos(Furn[furnid][f_objid],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z]);
					SetDynamicObjectRot(Furn[furnid][f_objid],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz]);
					Pedit[playerid]=PLAYER_EDIT_NONE;
					Editid[playerid]=-1;
					PlayerFurn[playerid]=-1;
					CancelEdit(playerid);
			    }
			    case PLAYER_EDIT_FURN_TXD:
			    {
			        UpdateFurnTxdColor(PlayerFurn[playerid]);
			        Pedit[playerid]=PLAYER_EDIT_NONE;
			        Editid[playerid]=-1;
		        	PlayerFurn[playerid]=-1;
			    }
			    case PLAYER_EDIT_FURN_MOVE:
			    {
				    new furnid=Editid[playerid];
					SetDynamicObjectPos(Furn[furnid][f_objid],Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z]);
					SetDynamicObjectRot(Furn[furnid][f_objid],Furn[furnid][f_rx],Furn[furnid][f_ry],Furn[furnid][f_rz]);
					Furn[furnid][f_area]=CreateDynamicSphere(Furn[furnid][f_x],Furn[furnid][f_y],Furn[furnid][f_z],3.0,Furn[furnid][f_wl],Furn[furnid][f_in]);
					Furn[furnid][f_move]=0;
	                UpdateFurnMove(furnid,0);
					Pedit[playerid]=PLAYER_EDIT_NONE;
					Editid[playerid]=-1;
	    			PlayerFurn[playerid]=-1;
			    }
			}
		}
	}
	PlayerFurn[playerid]=-1;
	HoldingFurn[playerid]=-1;
	Editid[playerid]=-1;
 	Pedit[playerid]=PLAYER_EDIT_NONE;
	return CallLocalFunction("Furn_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Furn_OnPlayerDisconnect
forward Furn_OnPlayerDisconnect(playerid,reason);
#include WD3/Furniture/Furn_Cmd.pwn
