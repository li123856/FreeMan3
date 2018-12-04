enum baginfo
{
    type,
    model,
    amout,
	name[80]
}
new bag[MAX_PLAYERS][MAX_CELL][baginfo];
new Iterator:bag[MAX_PLAYERS]<MAX_CELL>;
