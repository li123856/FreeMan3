#include WD3/House/House_Define.pwn
#include WD3/House/House_Custom.pwn
#include WD3/House/House_Object.pwn
#include WD3/House/House_Cmd.pwn
public OnGameModeInit()
{
    Iter_Init(hobj);
	LoadHouses();
	return CallLocalFunction("House_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
   #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit House_OnGameModeInit
forward House_OnGameModeInit();

public OnPlayerConnect(playerid)
{
	pEnter[playerid]=false;
	return CallLocalFunction("House_OnPlayerConnect", "i",playerid);
}
#if defined _ALS_OnPlayerConnect
   #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect House_OnPlayerConnect
forward House_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	pEnter[playerid]=false;
	return CallLocalFunction("House_OnPlayerDisconnect", "ii",playerid,reason);
}
#if defined _ALS_OnPlayerDisconnect
   #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect House_OnPlayerDisconnect
forward House_OnPlayerDisconnect(playerid,reason);


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(Login[playerid])
	{
		if(PRESSED(KEY_CTRL_BACK))
		{
			new index=GetPlayerVirtualWorld(playerid);
			new houseidx=index-HOUSE_LIMTS;
			if(Iter_Contains(house,houseidx))
			{
		        if(house[houseidx][h_uid]==pdate[playerid][uid])
		        {
		            new caption[80];
					format(caption,sizeof(caption), "���� %s ID: %i",house[houseidx][h_name],houseidx);
					Dialog_Show(playerid,dl_own_house_menu,DIALOG_STYLE_TABLIST,caption,ShowHouseOwnerMenu(houseidx), "ѡ��", "����");
                   	SetPVarInt(playerid,"House_Owner_Current_ID",houseidx);
		        }
		        else
		        {
         			if(Pedit[playerid]==PLAYER_EDIT_HOUSE_BUY)
            	    {
		                if(houseidx==Editid[playerid])
		                {
		                    new string[128];
							format(string, sizeof(string),"�Ƿ����� %s �۸� $%i",house[houseidx][h_name],house[houseidx][h_sellmoney]);
		                    Dialog_Show(playerid,dl_house_in_buy,DIALOG_STYLE_MSGBOX,"����",string, "����", "ȡ��");
		                }
		                else
						{
						    Pedit[playerid]=PLAYER_EDIT_NONE;
						    Editid[playerid]=-1;
						}
	                }
		        }
			}
	    }
	    if(PRESSED(KEY_NO))
		{
		    if(Pedit[playerid]==PLAYER_EDIT_HOUSE_DEC)
		    {
		        if(Editid[playerid]!=-1)
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
							format(string, sizeof(string),"�Ƿ����װ�� %s,�۸� $%i",nname,cache_get_field_content_int(0,"worth"));
							Dialog_Show(playerid,dl_house_buy_dec,DIALOG_STYLE_MSGBOX,"����װ��",string,"����","ȡ��");
					    }
						else
						{
							SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
                            Pedit[playerid]=PLAYER_EDIT_NONE;
                            Editid[playerid]=-1;
						}
					}
				}
			}
		}
    	if(PRESSED(KEY_ANALOG_LEFT))
		{
			if(Pedit[playerid]==PLAYER_EDIT_HOUSE_DEC)
			{
			    if(Editid[playerid]!=-1)
				{
				    new index=GetPlayerVirtualWorld(playerid);
			    	new houseidx=index-HOUSE_LIMTS;
					if(Iter_Contains(house,houseidx))
					{
					    if(house[houseidx][h_uid]==pdate[playerid][uid])
					    {
							Editid[playerid]--;
							if(house[houseidx][h_decid]==Editid[playerid])Editid[playerid]--;
						    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_DEC"` WHERE `id` = '%i' LIMIT 1",Editid[playerid]);
		    				mysql_query(mysqlid, Querys);
							if(cache_get_row_count(mysqlid))
							{
	    						SetPPos(playerid,cache_get_field_content_float(0,"x"),cache_get_field_content_float(0,"y"),cache_get_field_content_float(0,"z"),cache_get_field_content_float(0,"a"),cache_get_field_content_int(0,"int"),GetPlayerVirtualWorld(playerid),0.5,2);
								new nname[80],string[128];
								cache_get_field_content(0,"name",nname,mysqlid,80);
								format(string, sizeof(string),"װ�� %s,�۸� $%i",nname,cache_get_field_content_int(0,"worth"));
	            				SendClientMessage(playerid,COLOR_TIP,string);
							}
							else SendClientMessage(playerid,COLOR_WARNING,"û�����������");
						}
						else
						{
							SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
                            Pedit[playerid]=PLAYER_EDIT_NONE;
                            Editid[playerid]=-1;
						}
					}
				}
			}
		}
    	if(PRESSED(KEY_ANALOG_RIGHT))
		{
		    printf("PLAYER_EDIT_HOUSE_DEC");
			if(Pedit[playerid]==PLAYER_EDIT_HOUSE_DEC)
			{
			    if(Editid[playerid]!=-1)
				{
				    new index=GetPlayerVirtualWorld(playerid);
			    	new houseidx=index-HOUSE_LIMTS;
					if(Iter_Contains(house,houseidx))
					{
					    if(house[houseidx][h_uid]==pdate[playerid][uid])
					    {
							Editid[playerid]++;
							if(house[houseidx][h_decid]==Editid[playerid])Editid[playerid]++;
					        format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_DEC"` WHERE `id` = '%i' LIMIT 1",Editid[playerid]);
		    				mysql_query(mysqlid, Querys);
							if(cache_get_row_count(mysqlid))
							{
	    						SetPPos(playerid,cache_get_field_content_float(0,"x"),cache_get_field_content_float(0,"y"),cache_get_field_content_float(0,"z"),cache_get_field_content_float(0,"a"),cache_get_field_content_int(0,"int"),GetPlayerVirtualWorld(playerid),0.5,2);
								new nname[80],string[128];
								cache_get_field_content(0,"name",nname,mysqlid,80);
								format(string, sizeof(string),"װ�� %s,�۸� $%i",nname,cache_get_field_content_int(0,"worth"));
	            				SendClientMessage(playerid,COLOR_TIP,string);
							}
							else SendClientMessage(playerid,COLOR_WARNING,"û�����������");
						}
						else
						{
							SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
                            Pedit[playerid]=PLAYER_EDIT_NONE;
                            Editid[playerid]=-1;
						}
					}
				}
			}
		}
	}
	return CallLocalFunction("House_OnPlayerKeyStateChange","iii",playerid, newkeys, oldkeys);
}
#if defined _ALS_OnPlayerKeyStateChange
   #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange House_OnPlayerKeyStateChange
