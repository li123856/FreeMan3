#define ACT::%1(%3) \
                forward %1(%3); \
                public %1(%3)
#define COLOR_GREY				(0xD3D3D3AA)
#define COLOR_LIGHTBLUE			(0x00BFFFAA)
#define COLOR_ULTRARED			(0xFF0606FF)
#define COLOR_PURPLE			(0x9900FFAA)
#define COLOR_GREEN				(0x33AA33AA)
#define COLOR_YELLOW			(0xFFFFE0AA)
#define COLOR_ORANGE			(0xFFA500AA)
#define COLOR_RED				(0xFF0000AA)
#define COLOR_SYSTEM			(0xEFEFF7AA)
#define COLOR_ZONE_DM			(COLOR_LIGHTBLUE)
#define COLOR_WARNING			(COLOR_ULTRARED)
#define COLOR_TIP				(COLOR_LIGHTBLUE)
#define COLOR_STUDY				(COLOR_YELLOW)

#define MAX_DILOG_LIST 15

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define PRESSING(%0,%1) \
	(%0 & (%1))
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
	
#define IsValidVehicleModel(%0) \
    ((%0 > 399) && (%0 < 612))
#define IsValidSkin(%0) \
    ((%0 > 0) && (%0 < 312))
    

#define CUSTOM_TRAILER_MENU 10000
#define CUSTOM_SKIN_MENU 10001
#define CUSTOM_DM_SKIN_MENU  10002

#define PLAYER_EDIT_NONE		0
#define PLAYER_EDIT_FURN		1
#define PLAYER_EDIT_FURN_MOVE	2
#define PLAYER_EDIT_FURN_TXD	3
#define PLAYER_EDIT_HOUSE_DEC	4
#define PLAYER_EDIT_HOUSE_BUY	5


