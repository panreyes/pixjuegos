Begin
	if(argv[1]=="" or argv[2]=="") exit(); end
	set_mode(100,100,atoi(argv[2]));
	cd(argv[1]);
	file=fpg_new();
	from x=0 to 999;
		If(file_exists(itoa(x)+".png"))
			fpg_add(file,x,0,load_png(itoa(x)+".png"));
		end
	End
	save_fpg(file,"../../fpg/"+argv[1]+".fpg");
End