forward House_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);

public OnPlayerDeath(playerid, killerid, reason)
{
	if(Login[playerid])
	{
	    switch(Pedit[playerid])
	    {
	        case PLAYER_EDIT_HOUSE_DEC,PLAYER_EDIT_HOUSE_BUY:
	        {
	        	Pedit[playerid]=PLAYER_EDIT_NONE;
	        	Editid[playerid]=-1;
	        }
	    }
	}
    return CallLocalFunction("House_OnPlayerDeath", "iii",playerid,killerid,reason);
}
#if defined _ALS_OnPlayerDeath
   #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath House_OnPlayerDeath
forward House_OnPlayerDeath(playerid, killerid, reason);

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{

	return CallLocalFunction("House_OnPlayerInteriorChange", "iii",playerid, newinteriorid, oldinteriorid);
}
#if defined _ALS_OnPlayerInteriorChange
   #undef OnPlayerInteriorChange
#else
    #define _ALS_OnPlayerInteriorChange
#endif
#define OnPlayerInteriorChange House_OnPlayerInteriorChange
forward House_OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid);

ACT::LoadHouses()
{
    format(Querys, sizeof(Querys),"SELECT *  FROM `"SQL_HOUSE"`");
    mysql_tquery(mysqlid, Querys, "OnHousesLoad");
	return 1;
}
ACT::OnHousesLoad()
{
	new rows=cache_get_row_count(mysqlid);
	for(new i=0;i<rows;i++)
	{
		if(i<MAX_FURN)
		{
		    house[i][h_hid]=cache_get_field_content_int(i,"h_hid");
		    house[i][h_uid]=cache_get_field_content_int(i,"h_uid");
		    house[i][h_sellmoney]=cache_get_field_content_int(i,"h_sellmoney");
		    house[i][h_lock]=cache_get_field_content_int(i,"h_lock");
		    house[i][h_oin]=cache_get_field_content_int(i,"h_oin");
		    house[i][h_iin]=cache_get_field_content_int(i,"h_iin");
		    house[i][h_owl]=cache_get_field_content_int(i,"h_owl");
		    house[i][h_iwl]=HOUSE_LIMTS+i;
		    house[i][h_ox]=cache_get_field_content_float(i,"h_ox");
		    house[i][h_oy]=cache_get_field_content_float(i,"h_oy");
		    house[i][h_oz]=cache_get_field_content_float(i,"h_oz");
		    house[i][h_oa]=cache_get_field_content_float(i,"h_oa");
		    house[i][h_ix]=cache_get_field_content_float(i,"h_ix");
		    house[i][h_iy]=cache_get_field_content_float(i,"h_iy");
		    house[i][h_iz]=cache_get_field_content_float(i,"h_iz");
		    house[i][h_ia]=cache_get_field_content_float(i,"h_ia");
		    cache_get_field_content(i,"h_name",house[i][h_name],mysqlid,80);
		    cache_get_field_content(i,"h_pass",house[i][h_pass],mysqlid,129);
		    cache_get_field_content(i,"h_music",house[i][h_music],mysqlid,256);
		    house[i][h_decid]=cache_get_field_content_int(i,"h_decid");
		    Iter_Add(house,i);
		}
		else printf("���Ӷ�ȡ�ﵽ���� %i",MAX_HOUSES);
	}
	foreach(new c:house)
	{
		switch(LoadHouseTemplate(house[c][h_hid],c))
		{
			case 0:printf("�޷��� %i.pwn ģ���ļ�",house[c][h_hid]);
			case 1:
			{
				house[c][h_ox]=hobjdoor[c][0];
			    house[c][h_oy]=hobjdoor[c][1];
			    house[c][h_oz]=hobjdoor[c][2];
			    house[c][h_oa]=hobjdoor[c][3];
			    printf("���ط���ģ��, %i.pwn �ɹ�",house[c][h_hid]);
			}
			case 2:printf("���ط���ģ��, %i.pwn δ�����Ŷ�λ����",house[c][h_hid]);
		}
	    CreateHouseFace(c);
	}
	
    return 1;
}

