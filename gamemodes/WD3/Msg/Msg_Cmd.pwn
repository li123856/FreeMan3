YCMD:mail(playerid, params[], help)
{
    ShowPlayerMsgMenu(playerid,1);
	return 1;
}
YCMD:sm(playerid, params[], help)
{
	new players,string[512],cashs;
	if(sscanf(params, "is[512]D(0)",players,string,cashs))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /sm 目标玩家ID 内容 附件[钱数]");
	if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"对方没有登陆");
    if(cashs<0)return SendClientMessage(playerid,COLOR_WARNING,"钱数不能为负数");
    if(pdate[playerid][cash]<MSG_COST)
	{
	    new str[100];
		format(str, sizeof(str),"你的现金不足以支付邮费$%i",MSG_COST);
	    return SendClientMessage(playerid,COLOR_WARNING,str);
	}
    new tcash=floatround(cashs*0.1);
    if(cashs+tcash>pdate[playerid][cash])
    {
		new str[100];
		format(str, sizeof(str),"发送失败,你的现金不足以支付此费用\n明细:附件金额[$%i]\n手续费[$%i]\n邮费[$%i]\n共计需要[$%i]",cashs,tcash,MSG_COST,cashs+tcash+MSG_COST);
		return SendClientMessage(playerid,COLOR_WARNING,str);
    }
    if(PlayerSendMsgToPlayer(playerid,pdate[players][uid],string,cashs))
	{
	    if(cashs>0)
	    {
	        GiveCash(playerid,-cashs-tcash-MSG_COST);
	        new str[100];
			format(str, sizeof(str),"邮件发送成功\n明细:\n附件金额[$%i]\n手续费[$%i]\n邮费[$%i]\n共计花费[$%i]",cashs,tcash,MSG_COST,cashs+tcash+MSG_COST);
			return SendClientMessage(playerid,COLOR_TIP,str);
	    }
	    else
		{
		    GiveCash(playerid,-MSG_COST);
		    new str[100];
			format(str, sizeof(str),"邮件发送成功\n明细:\n邮费[$%i]\n共计花费[$%i]",MSG_COST,MSG_COST);
			return SendClientMessage(playerid,COLOR_TIP,str);
		}
	}
    else return SendClientMessage(playerid,COLOR_WARNING,"邮件发送失败,对方资料不存在?请截图至管理员解决");
}
YCMD:reply(playerid, params[], help)
{
	new players,string[512],cashs;
	if(sscanf(params, "is[512]D(0)",players,string,cashs))return SendClientMessage(playerid,COLOR_WARNING,"请按格式输入 /reply UID 内容 附件[钱数]");
	if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"对方没有登陆");
    if(cashs<0)return SendClientMessage(playerid,COLOR_WARNING,"钱数不能为负数");
    if(pdate[playerid][cash]<MSG_COST)
	{
	    new str[100];
		format(str, sizeof(str),"你的现金不足以支付邮费$%i",MSG_COST);
	    return SendClientMessage(playerid,COLOR_WARNING,str);
	}
    new tcash=floatround(cashs*0.1);
    if(cashs+tcash>pdate[playerid][cash])
    {
		new str[100];
		format(str, sizeof(str),"发送失败,你的现金不足以支付此费用\n明细:附件金额[$%i]\n手续费[$%i]\n邮费[$%i]\n共计需要[$%i]",cashs,tcash,MSG_COST,cashs+tcash+MSG_COST);
		return SendClientMessage(playerid,COLOR_WARNING,str);
    }
    if(PlayerSendMsgToPlayer(playerid,players,string,cashs))
	{
	    if(cashs>0)
	    {
	        GiveCash(playerid,-cashs-tcash-MSG_COST);
	        new str[100];
			format(str, sizeof(str),"邮件发送成功\n明细:\n附件金额[$%i]\n手续费[$%i]\n邮费[$%i]\n共计花费[$%i]",cashs,tcash,MSG_COST,cashs+tcash+MSG_COST);
			return SendClientMessage(playerid,COLOR_TIP,str);
	    }
	    else
		{
		    GiveCash(playerid,-MSG_COST);
		    new str[100];
			format(str, sizeof(str),"邮件发送成功\n明细:\n邮费[$%i]\n共计花费[$%i]",MSG_COST,MSG_COST);
			return SendClientMessage(playerid,COLOR_TIP,str);
		}
	}
    else return SendClientMessage(playerid,COLOR_WARNING,"邮件发送失败,对方资料不存在?请截图至管理员解决");
}

