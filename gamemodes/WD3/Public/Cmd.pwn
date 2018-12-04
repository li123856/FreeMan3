YCMD:accpet(playerid, params[], help)
{
	new inpute[80];
	new idx;
	inpute = strtok(params,idx);
    if(!strlen(inpute))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入/accpet join");
    if(GetPVarInt(playerid,"Gang_Join_ID")==-1)return SendClientMessage(playerid,COLOR_WARNING,"没有人要加入你的公司");
	if(!strcmp(inpute,"join",false))AcceptPlayerGangJoin(playerid);
	return 1;
}
YCMD:g(playerid, params[], help)
{
	new Float:xx,Float:yy,Float:zz;
	if(sscanf(params, "fff",xx,yy,zz))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /g x y z");
	SetPlayerPos(playerid,xx,yy,zz);
	return 1;
}
YCMD:addfurn(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new models,furnnames[80];
	if(sscanf(params, "s[80]iD(0)",furnnames,models))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /addfurn 命名 模型ID 价格  用户ID");
	new Float:xx,Float:yy,Float:zz;
	GetPlayerFaceFrontPos(playerid,2,xx,yy,zz);
	AddFurn(models,xx,yy,zz-0.5,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),furnnames);
	return 1;
}
YCMD:addhouse(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new sellr,decs,Float:ixx,Float:iyy,Float:izz,Float:iaa,hanmes[80],intts;
	if(sscanf(params, "iis[80]ffffi",decs,sellr,hanmes,ixx,iyy,izz,iaa,intts))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /addhouse 装潢ID 价格 房名 装潢X 装潢Y 装潢Z 装潢A 装潢空间ID");
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
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new index;
	if(sscanf(params, "i",index))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /sethouseout ID");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"该房子ID不存在");
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
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new index;
	if(sscanf(params, "i",index))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /sethousein ID");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"该房子ID不存在");
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
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new index;
	if(sscanf(params, "i",index))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /reloadhouse ID");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"该房子ID不存在");
	ReloadHouseTemplate(house[index][h_hid],index);
	return 1;
}
YCMD:removehouse(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new index;
	if(sscanf(params, "i",index))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /removehouse ID");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"该房子ID不存在");
	RemoveHouse(index);
	return 1;
}
YCMD:sellhouse(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new index,moneys;
	if(sscanf(params, "ii",index,moneys))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /sellhouse ID 价格");
	if(!Iter_Contains(house,index))return SendClientMessage(playerid,COLOR_WARNING,"该房子ID不存在");
    UpdateHouseOwner(index,-1,moneys,0,"NULL");
    UpdateHouse3D(index);
	return 1;
}


