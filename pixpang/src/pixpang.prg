Program pixpang;
//import "exec";
Global
	cancionsonando;

	max_grav=-250;
	njoys;
	posibles_jugadores;
	turbo;
	salto;
	fondotemporal;
	
	string fichero_lng[30];
	Struct ops;
		int op_lang=-1; 	// 0 = castellano, 1 = ingl�s
		int op_music=1;
		int op_sombras=1;
		int op_sonido=1;
		int p1_control; 
		int p2_control; 
		int ventana=0;
		int dificultad=1; //la normal
	End
	Struct pantalla;
		Int bx[200];
		Int by[200];
		Int btipo[200];
		Int br[200];
		Int btime;
	End
	Struct botones;
		int p1[5];
		Int p2[5];
	End
	String nombrep1;
	String nombrep2;
	int id_p1;
	int p1_vidas=10;
	int p1_arma;
	int p1_bolas; //ganando
	int p1_bonus; //ganando
	int p1_puntos; //ganando
	int p1_proteccion;
	int p1_estrella;
	int p1_disparos[2];
	int p1_muere;
	int p1_invocacion;
	int id_p2;
	int p2_vidas=10;
	int p2_arma;
	int p2_bolas; //ganando
	int p2_bonus;
	int p2_puntos;
	int p2_proteccion;
	int p2_disparos[2];
	int p2_estrella;
	int p2_muere;
	int p2_invocacion;
	int players;
	int ganando;
	int animglobal;
	int ready;
	int prisa;
	int escenario;
	int fnt1;
	int fnt2;
	int fnt3;
	int fnt4;
	int reloj;
	int relojarena;
	int dinamita;
	int time_puesto=120;
	int bolas;
	int matabolas;
	int velocidad=200;
	int graph_fondo;
	int num_disp;
	int bola_estrella=0;
        String prompt="_";
        String entry;
	inputText;
	int iniciando;
	int cont;
	int zbolas;
	int parpadea;
	int modo_juego;
	int segundos;
	int mundo;
	int id_titulo;
	int id_lang;
	int cocos;
	int borrar;
	int id_bolas[400];
	int mundo_alcanzado;
	int file_muneco1;
	int file_muneco2;
	int partida_rapida;
	int vidap1fuera;
	int vidap2fuera;
	int vidajefefuera;
	int secs;
	int screenshot;
	int mapadurezas;
// sonidos
	s[16];
// cosas raras
	Int contaor;
	int cheto_diox;
	int cheto_epilepsia;
	int cheto_borracho;
	int cheto_ayudante;
	int cheto_salto;
	int cheto_viejuno;
	int cheto_choca;
	int cheto_avaricioso;
	int jefe=0;
	int pixel_mola;
	int raton;
	int transicion;
	int fpg_lang;
	int fpg_jefe;
	int fpg_menu;
	int fpg_menu2;
	int fpg_bloquesmask;
	int img_pixpang;
	int txt_fondos[1];
	int filerecs;
	int ahora_toca;
	int color_texto[8];
	int que_toca;
	int tour_levels;
	// COMPATIBILIDAD CON XP/VISTA/LINUX (usuarios)
	string savegamedir;
	string developerpath="/.PiXJuegos/PiXPang/";

Local
	int ancho;
	int alto;
Private
    lee_archivo;
    guarda_archivo;
    intejer;
    num;
    pit;
Begin  
	if(os_id==0) //windows
		savegamedir=getenv("APPDATA")+developerpath;
		if(savegamedir==developerpath) //windows 9x/me
			savegamedir=cd();
		else
			crear_jerarquia(savegamedir);
		end
	end
	if(os_id==1) //linux
		savegamedir=getenv("HOME")+developerpath;
		crear_jerarquia(savegamedir);
	end

	if(file_exists(savegamedir+"opciones.dat"))
		load(savegamedir+"opciones.dat",ops);
	end

	borrar=new_map(1,1,8);
	Alpha_steps=64;
	set_title("PiX Pang");
	if(ops.ventana==0) Full_screen=true; else full_screen=false; end
	if(os_id==9) 
		scale_resolution=03200240; set_mode(800,600,16); 
	else
		set_mode(800,600,32);
	end
	load_fpg("./fpg/pixpang.fpg");
	fpg_menu=load_fpg("fpg/menu.fpg");
	fpg_bloquesmask=load_fpg("fpg/bloquesmask.fpg");
	if((atoi(ftime("%d",time()))>23 and atoi(ftime("%m",time()))==12) or (atoi(ftime("%d",time()))<8 and atoi(ftime("%m",time()))==1)) 
		file_muneco1=load_fpg("./fpg/charsxmas.fpg"); 
		file_muneco2=file_muneco1; 
	else 
		file_muneco1=load_fpg("./fpg/chars1.fpg"); 
		file_muneco2=file_muneco1; 
	end
	img_pixpang=950;
	fnt1=load_fnt("./fnt/textos.fnt");
	fnt2=load_fnt("./fnt/conta.fnt");
	fnt3=load_fnt("./fnt/textos2.fnt");

// joysticks
	njoys=number_joy();
	posibles_jugadores=njoys+1;
	
	if(posibles_jugadores>3) posibles_jugadores=3; end //2 joysticks
	switch(posibles_jugadores)
		case 1:
			ops.p1_control=0;
			ops.p2_control=-1;
		end
		case 2:
			ops.p1_control=1;
			ops.p2_control=0;
		end
		case 3:
			ops.p1_control=1;
			ops.p2_control=2;
		end
	end
//

// caca
	fondotemporal=load_png("fondos/temporal.png");
//
	carga_sonidos();
	set_fps(60,9);
	
	logo_pixjuegos();
End

Process muneco1();
Private
	anim;
	grav;
	if_id_disp;
	hexo;
	id_colisionado;
	toca;
	escaleras;
	subiendo;
	parpadeas=120;
	pulsando_control;
	controller;
	cont_1;
	y_statico;
	l;
	snd_muere;
	inercia;
	saltando;
Begin
	If(p1_vidas<0) Return; End
	botones.p1[0]=0; botones.p1[1]=0; botones.p1[2]=0; botones.p1[3]=0; botones.p1[4]=0;
	controller=controlador_player1();
	file=file_muneco1;
	x=370;
	graph=501;
	alto=graphic_info(file,graph,g_height);
	y_statico=510-(alto/2);
	y=y_statico;
	z=0;
	Frame;
	Loop
		ancho=graphic_info(file,graph,g_wide);
		alto=graphic_info(file,graph,g_height);
		If(cheto_borracho==1) If(rand(0,2338)==1) p1_muere=1; End End
		While(ready==0 AND ganando==0 AND p1_muere==0)
			graph=501;
			Frame;
			End
		While(ganando==1)
			graph=507;
			Frame;
		End
		If(!collision(Type escaleras))
			If(toca=collision(Type bloques))
				If(toca.y<y)
					grav++;
					cont_1=grav;
					While(cont_1>0 AND toca.y<y)
						y+=1;
						cont_1--;
					End
				Else
					y=(toca.y-(toca.alto/2)-(id.alto/2))+1;
					if(saltando==1)	saltando=0; end
					grav=0;
				End
			Else	
				grav++;
				cont_1=grav;
				While(cont_1>0)
					y+=1;
					cont_1--;
				End
				While(cont_1<0)
					y-=1;
					cont_1++;
				End
			End
		Else
			If(y>y_statico) y=y_statico; End
			if(saltando==1)	saltando=0; end
			grav=0;
		End
		If(!collision(Type bloques) AND !key(_up))
			subiendo=0;
		End
		If(y>y_statico)	if(saltando==1)	saltando=0; end y=y_statico; grav=0; End
		if(saltando==1) angle+=15000; else angle=0; end
		if(botones.p1[5]==1 and saltando==0 and (cheto_salto==1 or salto==1)) saltando=1; grav=-20; end
		If(escaleras=collision(Type escaleras))
			If(escaleras.graph!=429) subiendo=0; End
			If(escaleras.graph==429 AND botones.p1[2]==1 AND botones.p1[0]==0 AND botones.p1[1]==0)
				x=escaleras.x;
				subiendo=1; y-=4;
				If(anim<11)
					anim++;
				Else
					anim=0;
				End
				If(graph<510 OR graph>513) graph=510; End
				If(graph<513 AND anim>10)
					graph++;
				End
				If(graph==513)
					graph=510;
				End
			End
			If(escaleras.graph==429 AND botones.p1[3]==1 AND botones.p1[0]==0 AND botones.p1[1]==0)
				x=escaleras.x;
				subiendo=1; y+=4;
				If(anim<11)
					anim++;
				Else
					anim=0;
				End
				If(graph<513 AND anim>10) 
					graph++; 
				End
				If(graph<510 OR graph>513) graph=510; End
				If(graph==513) 
					graph=510; 
				End
			End
		Else
//			If(botones.p1[2]==1 OR botones.p1[3]==1)
//				graph=501;
//			End
		End
//		If(botones.p1[1]==1 AND (botones.p1[2]==0 AND botones.p1[3]==0))
		If(botones.p1[1]==1)
			If(graph==501 OR graph==506 OR graph>510)
				graph=502;
				End
			If(x<755)
				If(collision(type col_hielo)) inercia++; if(inercia>4 or inercia<-4) x+=inercia/5; end end
				If(toca=collision(Type bloques))
					If((toca.x=<x AND toca.y=<y) OR toca.y=>y) x+=4; End
				Else
					x+=4;
				subiendo=0;
				End
			End
			If(anim<11)
				anim++;
			Else
				anim=0;
			End
			If(graph<506 AND anim>10) 
				graph++; 
				End
			If(graph==506) 
				graph=502; 
				End
			flags=0;  
			End
//		If(botones.p1[0]==1 AND (botones.p1[2]==0 AND botones.p1[3]==0))
		If(botones.p1[0]==1)
			If(graph==501 OR graph==506 OR graph>510)
				graph=502;
				End
			If(x>45) 
				If(collision(type col_hielo)) inercia--; if(inercia>4 or inercia<-4) x+=inercia/5; end end
				If(toca=collision(Type bloques))
					If((toca.x=>x AND toca.y=<y) OR toca.y=>y) x-=4; End
				Else
					x-=4;
					subiendo=0;
				End
		End
		If(anim<11)
				anim++;
			Else
				anim=0;
			End
			If(graph<506 AND anim>10)
				graph++;
				End
			If(graph==506)
				graph=502; 
			End
			flags=1; 
		End
		If(botones.p1[4]==0) pulsando_control=0; End
		If(pulsando_control==0 AND botones.p1[4]==1 AND ((p1_arma==1 AND !exists(type dispcab)) OR (p1_arma==2 AND (!exists(type dispcab) OR !exists(type dispcab2))) OR (p1_arma==3 AND !exists(type dispcab)) OR (p1_arma==4 AND (!exists(type dispcab) OR !exists(type dispcab2)))))
			graph=506;
			angle=0;
			If(parpadeas<120) flags+=4; End Frame; If(parpadeas<120) parpadeas++; flags-=4; End 
			If(parpadeas<120) flags+=4; End Frame; If(parpadeas<120) parpadeas++; flags-=4; End
			If(parpadeas<120) flags+=4; End Frame; If(parpadeas<120) parpadeas++; flags-=4; End
			If(cheto_borracho==1) Frame(rand(100,1000)); End
			pulsando_control=1; 

			If(flags==1) If(exists(type dispcab)) If(!exists(type dispcab2)) p1_disparos[2]=dispcab2(p1_arma,x-3,y,2); End End If(!exists(type dispcab)) p1_disparos[1]=dispcab(p1_arma,x-3,y,1); End End 
			If(flags==0) If(exists(type dispcab)) If(!exists(type dispcab2)) p1_disparos[2]=dispcab2(p1_arma,x+5,y,2); End End If(!exists(type dispcab)) p1_disparos[1]=dispcab(p1_arma,x+5,y,1); End End
		End
		If(!collision(type col_hielo) and inercia!=0) inercia=0; end
		If(botones.p1[0]==0 AND botones.p1[1]==0 AND botones.p1[2]==0 AND botones.p1[3]==0) 
			graph=501;
			if(inercia>4 or inercia<-4) x+=inercia/3; end
			If(subiendo==1) graph=511; Else anim=0; End
		End
		If(botones.p1[1]==1 AND botones.p1[0]==1)
			graph=501; 
			if(inercia>4 or inercia<-4) x+=inercia/3; end
			If(subiendo==1) graph=511; Else anim=0; End
		End
		If(p1_muere==1)
			If(p1_proteccion==1) 
				p1_proteccion=0;
//				suena(12);
					l=(x*255)/800;
					snd_muere=play_wav(s[12],0); 
					set_panning(snd_muere,255-l,l);
				parpadeas=0;
			Else
				If(parpadeas==120)
					If((cheto_diox==1 OR cheto_borracho==1) AND ((segundos>0 and modo_juego==2) or modo_juego==1))
					ready=0;
					parpadeo();
					suena(4);
					grav=rand(50,250);
					While(y<464)
						If(ops.op_sombras==1) sombra(graph,x,y,flags,1); End
						If(flags==0) x+=12; End
						If(flags==1) x-=12; End
						If(x=>755) flags=1; End
						If(x=<45) flags=0; End
						If(grav>0) graph=508; End
						If(grav<0) graph=509; End
						grav-=5;
						y-=grav/10;
						l=(x*255)/800;
						set_panning(snd_muere,255-l,l);
						Frame;
					End
					y=y_statico;
					ready=1;
					grav=0;
					itemreloj(3);
					p1_muere=0;
				Else
					Break;
				End
				Else
					p1_muere=0;
				End
			End
		End
		hexo=0;
		If(parpadeas<120) flags+=4; End
		If(x>755) x=755; end
		If(x<45) x=45; end
		If(cheto_epilepsia==0 and turbo==0) Frame; Else Frame(50); If(ops.op_sombras==1) sombra(graph,x,y,flags,1); End End
		If(parpadeas<120) parpadeas++; flags-=4; End
	End
	ready=0;
	vidap1fuera=1;
	parpadeo();
	timer[2]=0;
	While(timer[2]<50) Frame; End
	suena(4);
	grav=rand(50,250);
	While(y<480)
		If(ops.op_sombras==1) sombra(graph,x,y,flags,1); End
		If(flags==0) x+=12; End
		If(flags==1) x-=12; End
		If(x=>755) flags=1; End
		If(x=<45) flags=0; End
		If(grav>0) graph=508; End 
		If(grav<0) graph=509; End 
		grav-=5;
		y-=grav/10;
		Frame;
	End
	suena(5);
	p1_vidas--;
	p1_muere=3;
	If(players==3 AND p2_muere==0) ready=1; itemreloj(3); End
	signal(controller,s_kill_tree);