ACT::AddHouse(deciindex,Float:ox,Float:oy,Float:oz,Float:oa,Float:ix,Float:iy,Float:iz,Float:ia,oin,owl,iin,buymoney,housename[],uidid)
{
    new i=Iter_Free(house);
    if(i==-1)return 0;
    house[i][h_uid]=uidid;
	house[i][h_sellmoney]=buymoney;
	house[i][h_lock]=0;
	house[i][h_oin]=oin;
	house[i][h_iin]=iin;
	house[i][h_owl]=owl;
	house[i][h_iwl]=i+HOUSE_LIMTS;
	house[i][h_ox]=ox;
	house[i][h_oy]=oy;
	house[i][h_oz]=oz;
	house[i][h_oa]=oa;
	house[i][h_ix]=ix;
	house[i][h_iy]=iy;
	house[i][h_iz]=iz;
	house[i][h_ia]=ia;
	format(house[i][h_name],80,housename);
	format(house[i][h_pass],129,"NULL");
	format(house[i][h_music],256,"NULL");
	house[i][h_decid]=deciindex;
	format(Querys, sizeof(Querys),"INSERT INTO `"SQL_HOUSE"`(`h_uid`,`h_sellmoney`,`h_oin`,`h_iin`,`h_owl`,`h_ox`,`h_oy`,`h_oz`,`h_oa`,`h_ix`,`h_iy`,`h_iz`,`h_ia`,`h_name`,`h_decid`)\
	VALUES ('%i','%i','%i','%i','%i','%0.3f','%0.3f','%0.3f','%0.3f','%0.3f','%0.3f','%0.3f','%0.3f','%s','%i')",house[i][h_uid],house[i][h_sellmoney],house[i][h_oin],house[i][h_iin],house[i][h_owl]
	,house[i][h_ox],house[i][h_oy],house[i][h_oz],house[i][h_oa],house[i][h_ix],house[i][h_iy],house[i][h_iz],house[i][h_ia],house[i][h_name],house[i][h_decid]);
	mysql_query(mysqlid,Querys);
	house[i][h_hid]=cache_insert_id();
    CreateHouseFace(i);
	Iter_Add(house,i);
	return 1;
}
ACT::RemoveHouse(index)
{
    DeleteHouseFace(index);
	format(Querys,sizeof(Querys),"DELETE FROM `"SQL_HOUSE"` WHERE `h_hid` = '%i'",house[index][h_hid]);
	mysql_query(mysqlid,Querys,false);
    Iter_Remove(house,index);
    return 1;
}
ACT::UpdateHouseOutPos(index,Float:xx,Float:yy,Float:zz,Float:aa,intt,worlds)
{
    house[index][h_ox]=xx;
	house[index][h_oy]=yy;
	house[index][h_oz]=zz;
	house[index][h_oa]=aa;
	house[index][h_oin]=intt;
	house[index][h_owl]=worlds;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_HOUSE"` SET  `h_ox`='%0.3f',`h_oy`='%0.3f',`h_oz`='%0.3f',`h_oa`='%0.3f',`h_oin`='%i',`h_owl`='%i'  WHERE `"SQL_HOUSE"`.`h_hid` ='%i'",house[index][h_ox],house[index][h_oy],house[index][h_oz],house[index][h_oa],house[index][h_oin],house[index][h_owl],house[index][h_hid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::UpdateHouseInPos(index,Float:xx,Float:yy,Float:zz,Float:aa,intt,decindex)
{
    house[index][h_ix]=xx;
	house[index][h_iy]=yy;
	house[index][h_iz]=zz;
	house[index][h_ia]=aa;
	house[index][h_iin]=intt;
	house[index][h_decid]=decindex;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_HOUSE"` SET  `h_ix`='%0.3f',`h_iy`='%0.3f',`h_iz`='%0.3f',`h_ia`='%0.3f',`h_iin`='%i',`h_decid`='%i'  WHERE `"SQL_HOUSE"`.`h_hid` ='%i'",house[index][h_ix],house[index][h_iy],house[index][h_iz],house[index][h_ia],house[index][h_iin],house[index][h_decid],house[index][h_hid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::UpdateHouseOwner(index,uidid,sellcash,locked,passes[])
{
    house[index][h_uid]=uidid;
    house[index][h_sellmoney]=sellcash;
    house[index][h_lock]=locked;
    format(house[index][h_pass],129,passes);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_HOUSE"` SET  `h_uid`='%i',`h_sellmoney`='%i',`h_lock`='%i',`h_pass`='%s'  WHERE `"SQL_HOUSE"`.`h_hid` ='%i'",house[index][h_uid],house[index][h_sellmoney],house[index][h_lock],house[index][h_pass],house[index][h_hid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::UpdateHouseName(index,hnames[])
{
    format(house[index][h_name],80,hnames);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_HOUSE"` SET  `h_name`='%s'  WHERE `"SQL_HOUSE"`.`h_hid` ='%i'",house[index][h_name],house[index][h_hid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::UpdateHouseSell(index,sellcash)
{
    house[index][h_sellmoney]=sellcash;
	format(Querys, sizeof(Querys),"UPDATE `"SQL_HOUSE"` SET  `h_sellmoney`='%i'  WHERE `"SQL_HOUSE"`.`h_hid` ='%i'",house[index][h_sellmoney],house[index][h_hid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::UpdateHouseMusic(index,hnames[])
{
    format(house[index][h_music],256,hnames);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_HOUSE"` SET  `h_music`='%s'  WHERE `"SQL_HOUSE"`.`h_hid` ='%i'",house[index][h_music],house[index][h_hid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::UpdateHouseLock(index,loaked,passwordsd[])
{
    house[index][h_lock]=loaked;
    format(house[index][h_pass],129,passwordsd);
	format(Querys, sizeof(Querys),"UPDATE `"SQL_HOUSE"` SET  `h_lock`='%i',`h_pass`='%s'  WHERE `"SQL_HOUSE"`.`h_hid` ='%i'",house[index][h_lock],house[index][h_pass],house[index][h_hid]);
	mysql_query(mysqlid,Querys,false);
	return 1;
}
ACT::UpdateHouse3D(index)
{
	new string[128];
	if(house[index][h_uid]==-1)format(string, sizeof(string),"ID:%i\n%s\n����:ϵͳ\n�۸�:$%i\n���ƺ�[%i]",index,house[index][h_name],house[index][h_sellmoney],index,house[index][h_hid]);
	else
	{
	    if(house[index][h_sellmoney]>0)format(string, sizeof(string),"ID:%i\n%s\n����:%s\n�۸�:$%i\n���ƺ�[%i]",index,house[index][h_name],GetUidName(house[index][h_uid]),house[index][h_sellmoney],house[index][h_hid]);
		else format(string, sizeof(string),"ID:%i\n%s\n����:%s\n���ƺ�:No.%i",house[index][h_name],GetUidName(house[index][h_uid]),house[index][h_hid]);
	}
	UpdateDynamic3DTextLabelText(house[index][h_o3d],COLOR_YELLOW,string);
	return 1;
}
ACT::CreateHouseFace(index)
{
	new string[128];
	if(house[index][h_uid]==-1)
	{
		format(string, sizeof(string),"ID:%i\n%s\n����:ϵͳ\n�۸�:$%i\n���ƺ�[%i]",index,house[index][h_name],house[index][h_sellmoney],house[index][h_hid]);
		house[index][h_map]=CreateDynamicMapIcon(house[index][h_ox],house[index][h_oy],house[index][h_oz],31,-1,house[index][h_owl],house[index][h_oin],-1,500.0,MAPICON_LOCAL);
		house[index][h_opic]=CreateDynamicPickup(1273,1,house[index][h_ox],house[index][h_oy],house[index][h_oz],house[index][h_owl],house[index][h_oin],-1,20);
	}
	else
	{
	    if(house[index][h_sellmoney]>0)
		{
			format(string, sizeof(string),"ID:%i\n%s\n����:%s\n�۸�:$%i\n���ƺ�[%i]",index,house[index][h_name],GetUidName(house[index][h_uid]),house[index][h_sellmoney],house[index][h_hid]);
			house[index][h_map]=CreateDynamicMapIcon(house[index][h_ox],house[index][h_oy],house[index][h_oz],33,-1,house[index][h_owl],house[index][h_oin],-1,500.0,MAPICON_LOCAL);
			house[index][h_opic]=CreateDynamicPickup(1274,1,house[index][h_ox],house[index][h_oy],house[index][h_oz],house[index][h_owl],house[index][h_oin],-1,20);
		}
		else
		{
			format(string, sizeof(string),"ID:%i\n%s\n����:%s\n���ƺ�[%i]",index,house[index][h_name],GetUidName(house[index][h_uid]),house[index][h_hid]);
            house[index][h_map]=CreateDynamicMapIcon(house[index][h_ox],house[index][h_oy],house[index][h_oz],32,-1,house[index][h_owl],house[index][h_oin],-1,500.0,MAPICON_LOCAL);
			house[index][h_opic]=CreateDynamicPickup(1272,1,house[index][h_ox],house[index][h_oy],house[index][h_oz],house[index][h_owl],house[index][h_oin],-1,20);
		}
	}
	house[index][h_o3d]=CreateDynamic3DTextLabel(string,COLOR_YELLOW,house[index][h_ox],house[index][h_oy],house[index][h_oz],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,house[index][h_owl],house[index][h_oin],-1,STREAMER_3D_TEXT_LABEL_SD);
	house[index][h_i3d]=CreateDynamic3DTextLabel("����",COLOR_YELLOW,house[index][h_ix],house[index][h_iy],house[index][h_iz],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,house[index][h_iwl],house[index][h_iin],-1,STREAMER_3D_TEXT_LABEL_SD);
	house[index][h_ipic]=CreateDynamicPickup(1318,1,house[index][h_ix],house[index][h_iy],house[index][h_iz],house[index][h_iwl],house[index][h_iin],-1,20);
	house[index][h_oarea]=CreateDynamicSphere(house[index][h_ox],house[index][h_oy],house[index][h_oz],1.0,house[index][h_owl],house[index][h_oin]);
	house[index][h_iarea]=CreateDynamicSphere(house[index][h_ix],house[index][h_iy],house[index][h_iz],1.0,house[index][h_iwl],house[index][h_iin]);
    return 1;
}
ACT::DeleteHouseFace(index)
{
	DestroyDynamic3DTextLabel(house[index][h_o3d]);
	DestroyDynamic3DTextLabel(house[index][h_i3d]);
	DestroyDynamicPickup(house[index][h_opic]);
	DestroyDynamicPickup(house[index][h_ipic]);
	DestroyDynamicMapIcon(house[index][h_map]);
	DestroyDynamicArea(house[index][h_oarea]);
	DestroyDynamicArea(house[index][h_iarea]);
    return 1;
}


ShowHouseOwnerMenu(index)
{
	new string[1024],str[100];
	format(str, sizeof(str),"����\t%s\n",house[index][h_name]);
	strcat(string,str);
	if(house[index][h_lock])
	{
	    if(!strcmp(house[index][h_pass],"NULL",false))format(str, sizeof(str),"����\t����-������\n");
	    else format(str, sizeof(str),"����\t����-������\n");
	}
	else format(str, sizeof(str),"����\t�ر�\n");
	strcat(string,str);
	format(str, sizeof(str),"��������\t$10000\n");
	strcat(string,str);
	if(house[index][h_decid]==-1)format(str, sizeof(str),"����װ��\t�Զ���\n");
	else
	{
		format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_DEC"` WHERE `id` = '%i' LIMIT 1",house[index][h_decid]);
    	mysql_query(mysqlid, Querys);
   		new nname[80];
		cache_get_field_content(0,"name",nname,mysqlid,80);
		format(str, sizeof(str),"����װ��\t%s\n",nname);
	}
	strcat(string,str);
	if(house[index][h_sellmoney]>-1)format(str, sizeof(str),"���۷���\t$%i\n",house[index][h_sellmoney]);
	else format(str, sizeof(str),"���۷���\t\n");
	strcat(string,str);
	format(str, sizeof(str),"��������\t���˿�\n");
	strcat(string,str);
    return string;
}
ShowHouseBuyMenu(index)
{
	new string[1024],str[100];
	format(str, sizeof(str),"������\t$%i\n",house[index][h_sellmoney]);
	strcat(string,str);
	format(str, sizeof(str),"�ι�һ��\t\n");
	strcat(string,str);
	format(str, sizeof(str),"���빺��\t\n");
	strcat(string,str);
    return string;
}
ACT::OnplayerEnterHouseDoor(playerid,areaid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
		foreach(new i:house)
		{
		    if(areaid==house[i][h_oarea])
		    {
	    		if(house[i][h_uid]==-1)
				{
				    if(pEnter[playerid])
					{
						pEnter[playerid]=false;
						return 1;
					}
                	new caption[80];
					format(caption,sizeof(caption), "ϵͳ���� %s ����˵�",house[i][h_name]);
					Dialog_Show(playerid,dl_system_house_buy,DIALOG_STYLE_TABLIST,caption,ShowHouseBuyMenu(i), "ѡ��", "����");
                    SetPVarInt(playerid,"House_Buy_Current_ID",i);
				}
				else
				{
				    if(house[i][h_uid]==pdate[playerid][uid])
				    {
        				if(pEnter[playerid])
				        {
            				pEnter[playerid]=false;
				            return 1;
				        }
				        else
				        {
			        		pEnter[playerid]=true;
				        	SetPPos(playerid,house[i][h_ix],house[i][h_iy],house[i][h_iz],house[i][h_ia],house[i][h_iin],house[i][h_iwl],0.5,2);
             				EnterHouseTip(playerid,i);
						}
				    }
				    else
				    {
					    if(house[i][h_sellmoney]>-1)
						{
                            if(pEnter[playerid])
							{
								pEnter[playerid]=false;
								return 1;
							}
	                		new caption[80];
							format(caption,sizeof(caption), "%s���� %s ����˵�",GetUidName(house[i][h_uid]),house[i][h_name]);
							Dialog_Show(playerid,dl_player_house_buy,DIALOG_STYLE_TABLIST,caption,ShowHouseBuyMenu(i), "ѡ��", "����");
	                        SetPVarInt(playerid,"House_Buy_Current_ID",i);
						}
						else
						{
						    if(house[i][h_lock])
						    {
						        new string[128];
						        if(!strcmp(house[i][h_pass],"NULL",false))
						        {
	         		    		    format(string, sizeof(string)," %s �ķ��� %s ������,�޷�����",GetUidName(house[i][h_uid]),house[i][h_name]);
			    		        	SendClientMessage(playerid,COLOR_TIP,string);
						        }
	                            else
	                            {
	                                format(string, sizeof(string)," %s �ķ��� %s ��������",GetUidName(house[i][h_uid]),house[i][h_name]);
	                                Dialog_Show(playerid,dl_house_pass,DIALOG_STYLE_INPUT,string,"�����뷿������","ȷ��","ȡ��");
	                                SetPVarInt(playerid,"House_Enter_Current_ID",i);
	                            }
						    }
						    else
						    {
						        if(pEnter[playerid])
						        {
						            pEnter[playerid]=false;
						            return 1;
						        }
						        else
						        {
						        	pEnter[playerid]=true;
						        	SetPPos(playerid,house[i][h_ix],house[i][h_iy],house[i][h_iz],house[i][h_ia],house[i][h_iin],house[i][h_iwl],0.5,2);
	                                EnterHouseTip(playerid,i);
								}
							}
						}
					}
				}
				return 1;
		    }
		    if(areaid==house[i][h_iarea])
		    {
    		    if(pEnter[playerid])
    		    {
    		        pEnter[playerid]=false;
    		        return 1;
    		    }
    		    else
    		    {
    		        pEnter[playerid]=true;
    		        SetPPos(playerid,house[i][h_ox],house[i][h_oy],house[i][h_oz],house[i][h_oa],house[i][h_oin],house[i][h_owl],0.5,2);
	    		}
	    		return 1;
		    }
		}
	}
    return 1;
}
ACT::OnplayerLeaveHouseDoor(playerid,areaid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{

	}
    return 1;
}
ACT::EnterHouseTip(playerid,index)
{
	new string[128];
	if(house[index][h_uid]==pdate[playerid][uid])format(string, sizeof(string),"���������ķ��� %s",house[index][h_name]);
	else format(string, sizeof(string),"�������ϵͳ���۵ķ��� %s",house[index][h_name]);
	SendClientMessage(playerid,COLOR_TIP,string);
	if(strcmp(house[index][h_music],"NULL",false))PlayAudioStreamForPlayer(playerid,house[index][h_music]);
    return 1;
}
Dialog:dl_house_in_buy(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new listid=Editid[playerid];
        if(house[listid][h_sellmoney]==-1)return SendClientMessage(playerid,COLOR_WARNING,"�÷����ѱ����˹���");
		if(pdate[playerid][cash]<house[listid][h_sellmoney])return SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
        if(house[listid][h_uid]==-1)
        {
         	GiveCash(playerid,-house[listid][h_sellmoney]);
			UpdateHouseOwner(listid,pdate[playerid][uid],-1,0,"NULL");
   			DeleteHouseFace(listid);
    		CreateHouseFace(listid);
            SendClientMessage(playerid,COLOR_TIP,"����ɹ�");
 			pEnter[playerid]=true;
 			SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
  			EnterHouseTip(playerid,listid);
        }
        else
        {
        	new string[128];
         	format(string, sizeof(string),"%s ���� $%i ��������ķ��� %s ",Pname[playerid],house[listid][h_sellmoney],house[listid][h_name]);
         	SystemSendMsgToPlayer(house[listid][h_uid],string,house[listid][h_sellmoney]);
			GiveCash(playerid,-house[listid][h_sellmoney]);
			UpdateHouseOwner(listid,pdate[playerid][uid],-1,0,"NULL");
			DeleteHouseFace(listid);
          	CreateHouseFace(listid);
			SendClientMessage(playerid,COLOR_TIP,"����ɹ�");
			pEnter[playerid]=true;
			SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
			EnterHouseTip(playerid,listid);
        }
    	Pedit[playerid]=PLAYER_EDIT_NONE;
		Editid[playerid]=-1;
	}
	return 1;
}
Dialog:dl_system_house_buy(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new listid=GetPVarInt(playerid,"House_Buy_Current_ID");
        if(house[listid][h_sellmoney]==-1)return SendClientMessage(playerid,COLOR_WARNING,"�÷����ѱ����˹���");
        switch(listitem)
        {
            case 0:
            {
                if(pdate[playerid][cash]<house[listid][h_sellmoney])return SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
                GiveCash(playerid,-house[listid][h_sellmoney]);
                UpdateHouseOwner(listid,pdate[playerid][uid],-1,0,"NULL");
          		DeleteHouseFace(listid);
          		CreateHouseFace(listid);
                SendClientMessage(playerid,COLOR_TIP,"����ɹ�");
       			pEnter[playerid]=true;
       			SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
          		EnterHouseTip(playerid,listid);
            }
            case 1:
            {
       			pEnter[playerid]=true;
       			SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
          		EnterHouseTip(playerid,listid);
          		Pedit[playerid]=PLAYER_EDIT_HOUSE_BUY;
            	Editid[playerid]=listid;
          		SendClientMessage(playerid,COLOR_TIP,"�����ڲι۷���,����H�����Թ���");
            }
        }
	}
	return 1;
}
Dialog:dl_player_house_buy(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new listid=GetPVarInt(playerid,"House_Buy_Current_ID");
        if(house[listid][h_sellmoney]==-1)return SendClientMessage(playerid,COLOR_WARNING,"�÷����ѱ����˹���");
        switch(listitem)
        {
            case 0:
            {
                if(pdate[playerid][cash]<house[listid][h_sellmoney])return SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
                new string[128];
                format(string, sizeof(string),"%s ���� $%i ��������ķ��� %s ",Pname[playerid],house[listid][h_sellmoney],house[listid][h_name]);
                SystemSendMsgToPlayer(house[listid][h_uid],string,house[listid][h_sellmoney]);
				GiveCash(playerid,-house[listid][h_sellmoney]);
                UpdateHouseOwner(listid,pdate[playerid][uid],-1,0,"NULL");
          		DeleteHouseFace(listid);
          		CreateHouseFace(listid);
                SendClientMessage(playerid,COLOR_TIP,"����ɹ�");
       			pEnter[playerid]=true;
       			SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
          		EnterHouseTip(playerid,listid);

            }
            case 1:
            {
       			pEnter[playerid]=true;
       			SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
          		EnterHouseTip(playerid,listid);
          		Pedit[playerid]=PLAYER_EDIT_HOUSE_BUY;
            	Editid[playerid]=listid;
          		SendClientMessage(playerid,COLOR_TIP,"�����ڲι۷���,����H�����Թ���");
            }
        }
	}
	return 1;
}
Dialog:dl_house_pass(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new listid=GetPVarInt(playerid,"House_Enter_Current_ID");
	    new hpass[129];
	    SHA256_PassHash(inputtext,Salt_ACCOUNT,hpass,129);
	    if(!strcmp(hpass,house[listid][h_pass], false))
		{
			pEnter[playerid]=true;
		    SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
            EnterHouseTip(playerid,listid);
		}
		else SendClientMessage(playerid,COLOR_WARNING,"�������,�޷�����");
	}
	return 1;
}
Dialog:dl_own_house_menu(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
        if(house[listid][h_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
        switch(listitem)
        {
            case 0:Dialog_Show(playerid,dl_owner_house_rename, DIALOG_STYLE_INPUT,"���ķ���","�����뷿�ӵ�����.","ȷ��","ȡ��");
            case 1:Dialog_Show(playerid,dl_owner_house_locked,DIALOG_STYLE_TABLIST,"��������","��������\t\n��������\t\nȡ������\n","ȷ��","ȡ��");
            case 2:Dialog_Show(playerid,dl_owner_house_music,DIALOG_STYLE_TABLIST,"��������","��������\t$10000\nȡ������\n","ȷ��","ȡ��");
            case 3:ShowPlayerDecorateBuy(playerid,1);
            case 4:Dialog_Show(playerid,dl_owner_house_sell,DIALOG_STYLE_TABLIST,"��������","���۷���\t\nȡ������\n","ȷ��","ȡ��");
            case 5:
            {
                UpdateHouseOwner(listid,-1,10000,0,"NULL");
                UpdateHouse3D(listid);
                pEnter[playerid]=true;
    		    SetPPos(playerid,house[listid][h_ox],house[listid][h_oy],house[listid][h_oz],house[listid][h_oa],house[listid][h_oin],house[listid][h_owl],0.5,2);
            }
        }
    }
    return 1;
}
Dialog:dl_owner_house_sell(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
        if(house[listid][h_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
        switch(listitem)
        {
            case 0:Dialog_Show(playerid,dl_owner_house_set_sell, DIALOG_STYLE_INPUT,"���ü۸�","������Ҫ���۵ļ۸�.","ȷ��","ȡ��");
            case 1:
			{
				UpdateHouseSell(listid,-1);
				UpdateHouse3D(listid);
			}
        }
    }
    return 1;
}
Dialog:dl_owner_house_set_sell(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strval(inputtext)<1)return Dialog_Show(playerid,dl_owner_house_set_sell, DIALOG_STYLE_INPUT,"���ü۸�","������Ҫ���۵ļ۸�.","ȷ��","ȡ��");
        new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
        if(house[listid][h_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
		UpdateHouseSell(listid,strval(inputtext));
		UpdateHouse3D(listid);
    }
    return 1;
}
Dialog:dl_owner_house_music(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
        if(house[listid][h_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
        switch(listitem)
        {
            case 0:Dialog_Show(playerid,dl_owner_house_music_str, DIALOG_STYLE_INPUT,"��������","��������������.","ȷ��","ȡ��");
            case 1:UpdateHouseMusic(listid,"NULL");
        }
    }
    return 1;
}
Dialog:dl_owner_house_music_str(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext)<4||strlen(inputtext)>256)return Dialog_Show(playerid,dl_owner_house_music_str, DIALOG_STYLE_INPUT,"��������","��������������.","ȷ��","ȡ��");
        if(pdate[playerid][cash]<10000)return SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
        new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
        if(house[listid][h_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
		GiveCash(playerid,-10000);
		UpdateHouseMusic(listid,inputtext);
    }
    return 1;
}
Dialog:dl_owner_house_locked(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
        if(house[listid][h_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
        switch(listitem)
        {
            case 0:UpdateHouseLock(listid,1,"NULL");
            case 1:
			{
			    if(!house[listid][h_lock])return SendClientMessage(playerid,COLOR_WARNING,"�㻹û�п�������");
				Dialog_Show(playerid,dl_owner_house_pass_set, DIALOG_STYLE_INPUT,"��������","����������.","ȷ��","ȡ��");
			}
            case 2:UpdateHouseLock(listid,0,"NULL");
        }
    }
    return 1;
}
Dialog:dl_owner_house_pass_set(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext)<4||strlen(inputtext)>129)return Dialog_Show(playerid,dl_owner_house_password_set, DIALOG_STYLE_INPUT,"��������","����������.","ȷ��","ȡ��");
        new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
        if(house[listid][h_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
        UpdateHouseLock(listid,1,inputtext);
    }
    return 1;
}
Dialog:dl_owner_house_rename(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext)<4||strlen(inputtext)>80)return Dialog_Show(playerid,dl_owner_house_rename, DIALOG_STYLE_INPUT,"���ķ���","�����뷿�ӵ�����.","ȷ��","ȡ��");
        new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
        if(house[listid][h_uid]!=pdate[playerid][uid])return SendClientMessage(playerid,COLOR_WARNING,"�ⲻ����ķ���");
        UpdateHouseName(listid,inputtext);
        UpdateHouse3D(listid);
    }
    return 1;
}
ACT::ShowPlayerDecorateBuy(playerid,pages)
{
	format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_DEC"`");
    mysql_tquery(mysqlid, Querys, "OnPlayerDecorateBuyMenu", "ii",playerid,pages);
	return 1;
}
ACT::OnPlayerDecorateBuyMenu(playerid,pages)
{
	new rows=cache_get_row_count(mysqlid);
	if(!rows)return SendClientMessage(playerid,COLOR_WARNING,"û��װ���б�");
    current_number[playerid]=1;
  	for(new i=0;i<rows;i++)
	{
        current_idx[playerid][current_number[playerid]]=cache_get_field_content_int(i, "id");
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"û����һҳ");
	}
	else page[playerid]=pages;
	if(pages>floatround(rows/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"û�и�ҳ");
		page[playerid]=1;
	}

    new string[2048],caption[64];
    new pager = (page[playerid]-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "����\t�۸�\tʹ����\n");
	strcat(string,caption);
	strcat(string,"{FF8000}��һҳ\n");
	new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
 	for(new i = pager;i < pager+MAX_DILOG_LIST;i++)
	{
	    new tmp[300],tmps[270],sendertime[80];
		if(i<current_number[playerid])
		{
			format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_DEC"` WHERE `id` = '%i' LIMIT 1",current_idx[playerid][i]);
    		mysql_query(mysqlid, Querys);
            cache_get_field_content(0,"name",sendertime,mysqlid,256);
            format(tmps,sizeof(tmps),"{33AA33}%s\t",sendertime);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"{33AA33}$%i\t",cache_get_field_content_int(0,"worth"));
            strcat(tmp,tmps);
            if(house[listid][h_decid]==current_idx[playerid][i])format(tmps,sizeof(tmps),"{33AA33}��\n");
            else format(tmps,sizeof(tmps)," \n");
            strcat(tmp,tmps);
		}
	    if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
	    else strcat(string,tmp);
	}
	if(!isover)strcat(string, "{FF8000}��һҳ\n");

	new str[60];
	format(str,sizeof(str),"����װ���б�-����[%i]",rows);
	Dialog_Show(playerid,dl_player_Decorate_buy,DIALOG_STYLE_TABLIST_HEADERS,str,string, "ѡ��", "����");
	return 1;
}
Dialog:dl_player_Decorate_buy(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowPlayerDecorateBuy(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowPlayerDecorateBuy(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			new listid1=GetPVarInt(playerid,"House_Owner_Current_ID");
			if(house[listid1][h_decid]==listid)return SendClientMessage(playerid,COLOR_WARNING,"���Ѿ������װ����");
            format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_DEC"` WHERE `id` = '%i' LIMIT 1",listid);
    		mysql_query(mysqlid, Querys);
    		SetPPos(playerid,cache_get_field_content_float(0,"x"),cache_get_field_content_float(0,"y"),cache_get_field_content_float(0,"z"),cache_get_field_content_float(0,"a"),cache_get_field_content_int(0,"int"),GetPlayerVirtualWorld(playerid),0.5,2);
			new nname[80],string[128];
			cache_get_field_content(0,"name",nname,mysqlid,80);
			SendClientMessage(playerid,COLOR_TIP,"װ��Ԥ��,4��6���л�,N�������ȡ��");
			format(string, sizeof(string),"װ�� %s,�۸� $%i",nname,cache_get_field_content_int(0,"worth"));
            SendClientMessage(playerid,COLOR_TIP,string);
    		Pedit[playerid]=PLAYER_EDIT_HOUSE_DEC;
            Editid[playerid]=listid;
		}
	}
	else
	{

	}
	return 1;
}
Dialog:dl_house_buy_dec(playerid, response, listitem, inputtext[])
{
    new listid=GetPVarInt(playerid,"House_Owner_Current_ID");
	if(response)
	{
  		format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_DEC"` WHERE `id` = '%i' LIMIT 1",Editid[playerid]);
    	mysql_query(mysqlid, Querys);
	    if(pdate[playerid][cash]<cache_get_field_content_int(0,"worth"))
		{
			Editid[playerid]=-1;
			Pedit[playerid]=PLAYER_EDIT_NONE;
			pEnter[playerid]=true;
       		SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
            SendClientMessage(playerid,COLOR_WARNING,"����ֽ���");
			return 1;
		}
		GiveCash(playerid,-cache_get_field_content_int(0,"worth"));
		UpdateHouseInPos(listid,cache_get_field_content_float(0,"x"),cache_get_field_content_float(0,"y"),cache_get_field_content_float(0,"z"),cache_get_field_content_float(0,"a"),cache_get_field_content_int(0,"int"),Editid[playerid]);
        DeleteHouseFace(listid);
        CreateHouseFace(listid);
		Editid[playerid]=-1;
		Pedit[playerid]=PLAYER_EDIT_NONE;
		pEnter[playerid]=true;
       	SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
	}
	else
	{
		Editid[playerid]=-1;
		Pedit[playerid]=PLAYER_EDIT_NONE;
		pEnter[playerid]=true;
       	SetPPos(playerid,house[listid][h_ix],house[listid][h_iy],house[listid][h_iz],house[listid][h_ia],house[listid][h_iin],house[listid][h_iwl],0.5,2);
	}
	return 1;
}