YCMD:clear(playerid, params[], help)
{

	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new types;
	if(sscanf(params, "D(0)",types))
	switch(types)
	{
	    case 0:
	    {
			format(Querys, sizeof(Querys),"TRUNCATE TABLE `"SQL_LOG"`");
			mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"管理员 %s 清空了所有的日志",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
			return SendClientMessage(playerid,COLOR_WARNING,"你清空了所有的日志");
		}
		case LOG_TYPE_LOGIN:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_LOGIN);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"管理员 %s 清空了所有的登录日志",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"你清空了所有的登录日志");
		}
		case LOG_TYPE_OUT:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_OUT);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"管理员 %s 清空了所有的离开日志",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"你清空了所有的离开日志");
		}
		case LOG_TYPE_ADMIN:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_ADMIN);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"管理员 %s 清空了所有的管理日志",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"你清空了所有的管理日志");
		}
		case LOG_TYPE_CHEATE:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_CHEATE);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"管理员 %s 清空了所有的反作弊日志",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"你清空了所有的反作弊日志");
		}
		case LOG_TYPE_TEXT:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_TEXT);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"管理员 %s 清空了所有的公屏日志",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"你清空了所有的公屏日志");
		}
		case LOG_TYPE_DEAL:
		{
		    format(Querys,sizeof(Querys),"DELETE FROM `"SQL_LOG"` WHERE `  type ` = '%i'",LOG_TYPE_DEAL);
	    	mysql_query(mysqlid,Querys,false);
			new string[100];
			format(string, sizeof(string),"管理员 %s 清空了所有的交易日志",Pname[playerid]);
			AddLog(LOG_TYPE_ADMIN,string);
	    	return SendClientMessage(playerid,COLOR_WARNING,"你清空了所有的交易日志");
		}
	}
	return 1;
}
YCMD:setadmin(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new levels,players;
	if(sscanf(params, "ii",players,levels))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /setadmin 目标玩家ID 等级[0-2]");
    if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"对方没有登陆");
	if(levels<0||levels>=ADMIN_LARGE)return SendClientMessage(playerid,COLOR_WARNING,"等级错误,范围[0-3]");
	SetAdmin(players,levels);
	new str[100];
	format(str, sizeof(str),"管理员 %s 设置 %s 为 %i 级管理员",Pname[playerid],Pname[players],levels);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:duty(playerid, params[], help)
{
    if(pdate[playerid][admin]<ADMIN_SMALL)return SendClientMessage(playerid,COLOR_WARNING,"你不是管理员");
    if(Duty[playerid])
	{
	    Duty[playerid]=false;
		return SendClientMessage(playerid,COLOR_WARNING,"你已经退出管理模式");
	}
    if(!strcmp("NULL",pdate[playerid][adminpasswords], false))Dialog_Show(playerid,dl_admin_register, DIALOG_STYLE_INPUT,"注册管理密码","你是新任命的管理员,请先注册管理密码再登录.","注册","取消");
	else Dialog_Show(playerid,dl_admin_login, DIALOG_STYLE_PASSWORD,"登录管理","请输入你的管理密码","登录","取消");
    return 1;
}
YCMD:givemoney(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new players,amouts;
	if(sscanf(params, "ii",players,amouts))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /givemoney 目标玩家ID 钱数");
    if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"对方没有登陆");
	GiveCash(players,amouts);
	new string[128];
    format(string,sizeof(string), "[管理员] %s 给予你现金 $%i",Pname[playerid],amouts);
    SendClientMessage(players,COLOR_WARNING,string);
    format(string,sizeof(string), "[管理员] 你给予了 %s 现金 $%i",Pname[players],amouts);
    SendClientMessage(playerid,COLOR_WARNING,string);
	new str[100];
	format(str, sizeof(str),"管理员 %s 给予了 %s 现金 $%i",Pname[playerid],Pname[players],amouts);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:setmoney(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new players,amouts;
	if(sscanf(params, "ii",players,amouts))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /setmoney 目标玩家ID 钱数");
    if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"对方没有登陆");
    SetCash(players,amouts);
	new string[128];
    format(string,sizeof(string), "[管理员] %s 设置你的现金为 $%i",Pname[playerid],amouts);
    SendClientMessage(players,COLOR_WARNING,string);
    format(string,sizeof(string), "[管理员] 你设置了 %s 的现金为 $%i",Pname[players],amouts);
    SendClientMessage(playerid,COLOR_WARNING,string);
	new str[100];
	format(str, sizeof(str),"管理员 %s 设置了 %s 现金为 $%i",Pname[playerid],Pname[players],amouts);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:setbank(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new players,amouts;
	if(sscanf(params, "ii",players,amouts))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /setbank 目标玩家ID 钱数");
    if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"对方没有登陆");
    SetBank(players,amouts);
	new string[128];
    format(string,sizeof(string), "[管理员] %s 设置你的存款为 $%i",Pname[playerid],amouts);
    SendClientMessage(players,COLOR_WARNING,string);
    format(string,sizeof(string), "[管理员] 你设置了 %s 的存款为 $%i",Pname[players],amouts);
    SendClientMessage(playerid,COLOR_WARNING,string);
	new str[100];
	format(str, sizeof(str),"管理员 %s 设置了 %s 存款为 $%i",Pname[playerid],Pname[players],amouts);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:veh(playerid, params[], help)
{
    if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
    ShowAllVeh(playerid,1);
	return 1;
}
YCMD:dveh(playerid, params[], help)
{
    if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new vid;
    if(sscanf(params, "i",vid))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /dveh 车ID");
	if(!Iter_Contains(veh,vid))return SendClientMessage(playerid,COLOR_WARNING,"该载具不存在");
    DeleteVeh(vid);
	new str[100];
	format(str, sizeof(str),"管理员 %s 删除了载具ID %i",Pname[playerid],vid);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}
YCMD:ssm(playerid, params[], help)
{
	if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new uidd,string[512],cashs;
	if(sscanf(params, "is[512]D(0)",uidd,string,cashs))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /ssm 目标玩家ID 内容 附件[钱数]");
    if(cashs<0)return SendClientMessage(playerid,COLOR_WARNING,"钱数不能为负数");
    if(SystemSendMsgToPlayer(uidd,string,cashs))
	{
	    if(cashs>0)
	    {
	        new str[100];
			format(str, sizeof(str),"邮件发送成功,附件金额[$%i]",cashs);
			SendClientMessage(playerid,COLOR_WARNING,str);
	    }
	    else SendClientMessage(playerid,COLOR_TIP,"邮件发送成功");
		new str[100],named[80];
		format(Querys, sizeof(Querys),"SELECT `name`  FROM `"SQL_ACCOUNT"` WHERE `uid` = '%i' LIMIT 1",uidd);
		mysql_query(mysqlid,Querys,true);
		cache_get_field_content(0,"name",named,mysqlid,80);
		format(str, sizeof(str),"管理员 %s 发送邮件给 %s 附件 $%i",Pname[playerid],named,cashs);
		AddLog(LOG_TYPE_ADMIN,str);
	}
    else SendClientMessage(playerid,COLOR_WARNING,"发送失败,对方资料不存在");
    return 1;
}
YCMD:addbuyveh(playerid, params[], help)
{
    if(!IsAdminLevel(playerid,ADMIN_LARGE))return SendClientMessage(playerid,COLOR_WARNING,"你不是总管或没有值班");
	new models,col1,col2,buys;
	if(sscanf(params, "iiD(0)D(0)",models,buys,col1,col2))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /addbuyveh 车型 购买价格 颜色1 颜色2");
    if(!IsValidVehicleModel(models))return SendClientMessage(playerid,COLOR_WARNING,"车型ID无效");
	if(buys<=0)return SendClientMessage(playerid,COLOR_WARNING,"价格设置错误,数值必须大于0");
	new Float:xx,Float:yy,Float:zz,Float:angled;
	GetPlayerPos(playerid,xx,yy,zz);
	GetPlayerFacingAngle(playerid,angled);
	new cids=AddBuyVeh(models,buys,xx,yy,zz,angled,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,-1,0);
	new str[100];
	format(str, sizeof(str),"管理员 %s 刷出了一辆车 CID:%i",veh[cids][cid]);
	AddLog(LOG_TYPE_ADMIN,str);
	return 1;
}