End

Process muneco2();
Private
	anim;
	grav;
	if_id_disp;
	hexo;
	id_colisionado;
	toca;
	escaleras;
	subiendo;
	parpadeas=120;
	pulsando_control;
	controller;
	cont_1;
	y_statico;
	saltando;
	l;
	snd_muere;
	inercia;
Begin
	If(p2_vidas<0) Return; End
	botones.p2[0]=0; botones.p2[1]=0; botones.p2[2]=0; botones.p2[3]=0; botones.p2[4]=0;
	controller=controlador_player2();
	file=file_muneco2;
	graph=551;
	x=430;
	alto=graphic_info(file,graph,g_height);
	y_statico=510-(alto/2);
	y=y_statico;
	z=1;
	Loop
		While(ready==0 AND ganando==0 AND p2_muere==0)
			graph=551;
			Frame;
			End
		While(ganando==1)
			graph=557;
			Frame;
		End
		If(!collision(Type escaleras))
			If(toca=collision(Type bloques))
				If(toca.y<y)
					grav++;
					cont_1=grav;
					While(cont_1>0 AND toca.y<y)
						y+=1;
						cont_1--;
					End
				Else
					y=(toca.y-(toca.alto/2)-(id.alto/2))+1;
					if(saltando==1)	saltando=0; end
					grav=0;
				End
			Else	
				grav++;
				cont_1=grav;
				While(cont_1>0)
					y+=1;
					cont_1--;
				End
				While(cont_1<0)
					y-=1;
					cont_1++;
				End
			End
		Else
			If(y>y_statico) y=y_statico; End
			if(saltando==1)	saltando=0; end
			grav=0;
		End
		If(!collision(Type bloques) AND !key(_up))
			subiendo=0;
		End
		If(y>y_statico)	if(saltando==1)	saltando=0; end y=y_statico; grav=0; End
		if(saltando==1) angle+=15000; else angle=0; end
		if(botones.p2[5]==1 and saltando==0 and (cheto_salto==1 or salto==1)) saltando=1; grav=-20; end
		If(escaleras=collision(Type escaleras))
			If(escaleras.graph!=429) subiendo=0; End
			If(escaleras.graph==429 AND botones.p2[2]==1 AND botones.p2[0]==0 AND botones.p2[1]==0)
				x=escaleras.x;
				subiendo=1; y-=4;
				If(anim<11)
					anim++;
				Else
					anim=0;
				End
				If(graph<560 OR graph>563) graph=560; End
				If(graph<562 AND anim>10)
					graph++;
				End
				If(graph==563)
					graph=560;
				End
			End
			If(escaleras.graph==429 AND botones.p2[3]==1 AND botones.p2[0]==0 AND botones.p2[1]==0)
				x=escaleras.x;
				subiendo=1; y+=4; 
				If(anim<11)
					anim++;
				Else
					anim=0;
				End
				If(graph<560 OR graph>563) graph=560; End
				If(graph<562 AND anim>10) 
					graph++; 
				End
				If(graph==563) 
					graph=560; 
				End
			End
		Else
//			If(botones.p2[2]==1 OR botones.p2[3]==1)
//				graph=551;
//			End
		End
//		If(botones.p2[1]==1 AND (botones.p2[2]==0 AND botones.p2[3]==0))
		If(botones.p2[1]==1)
			If(graph==551 OR graph==556 OR graph>560)
				graph=552;
				End
			If(x<755) 
				If(collision(type col_hielo)) inercia++; if(inercia>4 or inercia<-4) x+=inercia/5; end end
				If(toca=collision(Type bloques))
					If((toca.x=<x AND toca.y=<y) OR toca.y=>y) x+=4; End
				Else
				x+=4;
				subiendo=0;
				End
				End
			If(anim<11)
				anim++;
			Else
				anim=0;
			End
			If(graph<556 AND anim>10) 
				graph++; 
				End
			If(graph==556) 
				graph=552; 
				End
			flags=0;  
			End
		If(botones.p2[0]==1 AND (botones.p2[2]==0 AND botones.p2[3]==0))
			If(graph==551 OR graph==556 OR graph>560)
				graph=552;
				End
			If(x>45) 
				If(collision(type col_hielo)) inercia--; if(inercia>4 or inercia<-4) x+=inercia/5; end end
				If(toca=collision(Type bloques))
					If((toca.x=>x AND toca.y=<y) OR toca.y=>y) x-=4; End
				Else
					x-=4;
					subiendo=0;
				End
				End
			If(anim<11)
				anim++;
			Else
				anim=0;
			End
			If(graph<556 AND anim>10)
				graph++; 
				End
			If(graph==556) 
				graph=552; 
				End
			flags=1; 
			End
		If(botones.p2[4]==0) pulsando_control=0; End
		If(pulsando_control==0 AND botones.p2[4]==1 AND ((p2_arma==1 AND !exists(type dispcab3)) OR (p2_arma==2 AND (!exists(type dispcab3) OR !exists(type dispcab4))) OR (p2_arma==3 AND !exists(type dispcab3)) OR (p2_arma==4 AND (!exists(type dispcab3) OR !exists(type dispcab4)))))
			graph=556;
			angle=0;
			If(parpadeas<120) flags+=4; End Frame; If(parpadeas<120) parpadeas++; flags-=4; End 
			If(parpadeas<120) flags+=4; End Frame; If(parpadeas<120) parpadeas++; flags-=4; End
			If(parpadeas<120) flags+=4; End Frame; If(parpadeas<120) parpadeas++; flags-=4; End
			If(cheto_borracho==1) Frame(rand(100,1000)); End
			pulsando_control=1; 
			If(flags==1) If(exists(type dispcab3)) If(!exists(type dispcab4)) p2_disparos[2]=dispcab4(p2_arma,x-3,y,2); End End If(!exists(type dispcab3)) p2_disparos[1]=dispcab3(p2_arma,x-3,y,1); End End 
			If(flags==0) If(exists(type dispcab3)) If(!exists(type dispcab4)) p2_disparos[2]=dispcab4(p2_arma,x+5,y,2); End End If(!exists(type dispcab3)) p2_disparos[1]=dispcab3(p2_arma,x+5,y,1); End End
		End
		If(!collision(type col_hielo) and inercia!=0) inercia=0; end
		If(botones.p2[0]==0 AND botones.p2[1]==0 AND botones.p2[2]==0 AND botones.p2[3]==0) 
			graph=551; 
			if(inercia>4 or inercia<-4) x+=inercia/3; end
			If(subiendo==1) graph=551; End
			anim=0;
			End
		If(botones.p2[1]==1 AND botones.p2[0]==1)
			graph=551; 
			if(inercia>4 or inercia<-4) x+=inercia/3; end
			If(subiendo==1) graph=551; End
			anim=0;
			End
		If(p2_muere==1)
			If(p2_proteccion==1) 
				p2_proteccion=0;
				parpadeas=0;
//				suena(12);
					l=(x*255)/800;
					snd_muere=play_wav(s[12],0); 
					set_panning(snd_muere,255-l,l);
			Else
				If(parpadeas==120)
					If(cheto_diox==1 AND segundos>0)
					ready=0;
					parpadeo();
					suena(4);
					grav=rand(50,250);
					While(y<464)
						If(ops.op_sombras==1) sombra(graph,x,y,flags,1); End
						If(flags==0) x+=12; End
						If(flags==1) x-=12; End
						If(x=>755) flags=1; End
						If(x=<45) flags=0; End
						If(grav>0) graph=558; End 
						If(grav<0) graph=559; End 
						grav-=5;
						y-=grav/10;
						l=(x*255)/800;
						set_panning(snd_muere,255-l,l);
						Frame;
					End
					y=462;
					ready=1;
					grav=0;
					itemreloj(3);
					p2_muere=0;
				Else
					Break;
				End	
				Else
					p2_muere=0;
				End
			End
		End
		hexo=0;
		If(parpadeas<120) flags+=4; End
		If(x>755) x=755; end
		If(x<45) x=45; end
		If(cheto_epilepsia==0 and turbo==0) Frame; Else Frame(50); If(ops.op_sombras==1) sombra(graph,x,y,flags,1); End End
		If(parpadeas<120) parpadeas++; flags-=4; End
	End
	ready=0;
	vidap2fuera=1;
	parpadeo();
	timer[2]=0;
	While(timer[2]<50) Frame; End
	suena(4);
	grav=rand(50,250);
	While(y<480)
		If(ops.op_sombras==1) sombra(graph,x,y,flags,1); End
		If(flags==0) x+=12; End
		If(flags==1) x-=12; End
		If(x=>755) flags=1; End
		If(x=<45) flags=0; End
		If(grav>0) graph=558; End
		If(grav<0) graph=559; End
		grav-=5;
		y-=grav/10;
		Frame;
	End
	suena(5);
	p2_vidas--;
	p2_muere=3;
	If(players==3 AND p1_muere==0) ready=1; itemreloj(3); End
	signal(controller,s_kill_tree); raton=0;
End

Process dispcab(arma,x,y,num_disp);
Private
	cachos;
	cachos_y;
	y_keko;
	disparo;
	metralleta_x;
	graphcacho;
	distancia;
	cont_ganxo;
	toca;
Begin
	disparo=num_disp;
	z=2;
	y_keko=y+(graphic_info(father.file,father.graph,g_height)/2);
	y=y_keko-graphic_info(father.file,father.graph,g_height);
	graph=601;
	define_region(2,1,1,800,y_keko);
	If(p1_arma==1)
		suena(1);
		While(!collision (Type grafico))
			If(ready==1) 
				y-=5; 
				If(animglobal<=15) graphcacho=602; End
				If(animglobal<=30 AND animglobal>15) graphcacho=603; End
				If(animglobal<45 and animglobal>30) graphcacho=607; End
				If(animglobal=>45) graphcacho=603; end
				if(y<0) break; end
			End
			cachos=((y_keko-y)+39)/39;
			While(cachos>0)
				cachos_y=y+39*(cachos+1);
				cachodisp(x,cachos_y-50,graphcacho);
				cachos--;
			End
			Frame;
		End
	End
	If(p1_arma==2)
		suena(1);
		While(!collision (Type grafico) and y>0)
			If(ready==1) 
				y-=5; 
				If(animglobal<=15) graphcacho=602; End
				If(animglobal<=30 AND animglobal>15) graphcacho=603; End
				If(animglobal<45 and animglobal>30) graphcacho=607; End
				If(animglobal=>45) graphcacho=603; end
				if(y<0) break; end
			End
			cachos=((y_keko-y)+39)/39;
			While(cachos>0)
				cachos_y=y+39*(cachos+1);
				If(disparo==1) cachodisp(x,cachos_y-50,graphcacho); End
				If(disparo==2) cachodisp2(x,cachos_y-50,graphcacho); End
				cachos--;
			End
			Frame;
		End
	End
	If(p1_arma==3)
		suena(1);
		While(!collision (Type grafico) AND !collision(Type bloques) and y>0)
			If(ready==1) y-=5; 
				if(y<0) break; end
			End
			cachos=(y_keko-y)/5;
			While(cachos>0)
				cachos_y=y+5*(cachos+1);
				cachodisp(x,cachos_y-5,graphcacho);
				cachos--;
			End
			graphcacho=608; 
			Frame;
		End
		suena(7);
		While(cont_ganxo<3*60)
			if(ready==1)
				If(botones.p1[4]==0) cont_ganxo++; Else cont_ganxo+=3; End
			end
			graph=609;
			cachos=(y_keko-y)/5;
			While(cachos>0)
				cachos_y=y+5*(cachos+1);
				cachodisp(x,cachos_y-5,graphcacho);
				cachos--;
			End
			If(cont_ganxo<2*60) graphcacho=608; Else  graph=611; graphcacho=610; End
			if(y<0) break; end
			Frame;
		End
	End
	If(p1_arma==4)
		graph=borrar;
		y+=50;
		While(y>18)
			If(ready==1) y-=10; metralleta_x+=2; End
			cachos_y=y;
			cachodisp(x-(metralleta_x),cachos_y-43,604);
			cachodisp(x-(metralleta_x/2),cachos_y-43,605); 
			cachodisp(x+(metralleta_x/2),cachos_y-43,605); 
			cachodisp(x+(metralleta_x),cachos_y-43,606); 
			Frame;
		End
	End
	p1_disparos[1]=0;
End

Process dispcab2(arma,x,y,num_disp);
Private
	cachos;
	cachos_y;
	y_keko;
	disparo;
	metralleta_x;
	graphcacho;
Begin
	disparo=num_disp;
	z=2;
	y_keko=y+(graphic_info(father.file,father.graph,g_height)/2);
	y=y_keko-graphic_info(father.file,father.graph,g_height);
	define_region(3,1,1,800,y_keko);
	graph=601;       
	If(p1_arma==2)
		suena(1);
		While(!collision (Type grafico) and y>0)
			If(ready==1) 
				y-=5; 
				If(animglobal<=15) graphcacho=602; End
				If(animglobal<=30 AND animglobal>15) graphcacho=603; End
				If(animglobal<45 and animglobal>30) graphcacho=607; End
				If(animglobal=>45) graphcacho=603; end
				if(y<0) break; end
			End
			cachos=((y_keko-y)+39)/39;
			While(cachos>0)
				cachos_y=y+39*(cachos+1);
				If(disparo==1) cachodisp(x,cachos_y-50,graphcacho); End
				If(disparo==2) cachodisp2(x,cachos_y-50,graphcacho); End
				cachos--;
			End
			Frame;
		End
	End
	If(p1_arma==4)
		graph=borrar;
		y+=50;
		While(y>18)
			If(ready==1) y-=10; metralleta_x+=2; End
			cachos_y=y;
			cachodisp2(x-(metralleta_x),cachos_y-43,604); 
			cachodisp2(x-(metralleta_x/2),cachos_y-43,605); 
			cachodisp2(x+(metralleta_x/2),cachos_y-43,605); 
			cachodisp2(x+(metralleta_x),cachos_y-43,606); 
			Frame;
		End
	End
	p1_disparos[2]=0;
End

Process cachodisp(x,y,graph);
Begin
	z=2;  
	region=2;   
	Frame;
End

Process cachodisp2(x,y,graph);
Begin
	z=2;      
	region=3;   
	Frame;
