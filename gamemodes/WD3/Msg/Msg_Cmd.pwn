YCMD:mail(playerid, params[], help)
{
    ShowPlayerMsgMenu(playerid,1);
	return 1;
}
YCMD:sm(playerid, params[], help)
{
	new players,string[512],cashs;
	if(sscanf(params, "is[512]D(0)",players,string,cashs))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /sm Ŀ�����ID ���� ����[Ǯ��]");
	if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"�Է�û�е�½");
    if(cashs<0)return SendClientMessage(playerid,COLOR_WARNING,"Ǯ������Ϊ����");
    if(pdate[playerid][cash]<MSG_COST)
	{
	    new str[100];
		format(str, sizeof(str),"����ֽ�����֧���ʷ�$%i",MSG_COST);
	    return SendClientMessage(playerid,COLOR_WARNING,str);
	}
    new tcash=floatround(cashs*0.1);
    if(cashs+tcash>pdate[playerid][cash])
    {
		new str[100];
		format(str, sizeof(str),"����ʧ��,����ֽ�����֧���˷���\n��ϸ:�������[$%i]\n������[$%i]\n�ʷ�[$%i]\n������Ҫ[$%i]",cashs,tcash,MSG_COST,cashs+tcash+MSG_COST);
		return SendClientMessage(playerid,COLOR_WARNING,str);
    }
    if(PlayerSendMsgToPlayer(playerid,pdate[players][uid],string,cashs))
	{
	    if(cashs>0)
	    {
	        GiveCash(playerid,-cashs-tcash-MSG_COST);
	        new str[100];
			format(str, sizeof(str),"�ʼ����ͳɹ�\n��ϸ:\n�������[$%i]\n������[$%i]\n�ʷ�[$%i]\n���ƻ���[$%i]",cashs,tcash,MSG_COST,cashs+tcash+MSG_COST);
			return SendClientMessage(playerid,COLOR_TIP,str);
	    }
	    else
		{
		    GiveCash(playerid,-MSG_COST);
		    new str[100];
			format(str, sizeof(str),"�ʼ����ͳɹ�\n��ϸ:\n�ʷ�[$%i]\n���ƻ���[$%i]",MSG_COST,MSG_COST);
			return SendClientMessage(playerid,COLOR_TIP,str);
		}
	}
    else return SendClientMessage(playerid,COLOR_WARNING,"�ʼ�����ʧ��,�Է����ϲ�����?���ͼ������Ա���");
}
YCMD:reply(playerid, params[], help)
{
	new players,string[512],cashs;
	if(sscanf(params, "is[512]D(0)",players,string,cashs))return SendClientMessage(playerid,COLOR_WARNING,"�밴��ʽ���� /reply UID ���� ����[Ǯ��]");
	if(!Login[players])return SendClientMessage(playerid,COLOR_WARNING,"�Է�û�е�½");
    if(cashs<0)return SendClientMessage(playerid,COLOR_WARNING,"Ǯ������Ϊ����");
    if(pdate[playerid][cash]<MSG_COST)
	{
	    new str[100];
		format(str, sizeof(str),"����ֽ�����֧���ʷ�$%i",MSG_COST);
	    return SendClientMessage(playerid,COLOR_WARNING,str);
	}
    new tcash=floatround(cashs*0.1);
    if(cashs+tcash>pdate[playerid][cash])
    {
		new str[100];
		format(str, sizeof(str),"����ʧ��,����ֽ�����֧���˷���\n��ϸ:�������[$%i]\n������[$%i]\n�ʷ�[$%i]\n������Ҫ[$%i]",cashs,tcash,MSG_COST,cashs+tcash+MSG_COST);
		return SendClientMessage(playerid,COLOR_WARNING,str);
    }
    if(PlayerSendMsgToPlayer(playerid,players,string,cashs))
	{
	    if(cashs>0)
	    {
	        GiveCash(playerid,-cashs-tcash-MSG_COST);
	        new str[100];
			format(str, sizeof(str),"�ʼ����ͳɹ�\n��ϸ:\n�������[$%i]\n������[$%i]\n�ʷ�[$%i]\n���ƻ���[$%i]",cashs,tcash,MSG_COST,cashs+tcash+MSG_COST);
			return SendClientMessage(playerid,COLOR_TIP,str);
	    }
	    else
		{
		    GiveCash(playerid,-MSG_COST);
		    new str[100];
			format(str, sizeof(str),"�ʼ����ͳɹ�\n��ϸ:\n�ʷ�[$%i]\n���ƻ���[$%i]",MSG_COST,MSG_COST);
			return SendClientMessage(playerid,COLOR_TIP,str);
		}
	}
    else return SendClientMessage(playerid,COLOR_WARNING,"�ʼ�����ʧ��,�Է����ϲ�����?���ͼ������Ա���");
}

