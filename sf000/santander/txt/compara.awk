BEGIN{ANTERIOR="NADA"; cuento=0;estecar="";}
{
	if(ANTERIOR=="NADA")
	{
	}
	else
	{
		if(substr($0,1,16)==substr(ANTERIOR,1,16))
		{
			print "Linea repetida "NR" "$0;
		}
	}
	for(cuento=0;cuento<length($0)-2;cuento++)
	{
#                print "Cuento vale "cuento;
		estecar=substr($0,cuento,1);
		if(estecar<"0" || estecar>"9")
		{
			if(estecar!=" ") print "caracter incorrecto en "NR" "$0; 
		}
	} 
	ANTERIOR=$0;
}
END{}