End

Process dispcab3(arma,x,y,num_disp);
Private
	cachos;
	cachos_y;
	y_keko;
	disparo;
	metralleta_x;
	graphcacho;
	distancia;
	cont_ganxo;
	toca;
Begin
	disparo=num_disp;
	z=2;
	y_keko=y+(graphic_info(father.file,father.graph,g_height)/2);
	y=y_keko-graphic_info(father.file,father.graph,g_height);
	define_region(4,1,1,800,y_keko);
	graph=612;
	If(p2_arma==1)
		suena(1);
		While(!collision (Type grafico) and y>0)
			If(ready==1) 
				y-=5; 
				If(animglobal<=15) graphcacho=613; End
				If(animglobal<=30 AND animglobal>15) graphcacho=614; End
				If(animglobal<45 and animglobal>30) graphcacho=618; End
				If(animglobal=>45) graphcacho=614; end
				if(y<0) break; end
			End
			cachos=((y_keko-y)+39)/39;
			While(cachos>0)
				cachos_y=y+39*(cachos+1);
				cachodisp3(x,cachos_y-50,graphcacho);
				cachos--;
			End
			Frame;
		End
	End
	If(p2_arma==2)
		suena(1);
		While(!collision (Type grafico) and y>0)
			If(ready==1) 
				y-=5; 
				If(animglobal<=15) graphcacho=613; End
				If(animglobal<=30 AND animglobal>15) graphcacho=614; End
				If(animglobal<45 and animglobal>30) graphcacho=618; End
				If(animglobal=>45) graphcacho=614; end
				if(y<0) break; end
			End
			cachos=((y_keko-y)+39)/39;
			While(cachos>0)
				cachos_y=y+39*(cachos+1);
				If(disparo==1) cachodisp3(x,cachos_y-50,graphcacho); End
				If(disparo==2) cachodisp4(x,cachos_y-50,graphcacho); End
				cachos--;
			End
			Frame;
		End
	End
	If(p2_arma==3)
		suena(1);
		While(!collision (Type grafico) AND !collision(Type bloques) and y>0)
			If(ready==1) y-=5; End
			cachos=(y_keko-y)/5;
			While(cachos>0)
				cachos_y=y+5*(cachos+1);
				cachodisp3(x,cachos_y-5,graphcacho);
				cachos--;
			End
			graphcacho=619; 
			Frame;
		End
		suena(7);
		While(cont_ganxo<3*60)
			if(ready==1)
				If(botones.p2[4]==0) cont_ganxo++; Else cont_ganxo+=3; End
			end
			graph=620;
			If(cont_ganxo<2*60) graphcacho=619; Else graph=622; graphcacho=621; End
			cachos=(y_keko-y)/5;
			While(cachos>0)
				cachos_y=y+5*(cachos+1);
				cachodisp(x,cachos_y-5,graphcacho);
				cachos--;
			End
			if(y<0) break; end
			Frame;
		End
	End
	If(p2_arma==4)
		graph=borrar;
		y+=50;
		While(y>18)
			If(ready==1) y-=10; metralleta_x+=2; End
			cachos_y=y;
			cachodisp3(x-(metralleta_x),cachos_y-43,615); 
			cachodisp3(x-(metralleta_x/2),cachos_y-43,616); 
			cachodisp3(x+(metralleta_x/2),cachos_y-43,616); 
			cachodisp3(x+(metralleta_x),cachos_y-43,617); 
			Frame;
		End
	End
	p2_disparos[1]=0;
End

Process dispcab4(arma,x,y,num_disp);
Private
	cachos;
	cachos_y;
	y_keko;
	disparo;
	metralleta_x;
	graphcacho;
Begin
	disparo=num_disp;
	z=2;
	y_keko=y+(graphic_info(father.file,father.graph,g_height)/2);
	y=y_keko-graphic_info(father.file,father.graph,g_height);
	define_region(5,1,1,800,y_keko);
	graph=612;
	If(p2_arma==2)
		suena(1);
		While(!collision (Type grafico) and y>0)
			If(ready==1) 
				y-=5; 
				If(animglobal<=15) graphcacho=613; End
				If(animglobal<=30 AND animglobal>15) graphcacho=614; End
				If(animglobal<45 and animglobal>30) graphcacho=618; End
				If(animglobal=>45) graphcacho=614; end
				if(y<0) break; end
			End
			cachos=((y_keko-y)+39)/39;
			While(cachos>0)
				cachos_y=y+39*(cachos+1);
				If(disparo==1) cachodisp3(x,cachos_y-50,graphcacho); End
				If(disparo==2) cachodisp4(x,cachos_y-50,graphcacho); End
				cachos--;
			End
			Frame;
		End
	End
	If(p2_arma==4)
		graph=borrar;
		y+=50;
		While(y>18 and y>0)
			If(ready==1) y-=10; metralleta_x+=2; End
			cachos_y=y;
			cachodisp4(x-(metralleta_x),cachos_y-43,615);
			cachodisp4(x-(metralleta_x/2),cachos_y-43,616); 
			cachodisp4(x+(metralleta_x/2),cachos_y-43,616); 
			cachodisp4(x+(metralleta_x),cachos_y-43,617); 
			Frame;
		End
	End
	p2_disparos[2]=0;
End

Process cachodisp3(x,y,graph);
Begin
	z=2;
	region=4;
	Frame;
End

Process cachodisp4(x,y,graph);
Begin
	z=2;
	region=5;
	Frame;
End


Process bola(x,y,tamano,lao); //tamano 1:peke�a 2:medio-peke�a 3:medio-grande 4:grande
Private
	grav;
	grav_org;
	ancho_bola;
	altura_bola;
	ancho_bloque;
	alto_bloque;
	id_disp;
	iddisp[7];
	rota;
	toca;                    
	peq_izq;       
	contator;
	asdrugol;
	varibiliosa;
	mutante;
	viejunidad;
	matando;
Begin        
    While(exists(id_bolas[contator]))
        contator++;
    End
    id_bolas[contator]=id;
	zbolas--;
	z=zbolas;
	bolas++;
	If(tamano==1) If(lao==1 AND modo_juego==1) if(rand(0,3)==3) peq_izq=1; end End graph=701; grav_org=100; End //normal
	If(tamano==2) graph=702; grav_org=120; End
	If(tamano==3) graph=703; grav_org=140; End
	If(tamano==4) graph=704; grav_org=160; End 
	If(tamano==5) graph=705; grav_org=180; End
	If(tamano==6) If(lao==1 AND modo_juego==1) if(rand(0,3)==3) peq_izq=1; end End graph=711; grav_org=160; End //verde
	If(tamano==7) graph=713; grav_org=180; End
	If(tamano==8) graph=715; grav_org=200; End
	If(tamano==9) graph=716; grav_org=220; End
	If(tamano==10) If(lao==1 AND modo_juego==1) if(rand(0,3)==3) peq_izq=1; end End graph=801; size=33; grav_org=0; grav=1; End //rotativa
	If(tamano==11) graph=801; size=66; grav_org=0; grav=1; End
	If(tamano==12) graph=801; size=100; grav_org=0; grav=1; End
	If(tamano==13) If(lao==1 AND modo_juego==1) if(rand(0,3)==3) peq_izq=1; end End graph=717; grav_org=255; End //bota al rev�s
	If(tamano==14) graph=718; grav_org=220; End
	If(tamano==15) graph=719; grav_org=210; End
	If(tamano==16) graph=720; grav_org=200; End
	If(tamano==17) graph=721; bola_estrella=1; grav_org=180; End //bola estrella
	//tamano 18 reservado para bola estrella!
	If(tamano==19) graph=723; grav_org=180; End //bola perseguidora
	if(tamano==20) graph=724; grav_org=120; end //bola est�tica verticalmente
	if(tamano==21) graph=725; grav_org=120; end //bota est�tica y bota normal...
	if(tamano==22) mutante=1; tamano=1; If(lao==1 AND modo_juego==1) if(rand(0,3)==3) peq_izq=1; end End graph=701; grav_org=100; end
	if(cheto_borracho==1) size=rand(20,200); end
	ancho_bola=graphic_info(0,graph,g_wide);
	altura_bola=graphic_info(0,graph,g_height);
	If((tamano==5 OR tamano==9 OR tamano==12 OR tamano==16 or tamano==17 or tamano==19 or tamano==20 or tamano==21) AND (modo_juego==1 OR modo_juego==-1)) 
		y=(0-altura_bola);
		While(y<0+(altura_bola/2) AND matabolas==0)
			if(ready) y+=1; end
			Frame;
		End
	End
	if(modo_juego==2 and ops.op_sombras==1 and ready==0)
		from alpha=0 to 255 step 2; frame; end
	end
	alpha=255;
	Loop
		if(cheto_viejuno and modo_juego==1)
			if(viejunidad<200) viejunidad++; else
				viejunidad=0;
				if(tamano!=5 and tamano!=9 and tamano!=12 and tamano!=16 and tamano!=18 and tamano!=21 and tamano!=22) 
					tamano++;
					suena(3);
					If(tamano==1) If(lao==1 AND modo_juego==1) peq_izq=1; End graph=701; grav_org=100; End //normal
					If(tamano==2) graph=702; grav_org=120; End
					If(tamano==3) graph=703; grav_org=140; End
					If(tamano==4) graph=704; grav_org=160; End 
					If(tamano==5) graph=705; grav_org=180; End
					If(tamano==6) If(lao==1 AND modo_juego==1) peq_izq=1; End graph=711; grav_org=160; End //verde
					If(tamano==7) graph=713; grav_org=180; End
					If(tamano==8) graph=715; grav_org=200; End
					If(tamano==9) graph=716; grav_org=220; End
					If(tamano==10) If(lao==1 AND modo_juego==1) peq_izq=1; End graph=801; size=33; grav_org=0; grav=1; End //rotativa
					If(tamano==11) graph=801; size=66; grav_org=0; grav=1; End
					If(tamano==12) graph=801; size=100; grav_org=0; grav=1; End
					If(tamano==13) If(lao==1 AND modo_juego==1) peq_izq=1; End graph=717; grav_org=255; End //bota al rev�s
					If(tamano==14) graph=718; grav_org=220; End
					If(tamano==15) graph=719; grav_org=210; End
					If(tamano==16) graph=720; grav_org=200; End
					If(tamano==17) graph=721; bola_estrella=1; grav_org=180; End //bola estrella
					//tamano 18 reservado para bola estrella!
					If(tamano==19) graph=723; grav_org=180; End //bola perseguidora
					if(tamano==20) graph=724; grav_org=120; end //bola est�tica verticalmente
					if(tamano==21) graph=725; grav_org=120; end //bota est�tica y bota normal...
					if(tamano==22) mutante=1; tamano=1; If(lao==1 AND modo_juego==1) peq_izq=1; End graph=701; grav_org=100; end
				end
			end
		end
		If(ops.op_sombras==1 AND grav_org>0) sombra(graph,x,y,flags,1); End
		While(ready==0) 
			Frame;
		End
		If(parpadea==1) If(flags==0) flags=4; Else flags=0; End End
		If(dinamita==1 AND tamano>1 AND tamano!=6 AND tamano!=10 and tamano!=13 and tamano!=17and tamano!=18 and tamano!=19 and tamano!=20 and tamano!=21) Frame(velocidad); Break; End
		If(reloj==0 AND grav_org==0)
			flags=0;
			angle+=1000;
			If(toca=collision(Type bloques))
				If(toca.graph!=429)
					ancho_bloque=graphic_info(0,toca.graph,g_wide);
					alto_bloque=graphic_info(0,toca.graph,g_height);
					If((toca.x+(ancho_bloque/100*size/2))<x) lao=0; End
					If((toca.x-(ancho_bloque/100*size/2))>x) lao=1; End
					If((toca.y-(alto_bloque/100*size/2))>y) grav=1; End
					If((toca.y+alto_bloque/100*size/2)<y) grav=0; End
					if(mutante==1) mutante=2; end
				End
			End        
			If(lao==0) x+=3; End
			If(lao==1) x-=3; End
			If(grav==1) y-=3; End
			If(grav==0) y+=3; End
			If(animglobal<60) graph=802; End
			If(animglobal<45) graph=801; End
			If(animglobal<30) graph=802; End
			If(animglobal<15) graph=801; End
			If(x=>800-18-(ancho_bola/2)) lao=1; End
			If(x=<(((ancho_bola)/2))+18) lao=0; End
			If(y>(500-(altura_bola/2))) grav=1; if(mutante==1) mutante=2; end End
			If(y<(18+(altura_bola/2))) grav=0; End
		End
		If(reloj==0 AND grav_org>0 and tamano<13 or tamano==17 or tamano==18 or tamano==19 or tamano==20 or tamano==21)
			flags=0;
			If(toca=collision(Type bloques))
				If(toca.graph!=429)
					if(mutante==1) mutante=2; end
					ancho_bloque=graphic_info(0,toca.graph,g_wide);
					alto_bloque=graphic_info(0,toca.graph,g_height);
					If((toca.x+(ancho_bloque/2))<x) lao=0; End
					If((toca.x-(ancho_bloque/2))>x) lao=1; End
					If((toca.y-(alto_bloque/2))>y) 
						if(((500-y)/80)!=0) 
							grav=grav_org/((500-y)/80);
						else 
							grav=grav_org; 
						end 
					End
					If((toca.y+alto_bloque/2)<y) 
						grav=0-grav_org;
						if(tamano==21)
							if(varibiliosa==0) varibiliosa=1; else varibiliosa=0; end
						end
						if(tamano==19)
							if(exists(id_p1) and exists(id_p2))
								if(get_dist(id_p1)>get_dist(id_p2))
									if(id_p1.x<x) lao=1; else lao=0; end
								else
									if(id_p2.x<x) lao=1; else lao=0; end
								end
							end
							if(exists(id_p1) and !exists(id_p2))
								if(id_p1.x<x) lao=1; else lao=0; end
							end
							if(exists(id_p2) and !exists(id_p1))
								if(id_p2.x<x) lao=1; else lao=0; end
							end
						end
					End
				End
			End        
			if(cheto_choca) If(toca=collision(Type bola))
				ancho_bloque=graphic_info(0,toca.graph,g_wide);
				alto_bloque=graphic_info(0,toca.graph,g_height);
				If((toca.x+(ancho_bloque/2))<x) lao=0; End
				If((toca.x-(ancho_bloque/2))>x) lao=1; End
				If((toca.y-(alto_bloque/2))>y) 
					if(((500-y)/80)!=0) 
						grav=grav_org/((500-y)/80);
					else 
						grav=grav_org; 
					end 
				End
				If((toca.y+alto_bloque/2)<y) 
					grav=0-grav_org;
					if(tamano==21)
						if(varibiliosa==0) varibiliosa=1; else varibiliosa=0; end
					end
				End
			End        
			End //cheto choca

			If(lao==0 and tamano!=20 and varibiliosa==0) x+=3; End
			If(lao==1 and tamano!=20 and varibiliosa==0) x-=3; End
			If(x=>800-18-(ancho_bola/2)) x=800-18-(ancho_bola/2); lao=1; End
			If(x=<(((ancho_bola)/2))+18) x=(((ancho_bola)/2))+18; lao=0; End
			if(asdrugol<10) asdrugol++; end
			If(y>(500-(altura_bola/2)) and asdrugol==10) 
				if(mutante==1) mutante=2; end
				asdrugol=0; 
				if(tamano==17) tamano=18; graph=722; else if(tamano==18) tamano=17; graph=721; end end 
				grav=grav_org; 
				if(tamano==19)
					if(exists(id_p1) and exists(id_p2))
						if(get_dist(id_p1)>get_dist(id_p2))
							if(id_p1.x<x) lao=1; else lao=0; end
						else
							if(id_p2.x<x) lao=1; else lao=0; end
						end
					end
					if(exists(id_p1) and !exists(id_p2))
						if(id_p1.x<x) lao=1; else lao=0; end
					end
					if(exists(id_p2) and !exists(id_p1))
					if(id_p2.x<x) lao=1; else lao=0; end
					end
				end
				if(tamano==21)
					if(varibiliosa==0) varibiliosa=1; else varibiliosa=0; end
				end
			End
			grav-=5;
			y-=3+(grav/20);
		End      
		If(reloj==0 AND grav_org>0 and tamano>12 and tamano<17)
			flags=0;
			If(toca=collision(Type bloques))
				If(toca.graph!=429)
					if(mutante==1) mutante=2; end
					ancho_bloque=graphic_info(0,toca.graph,g_wide);
					alto_bloque=graphic_info(0,toca.graph,g_height);
					If((toca.x+(ancho_bloque/2))<x) lao=0; End
					If((toca.x-(ancho_bloque/2))>x) lao=1; End
					If((toca.y-(alto_bloque/2))>y) if(((16+y)/80)!=0) grav=-(grav_org/((16+y)/80)); else grav=-grav_org; end End
					If((toca.y+alto_bloque/2)<y) grav=0+grav_org; End
				End
			End        
			If(lao==0) x+=3; End
			If(lao==1) x-=3; End
			If(x=>800-18-(ancho_bola/2)) lao=1; End
			If(x=<(((ancho_bola)/2))+18) lao=0; End
			If(y<(16+(altura_bola/2))) grav=grav_org; if(mutante==1) mutante=2; end End
			grav-=5;
			y+=3+(grav/20);
			angle+=6000;
		End
		if(mutante==2)
			if(tamano<20) tamano++; else tamano=1; end
			grav=0;
			grav_org=0;
			ancho_bola=0;
			altura_bola=0;
			ancho_bloque=0;
			alto_bloque=0;
			id_disp=0;
			rota=0;
			toca=0;                    
			peq_izq=0;       
			contator=0;
			varibiliosa=0;
			If(tamano==1) If(lao==1 AND modo_juego==1) peq_izq=1; End graph=701; grav_org=100; End //normal
			If(tamano>1 and tamano<6) tamano=6; End
			If(tamano==6) If(lao==1 AND modo_juego==1) peq_izq=1; End graph=711; grav_org=160; End //verde
			If(tamano>6 and tamano<19) tamano=19; End
			If(tamano==19) graph=723; grav_org=180; End //bola perseguidora
			if(tamano==20) graph=724; grav_org=120; end //bola est�tica verticalmente
			grav=grav_org;
			if(cheto_borracho==1) size=rand(20,200); end
			ancho_bola=graphic_info(0,graph,g_wide);
			altura_bola=graphic_info(0,graph,g_height);
			mutante=1;
		end
		if(y<20) grav=-grav_org; end
		if(grav<max_grav) grav=max_grav; end //est� too mal xd
			if(collision(type dispcab) or collision(type cachodisp)) p1_bonus+=100; p1_puntos+=500; p1_bolas++; if(tamano==17) p1_bolas+=20; end signal(p1_disparos[1],s_kill); break; end
			if(collision(type dispcab2) or collision(type cachodisp2)) p1_bonus+=100; p1_puntos+=500; p1_bolas++; if(tamano==17) p1_bolas+=20; end signal(p1_disparos[2],s_kill); break; end
			if(collision(type dispcab3) or collision(type cachodisp3)) p2_bonus+=100; p2_puntos+=500; p2_bolas++; if(tamano==17) p2_bolas+=20; end signal(p2_disparos[1],s_kill); break; end
			if(collision(type dispcab4) or collision(type cachodisp4)) p2_bonus+=100; p2_puntos+=500; p2_bolas++; if(tamano==17) p2_bolas+=20; end signal(p2_disparos[2],s_kill); break; end
			if(matabolas==1 OR rota==1) break; end

			if(reloj==0)
				If(p1_estrella==0 and collision(id_p1)) if(matando==10) p1_muere=1; If(p1_proteccion==1) Break; End matando=0; else matando++; end End
				If(p2_estrella==0 and collision(id_p2)) if(matando==10) p2_muere=1; If(p2_proteccion==1) Break; End matando=0; else matando++; end End
			end
			If((!collision(id_p1)) and (!collision(id_p2))) matando=0; End
			If((p1_estrella==1) and (collision(id_p1)==1)) p1_bolas++; break; end
			If((p2_estrella==1) and (collision(id_p2)==1)) p2_bolas++; break; end
			If(collision(Type cocodrilo) OR collision(Type volador)) Break; End
			If(peq_izq==1 and jefe==0) If(flags==4) flags=0; Else flags=4; End End
			
			if(tamano!=19) Frame(velocidad/2); else frame(velocidad/3); end
		End
	frame;		
	If(peq_izq==1 and matabolas==0 and jefe==0) if(reloj==0) itemreloj(1); else secs+=60; end End
	If(tamano!=1 AND tamano!=6 AND tamano!=10 and tamano!=13 and tamano!=17 and tamano!=18 and tamano!=19 and tamano!=20 and tamano!=21 and tamano!=22) if(cheto_borracho==0 or matabolas==1 or dinamita==1) bola(x-(ancho_bola/4),y,tamano-1,1); bola(x+(ancho_bola/4),y,tamano-1,0); else if(rand(0,3)==0 and tamano<17) bola(x-(ancho_bola/4),y,tamano,1); bola(x+(ancho_bola/4),y,tamano,0); else bola(x-(ancho_bola/4),y,tamano-1,1); bola(x+(ancho_bola/4),y,tamano-1,0); End End End
	If(tamano==1 OR tamano==6 OR tamano==10 or tamano==13) size=0; End
	if(os_id!=9) explotalo(x,y,z,alpha,0,file,graph,60); end
	suena(2);
	bolas--;
	if(tamano==17) bola_estrella=0; matabolas=1; graph=0; frame(6000); matabolas=0; end
	if(tamano==18) bola_estrella=0; itemreloj(10); end
	If(tamano!=1 AND tamano!=6 and tamano!=10 and tamano!=13 AND modo_juego==2) If(rand(0,10)<3) items(x,y,rand(0,9)); End End
