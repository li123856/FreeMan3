YCMD:accpet(playerid, params[], help)
{
	new inpute[80];
	new idx;
	inpute = strtok(params,idx);
    if(!strlen(inpute))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ����/accpet join");
    if(GetPVarInt(playerid,"Gang_Join_ID")==-1)return SendClientMessage(playerid,COLOR_WARNING,"û����Ҫ������Ĺ�˾");
	if(!strcmp(inpute,"join",false))AcceptPlayerGangJoin(playerid);
	return 1;
}
YCMD:g(playerid, params[], help)
{
	new Float:xx,Float:yy,Float:zz;
	if(sscanf(params, "fff",xx,yy,zz))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /g x y z");
	SetPlayerPos(playerid,xx,yy,zz);
	return 1;
}
YCMD:addfurn(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new models,furnnames[80];
	if(sscanf(params, "s[80]iD(0)",furnnames,models))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /addfurn ���� ģ��ID �۸�  �û�ID");
	new Float:xx,Float:yy,Float:zz;
	GetPlayerFaceFrontPos(playerid,2,xx,yy,zz);
	AddFurn(models,xx,yy,zz-0.5,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),furnnames);
	return 1;
}
YCMD:addhouse(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new sellr,decs,Float:ixx,Float:iyy,Float:izz,Float:iaa,hanmes[80],intts;
	if(sscanf(params, "iis[80]ffffi",decs,sellr,hanmes,ixx,iyy,izz,iaa,intts))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /addhouse װ��ID �۸� ���� װ��X װ��Y װ��Z װ��A װ��ռ�ID");
	new Float:xx,Float:yy,Float:zz,Float:aa;
	GetPlayerFacingAngle(playerid,aa);
	GetPlayerPos(playerid,xx,yy,zz);
	if(decs>=1)
	{
        format(Querys, sizeof(Querys), "SELECT * FROM `"SQL_DEC"` WHERE `id` = '%i' LIMIT 1",decs);
    	mysql_query(mysqlid, Querys);
    	AddHouse(decs,xx,yy,zz,aa,cache_get_field_content_float(0,"x"),cache_get_field_content_float(0,"y"),cache_get_field_content_float(0,"z"),cache_get_field_content_float(0,"a"),GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),cache_get_field_content_int(0,"int"),sellr,hanmes,-1);
	}
	else AddHouse(decs,xx,yy,zz,aa,ixx,iyy,izz,iaa,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),intts,sellr,hanmes,-1);
	return 1;
}
YCMD:sethouseout(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new index;
	if(sscanf(params, "i",index))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /sethouseout ID");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"�÷���ID������");
	new Float:xx,Float:yy,Float:zz,Float:aa;
	GetPlayerFacingAngle(playerid,aa);
	GetPlayerPos(playerid,xx,yy,zz);
	UpdateHouseOutPos(index,xx,yy,zz,aa,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
	DeleteHouseFace(index);
	CreateHouseFace(index);
	return 1;
}
YCMD:sethousein(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new index;
	if(sscanf(params, "i",index))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /sethousein ID");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"�÷���ID������");
	new Float:xx,Float:yy,Float:zz,Float:aa;
	GetPlayerFacingAngle(playerid,aa);
	GetPlayerPos(playerid,xx,yy,zz);
	UpdateHouseInPos(index,xx,yy,zz,aa,GetPlayerInterior(playerid),-1);
	DeleteHouseFace(index);
	CreateHouseFace(index);
	return 1;
}

YCMD:reloadhouse(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new index;
	if(sscanf(params, "i",index))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /reloadhouse ID");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"�÷���ID������");
	ReloadHouseTemplate(house[index][h_hid],index);
	return 1;
}
YCMD:removehouse(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new index;
	if(sscanf(params, "i",index))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /removehouse ID");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"�÷���ID������");
	RemoveHouse(index);
	return 1;
}
YCMD:sellhouse(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new index,moneys;
	if(sscanf(params, "ii",index,moneys))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /sellhouse ID �۸�");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"�÷���ID������");
    UpdateHouseOwner(index,-1,moneys,0,"NULL");
    UpdateHouse3D(index);
	return 1;
}


YCMD:clear(playerid, params[], help)
{

	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new types;
	if(sscanf(params, "D(0)",types))
	switch(types)
	{
	    case 0:
	    {
			format(Querys, sizeof(Querys),"TRUNCATE TABLE `"SQL_LOG"`");
			mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"����Ա %s ��������е���־",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
			return SendClientMessage(playerid,COLOR_WARNING,"����������е���־");
		}
		case LOG_TYPE_LOGIN:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_LOGIN);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"����Ա %s ��������еĵ�¼��־",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"����������еĵ�¼��־");
		}
		case LOG_TYPE_OUT:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_OUT);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"����Ա %s ��������е��뿪��־",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"����������е��뿪��־");
		}
		case LOG_TYPE_ADMIN:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_ADMIN);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"����Ա %s ��������еĹ�����־",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"����������еĹ�����־");
		}
		case LOG_TYPE_CHEATE:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_CHEATE);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"����Ա %s ��������еķ�������־",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"����������еķ�������־");
		}
		case LOG_TYPE_TEXT:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_TEXT);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"����Ա %s ��������еĹ�����־",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"����������еĹ�����־");
		}
		case LOG_TYPE_DEAL:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_DEAL);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"����Ա %s ��������еĽ�����־",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"����������еĽ�����־");
		}
	}
	return 1;
}
YCMD:setadmin(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new levels,players;
	if(sscanf(params, "ii",players,levels))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /setadmin Ŀ�����ID �ȼ�[0-2]");
    if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"�Է�û�е�½");
	if(levels<0||levels>=ADMIN_LARGE)return SendClientMessage(playerid,COLOR_WARNING,"�ȼ�����,��Χ[0-3]");
	SetAdmin(players,levels);
	new str[100];
	format(str, sizeof(str),"����Ա %s ���� %s Ϊ %i ������Ա",Pname[playerid],Pname[players],levels);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:duty(playerid, params[], help)
{
    if(pdate[playerid][admin]<ADMIN_SMALL)return SendClientMessage(playerid,COLOR_WARNING,"�㲻�ǹ���Ա");
    if(Duty[playerid])
	{
	    Duty[playerid]=false;
		return SendClientMessage(playerid,COLOR_WARNING,"���Ѿ��˳�����ģʽ");
	}
    if(!strcmp("NULL",pdate[playerid][adminpasswords], false))Dialog_Show(playerid,dl_admin_register, DIALOG_STYLE_INPUT,"ע���������","�����������Ĺ���Ա,����ע����������ٵ�¼.","ע��","ȡ��");
	else Dialog_Show(playerid,dl_admin_login, DIALOG_STYLE_PASSWORD,"��¼����","��������Ĺ�������","��¼","ȡ��");
    return 1;
}
YCMD:givemoney(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new players,amouts;
	if(sscanf(params, "ii",players,amouts))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /givemoney Ŀ�����ID Ǯ��");
    if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"�Է�û�е�½");
	GiveCash(players,amouts);
	new string[128];
    format(string,sizeof(string), "[����Ա] %s �������ֽ� $%i",Pname[playerid],amouts);
    SendClientMessage(players,COLOR_WARNING,string);
    format(string,sizeof(string), "[����Ա] ������� %s �ֽ� $%i",Pname[players],amouts);
    SendClientMessage(playerid,COLOR_WARNING,string);
	new str[100];
	format(str, sizeof(str),"����Ա %s ������ %s �ֽ� $%i",Pname[playerid],Pname[players],amouts);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:setmoney(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new players,amouts;
	if(sscanf(params, "ii",players,amouts))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /setmoney Ŀ�����ID Ǯ��");
    if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"�Է�û�е�½");
    SetCash(players,amouts);
	new string[128];
    format(string,sizeof(string), "[����Ա] %s ��������ֽ�Ϊ $%i",Pname[playerid],amouts);
    SendClientMessage(players,COLOR_WARNING,string);
    format(string,sizeof(string), "[����Ա] �������� %s ���ֽ�Ϊ $%i",Pname[players],amouts);
    SendClientMessage(playerid,COLOR_WARNING,string);
	new str[100];
	format(str, sizeof(str),"����Ա %s ������ %s �ֽ�Ϊ $%i",Pname[playerid],Pname[players],amouts);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:setbank(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new players,amouts;
	if(sscanf(params, "ii",players,amouts))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /setbank Ŀ�����ID Ǯ��");
    if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"�Է�û�е�½");
    SetBank(players,amouts);
	new string[128];
    format(string,sizeof(string), "[����Ա] %s ������Ĵ��Ϊ $%i",Pname[playerid],amouts);
    SendClientMessage(players,COLOR_WARNING,string);
    format(string,sizeof(string), "[����Ա] �������� %s �Ĵ��Ϊ $%i",Pname[players],amouts);
    SendClientMessage(playerid,COLOR_WARNING,string);
	new str[100];
	format(str, sizeof(str),"����Ա %s ������ %s ���Ϊ $%i",Pname[playerid],Pname[players],amouts);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:veh(playerid, params[], help)
{
    if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
    ShowAllVeh(playerid,1);
	return 1;
}
YCMD:dveh(playerid, params[], help)
{
    if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new vid;
    if(sscanf(params, "i",vid))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /dveh ��ID");
	if(!Iter_Contains(veh,vid))return SendClientMessage(playerid,COLOR_WARNING,"���ؾ߲�����");
    DeleteVeh(vid);
	new str[100];
	format(str, sizeof(str),"����Ա %s ɾ�����ؾ�ID %i",Pname[playerid],vid);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:ssm(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new uidd,string[512],cashs;
	if(sscanf(params, "is[512]D(0)",uidd,string,cashs))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /ssm Ŀ�����ID ���� ����[Ǯ��]");
    if(cashs<0)return SendClientMessage(playerid,COLOR_WARNING,"Ǯ������Ϊ����");
    if(SystemSendMsgToPlayer(uidd,string,cashs))
	{
	    if(cashs>0)
	    {
	        new str[100];
			format(str, sizeof(str),"�ʼ����ͳɹ�,�������[$%i]",cashs);
			SendClientMessage(playerid,COLOR_WARNING,str);
	    }
	    else SendClientMessage(playerid,COLOR_TIP,"�ʼ����ͳɹ�");
		new str[100],named[80];
		format(Querys, sizeof(Querys),"SELECT `name`  FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",uidd);
		mysql_query(mysqlid,Querys,true);
		cache_get_field_content(0,"name",named,mysqlid,80);
		format(str, sizeof(str),"����Ա %s �����ʼ��� %s ���� $%i",Pname[playerid],named,cashs);
		AddLog(LOG_TYPE_ADMIN,str);
	}
    else SendClientMessage(playerid,COLOR_WARNING,"����ʧ��,�Է����ϲ�����");
    return 1;
}
YCMD:addbuyveh(playerid, params[], help)
{
    if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"�㲻���ܹܻ�û��ֵ��");
	new models,col1,col2,buys;
	if(sscanf(params, "iiD(0)D(0)",models,buys,col1,col2))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /addbuyveh ���� ����۸� ��ɫ1 ��ɫ2");
    if(!IsValidVehicleModel(models))return SendClientMessage(playerid,COLOR_WARNING,"����ID��Ч");
	if(buys<=0)return SendClientMessage(playerid,COLOR_WARNING,"�۸����ô���,��ֵ�������0");
	new Float:xx,Float:yy,Float:zz,Float:angled;
	GetPlayerPos(playerid,xx,yy,zz);
	GetPlayerFacingAngle(playerid,angled);
	new cids=AddBuyVeh(models,buys,xx,yy,zz,angled,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,-1,0);
	new str[100];
	format(str, sizeof(str),"����Ա %s ˢ����һ���� CID:%i",veh[cids][cid]);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}