ACT::ShowAllHouse(playerid,pages)
{
	if(!Iter_Count(house))return SendClientMessage(playerid,COLOR_WARNING,"û�з����ܼ�¼");
    current_number[playerid]=1;
  	foreach(new i:house)
	{
        current_idx[playerid][current_number[playerid]]=i;
        current_number[playerid]++;
	}
	if(pages==0)
	{
		page[playerid]=1;
		SendClientMessage(playerid,COLOR_WARNING,"û����һҳ");
	}
	else page[playerid]=pages;
	if(pages>floatround(Iter_Count(house)/float(MAX_DILOG_LIST),floatround_ceil))
	{
		SendClientMessage(playerid,COLOR_WARNING,"û�и�ҳ");
		page[playerid]=1;
	}
	new string[60];
	format(string,sizeof(string),"�����ܼ�¼-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_allhouse,DIALOG_STYLE_TABLIST_HEADERS,string,Dialog_AllHouse_RetrunStr(playerid,page[playerid]), "����", "����");
	return 1;
}
Dialog_AllHouse_RetrunStr(playerid,pager)
{
    new string[2048],caption[64];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager==0)pager = 1;
	else pager++;
	new isover=0;
	format(caption,sizeof(caption), "���\t����\t����\t�۸�\n");
	strcat(string,caption);
	strcat(string,"{FF8000}��һҳ\n");
 	for(new i = pager;i < pager+MAX_DILOG_LIST; i++)
	{
	    new tmp[100],tmps[32];
		if(i<current_number[playerid])
		{
            format(tmps,sizeof(tmps),"{00FF00}%i\t",house[current_idx[playerid][i]][h_hid]);
            strcat(tmp,tmps);
            format(tmps,sizeof(tmps),"{FF00FF}%s\t",house[current_idx[playerid][i]][h_name]);
            strcat(tmp,tmps);
            if(house[current_idx[playerid][i]][h_uid]!=-1)format(tmps,sizeof(tmps),"{33FF00}%s\t",GetUidName(house[current_idx[playerid][i]][h_uid]));
            else format(tmps,sizeof(tmps),"{33FF00}ϵͳ����\t");
            strcat(tmp,tmps);
            if(house[current_idx[playerid][i]][h_sellmoney]==-1)format(tmps,sizeof(tmps),"{00AAFF}������\n");
            else format(tmps,sizeof(tmps),"{00AAFF}$%i\n",house[current_idx[playerid][i]][h_sellmoney]);
            strcat(tmp,tmps);
		}
	    if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
	    else strcat(string,tmp);
	}
	if(!isover)strcat(string, "{FF8000}��һҳ\n");
    return string;
}
Dialog:dl_allhouse(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager = (page[playerid]-1)*MAX_DILOG_LIST;
		if(!pager)pager = 1;
		else pager++;
		if(!listitem)
	  	{
    	    page[playerid]--;
    	    ShowAllHouse(playerid,page[playerid]);
	    }
		else if(listitem==MAX_DILOG_LIST+1)
	  	{
			page[playerid]++;
            ShowAllHouse(playerid,page[playerid]);
	    }
		else
		{
			new listid=current_idx[playerid][pager+listitem-1];
			pEnter[playerid]=true;
       		SetPPos(playerid,house[listid][h_ox],house[listid][h_oy],house[listid][h_oz],house[listid][h_oa],house[listid][h_oin],house[listid][h_owl],0.5,2);
		}
	}
	else
	{

	}
	return 1;
}