End

Process marcadores();
Begin
	If(modo_juego==2) 
		grafico(350,539,403,-1,0,fpg_lang); 
		write(fnt1,400,560,1,"Level    "+itoa(mundo+1));
	End
	If(players==1) vidasp1();
	    If(modo_juego==2) armap1(); grafico(234,560,402,-1,0,0); End
	    If(modo_juego!=3) grafico(666,560,404,-1,1,fpg_lang); End 
		write_int(fnt1,190,540,5,&p1_puntos); 
	end
	If(players==2) vidasp2();
	    If(modo_juego==2) armap2(); grafico(566,560,402,-1,0,0); End
	    grafico(134,560,404,-1,1,fpg_lang); 
		write_int(fnt1,615,540,3,&p2_puntos);
	End
	If(players==3) vidasp1(); vidasp2();
	    If(modo_juego==2) armap1(); armap2(); grafico(234,560,402,-1,0,0); grafico(566,560,402,-1,0,0); End
		write_int(fnt1,190,540,5,&p1_puntos); 
		write_int(fnt1,615,540,3,&p2_puntos);
	End
	escenario();
End

Process grafico(x,y,graph,z,intparpadeo,file);
Private
	exgraph;
Begin
	exgraph=graph;
	Loop
		if(ops.op_sombras==0)
			If(intparpadeo==1) If(graph==exgraph) graph=borrar; Else graph=exgraph; End End
		else
			if(intparpadeo==1) 
				graph=exgraph;
				from alpha=255 to 0 step -3; frame; end
				from alpha=0 to 255 step 3; frame; end
			end
		end
	Frame(2000);
	End
End

Process escenario();
Begin
	x=400;
	y=300;
	grafico(400,559,7,1,0,0);
	If(modo_juego==1 OR modo_juego==-1) 
		grafico(400,300,2,2,0,0);
	    If(modo_juego==1) barra_nivel(); End
	End
	If(modo_juego==2) 
		grafico(400,300,1,2,0,0);
	End
	If(modo_juego==3)
		grafico(401,15,4,2,0,0);
		grafico(401,502,6,2,0,0);
	End		
	Loop
		Frame;
	End
End

Process barra_nivel();
Private
   energia=0;
Begin
   graph=444;
   // Se asignan las coordenadas
   x=305; y=575; z=0;
   grafico(400,540,442,0,0,fpg_lang);
   grafico(400,575,443,-1,0,0);
   Loop
      energia=((p1_bolas+p2_bolas)-((cont-1)*50));
      size_x=energia*2;
	  if(size_x>100) size_x=100; end
      Frame;
   End
End

Process musica(cancion);
Private
    cargada;
    String numerito;
	int numerete;
	string formato="ogg";
Begin
	if(os_id==9) formato="wav"; end
	If(is_playing_song()) stop_song(); End
// nota para el se�or programador, osea yop: esto es un **** l�o
// cuando puedas b�rralo todo y hazlo tal como se usa ahora!
	If(cancion>-1) stop_song();  unload_song(cargada); End
	numerete=mundo+1;
	if(numerete==1 and modo_juego==1) numerete=rand(1,13); end
	while(numerete>13) numerete-=13; end
	numerito=itoa(numerete);
	If(cancion==0) cargada=load_song("./ogg/23."+formato); End
	numerete=mundo;
	while(numerete>2) numerete-=3; end
	If(cancion=>1 AND cancion=<4) 
		switch(numerete) 
			case 0:
				cargada=load_song("./ogg/23."+formato); 
			end
			case 1: 
				cargada=load_song("./ogg/pang2."+formato); 
			end 
			case 2: 
				cargada=load_song("./ogg/pang3."+formato); 
			end 
		End
	end
	// no hay mucha m�sica oficial por ahora...
	
	If(cancion==5) cargada=load_song("./ogg/menu."+formato); End
	If(cancion==6) cargada=load_song("./ogg/20."+formato); End
    If(cancion==7) //prisa!
			cargada=load_song("./ogg/24."+formato);
    End
    If(cancion==8) cargada=load_song("./ogg/18."+formato); End
	If(cancion==9) cargada=load_song("./ogg/19."+formato); End
	If(cancion==10) cargada=load_song("./ogg/intro."+formato); End
	If(cancion==-1)
		fade_music_off(250);
		Return;
	End
	If(ops.op_music==1)
		If(cancion!=6 AND cancion!=8)
			play_song(cargada,999);
		Else
			play_song(cargada,0);
		End
	End
	//pSounds.musica = cancion;
End

Process vidasp1();
Private
	escrito;
Begin
    vidap1(921);
	Loop
		If(p1_vidas>99) p1_vidas=99; End
		If(p1_muere=>3) p1_muere++; End
		If(p1_muere=>35) p1_muere=2; Break; End
		If(escrito==0) escrito=1;  write(fnt2,106,548,0,"x"); write_int(fnt2,136,548,0,OFFSET p1_vidas); End
		z=-1;
		Frame;
	End
End

Process vidap1(vidan);
Begin
	file=file_muneco1;
	z=-3;
	y=550;
	x=-50;
	vidap1fuera=0;
	graph=vidan;
	While(vidap1fuera==0)
		If(x<50) x+=2; Frame; End
		Frame;
	End
	While(x>-50) x-=2; Frame; End
	Frame;
End

Process vidasp2();
Private
	escrito;
Begin
    If(modo_juego==1) if(jefe!=0) vidap2(0); else vidap2(922); End end
    If(modo_juego==2) vidap2(922); End
    If(modo_juego==3) vidap2(924); End
    Loop
	    If(p2_vidas>99) p2_vidas=99; End
	    If(p2_muere=>3) p2_muere++; End
	    If(p2_muere=>35) p2_muere=2; Break; End
	    If(escrito==0) escrito=1;  write(fnt2,694,548,2,"x");
	        If(modo_juego!=3)  write_int(fnt2,664,548,2,OFFSET p2_vidas); Else  write_int(fnt2,664,548,2,OFFSET contaor); End
	    End
	    z=-1;
	    Frame;
    End
End

Process vidajefe();
Private
	escrito;
	id_textuales[1];
Begin
    vidajefe2();
     id_textuales[0]=write(fnt2,694,48,2,"x");
     id_textuales[1]=write_int(fnt2,664,48,2,OFFSET contaor);
    While(!vidajefefuera)
	Frame;
    End
    delete_text(id_textuales[0]);
    delete_text(id_textuales[1]);
End

Process vidajefe2();
Begin
	file=fpg_jefe;
	graph=100;
	z=-3;
	y=50;
	x=850;
	vidap2fuera=0;
	While(!vidajefefuera)
		If(x>750) x-=2; Frame; End
		Frame;
	End
	While(x<850) x+=2; Frame; End
	Frame;
End

Process vidap2(vidan);
Begin
	if(vidan!=0)
		file=file_muneco2;
		graph=vidan;
	else
		file=fpg_jefe;
		graph=100;
	end
	z=-3;
	y=550;
	x=850;
	vidap2fuera=0;
	While(vidap2fuera==0)
		If(x>750) x-=2; Frame; End
		Frame;
	End
	While(x<850) x+=2; Frame; End
	Frame;
