!- Testing frogger type of movement
!-      V0.50   Trying multipart programs
!-              Part 1 = Loader program - User-defined characters
!-              Part 2 = this program
!-
!- MEMORY
!-      7680    Screen memory
!-              User-defined characters
!-      7168    Top of BASIC / Strings
!-
!-      1025    Start of BASIC (+3K RAM pack)
!-
!-10 POKE51,0:POKE52,28:POKE55,0:POKE56,28:CLR
!- Vic      sound1  s2      s3      s0(noise) volume
20 sv=36873:s1=sv+1:s2=sv+2:s3=sv+3:s0=sv+4:vo=sv+5
!- Screen&border_colour, Screen_memory, Colour_memory, nest_positions
30 sb=sv+6:sm=7680:cm=38400:DIMnp%(4),tu%(3)
35 tu%(0)=225:tu%(1)=231:tu%(2)=235:tu%(3)=240
!-40 POKEsb,8:PRINT"{clear}{white}{right*5}vic{green}{reverse on}frogger{reverse off}"
!- Define main strings
50 GOSUB3000
!- User-defined characters
!- 60 GOSUB4000
!- Switch to UDC
!-70 POKE36869,255
!------------------------------------------------------------------------------
!- Frog,score,start_time,game_over
90 fr=5:sc=0:t0=TI:ov=0
!- Nest positions 0 1 2 3    nests(total)
95 np%(1)=0:np%(2)=0:np%(3)=0:np%(4)=0:ns=0
!-  Game screen
100 GOSUB2000
!-  Frog's column row   top_row
110 co=10:ro=21:rt=0
!-  old_byte old_colour
120 ob=PEEK(sm+ro*22+co):oc=PEEK(cm+ro*22+co)
130 POKEsm+ro*22+co,27:POKEcm+ro*22+co,7
!-- Loop counter: m=move frog  n=move traffic
140 m=1:n=1
!------------------------------------------------------------------------------
!-  Main loop
!-  Traffic p1
200 IFm=1THENGOSUB600:GOSUB360:IFrtTHEN1000
!-    Traffic p2
210   IFm=5THENGOSUB800:GOSUB360:IFrtTHEN1000
220   GOSUB400:IFrtTHEN1000
230   m=m+1
240 IFm<9THEN200
!---- loop
250 m=1:n=n+1
260   IFn>10THENn=1
!-- If frog on log/turtles... move frog too
270   IFro=4ORro=8THENco=co-1:IFco<0THENco=0
290   IFro=6ORro=10THENco=co+1:IFco>21THENco=21
300 IFn<>2THEN200
!-- loop
310   tt=200-INT((TI-t0)/60)
320   IFtt<0THENPRINT"{home}{white}{right*19}  0";:GOTO1200
330   t$=RIGHT$(" "+STR$(tt),3)
340   PRINT"{home}{white}{right*19}"t$;
350 GOTO200
!-- loop
!-- Check if car hits frog
360 IFro<14ORro>20THEN390
370 IFPEEK(sm+ro*22+co)<>32THENrt=2
390 RETURN
!------------------------------------------------------------------------------
!-  Get user input, move frog
400 c=0:r=0
410 GETk$
420 IFk$<>"{up}"THEN450
430 IFro=21THENr=-1:GOTO500
440 r=-2:GOTO500
!---
450 IFk$<>"{down}"THEN480
460 IFro=20THENr=1:GOTO500
470 IFro<20THENr=2:GOTO500
!---
480 IFk$="{left}"THENc=-1
490 IFk$="{right}"THENc=1
!---
495 IFc=0ANDr=0THEN530
!---
500 POKEsm+ro*22+co,ob:POKEcm+ro*22+co,oc
501 co=co+c:ro=ro+r
502 IFco<0THENco=0
503 IFco>21THENco=21
505 ob=PEEK(sm+ro*22+co):oc=PEEK(cm+ro*22+co)
510 IFro>13ANDro<21ANDob<>32ANDob<>27THENrt=2:GOTO550
520 IFro>3ANDro<11ANDob=32THENrt=2:GOTO550
!-- Sound: woop
525 POKEvo,15:FORi=140TO150:POKEs3,i:NEXT:POKEs3,0:POKEvo,0
!-- Frog char
530 POKEsm+ro*22+co,27:POKEcm+ro*22+co,7
540 IFro=2THENrt=1
550 RETURN
!---
560 ov=1
565 PRINT"{home}{right*15}"ro;ob;
570 POKEsm+ro*22+co,24:POKEcm+ro*22+co,1
580 FORt=1TO2000:NEXT
590 RETURN
!------------------------------------------------------------------------------
!-  The traffic - part 1
600 PRINT"{home}{down*2}"
610 PRINT"{purple}"MID$(a$,n,22);
620 PRINT"{down}{green}"MID$(c$,11-n,22);
630 PRINT"{down}{red}"MID$(a$,n+2,22);
640 PRINT"{down}{white}"MID$(c$,13-n,22);
650 PRINT"{down*2}";
660 PRINT"{down}{blue}"MID$(e$,n,22);
670 PRINT"{down}{cyan}"MID$(g$,11-n,22);
680 PRINT"{down}{green}"MID$(e$,n+2,22);
690 PRINT"{down}{white}"MID$(g$,13-n,22);
700 RETURN
!------------------------------------------------------------------------------
!-  The traffic - part 2
800 PRINT"{home}{down*2}"
810 PRINT"{purple}"MID$(b$,n,22);
820 PRINT"{down}{green}"MID$(d$,11-n,22);
830 PRINT"{down}{red}"MID$(b$,n+2,22);
840 PRINT"{down}{white}"MID$(d$,13-n,22);
850 PRINT"{down*2}";
860 PRINT"{down}{blue}"MID$(f$,n,22);
870 PRINT"{down}{cyan}"MID$(h$,11-n,22);
880 PRINT"{down}{green}"MID$(f$,n+2,22);
890 PRINT"{down}{white}"MID$(h$,13-n,22);
900 RETURN
!------------------------------------------------------------------------------
!-  Reached top line or dead?
1000 IFrt=1ANDob=32THEN1100
!--- Dead frog
1010 POKEsm+ro*22+co,62:POKEcm+ro*22+co,1
1020 GOSUB1300:FORt=1TO1000:NEXT
1030 j$="{red}lost a frog":GOSUB1400
!--- One less frog
1040 fr=fr-1
1050 IFfr=0THENj$="{red}no more frog":GOSUB1400:GOTO1200
1060 GOTO100
!--- Safe in nest
1100 ns=ns+1:np%(ns)=co:GOSUB1500
1110 sc=sc+100:IFsc>hiTHENhi=sc
1120 j$="{green}nest"+str$(ns):GOSUB1400
1130 IFns<4THEN1170
1140 sc=sc+tt*20:IFsc>hiTHENhi=sc
1150 j$="{green}quest completed":GOSUB1600:GOSUB1400:GOTO1220
1170 GOTO100
!--- Game over
1200 j$="{red}game over":GOSUB1700:GOSUB1400
1210 j$="{white}score"+str$(sc):GOSUB1400
!--- Play again?
1220 GOSUB1500
1230 j$="{white}play again? y/n":GOSUB1400
1240 GETk$
1250 IFk$="y"ORk$="Y"THENGOSUB1500:GOTO90
1260 IFk$="n"ORk$="N"THEN1280
1270 GOTO1240
1280 PRINT"{clear}":GOSUB1700
1290 END
!--- Sound: dead frog
1300 POKEvo,15
1310 FORi=200TO128STEP-3:POKEs0,i
1330 FORj=1TO10:NEXT
1340 NEXT
1350 POKEvo,0:POKEs0,0
1360 RETURN
!--- Popup dialog box & pause
1400 PRINT"{home}{down*9}{yellow}!!!!!!!!!!!!!!!!!!!!!!";
1410 FORi=1TO3
1420 PRINT"!                    !";
1430 NEXT
1440 PRINT"!!!!!!!!!!!!!!!!!!!!!!";
1450 j=11-LEN(j$)/2
1460 PRINT"{home}{down*11}";LEFT$("{right*10}",j);j$;
1470 FORt=1TO3000:NEXT
1480 RETURN
!--- Sound: win
1500 POKEvo,15
1510 i=225:GOSUB1560
1520 i=235:GOSUB1560
1530 i=243:GOSUB1560
1540 POKEs2,0:POKEvo,0
1550 RETURN
1560 POKEs2,i:FORj=1TO50:NEXT:RETURN
!--------------------
!-  Tune: Victory
1600 POKEvo,15
1630 FORi=0TO3:POKEs1,tu%(i)
1650 FORj=1TO100:NEXT:NEXT
1660 FORj=1TO200:NEXT
1670 POKEs1,0:POKEvo,0
1680 RETURN
!--------------------
!-  Tune: Game over
1700 FORi=15TO0STEP-1
1710   POKEvo,i:POKEs1,200+i*2
1730   FORj=1TO50:NEXT
1740 NEXT
1750 POKEs1,0
1760 RETURN
!------------------------------------------------------------------------------
!-   Game screen
2000 j$="!!!!!!!!!!!!!!!!!!!!!!"
2010 k$="{white}{arrow left} {arrow left} {arrow left} {arrow left} {arrow left} {arrow left} {arrow left} {arrow left} {arrow left} {arrow left} {arrow left}"
2020 PRINT"{clear}{white}sc";sc;"{home}{right*8}hi";hi
2040 PRINT"{green}"j$"!!! !!!! !!!! !!!! !!!";
2050 PRINT"{down*9}"j$;j$;
2060 PRINT"{down}"k$
2070 PRINT"{down}"k$
2080 PRINT"{down}"k$
2090 PRINT"{down}{green}"j$;left$(j$,21);"{left}{148}!";
2100 FORi=1TO3
2110 IFnp%(i)>0THENPOKEsm+44+np%(i),27:POKEcm+44+np%(i),3
2120 NEXT
2130 IFfr>1THENFORi=1TOfr-1:POKEsm+483+i,28:POKEcm+483+i,5:NEXT
!--- Clear keyboard buffer
2140 GETk$:IFk$<>""GOTO2140
2190 RETURN
!------------------------------------------------------------------------------
!-  Declare/define the main strings
3000 a$="%&&&'%&&' %&&&'%&&' %&&&'%&&' %&&&"
3010 b$="###$ ##$  ###$ ##$  ###$ ##$  ###$"
3020 c$="]]]  ]]   ]]]  ]]   ]]]  ]]   ]]] "
3030 d$="^^^  ^^   ^^^  ^^   ^^^  ^^   ^^^ "
3050 e$="*+, *+,   *+, *+,   *+, *+,   *+, "
3060 f$="()  ()    ()  ()    ()  ()    ()  "
3070 g$="<!;:      <!;:      <!;:      <!;:"
3080 h$=" =!-       =!-       =!-       =!-"
3190 RETURN
