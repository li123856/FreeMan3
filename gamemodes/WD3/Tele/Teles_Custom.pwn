enum teleinfo
{
	t_id,
	t_uid,
	Float:t_x,
	Float:t_y,
	Float:t_z,
	Float:t_a,
	Float:t_dis,
	t_int,
	t_world,
	t_rate,
	t_create[80],
	t_color,
	t_cmd[80],
	t_name[80],
	t_open,
	t_daly
}
new tele[MAX_TELES][teleinfo];
new Iterator:tele<MAX_TELES>;