End

Process anim_global();
Begin
	Loop
		If(animglobal<60) animglobal++;
			Else animglobal=0;
		End
		Frame;
	End
End

Process carga_sonidos();
Private
	flipando;
Begin
	from flipando=0 to 16; s[flipando]=load_wav("./wav/"+flipando+".wav"); end
End

Process suena(sonido);
Private
	l;
	id_sonido;
Begin
    If(ops.op_sonido==1)
	l=(father.x*255)/800;
	id_sonido=play_wav(s[sonido],0); 
	set_panning(id_sonido,255-l,l);
    End
End

Process tiempo_nivel(segs);
Begin
	If(segs==-1) Return; End
	segs=segs*60;
	write_int(fnt2,460,539,4,OFFSET segundos);
	Loop
		If(ready==1 AND reloj==0) segs--; End
		segundos=segs/60;
		If(segundos<21 AND prisa==0) prisa=1; hayprisa(); End
		If(segs<10 AND (p1_muere==0 OR p2_muere==0)) p1_muere=1; p2_muere=1; ready=0; End
		Frame;
	End
End

Process hayprisa();
Begin
	if(jefe==0) musica(7); end
	if(modo_juego==1 and jefe==0 and bola_estrella==0) bola(rand(60,740),0,17,rand(0,1)); end
	If(modo_juego==2) grafico(350,539,103,-2,0,fpg_lang); End
End

Process armap1(); //1=normal, 2=2 tiros, 3=gancho, 4=metralleta
Begin
	x=234;
	y=560;
	z=-2;
	Loop
		If(p1_arma==1) 
			graph=borrar;
		End
		If(p1_arma==2)
			graph=411;
		End
		If(p1_arma==3)
			graph=412;
		End
		If(p1_arma==4)
			graph=413;
		End
		Frame;
	End
End

Process armap2(); //1=normal, 2=2 tiros, 3=gancho, 4=metralleta
Begin
	x=566;
	y=560;
	z=-2;
	Loop
		If(p2_arma==1) 
			graph=borrar;
		End
		If(p2_arma==2)
			graph=411;
		End
		If(p2_arma==3)
			graph=412;
		End
		If(p2_arma==4)
			graph=413;
		End
		Frame;
	End
End

Process itemreloj(eltiempo);
Private
	segundox;
	rolex;
Begin
	if(p1_estrella or p2_estrella) return; end
	secs=eltiempo;
	suena(9);
	secs=secs*60;
	rolex=write_int(fnt2,400,200,4,&segundox);
	While(secs=>1)
		reloj=1;
		if(p1_estrella or p2_estrella) secs=1; parpadea=0; end
		
		If(ready==1) 
			secs--;
		else
			while(ready==0) frame; end
		End
		segundox=secs/60;
		If(segundox<2) parpadea=1; End
		Frame;
	End
	delete_text(rolex); 
	reloj=0; parpadea=0;
End


Process proteccion(num_muneco);
Private
	rolling;
	algo;
Begin
	if(num_muneco==1) graph=514; else graph=515; end
	while((p1_proteccion and num_muneco==1) or (p2_proteccion and num_muneco==2))
		if(num_muneco==1)
			x=id_p1.x;
			y=id_p1.y+10;
			z=id_p1.z-1;
		else
			x=id_p2.x;
			y=id_p2.y+10;
			z=id_p2.z-1;
		end
		alpha=100+rolling;
		size_x=100+(rolling/6);
		size_y=100-(rolling/4);
		if(algo==false)
			if(rolling<100) rolling++; else algo=true; end
		else
			if(rolling>0) rolling--; else algo=false; end
		end
		frame;
	end
	from alpha=255 to 0 step -5; frame; end
End

Process estrella();
Private
	rolling;
	algo;
	tiempo_estrella;
	segundox;
	rolex;
	tenia_protec[1];
Begin
	if(p1_estrella) return; end
	p1_estrella=1;
	p2_estrella=1;
	suena(9);
	 
	tiempo_estrella=5*60;
	turbo=1;
	salto=1;
	tenia_protec[0]=p1_proteccion;
	tenia_protec[1]=p2_proteccion;
	p1_proteccion=0;
	p2_proteccion=0;
	switch(players)
		case 1:
			sub_estrella(1);
		end
		case 2: 
			sub_estrella(2);
		end
		case 3:
			if(exists(id_p1)) sub_estrella(1); end
			if(exists(id_p2)) sub_estrella(2); end
		end
	end
	rolex=write_int(fnt2,400,200,4,&segundox);
	while(tiempo_estrella>2 and ganando==0)
		if(ready==1) 
			tiempo_estrella--;
			else
			while(ready==0) frame; end		 
		end
		segundox=tiempo_estrella/60;
		frame;
	end
	delete_text(rolex);
	suena(12);
	if(tenia_protec[0]) suena(11); p1_proteccion=1; proteccion(1); end
	if(tenia_protec[1]) suena(11); p2_proteccion=1; proteccion(2); end
	p1_estrella=0;
	p2_estrella=0;
	turbo=0;
	salto=0;
End

Process sub_estrella(num_muneco);
Private
	rolling;
	algo;
Begin
	graph=519;
	while((num_muneco==1 and p1_estrella==1) or (num_muneco==2 and p2_estrella==1))
		if(num_muneco==1)
			x=id_p1.x;
			y=id_p1.y;
			z=id_p1.z-1;
		else
			x=id_p2.x;
			y=id_p2.y;
			z=id_p2.z-1;
		end
		alpha=100+rolling;
		size_x=100+(rolling/6);
		size_y=100-(rolling/4);
		angle+=5000;
		frame;
		if(algo==false)
			if(rolling<100) rolling++; else algo=true; end
		else
			if(rolling>0) rolling--; else algo=false; end
		end
	end
	from alpha=255 to 0 step -5; frame; end
End

Process ganar();
Begin
	if(ready==0) Return; End
	ganando=1;
	ready=0;
	If(modo_juego==2)
		If(players==1 OR players==3) cuadro_ganar(1); End
		If(players==2 OR players==3) cuadro_ganar(2); End
		mundo++;
	End
	musica(6);
	stage_clear();
	timer[5]=0;
	if(modo_juego==2) frame(15000); faderaro(-2); end
	While(modo_juego!=2 and timer[5]<500) Frame; End
	If(modo_juego==1 OR modo_juego==3)
		faderaro(img_pixpang);
		If(modo_juego==3) stop_scroll(0); End
		let_me_alone();
	End
	If(modo_juego==2) If(mundo==tour_levels+1) menu(); else inicio(); End end
End

Process cuadro_ganar(num);
Begin
	graph=406;
	y=345;
	 
	If(num==1) 
		if(p1_muere) p1_bonus=0; return; end
		x=210; 
		If(p1_bolas>p2_bolas and p1_muere==0) 
			grafico(310,323,408,-2,0,fpg_lang); 
			grafico(120,363,410,-2,0,fpg_lang); 
			write_int(fnt1,250,363,4,OFFSET p1_bonus); 
		Else
			grafico(310,323,407,-2,0,fpg_lang);
			p1_bonus=0;
			grafico(200,363,409,-2,0,fpg_lang);
		End
		write_int(fnt1,140,323,4,OFFSET p1_bolas); 
	End
	If(num==2) 
		if(p2_muere) p2_bonus=0; return; end
		x=590; 
		If(p2_bolas>p1_bolas and p2_muere==0) 
			grafico(680,363,410,-2,0,fpg_lang); 
			write_int(fnt1,550,363,4,OFFSET p2_bonus); 
			grafico(490,323,408,-2,0,fpg_lang);
		Else
			p2_bonus=0;
			grafico(600,363,409,-2,0,fpg_lang); 
			grafico(490,323,407,-2,0,fpg_lang);
		End
		write_int(fnt1,660,323,4,OFFSET p2_bolas); 
	End
	While(ganando==1) Frame; End
End

Process stage_clear();
Begin
	y=162;
	x=400;
	file=fpg_lang;
	graph=414;
	if(ops.op_sombras)
		from alpha=0 to 255 step 5; frame; end
	end
	While(ganando==1)
		Frame;
	End
End

Process sombra(graph,x,y,flags,num);
Begin
	flags+=4;
	file=father.file;
	size=father.size;
	size_x=father.size_x;
	size_y=father.size_y;
	angle=father.angle;
	Frame;
	sombra2(graph,x,y,flags);
End

Process sombra2(graph,x,y,flags);
Begin
	flags+=4;
	file=father.file;
	size=father.size;
	size_x=father.size_x;
	size_y=father.size_y;
	angle=father.angle;
	Frame(100);
End

Process relojarena();
Private
	cont_arena;
	velocidad_antes;
Begin
	if(relojarena==1) return; else relojarena=1; end
	velocidad_antes=velocidad;
	suena(13);
	From velocidad=velocidad_antes To velocidad_antes*2 Step 5; Frame; End
	While(cont_arena<200)
		cont_arena++;
		Frame;
	End
	suena(14);
	From velocidad=velocidad_antes*2 To velocidad_antes Step -5; Frame; End
	relojarena=0;
End

/*Process fondos_panic();
Private
	png_fondo;
	cambiado;  
	id_fondo;
Begin
	x=400;
	y=260;
	z=512;
	Loop
		If(p1_bolas+p2_bolas=>0 AND cont==0) texto_fondos("1.Ashura"); png_fondo=load_image(".\fondos\3.jpg"); cont=1; End
		If(p1_bolas+p2_bolas=>50 AND cont==1) If(p1_bolas+p2_bolas<100) texto_fondos("2.Alejandro"); png_fondo=load_image(".\fondos\1.jpg"); End  cambiado=0; cont=2; End // alejo
		If(p1_bolas+p2_bolas=>100 AND cont==2) If(p1_bolas+p2_bolas<150) texto_fondos("3.HH Sigmar MC"); png_fondo=load_image(".\fondos\2.jpg"); End cambiado=0; cont=3; End // carlos
		If(p1_bolas+p2_bolas=>150 AND cont==3) If(p1_bolas+p2_bolas<200) texto_fondos("4.Donan"); png_fondo=load_image(".\fondos\10.jpg"); End cambiado=0; cont=4; End // carlos
		If(p1_bolas+p2_bolas=>200 AND cont==4) If(p1_bolas+p2_bolas<250) texto_fondos("5.Donan 2"); png_fondo=load_image(".\fondos\4.jpg"); End cambiado=0; cont=5; End // donan
		If(p1_bolas+p2_bolas=>250 AND cont==5) If(p1_bolas+p2_bolas<300) texto_fondos("6.Donan 3"); png_fondo=load_image(".\fondos\5.jpg"); End cambiado=0; cont=6; End // donan
		If(p1_bolas+p2_bolas=>300 AND cont==6) If(p1_bolas+p2_bolas<350) texto_fondos("7.SiNk!"); png_fondo=load_image(".\fondos\6.jpg"); End cambiado=0; cont=7; End // carlos166
		If(p1_bolas+p2_bolas=>350 AND cont==7) If(p1_bolas+p2_bolas<400) texto_fondos("8.Wakroo"); png_fondo=load_image(".\fondos\7.jpg"); End cambiado=0; cont=8; End // carlos166
		If(p1_bolas+p2_bolas=>400 AND cont==8) If(p1_bolas+p2_bolas<450) texto_fondos("9.Wakroo 2"); png_fondo=load_image(".\fondos\8.jpg"); End cambiado=0; cont=9; End // santi
		If(p1_bolas+p2_bolas=>450 AND cont==9) If(p1_bolas+p2_bolas<500) texto_fondos("10.Wakroo 3"); png_fondo=load_image(".\fondos\9.jpg"); End cambiado=0; cont=10; End // dani el negro
		If(p1_bolas+p2_bolas=>500 AND cont==10) If(p1_bolas+p2_bolas<550) texto_fondos("11.Aryadna y Emilio"); png_fondo=load_image(".\fondos\30.jpg"); End cambiado=0; cont=11; End // donan 3
		If(p1_bolas+p2_bolas=>550 AND cont==11) If(p1_bolas+p2_bolas<600) texto_fondos("12.???????"); png_fondo=load_image(".\fondos\11.jpg"); End cambiado=0; cont=12; End // ???
		if(jefe!=0)
			If(exists(id_fondo)) signal(id_fondo,s_kill); End
			return;
		end
		If(cambiado==0) 
			If(exists(id_fondo)) signal(id_fondo,s_kill); End
			If(ops.op_sombras==1) alpha=0; End
			graph=png_fondo;
			If(ops.op_sombras==1) dump_type=1; restore_type=1; End
			While(alpha<255	AND ops.op_sombras==1)
				alpha+=15;
				Frame;
			End
			dump_type=0;
			restore_type=0;
			id_fondo=pon_fondo(png_fondo);
			cambiado=1; 
			graph=borrar;
		End
		Frame;
	End
End                  */

process fondos_panic();
begin
	pon_fondo(fondotemporal);
	loop
		cont=((p1_bolas+p2_bolas)/50)+1;
		frame;
	end
end

process fondos_tour();
begin
	pon_fondo(fondotemporal);
end

