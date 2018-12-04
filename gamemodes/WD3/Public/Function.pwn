PreLoadAnim(playerid)
{
	PreloadAnimLib(playerid,"BOMBER");
	PreloadAnimLib(playerid,"RAPPING");
	PreloadAnimLib(playerid,"SHOP");
	PreloadAnimLib(playerid,"BEACH");
	PreloadAnimLib(playerid,"SMOKING");
	PreloadAnimLib(playerid,"FOOD");
	PreloadAnimLib(playerid,"ON_LOOKERS");
	PreloadAnimLib(playerid,"DEALER");
	PreloadAnimLib(playerid,"CRACK");
	PreloadAnimLib(playerid,"CARRY");
	PreloadAnimLib(playerid,"COP_AMBIENT");
	PreloadAnimLib(playerid,"PARK");
	PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"FOOD");
	PreloadAnimLib(playerid,"PED");
}
PreloadAnimLib(playerid, animlib[])ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
Float:randfloat(Float:max)
{
	new tmp = random(floatround(max*1000));
	new Float:result = floatdiv(float(tmp), 1000.0);
	return Float:result;
}
#include WD3/Mysql/Mysql.pwn
#include WD3/Log/Log.pwn
#include WD3/Account/Account.pwn
#include WD3/Gang/Gang.pwn
#include WD3/Mail/Mail.pwn
#include WD3/Bag/Bag.pwn
#include WD3/Veh/Veh.pwn
#include WD3/Msg/Msg.pwn
#include WD3/Furniture/Furn.pwn
#include WD3/Attach/Att.pwn
#include WD3/Friend/Friend.pwn
#include WD3/House/House.pwn
#include WD3/Tele/Teles.pwn
#include WD3/Race/Races.pwn
#include WD3/Area/Areas.pwn
#include WD3/DeathMatch/DM.pwn
ARGB(color_rgba)
{
	new alpha = (color_rgba & 0xff) << 24;
	new rgb = color_rgba >>> 8;
	return alpha | rgb;
}
task ServerUpdateMin[60000]()
{
	OnDmRoomUpdate();
}
task ServerUpdateHalfSec[500]()
{
	OnDmRoomAntiChack();
}
ACT::IsUidLogin(uidid)
{
    foreach(new i:Player)
    {
        if(Login[i])
        {
            if(pdate[i][uid]==uidid)return i;
        }
    }
    return -1;
}
ACT::LetVehHere(playerid,vehicle)
{
   	new Float:xyz[4];
	GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
	GetPlayerFacingAngle(playerid,xyz[3]);
 	SetVehiclePos(vehicle,xyz[0]+randfloat(0.5),xyz[1]+randfloat(0.5),xyz[2]);
 	SetVehicleZAngle(vehicle,xyz[3]);
   	LinkVehicleToInterior(vehicle,GetPlayerInterior(playerid));
 	SetVehicleVirtualWorld(vehicle,GetPlayerVirtualWorld(playerid));
	return 1;
}
ACT::SetVPos(vehicle,Float:xx,Float:yy,Float:zz,Float:aa,interiors,worlds)
{
	SetVehiclePos(vehicle,xx,yy,zz+0.6);
	SetVehicleZAngle(vehicle,aa);
    LinkVehicleToInterior(vehicle,interiors);
    SetVehicleVirtualWorld(vehicle,interiors);
	return 1;
}
ACT::SetPPos(playerid,Float:xx,Float:yy,Float:zz,Float:aa,interiors,worlds,Float:rand,deferd)
{
	if(IsPlayerInAnyVehicle(playerid)&&!GetPlayerVehicleSeat(playerid))
	{
         new caid=GetPlayerVehicleID(playerid);
         SetPlayerPos(playerid,xx+randfloat(rand),yy+randfloat(rand),zz);
	     SetPlayerFacingAngle(playerid,aa);
		 SetPlayerInterior(playerid,interiors);
		 SetPlayerVirtualWorld(playerid,worlds);
		 SetVehiclePos(caid,xx+randfloat(rand),yy+randfloat(rand),zz+rand);
		 SetVehicleZAngle(caid,aa);
         LinkVehicleToInterior(caid,interiors);
    	 SetVehicleVirtualWorld(caid,interiors);
		 PutPlayerInVehicle(playerid,caid,0);
	}
	else
	{
		 SetPlayerPos(playerid,xx+randfloat(rand),yy+randfloat(rand),zz);
	     SetPlayerFacingAngle(playerid,aa);
		 SetPlayerInterior(playerid,interiors);
		 SetPlayerVirtualWorld(playerid,worlds);
	}
	SetCameraBehindPlayer(playerid);
	if(!deferd)return 1;
    TogglePlayerControllable(playerid ,0);
    defer ToggleEnd[deferd*1000](playerid);
    return 1;
}
timer ToggleEnd[1000](playerid)TogglePlayerControllable(playerid ,1);