/*Process fondos_tour();
Private
	png_fond;
Begin
	If(mundo==0) png_fond=load_image(".\fondos\31.jpg"); End
	If(mundo==1) png_fond=load_image(".\fondos\29.jpg"); End
	If(mundo==2) png_fond=load_image(".\fondos\28.jpg"); End  
	If(mundo==3) png_fond=load_image(".\fondos\27.jpg"); End  
	If(mundo==4) png_fond=load_image(".\fondos\26.jpg"); End  
	If(mundo==5) png_fond=load_image(".\fondos\25.jpg"); End  
	If(mundo==6) png_fond=load_image(".\fondos\24.jpg"); End  
	If(mundo==7) png_fond=load_image(".\fondos\23.jpg"); End  
	If(mundo==8) png_fond=load_image(".\fondos\22.jpg"); End
	If(mundo==9) png_fond=load_image(".\fondos\21.jpg"); End  
	If(mundo==10) png_fond=load_image(".\fondos\20.jpg"); End
	If(mundo==11) png_fond=load_image(".\fondos\19.jpg"); End  
	If(mundo==12) png_fond=load_image(".\fondos\18.jpg"); End  
	If(mundo==13) png_fond=load_image(".\fondos\17.jpg"); End  
	If(mundo==14) png_fond=load_image(".\fondos\16.jpg"); End  
	If(mundo==15) png_fond=load_image(".\fondos\15.jpg"); End
	If(mundo==16) png_fond=load_image(".\fondos\14.jpg"); End  
	If(mundo==17) png_fond=load_image(".\fondos\13.jpg"); End 
	If(mundo==18) png_fond=load_image(".\fondos\12.jpg"); End  
	If(mundo==19) png_fond=load_image(".\fondos\11.jpg"); End  
	If(mundo>19) png_fond=load_image(".\fondos\"+itoa(mundo+12)+".jpg"); End
//----------ENGLAND TOUR
	If(mundo==100 AND mod_england==1) png_fond=load_image(".\england\fondos\1.jpg"); End
	If(mundo==101 AND mod_england==1) png_fond=load_image(".\england\fondos\2.jpg"); End
	If(mundo==102 AND mod_england==1) png_fond=load_image(".\england\fondos\3.jpg"); End
	If(mundo==103 AND mod_england==1) png_fond=load_image(".\england\fondos\4.jpg"); End
//----------ANDORRA TOUR
	If(mundo==100 AND mod_andorra==1) png_fond=load_image(".\andorra\fondos\1.jpg"); End
	If(mundo==101 AND mod_andorra==1) png_fond=load_image(".\andorra\fondos\2.jpg"); End
	If(mundo==102 AND mod_andorra==1) png_fond=load_image(".\andorra\fondos\3.jpg"); End
	If(mundo==103 AND mod_andorra==1) png_fond=load_image(".\andorra\fondos\4.jpg"); End
	If(mundo==104 AND mod_andorra==1) png_fond=load_image(".\andorra\fondos\5.jpg"); End
//----------CUSTOM TOUR
	If(mundo=>100 AND mod_custom==1) png_fond=load_image(".\custom\fondos\"+itoa(mundo-99)+".jpg"); End
	If(png_fond<1) png_fond=load_image(".\fondos\"+rand(1,42)+".jpg"); End
	pon_fondo(png_fond);
	Frame;
End*/

Process pon_fondo(el_png);
Begin                                 
    y=260;
    z=512;
    x=400;
    graph=el_png;
    Frame;
    Loop
        Frame(4000)	;
    End
End

Process inicio();
Begin
	p1_puntos+=p1_bonus;
	p1_bonus=0;
	p2_puntos+=p2_bonus;
	p2_bonus=0;
	//frame;
	let_me_alone();
	//faderaro(0);
	if(modo_juego==2 and mundo!=0) faderaro(-1); else faderaro(0); end
	iniciando=1;
	ready=0;
	p1_muere=0;
	p2_muere=0;
	p1_arma=1;
	p2_arma=1;
	ganando=0;
	dinamita=0;
	bola_estrella=0;
	If(modo_juego==2) prisa=0; End
	relojarena=0;
	p1_proteccion=0;
	p2_proteccion=0;
	raton=0;
	matabolas=0;
	if(posibles_jugadores==1)
		players=1;
	end
	guardar_partida();
	delete_text(all_text); // borra textos
	put_screen(0,0); // borra fondo
	cont=0; // contador fondos
	timer[9]=0;
	While(timer[9]<150) Frame; End
	p1_disparos[1]=0; p1_disparos[2]=0; // reinicia p1_disparos
	p2_disparos[1]=0; p2_disparos[2]=0; // reinicia p2_disparos
	bolas=0; // indica q no hay bolas en pantalla
	If(modo_juego==1) panic_mode(); End
	
	If(modo_juego==2) musica(-1); tour_mode(); End
	
	If(p1_vidas=>0 AND p2_vidas<0 AND players==3) players=1; End
	If(p2_vidas=>0 AND p1_vidas<0 AND players==3) players=2; End
	switch(players)
		case 1:	id_p1=muneco1(); end
		case 2:	id_p2=muneco2(); end
		case 3:	id_p1=muneco1(); id_p2=muneco2(); end
	end
	if(jefe!=0 and ops.dificultad<2) 
		p1_proteccion=1;
		p2_proteccion=1;
		p1_arma=2;
		p2_arma=2;
	End
	If(modo_juego==1 and jefe==0) fondos_panic(); End
	If(modo_juego==2) pon_pantalla(mundo); End
	anim_global();
	marcadores();
	timer[9]=0;
//	While(key(_enter) OR mouse.middle) Frame; End
//	While(timer[9]<70 AND !key(_enter)) Frame; End
	While(timer[9]<70) Frame; End
	if(modo_juego==2) tiempo_nivel(pantalla.btime); end
	if(jefe==0) readyando(); else
		switch(jefe)
			case 1: fantasma();  musica(7); end
			case 2: fantasma(); musica(7);  end
			case 3: fmars(); end
			case 4: jefe_gusano(); musica(7); end
			case 5: ultraball(); fondos_tour(); musica(7); end
			case 6: maskara(); musica(7); end
		end
	end
	p1_muere=0;
	p2_muere=0;
	p1_disparos[1]=0; p1_disparos[2]=0; // reinicia p1_disparos
	p2_disparos[1]=0; p2_disparos[2]=0; // reinicia p2_disparos
	ganando=0; 
	iniciando=0;
	reloj=0;
	transicion=0;
End

Process gameover();
Private
	id_input;
	otro_texto;
	tupapa;
Begin
	faderaro(img_pixpang);
	clear_screen();
	musica(-1);
	delete_text(all_text);
	let_me_alone();
	timer[9]=0;
	p1_vidas=10;
	p2_vidas=10;
	p1_puntos=0;
	p2_puntos=0;
	guardar_partida();
	While(timer[9]<100) Frame; End
	transicion=0;
	p1_muere=0;
	p2_muere=0;
	timer[9]=0;
	put_screen(fpg_menu2,4);
	musica(8);
	timer[9]=0;
	While(timer[9]<500 AND !key(_space)) Frame; end
	modo_juego=0;
	menu();;
End

Process panic_mode();
Private
	txt_pausa;
	txt_fps;
	kindabolas;
Begin
	dump_type=0;
	restore_type=0;
	p1_arma=2;
	p2_arma=2;
	modo_juego=1;    
	If(cont==12) cont=11; End
	Loop
		If(pixel_mola==1 and ready==1)
			If(key(_m) AND raton==0) coloca_raton(); End
			If(key(_x)) matabolas=1; Else matabolas=0; End
			If(key(_r) AND reloj==0) reloj=1; itemreloj(5); End
			If(key(_f) AND txt_fps==0) txt_fps=write_int(fnt1,0,0,0,&fps); End
			If(key(_n)) nube(); End
		End
		If(key(_esc) and !exists(type opciones) and ready==1) opciones(); ready=0; End
		If((p1_bolas+p2_bolas)>100 AND rand(0,200)==0) nube(); End
		If(bolas=>13 AND prisa==0) prisa=1; hayprisa(); End
		If(bolas<8 AND prisa==1) prisa=0; timer[8]=0; musica(0); End
		If(key(_d) AND key(_b) AND key(_g)) pixel_mola=1; End
		If(cont==12 AND ganando==0 AND bolas==0 AND ready==1) ganar(); Return; End
		If((timer[7]>1500 OR bolas<1) and jefe==0 AND (ganando==0 AND ready==1 AND p1_bolas+p2_bolas<550 and bola_estrella==0 and matabolas==0)) 
			timer[7]=0; 
			If(prisa==1) prisa=0; timer[8]=0; musica(0); End 
			if(p1_bolas+p2_bolas<200) kindabolas=rand(0,2); else kindabolas=rand(0,4); end 
			If(kindabolas==0) bola(rand(60,740),150,5,rand(0,1)); end 
			If(kindabolas==1) bola(rand(60,740),150,12,rand(0,1)); End 
			If(kindabolas==2) bola(rand(60,740),150,9,rand(0,1)); End 
			If(kindabolas==3) bola(rand(60,740),150,16,rand(0,1)); end 
			If(kindabolas==4) bola(-100,150,19,rand(0,1)); bola(900,150,rand(19,22),rand(0,1)); end
		End
		If(key(_alt) AND key(_x)) exit(0,0); End
		If(zbolas<-200) zbolas=-1; End
		If(players==3)
			If(p1_muere==2 AND p2_muere==0) p1_muere=0; If(p1_vidas<0) inicio(); Else vidasp1(); id_p1=muneco1(); End End
			If(p2_muere==2 AND p1_muere==0) p2_muere=0; If(p2_vidas<0) inicio(); Else vidasp2(); id_p2=muneco2(); End End
			If(p1_muere==2 AND p2_muere==2 AND (p1_vidas=>0 OR p2_vidas=>0)) inicio(); End
			If(p1_muere==2 AND p1_vidas<0 AND p2_muere==2 AND p2_vidas<0) gameover(); End
		End
		If(players==2)
			If(p2_muere==2 AND p2_vidas=>0 AND iniciando==0) inicio(); End
			If(p2_muere==2 AND p2_vidas<0) gameover(); End
		End
		If(players==1)
			If(p1_muere==2 AND p1_vidas=>0 AND iniciando==0) inicio(); End
			If(p1_muere==2 AND p1_vidas<0) gameover(); End
		End           
		If(relojarena==0 and jefe==0) 
			switch(ops.dificultad)			
				case 0:
					velocidad=600-(p1_bolas/3+p2_bolas/3); 
				end
				case 1:
					velocidad=550-(p1_bolas/3+p2_bolas/3); 
				end
				case 2:
					velocidad=500-(p1_bolas/3+p2_bolas/3); 
				end
				case 3:
					velocidad=400-(p1_bolas/3+p2_bolas/3); 
				end
			end
		End
		Frame;
	End                
End

Process tour_mode();
Private
	txt_pausa;
	txt_fps;
	avaricioso;
Begin
	dump_type=0;
	restore_type=0;
	p1_bolas=0;
	p2_bolas=0;
	modo_juego=2;
	cocos=0;
	Loop
		If(pixel_mola==1 and ready==1)
			If(key(_m) AND raton==0) coloca_raton(); End
			If(key(_x)) matabolas=1; Else matabolas=0; End
			If(key(_r) AND reloj==0) reloj=1; itemreloj(5); End
			if(key(_e) and p1_estrella==0) while(key(_e)) frame; end estrella(); end
			If(key(_c)) cocodrilo(rand(0,1)); End
			If(key(_v)) volador(); End
			If(key(_f) AND txt_fps==0) txt_fps=write_int(fnt1,0,0,0,&fps); End
		End
		if(cheto_avaricioso) if(avaricioso<20) avaricioso++; else cocodrilo(rand(0,1)); avaricioso=0; end end
		If(key(_g)) p1_arma=1; p2_arma=1; End
		If(key(_esc) and !exists(type opciones) and ready==1) opciones(); ready=0; End
		If(players==1 AND key(_2)) players=3; suena(6); p2_vidas=10; faderaro(-2); frame; inicio(); End
		If(players==2 AND key(_1)) players=3; suena(6); p1_vidas=10; inicio(); End
		If(key(_d) AND key(_b) AND key(_g)) pixel_mola=1; End
		If(bolas==0 AND ready==1 and jefe==0) ganar(); Break; End
		If(key(_alt) AND key(_x)) exit(0,0); End
		If(zbolas<-200) zbolas=-1; End
		If(cocos<3 and rand(0,2000)==0 and jefe==0) If(rand(0,1)==0) cocodrilo(rand(0,1)); Else volador(); End End
		If(players==3)
			If(p1_muere==2 AND p2_muere==2 AND (p1_vidas=>0 OR p2_vidas=>0) AND iniciando==0) musica(-1); faderaro(-2); frame; inicio(); End
			If(p1_muere==2 AND p1_vidas<0 AND p2_muere==2 AND p2_vidas<0) gameover(); End
		End
		If(players==2)
			If(p2_muere==2 AND p2_vidas=>0 AND iniciando==0) musica(-1); faderaro(-2); frame; inicio(); End
			If(p2_muere==2 AND p2_vidas<0) gameover(); End
		End
		If(players==1)
			If(p1_muere==2 AND p1_vidas=>0 AND iniciando==0) musica(-1); faderaro(-2); frame; inicio(); End
			If(p1_muere==2 AND p1_vidas<0) gameover(); End
		End
		If(relojarena==0) 
			if(p1_estrella)
				velocidad=100;
			else
				switch(ops.dificultad)			
					case 0:
						velocidad=400;
					end
					case 1:
						velocidad=300;
					end
					case 2:
						velocidad=250;
					end
					case 3:
						velocidad=200;
					end
				end
			end
		End
		Frame;
	End
End

Process grafico_alpha(x,y,graph,flags);
Begin
	If(ops.op_sombras==1) alpha=0; End
	While(!key(_enter))
		If(alpha<250 AND ops.op_sombras==1) alpha+=5; End
		Frame;
	End
	While(alpha>10 AND ops.op_sombras==1)
		alpha-=5;
		Frame;
	End
End

Process readyando();
Begin
	ready=0;
	x=400;
	y=250;
	z=-256;
	timer[9]=0;
	if(ops.op_sombras==0) 
		While(timer[9]<300)
		    file=fpg_lang;
		    graph=415;
			ready=0;
		    if(animglobal<30 AND timer[9]>100) graph=borrar; End
		    Frame;
		End
	else
			// way to 2.0!!
		    file=fpg_lang;
		    graph=415;
		    ready=0;
		    from alpha=0 to 255 step 7; frame; end
		    from alpha=255 to 0 step -7; frame; end
		    from alpha=0 to 255 step 7; frame; end
		    from alpha=255 to 0 step -7; frame; end
		    from alpha=0 to 255 step 10; frame; end
		    Frame(2000);
	    	    If(modo_juego==2 and jefe==0)
			    musica(1);
		    end
		    ready=1;
		    from alpha=255 to 0 step -10; size++; frame; end
		    return;
	End
	If(modo_juego==2 and jefe==0)
		musica(1);
	End
	ready=1;
End

Process items(x,y,item);
Private
	tuerestonto;
	aleatorio;
	toca;
Begin
	if(jefe!=0) return; end
	z=1;	
	If(item==0) graph=425; End // reloj arena
	If(item==1) graph=419; End // reloj
	If(item==2) aleatorio=rand(420,423); graph=aleatorio; End // pi�a
	If(item==3) graph=411; End // pistola doble
	If(item==4) graph=412; End // gancho
	If(item==5) graph=413; End // metralleta
	If(item==6) graph=424; size=150; End // protector
	If(item==7) graph=400; If(rand(0,2)!=1) Return; End End // vida
	If(item==8) graph=426; End // dinamita
	If(item==9) graph=519; End // estrella
	If(item==10) bola(x,y,19,rand(0,1)); bolas--; return; End // bola!!
	While(tuerestonto<(5*60))
	        If(item==7) 
			switch(players)
				case 3:
					If(animglobal<30) 
						file=file_muneco1; 
						graph=400; 
					Else 
						file=file_muneco2; 
						graph=401; 
					End 
				end
				case 2:
						file=file_muneco2; 
						graph=401; 
				end
				case 1:
						file=file_muneco1; 
						graph=400; 
				end			
			end
		End
		If(ready==1) tuerestonto+=3; End
		If(aleatorio==1 AND item==6) size+=3; If(size=>150) aleatorio=0; End End
		If(aleatorio==0 AND item==6) size-=3; If(size=<50) aleatorio=1; End End
		If(aleatorio==1 AND item==9) size++; angle+=15000; If(size=>70) aleatorio=0; End End
		If(aleatorio==0 AND item==9) size--; angle+=15000; If(size=<40) aleatorio=1; End End
		If(!collision(Type grafico) AND ready==1 and cheto_borracho==0)
			If(toca=collision(Type bloques))
				If(toca.y<y)
					y+=6; tuerestonto=0;
				End
			Else
					y+=6; tuerestonto=0;
			End
		End
		If(!collision(Type grafico) AND ready==1 and cheto_borracho==1)
			y-=6; tuerestonto=0;
		End
		If((collision(Type dispcab) OR collision(Type dispcab2)) AND item==2)
			p1_puntos+=2400; suena(10); Break; 
		End
		If(collision(id_p1) AND p1_muere==0)
			If(item==0) relojarena(); End // reloj arena
			If(item==1 and jefe==0) If(reloj==0) itemreloj(rand(3,7)); else secs+=4*60; End End // reloj
			If(item==2) p1_puntos+=2400; suena(10); End // pi�a
			If(item==3) p1_arma=2; suena(3); signal(type dispcab,s_kill); signal(type dispcab2,s_kill); p1_disparos[1]=0; p1_disparos[2]=0; End // pistola doble
			If(item==4) p1_arma=3; suena(3); signal(type dispcab,s_kill); signal(type dispcab2,s_kill); p1_disparos[1]=0; p1_disparos[2]=0; End // gancho
			If(item==5) p1_arma=4; suena(3); signal(type dispcab,s_kill); signal(type dispcab2,s_kill); p1_disparos[1]=0; p1_disparos[2]=0; End // metralleta
			If(item==6 and p1_proteccion==0) p1_proteccion=1; if(p1_estrella==0) proteccion(1); end suena(11); End // protector         
			If(item==9) estrella(); End // estrella!!
			If(item==7) p1_vidas++; suena(6); End // vida
			If(item==8 AND dinamita==0) dinamita=1; suena(15); graph=borrar; Frame(4000); dinamita=0; End // dinamita
			Break;
		End
		If(collision(id_p2) AND p2_muere==0)
			If(item==0) relojarena(); End // reloj arena
			If(item==1 and jefe==0) If(reloj==0) itemreloj(rand(3,7)); else secs+=4*60; End End // reloj
			If(item==2) p2_puntos+=2400; suena(10); End // pi�a
			If(item==3) p2_arma=2; suena(3); signal(type dispcab3,s_kill); signal(type dispcab4,s_kill); p2_disparos[1]=0; p2_disparos[2]=0; End // pistola doble
			If(item==4) p2_arma=3; suena(3); signal(type dispcab3,s_kill); signal(type dispcab4,s_kill); p2_disparos[1]=0; p2_disparos[2]=0; End // gancho
			If(item==5) p2_arma=4; suena(3); signal(type dispcab3,s_kill); signal(type dispcab4,s_kill); p2_disparos[1]=0; p2_disparos[2]=0; End // metralleta
			If(item==6 and p2_proteccion==0) p2_proteccion=1; if(p2_estrella==0) proteccion(2); end suena(11); End // protector         
			If(item==9) estrella(); End // estrella!!
			If(item==7) p2_vidas++; suena(6); End // vida
			If(item==8 AND dinamita==0) dinamita=1; graph=borrar; Frame(4000); dinamita=0; End // dinamita
			Break;
		End

		If(tuerestonto>(3*60)) If(flags==0) flags=4; Else flags=0; End End
		Frame(200);
	End
End

Process pa_largar();
Begin
	Loop
		If(key(_alt) AND key(_x)) exit(0,0); End
		Frame;
	End
End

Process col_hielo(x,y);
Begin
	graph=438;
	alpha=0;
	loop
		frame;
	end
End

Process bloques(x,y,regalo,tipo);
Private
	id_disp;
	rompible;
	iddisp[7];
Begin
	z=2;
	If(tipo==1) graph=427; rompible=1; End
	If(tipo==2) graph=428; rompible=1; End
	If(tipo==3) escaleras(x,y); Return; End
	If(tipo==4) graph=430; rompible=0; End
	If(tipo==5) graph=431; rompible=0; End
	If(tipo==6) graph=432; rompible=1; End
	If(tipo==7) graph=433; rompible=1; End
	If(tipo==8) graph=434; rompible=1; End
	If(tipo==9) graph=435; rompible=0; End
	If(tipo==10) graph=436; rompible=0; End
	If(tipo==11) graph=437; rompible=1; End
	If(tipo==12) graph=438; z=-1; col_hielo(x,y-10); rompible=0; End
	if(regalo==10 and rompible==1) bolas++; end
	ancho=graphic_info(0,graph,g_wide);
	alto=graphic_info(0,graph,g_height);
	if(cheto_borracho==1) angle=rand(0,360)*1000; end
	map_xput(fpg_bloquesmask,mapadurezas,graph,x,y,angle,size,0);
	Loop
		If(x==0 OR y==0) Break; End
/*		if(rompible==1 and p1_arma==4 and ((iddisp[0]=collision(Type cachodisp)) OR (iddisp[2]=collision(Type cachodisp2))))
			If(collision(iddisp[0])) signal(p1_disparos[1],s_kill); End
			If(collision(iddisp[2])) signal(p1_disparos[2],s_kill); End
		End
*/
		If(rompible==0 AND graph!=429 AND p1_arma!=3 AND (((iddisp[0]=collision(Type cachodisp)) OR (iddisp[1]=collision(Type dispcab))) OR ((iddisp[2]=collision(Type cachodisp2)) OR (iddisp[3]=collision(Type dispcab2)))))
			If(((collision(iddisp[0]) AND p1_arma==4) OR collision(iddisp[1])) and exists(p1_disparos[1])) if(p1_disparos[1].y>y) signal(p1_disparos[1],s_kill); end End
			If(((collision(iddisp[2]) AND p1_arma==4) OR collision(iddisp[3])) and exists(p1_disparos[2])) if(p1_disparos[2].y>y) signal(p1_disparos[2],s_kill); end End
		End
/*		if(rompible==1 and p2_arma==4 and ((iddisp[4]=collision(Type cachodisp3)) OR (iddisp[6]=collision(Type cachodisp4))))
			If(collision(iddisp[4])) signal(p2_disparos[1],s_kill); End
			If(collision(iddisp[6])) signal(p2_disparos[2],s_kill); End
		End*/

		If(rompible==0 AND graph!=429 AND p2_arma!=3 AND (((iddisp[4]=collision(Type cachodisp3)) OR (iddisp[5]=collision(Type dispcab3))) OR ((iddisp[6]=collision(Type cachodisp4)) OR (iddisp[7]=collision(Type dispcab4)))))
			If(((collision(iddisp[4]) AND p2_arma==4) OR collision(iddisp[5])) and exists(p2_disparos[1])) if(p2_disparos[1].y>y) signal(p2_disparos[1],s_kill); end End
			If(((collision(iddisp[6]) AND p2_arma==4) OR collision(iddisp[7])) and exists(p2_disparos[2])) if(p2_disparos[2].y>y) signal(p2_disparos[2],s_kill); end End
		End
		If(rompible==1)
			if(exists(p1_disparos[1])) if(collision(p1_disparos[1]) and p1_arma!=4) signal(p1_disparos[1],s_kill); break; End end
			if(exists(p1_disparos[2])) if(collision(p1_disparos[2]) and p1_arma!=4) signal(p1_disparos[2],s_kill); break; End end
			if(exists(p2_disparos[1])) if(collision(p2_disparos[1]) and p2_arma!=4) signal(p2_disparos[1],s_kill); break; End end
			if(exists(p2_disparos[2])) if(collision(p2_disparos[2]) and p2_arma!=4) signal(p2_disparos[2],s_kill); break; End end
		end
		if(regalo==10 and rompible==1 and !exists(type bola) and ready==1) if(ops.dificultad==3) items(x,y,regalo); return; else bolas--; return; end end
		Frame;
	End
	if(y>10) items(x,y,regalo); end
	if(os_id!=9) explotalo(x,y,z,alpha,0,file,graph,60); end
	//from alpha=255 to 0 step -10; frame; end
End

Process opciones();
Private
	opcion;
	t_opc;
	txt1;txt2;txt3;txt4;txt5;
	mano;
	txt_opmusic;
	txt_opsombras;
	txt_opsonido;
	struct partidaguardada;
		int pgpuntos[1];
		int pgplayers;
		int pgmundo;
		int pgvidas[1];
	end
	fotopartida;
Begin
	let_me_alone();
	stop_song();
	delete_text(all_text);
	menu();
	return;
End

Process coloca_raton();
Private
	tipo=1;
	cont_bloque;
	regalo;
	bloque_o_bola=1;
	lado_bola;
	ids_graficos[200];
Begin
	time_puesto=90;
	z=-3;
	raton=1;
	frame;
	write_int(fnt1,0,0,0,OFFSET cont_bloque);
	write_int(fnt1,450,539,4,OFFSET time_puesto);
	write_int(fnt1,800,0,2,OFFSET regalo);
	Loop
		If(x<400) lado_bola=0; Else lado_bola=1; End
		x=mouse.x;
		y=mouse.y;
		If(key(_down) AND time_puesto>40) time_puesto-=10; While(key(_down)) Frame; End End
		If(key(_up) AND time_puesto<250) time_puesto+=10; While(key(_up)) Frame; End End
		if(key(_left) and regalo>0) While(key(_left)) Frame; End regalo--; end
		if(key(_right) and regalo<11) While(key(_right)) Frame; End regalo++; end
		//regalo=rand(0,13);
		If(tipo<110 or tipo>113) size=100; End
		If(tipo==1)graph=427; End
		If(tipo==2) graph=428; End
		If(tipo==3) graph=429; End
		If(tipo==4) graph=430; End
		If(tipo==5) graph=431; End
		If(tipo==6) graph=432; End
		If(tipo==7) graph=433; End
		If(tipo==8) graph=434; End
		If(tipo==9) graph=435; End
		If(tipo==10) graph=436; End
		If(tipo==11) graph=437; End
		If(tipo==12) graph=438; End
		If(tipo==101) graph=701; End
		If(tipo==102) graph=702; End
		If(tipo==103) graph=703; End
		If(tipo==104) graph=704; End
		If(tipo==105) graph=705; End
		If(tipo==106) graph=711; End
		If(tipo==107) graph=713; End
		If(tipo==108) graph=715; End
		If(tipo==109) graph=716; End
		If(tipo==110) graph=801; size=33; End
		If(tipo==111) graph=801; size=66; End
		If(tipo==112) graph=801; size=100; End
		If(tipo==113) graph=717; End
		If(tipo==114) graph=718; End
		If(tipo==115) graph=719; End
		If(tipo==116) graph=720; End
		If(tipo==117) graph=721; End 
		If(tipo==118) tipo=119; End
		If(tipo==119) graph=723; End 
		if(tipo==120) graph=724; end 
 		if(tipo==121) graph=725; end 
		if(tipo==122) graph=726; end

		If(key(_space)) 
			While(key(_space)) Frame; End 
			If(bloque_o_bola==1) 
				tipo=101; bloque_o_bola=0; 
			Else 
				bloque_o_bola=1; tipo=1; 
			End 
		End
		If(key(_z) AND cont_bloque=>0) signal(ids_graficos[cont_bloque],s_kill); cont_bloque--; While(key(_z)) Frame; End End
		If(mouse.right==1) If((tipo<12 AND bloque_o_bola==1) OR (tipo<122 AND bloque_o_bola==0)) tipo++; Else If(bloque_o_bola==1) tipo=1; Else tipo=101; End End While(mouse.right==1) Frame; End End
		If(mouse.left==1) 
			If(tipo<100) 
				ids_graficos[cont_bloque]=bloques(x,y,regalo,tipo); 
			Else 
				ids_graficos[cont_bloque]=bola(x,y,tipo-100,lado_bola); 
			End
			pantalla.bx[cont_bloque]=x;
			pantalla.by[cont_bloque]=y;
			pantalla.btipo[cont_bloque]=tipo;
			pantalla.br[cont_bloque]=regalo;
			cont_bloque++;
			While(mouse.left==1) Frame; End 
		End
		pantalla.btime=time_puesto;
		If(cont_bloque==200) Break; End
		Frame;
	End
	raton=0;
End

Process pon_pantalla(num);
Private
	cont_bloque;
	tipo;
	regalo;
	lado_bola;
	el_input;