PlayerToPoint(Float:radi, playerid, Float:xx, Float:yy, Float:zz,inte,wold)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz,oldin,oldwl;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		oldwl=GetPlayerVirtualWorld(playerid);
		oldin=GetPlayerInterior(playerid);
		tempposx = (oldposx -xx);
		tempposy = (oldposy -yy);
		tempposz = (oldposz -zz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))&& oldin==inte&& oldwl==wold)return 1;
	}
	return 0;
}
GetPlayerFaceFrontPos(playerid,Float:distance,&Float:xx,&Float:yy,&Float:zz)
{
	new Float:deg;GetPlayerPos(playerid,xx,yy,zz);
	GetPlayerFacingAngle(playerid,deg);
	xx+=distance*floatsin(-deg,degrees);
	yy+=distance*floatcos(-deg,degrees);
}
strreplace(string[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = sizeof(string))
{
	if(limit == 0)return 0;
	new sublen = strlen(search),replen = strlen(replacement),bool:packed = ispacked(string),maxlen = maxlength,len = strlen(string),count = 0 ;
	if(packed)maxlen *= 4;
	if(!sublen)return 0;
	while(-1 != (pos = strfind(string, search, ignorecase, pos)))
	{
		strdel(string, pos, pos + sublen);
		len -= sublen;
		if(replen && len + replen < maxlen)
		{
			strins(string, replacement, pos, maxlength);
			pos += replen;
			len += replen;
		}
		if(limit != -1 && ++count >= limit)break;
	}
	return count;
}
DKick(playerid,delay_ms = 1000)defer Delay_Kick[delay_ms](playerid);
DBan(playerid,delay_ms = 1000)defer Delay_Ban[delay_ms](playerid);
timer Delay_Kick[1000](playerid)Kick(playerid);
timer Delay_Ban[1000](playerid)Ban(playerid);

IsPlayerInInvalidNosVehicle(playerid,vehicleid)
{
  #define MAX_INVALID_NOS_VEHICLES 29
  new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
  {
	581,523,462,521,463,522,461,448,468,586,
	509,481,510,472,473,493,595,484,430,453,
	452,446,454,590,569,537,538,570,449
  };
  vehicleid = GetPlayerVehicleID(playerid);
  if(IsPlayerInVehicle(playerid,vehicleid))
  {
		for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
		{
		  if(GetVehicleModel(vehicleid) == InvalidNosVehicles[i])return true;
		}
  }
  return false;
}
stock RangeBan(playerid, bool:tworanges)
{
	  new IP[16], string[32], start, end;
	  GetPlayerIp(playerid, IP, 16);
	  if(!tworanges) start = strfind(IP, ".", true, 9)+1;
	  else start = strfind(IP, ".", true, 5)+1;
	  strdel(IP, start, strlen(IP));
	  format(string, 32, "banip %s", IP);
	  SendRconCommand(string);
}

stock SetPlayerLookAt(playerid, Float:xx, Float:yy)
{
	new Float:Px, Float:Py, Float: Pa;
	GetPlayerPos(playerid, Px, Py, Pa);
	Pa = floatabs(atan((y-Py)/(x-Px)));
	if (xx <= Px && yy >= Py) Pa = floatsub(180, Pa);
	else if (xx < Px && yy < Py) Pa = floatadd(Pa, 180);
	else if (xx >= Px && yy <= Py) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	SetPlayerFacingAngle(playerid, Pa);
}

stock SetPlayerDistanceFromPoint(playerid, Float:xx, Float:yy, Float:distance)
{
	new
		Float:Px,
		Float:Py,
		Float:Pz;
	GetPlayerPos(playerid, Px, Py, Pz);
	Px -= xx;
	Py -= yy;
	Pz = floatsqroot(((Px * Px) + (Py * Py)) / (distance * distance));
	SetPlayerPosFindZ(playerid, x + (Px / Pz), y + (Py / Pz), 10.0);
}

RandomPlayerID()
{
	new playerid, connected;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(playerid) == 1) connected++;
	if(connected == 0) return -1;
	start:
	playerid = random(MAX_PLAYERS);
	if(IsPlayerConnected(playerid) == 0) goto start;
	return playerid;
}
ShowColorStr()
{
	new string[1024],str[80];
	for(new i=1;i<sizeof(colorstr);i++)
	{
		format(str,sizeof(str),"%s■■■■■■■■■\n",colorstr[i]);
		strcat(string,str);
	}
	return string;
}
ShowColorStrEx()
{
	new string[1024],str[80];
	for(new i=0;i<sizeof(colorstr);i++)
	{
		if(i==0)format(str,sizeof(str),"%s\n",colorstr[i]);
		else format(str,sizeof(str),"%s■■■■■■■■■\n",colorstr[i]);
		strcat(string,str);
	}
	return string;
}
ShowBonesStr()
{
	new string[512],str[64];
	for(new i=0;i<sizeof(AttBones);i++)
	{
		format(str,sizeof(str),"%s\n",AttBones[i]);
		strcat(string,str);
	}
	return string;
}
Dialog:dl_clickedplayer_doing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"Clickedplayer_Current_ID");
	    switch(listitem)
	    {
	        case 0:
			{
			    new string[128];
	            format(string,sizeof(string), "请使用/reply %i 发送邮件",pdate[listid][uid]);
	            SendClientMessage(playerid,COLOR_TIP,string);
	        }
	        case 1:
	        {
	            if(Iter_Free(friends[listid])==-1)
	            {
	                new string[128];
	            	format(string,sizeof(string), "%s 的好友数量已满,无法加入",Pname[listid]);
	            	SendClientMessage(playerid,COLOR_TIP,string);
	            	return 1;
	            }
	            if(Iter_Free(friends[playerid])==-1)return SendClientMessage(playerid,COLOR_TIP,"你的好友数量已满,无法加入");
				new string[128];
	            format(string,sizeof(string), "%s 请求加你为好友,是否同意",Pname[playerid]);
				if(Dialog_Show(listid,dl_player_friendadd,DIALOG_STYLE_MSGBOX,"好友通知",string,"同意","拒绝"))SendClientMessage(playerid,COLOR_TIP,"发送加好友信息成功");
				else SendClientMessage(playerid,COLOR_WARNING,"发送加好友信息失败,对方正在忙");
				SetPVarInt(listid,"FriendJoin_Current_ID",playerid);
	        }
	    }
	}
	return 1;
}
Dialog:dl_player_friendadd(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"FriendJoin_Current_ID");
	    new string[128];
	    switch(FriendAdd(playerid,listid))
	    {
			case 0:
			{
	            format(string,sizeof(string), "%s 成为了你的好友",Pname[listid]);
	            SendClientMessage(playerid,COLOR_TIP,string);
	            format(string,sizeof(string), "%s 成为了你的好友",Pname[playerid]);
	            SendClientMessage(listid,COLOR_TIP,string);
			}
			case 1:
			{
	            format(string,sizeof(string), "你的好友数量已满,无法加入");
	            SendClientMessage(playerid,COLOR_TIP,string);
	            format(string,sizeof(string), "%s 的好友数量已满,无法加入",Pname[playerid]);
	            SendClientMessage(listid,COLOR_TIP,string);
			}
			case 2:
			{
	            format(string,sizeof(string), "%s 的好友数量已满,无法加入",Pname[listid]);
	            SendClientMessage(playerid,COLOR_TIP,string);
	            format(string,sizeof(string), "你的好友数量已满,无法加入");
	            SendClientMessage(listid,COLOR_TIP,string);
			}
		}
	}
	return 1;
}
stock strlower(string[])
{
    for(new i; i<strlen(string); i++) string[i] = tolower(string[i]);
    return string;
}
stock ConvertTime(Milliseconds,&rHour,&rMin,&rS,&rMS )
{
	rHour			=	Milliseconds 	/ 	3600000;
	Milliseconds	-=	rHour			*	3600000;
	rMin			=	Milliseconds 	/ 	60000;
	Milliseconds	-=	rMin			*	60000;
	rS				=	Milliseconds	/	1000;
	Milliseconds	-=	rS				*	1000;
	rMS				=	Milliseconds;
}
strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
Sorting(const playerid, const Values, Player_ID[], Top_Score[], Loop)
{
	new t=0,p=Loop-1;
	while(t < p)
	{
	    if(Values>=Top_Score[t])
		{
			while(p>t)
			{
				Top_Score[p]=Top_Score[p-1];
				Player_ID[p]=Player_ID[p-1];
				p--;
			}
			Top_Score[t]=Values;
			Player_ID[t]=playerid;
			break;
		}
		t++;
	}
	return 1;
}