Begin
	While(key(_enter)) Frame; End
	if(mundo==4) jefe=2; end
	if(mundo==9) jefe=3; end
	if(mundo==14) jefe=4; end
	if(mundo==19) jefe=5; end
	if(mundo==79) jefe=6; end
	If((num=>0 and num<100) and jefe==0) load(".\tour\"+num+".pang",pantalla); end
	If(jefe!=0) 
		load(".\tour\mostro.pang",pantalla); 
	end
	if(jefe==0) fondos_tour(); end

	//if(mapadurezas) unload_map(0,mapadurezas); else mapadurezas=new_map(800,600,16); end
	
	While(cont_bloque<200)
		x=pantalla.bx[cont_bloque];
		y=pantalla.by[cont_bloque];
		regalo=pantalla.br[cont_bloque];
		tipo=pantalla.btipo[cont_bloque];
		If(x<400) lado_bola=0; Else lado_bola=1; End
		If(tipo<100) bloques(x,y,regalo,tipo); Else bola(x,y,tipo-100,lado_bola); End
		cont_bloque++;
	End
	frame;
	//save_png(0,mapadurezas,"c:\nivel.png");
	time_puesto=pantalla.btime;
	p1_muere=0; 
	p2_muere=0;
End

Process cocodrilo(lado); // a quien no le guste que no explote que se joda xD
Private
	id_bola;
	cont_giros;
	grav;
	id_disp;
Begin
	cocos++;
	If(lado==0) x=0; flags=1; Else x=800; flags=0; End
	y=466;
	z=-2;
	Loop
		While(ready==0 OR reloj==1) Frame; End
		If(ganando==1) Break; End
		If(animglobal<15) graph=312; End
		If(animglobal=>15 AND animglobal<30) graph=311; End
		If(animglobal=>30 AND animglobal<45) graph=310; End
		If(animglobal=>45) graph=311; End
		If(lado==0) x+=2; Else x-=2; End
		If(x=>770 AND lado==0 AND cont_giros<3) cont_giros++; lado=1; If(cheto_borracho==1) flags=1; Else flags=0; End End
		If(x=<30 AND lado==1 AND cont_giros<3) cont_giros++; lado=0; If(cheto_borracho==1) flags=0; Else flags=1; End End
		If(x>850 OR x<-50) Return; End

		if(collision(type dispcab) or collision(type cachodisp)) signal(p1_disparos[1],s_kill); break; end
		if(collision(type dispcab2) or collision(type cachodisp2)) signal(p1_disparos[2],s_kill); break; end
		if(collision(type dispcab3) or collision(type cachodisp3)) signal(p2_disparos[1],s_kill); break; end
		if(collision(type dispcab4) or collision(type cachodisp4)) signal(p2_disparos[2],s_kill); break; end

		Frame;
	End
	grav=rand(100,200);
	While(y<480)
		If(ops.op_sombras==1) sombra(graph,x,y,flags,1); End
		If(flags==0) x+=12; angle+=60000; End
		If(flags==1) x-=12; angle+=60000; End
		If(x=>755) flags=1; End
		If(x=<45) flags=0; End
		grav-=5;
		y-=grav/10;
		Frame;
	End
	cocos--;
End

Process volador();
Private
	inercia;
	y_destino;
	y_destino_final;
	lado;
	id_disp;
Begin
	graph=300;
	x=rand(100,500);
	z=-2;
	cocos++;
	y_destino_final=rand(100,400);
	Loop
		flags=lado;
		While(ready==0 OR reloj==1) Frame; End
		While(y<y_destino AND y<y_destino_final AND !collision(Type bola))
			inercia+=3;
			y+=inercia/2; 
			If(lado==1) x+=inercia*2; Else x-=inercia*2; End
			If(animglobal<15)
				graph=300; 
			End
			If(animglobal>14 AND animglobal<30) 
				graph=301;
			End
			If(animglobal>29 AND animglobal<45) 
				graph=300; 
			End
			If(animglobal>44 AND animglobal<60) 
				graph=301; 
			End
			Frame(400);
		End
		inercia=0;
		if(lado==1) x++; else x--; end
		If(collision(Type bola))
			If(lado==1) 
				While(x<850) x+=5; 
					If(animglobal<15) 
						graph=300; 
					End
					If(animglobal>14 AND animglobal<30) 
						graph=301;
					End
					If(animglobal>29 AND animglobal<45) 
						graph=300; 
					End
					If(animglobal>44 AND animglobal<60) 
						graph=301; 
					End
					Frame; 
				End 

			Else 
				While(x>-50) x+=5; 
					If(animglobal<15) 
						graph=300; 
					End
					If(animglobal>14 AND animglobal<30) 
						graph=301;
					End
					If(animglobal>29 AND animglobal<45) 
						graph=300; 
					End
					If(animglobal>44 AND animglobal<60) 
						graph=301; 
					End
					Frame;
				End
			End
			cocos--; 
			Return;
		End
		y_destino=y+30;
		If(animglobal<30) 
			graph=300;
		Else
			graph=301;
		End
		If(lado==1 AND (animglobal==60 OR y<y_destino_final)) lado=0; 
			ElseIf(lado==0 AND (animglobal==60 OR y<y_destino_final)) lado=1; 
		End
		if(collision(type dispcab) or collision(type cachodisp)) signal(p1_disparos[1],s_kill); break; end
		if(collision(type dispcab2) or collision(type cachodisp2)) signal(p1_disparos[2],s_kill); break; end
		if(collision(type dispcab3) or collision(type cachodisp3)) signal(p2_disparos[1],s_kill); break; end
		if(collision(type dispcab4) or collision(type cachodisp4)) signal(p2_disparos[2],s_kill); break; end

		Frame;
	End
	cocos--;
	While(size>0)
		size-=5;
		alpha-=10;
		angle+=25000;
		Frame;
	End
End

Process controlador_player1();
Begin
	Loop
		While(ready==0) Frame; End
		If(ops.p1_control==0)  // teclado
			If(key(_left)) botones.p1[0]=1; Else botones.p1[0]=0; End
			If(key(_right)) botones.p1[1]=1; Else botones.p1[1]=0; End
			If(key(_up)) botones.p1[2]=1; Else botones.p1[2]=0; End
			If(key(_down)) botones.p1[3]=1; Else botones.p1[3]=0; End
			If(key(_control) OR key(_space) or key(_enter)) botones.p1[4]=1; Else botones.p1[4]=0; End
			If(key(_z) or key(_esc)) botones.p1[5]=1; Else botones.p1[5]=0; End
		End
		If(ops.p1_control==1)  // joystick		
			If(get_joy_position(0,0)<-10000) botones.p1[0]=1; Else botones.p1[0]=0; End
			If(get_joy_position(0,0)>10000) botones.p1[1]=1; Else botones.p1[1]=0; End
			If(get_joy_position(0,1)<-7500) botones.p1[2]=1; Else botones.p1[2]=0; End
			If(get_joy_position(0,1)>7500) botones.p1[3]=1; Else botones.p1[3]=0; End
			If(get_joy_button(0,0) OR get_joy_button(0,1)) botones.p1[4]=1; Else botones.p1[4]=0; End
			If(get_joy_button(0,2) OR get_joy_button(0,3)) botones.p1[5]=1; Else botones.p1[5]=0; End
		End
		Frame;
	End
End

Process controlador_player2();
Begin
	Loop
		While(ready==0) Frame; End
		If(ops.p2_control==0)  // teclado
			If(key(_left)) botones.p2[0]=1; Else botones.p2[0]=0; End
			If(key(_right)) botones.p2[1]=1; Else botones.p2[1]=0; End
			If(key(_up)) botones.p2[2]=1; Else botones.p2[2]=0; End
			If(key(_down)) botones.p2[3]=1; Else botones.p2[3]=0; End
			If(key(_control) OR key(_space) or key(_enter))  botones.p2[4]=1; Else botones.p2[4]=0; End
			If(key(_z) or key(_esc)) botones.p2[5]=1; Else botones.p2[5]=0; End
		End
		If(ops.p2_control==1)  // joystick
            If(get_joy_position(0,0)<-10000) botones.p2[0]=1; Else botones.p2[0]=0; End
   		    If(get_joy_position(0,0)>10000) botones.p2[1]=1; Else botones.p2[1]=0; End
            If(get_joy_position(0,1)<-7500) botones.p2[2]=1; Else botones.p2[2]=0; End                        
			If(get_joy_position(0,1)>7500) botones.p2[3]=1; Else botones.p2[3]=0; End
			If(get_joy_button(0,0) OR get_joy_button(0,1)) botones.p2[4]=1; Else botones.p2[4]=0; End
			If(get_joy_button(0,2) OR get_joy_button(0,3)) botones.p2[5]=1; Else botones.p2[5]=0; End
		End
		If(ops.p2_control==2)  // joystick
            If(get_joy_position(1,0)<-10000) botones.p2[0]=1; Else botones.p2[0]=0; End
   		    If(get_joy_position(1,0)>10000) botones.p2[1]=1; Else botones.p2[1]=0; End
            If(get_joy_position(1,1)<-7500) botones.p2[2]=1; Else botones.p2[2]=0; End                        
			If(get_joy_position(1,1)>7500) botones.p2[3]=1; Else botones.p2[3]=0; End
			If(get_joy_button(1,0) OR get_joy_button(1,1)) botones.p2[4]=1; Else botones.p2[4]=0; End
			If(get_joy_button(1,2) OR get_joy_button(1,3)) botones.p2[5]=1; Else botones.p2[5]=0; End
		End

		Frame;
	End
End

Process faderaro(graphh);
Private
	nosubida;
	grav;
Begin
	if(ops.op_sombras==0) return; end
	x=400;
	y=300;
	z=-512;
	if(graphh>0) graph=graphh; else

		If(graphh==0) graph=920; End
		if(graphh==-2) screenshot=get_screen(); nosubida=1; end
		if(graphh!=-1 and graph!=2) transicion=1; else graph=screenshot; nosubida=1; end
	end

	If(ops.op_sombras==1) alpha=0; End
	While(alpha<255 and transicion==1 and nosubida==0)
		alpha+=15;
		Frame;
	End
	alpha=255;
	While(transicion==1) Frame; End
	if(rand(0,1)==0)
		While(alpha>15 AND ops.op_sombras==1)
			alpha-=15;
			Frame;
		End
	else
		set_center(0,graph,800,0); x=800; y=0; loop grav++; angle+=grav*1000; if(angle>90000) break; end frame;	end
	end
	
	if(graph==screenshot)
		graph=0;
		//unload_map(0,screenshot);
	end
End

Process escaleras(x,y);
Begin
	graph=429;
	z=3;
	Loop
		Frame;
	End
End

Process parpadeo();
Begin
	x=400; y=300;
	z=-511;
	graph=923;
	Frame(500);
End

Process nube();
Private
	tocante;
	velosidad;
	cosaxunga;
	rolling;
	algo;
	size_inicio;
Begin
	If(rand(0,1)==1) x=800; flags=1; Else x=0; flags=0; End
	if(cheto_borracho==0) y=rand(50,200); velosidad=rand(3,8); else y=rand(300,500); velosidad=rand(8,20); end
	graph=660;
	size_inicio=rand(70,100);
	If(ops.op_sombras==1) alpha=128; End
	While(flags==1 AND x>0)
		size_x=size_inicio+(rolling/6);
		size_y=size_inicio-(rolling/5);
		if(algo==false)
			if(rolling<100) rolling+=2; else algo=true; end
		else
			if(rolling>0) rolling-=2; else algo=false; end
		end
		x-=velosidad;
		If(tocante=collision(Type bola)) tocante.x-=velosidad; tocante.y--; End
		Frame(velocidad/2);
	End
	While(flags==0 AND x<800)
		size_x=size_inicio+(rolling/6);
		size_y=size_inicio-(rolling/5);
		if(algo==false)
			if(rolling<100) rolling+=2; else algo=true; end
		else
			if(rolling>0) rolling-=2; else algo=false; end
		end
		x+=velosidad;
		If(tocante=collision(Type bola)) tocante.x+=velosidad; tocante.y--; End
		Frame(velocidad/2);
	End
End

process logo_pixjuegos();
begin
	if(ops.op_lang==-1) 
		let_me_alone(); frame; menu_lenguaje(); return; 
	else
		if(ops.op_lang==0)
			fpg_menu2=load_fpg("fpg/menu-es.fpg");
			fpg_lang=load_fpg("fpg/eng.fpg");
		else
			fpg_menu2=load_fpg("fpg/menu-en.fpg");
			fpg_lang=load_fpg("fpg/eng.fpg");
		end
	end
	delete_text(0);
	graph=951;
	x=400;
	y=300;
	z=-10;
	from alpha=50 to 255 step 5; 
		if(key(_enter) or key(_esc)) break; end
		frame; 
	end
	timer[0]=0;
	while(timer[0]<300) if(scan_code!=0) break; end frame; end
	while(scan_code!=0) frame; end
	menu();
	from alpha=alpha to 0 step -10;
		frame; 
	end
end

Function guardar_partida();
Begin
	save(savegamedir+"partida.dat",mundo);
End

process cargar_partida();
Begin
	let_me_alone();
	load(savegamedir+"partida.dat",mundo);
	modo_juego=2;
	if(posibles_jugadores==1)
		players=1; inicio();
	else
		menu_jugadores_continuar();
	end
End

include "menu.pr-";
include "guardar.pr-";

// MONSTRUOS
include "monstruos/ultraball.pr-";
include "monstruos/fantasma.pr-";
include "monstruos/fmars.pr-";
include "monstruos/gusano.pr-";
include "monstruos/maskara.pr-";

process shell(string crap);
begin
end

Process explotalo(x,y,z,alpha,angle,file,graffico,frames);
Private
	a;
	b;
	c;
	tiempo;
	struct particula[10000];
		pixel;
		pos_x;
		pos_y;
		vel_y;
		vel_x;
	end
Begin
	if(!ready) return; end
	ancho=graphic_info(file,graffico,g_width);
	alto=graphic_info(file,graffico,g_height);
	from b=0 to alto-1 step 5;
		from a=0 to ancho-1 step 5;
			if(map_get_pixel(file,graffico,a,b)!=0)
				particula[c].pixel=map_get_pixel(file,graffico,a,b);
				
				particula[c].pos_x=a-(ancho/2);
				particula[c].pos_y=b-(alto/2);
				particula[c].vel_x=((a-(ancho/2))/12)+rand(-1,1);
				particula[c].vel_y=((b-(alto/2))/12)+rand(-1,1);
				
			//	particula[c].vel_x=(a-(ancho/2))/12;
			//	particula[c].vel_y=(b-(alto/2))/12;
				
				c++;
			end
		end
	end
	a=c;
	while(tiempo<frames)
		graph=new_map(ancho*8,alto*8,32);
		from c=0 to a;
			map_put_pixel(0,graph,particula[c].pos_x+(ancho*8/2),particula[c].pos_y+(alto*8/2),particula[c].pixel);
			map_put_pixel(0,graph,particula[c].pos_x+(ancho*8/2)+1,particula[c].pos_y+(alto*8/2),particula[c].pixel);
			map_put_pixel(0,graph,particula[c].pos_x+(ancho*8/2),particula[c].pos_y+(alto*8/2)+1,particula[c].pixel);
			map_put_pixel(0,graph,particula[c].pos_x+(ancho*8/2)+1,particula[c].pos_y+(alto*8/2)+1,particula[c].pixel);
			particula[c].pos_x+=particula[c].vel_x;
			particula[c].pos_y+=particula[c].vel_y+tiempo-10;
			
		end
		tiempo++;
		frame;
		unload_map(0,graph);
	end
end