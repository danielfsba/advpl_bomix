#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篜rograma  矲ESTR002  篈utor  ? CHRISTIAN ROCHA      ? Data ? DEZ/2012  罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ? Impress鉶 da Ordem de Produ玢o II						  罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? SIGAFAT - Faturamento                                      罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
*/

User Function FESTR002

Private c_Titulo := "ORDEM DE PRODU敲O"
Private c_Data   := dtoc(DDATABASE)
Private c_Hora   := Time()
Private c_Qry    := ''

CriaPerg("FESTR002")

If !(Pergunte("FESTR002",.T.))
	Return
EndIf

RptStatus({|| ImpRel()},c_titulo)

Return

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篜rograma  矷MPREL    篈utor  矯HRISTIAN ROCHA     ? Data ?   DEZ/2012  罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矲uncao que imprime o relatorio                              罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? SIGAEST                                                    罕?
北掏屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北?                     A L T E R A C O E S                               罕?
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篋ata      篜rogramador       篈lteracoes                               罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
*/

Static Function ImpRel()     
	//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
	Private oFont01n	:= TFont():New( "Arial",,18,,.T.,,,,,.F.,.F.) 
	Private oFont02		:= TFont():New( "Arial",,12,,.F.,,,,,.F.,.F.) 
	Private oFont02i	:= TFont():New( "Arial",,12,,.F.,,,,,.F.,.T.)
	Private oFont03		:= TFont():New( "Arial",,14,,.F.,,,,,.F.,.F.)
	Private oFont03n	:= TFont():New( "Arial",,14,,.T.,,,,,.F.,.F.)
	Private oFont04		:= TFont():New( "Arial",,08,,.F.,,,,,.F.,.F.) 
	Private oFont05		:= TFont():New( "Arial",,10,,.F.,,,,,.F.,.F.) 

	Private c_BitMap 	:= "\system\lgrl01.bmp"
	Private n_Lin
	Private n_QuantP	:= 0
	Private n_Pag		:= 1
	Private L			:= 1
	Private n_TotPag	:= 1 //Total de Paginas
	Private l_Rodape    := .F.

	f_Qry()    //Chama a fun玢o para gerar a query
		
	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()

	If Eof()
		Alert("Nenhum registro encontrado.")
		QRY->(dbCloseArea())
		Return
	End If

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砅ara contar a quantidade de paginas, tive que imprimir os dados no relatorio, excluir o objeto?
	//硂Prn, recri?-lo e imprimir tudo novamente.                                                    ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	For L := 1 TO 2
		oPrn := TMSPrinter():New("ORDEM DE PRODU敲O")
		oPrn:SetPortrait()  

	 	If L == 2
			oPrn:Setup()
	 	EndIf
	
		oPrn:StartPage()
		dbGoTop()

		While !Eof()
			c_NumOp := QRY->(C2_NUM + C2_ITEM + C2_SEQUEN)
			c_Desc  := QRY->B1_DESC
			
			ImpCabec() //Imprime o cabecalho	

			If L == 2
				oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)  
			EndIf

			QRY->(dbSkip())
			
			If !Eof() .And. QRY->(C2_NUM + C2_ITEM + C2_SEQUEN) <> c_NumOp
				oPrn:EndPage()
				n_Pag++
			Endif
		End

		If L == 2
			oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)
		EndIf
		
		oPrn:EndPage()

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//矨qui eu reincio as variaveis e guardo a quantidade de paginas.?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If L == 1                                                              
			n_TotPag	:= n_Pag
			n_Pag		:= 1
			oPrn:ResetPrinter()  //Exclui o objeto e reinicia suas propriedades.
			oPrn:End()
		Else
			oPrn:Preview()
		EndIf
	Next
	
	QRY->(dbCloseArea())
	
Return

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篜rograma  矷MPCABEC  篈utor  ? CHRISTIAN ROCHA    ? Data   ? DEZ/2012  罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矯abecalho da Ordem de Produ玢o                              罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? SIGAFAT                                                    罕?
北掏屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北?                     A L T E R A C O E S                               罕?
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篋ata      篜rogramador       篈lteracoes                               罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
*/

Static Function ImpCabec()     

oPrn:SayBitmap( 100,100,c_BitMap,540,150)
oPrn:Say(100,1000, "DATA DE CONTROLE:" ,oFont02,100)
oPrn:Say(200,800, "ORDEM DE PRODU敲O N? " + c_NumOp	,oFont01n,100)
oPrn:Say(100,1830, "P醙ina",oFont02,100)
oPrn:Say(150,1830, "Data:   " + c_Data + "   " + c_Hora,oFont02,100) 

oPrn:Line( 275,100,275,2350 )

oPrn:Say(300, 100, "Produto: " ,oFont02i,100)  
oPrn:Say(300, 280, AllTrim(QRY->C2_PRODUTO) + " - "	+ MemoLine(c_Desc,50,1),oFont02,100)  
oPrn:Say(350, 280, MemoLine(c_Desc,50,2),oFont02,100)  

oPrn:Say(300, 1770,"Quantidade: "	,oFont02i,100)  
oPrn:Say(300, 2010,AllTrim(Transform(QRY->C2_QUANT, "@E 999,999,999"))	,oFont02,100)  

oPrn:Say(400, 100, "Recurso: "	,oFont02i,100)
oPrn:Say(400, 280, IIF(Empty(QRY->C2_RECURSO), AllTrim(QRY->G2_RECURSO), AllTrim(QRY->C2_RECURSO)) + " - "	+ AllTrim(QRY->H1_DESCRI),oFont02,100)
oPrn:Say(350, 1770, "Saldo ? Produzir:",oFont02i,100)
oPrn:Say(350, 2100, AllTrim(Transform(QRY->C2_QUANT - QRY->C2_QUJE, "@E 999,999,999")),oFont02,100)
oPrn:Say(400 ,1770,"Qtd por Embalagem: "		,oFont02i,100)
oPrn:Say(400 ,2170,AllTrim(Transform(QRY->C2_FSQTDPE, "@E 999,999,999"))	,oFont02,100)

oPrn:Say(450, 100, "Ferramenta: "	,oFont02i,100)
oPrn:Say(450, 340, AllTrim(QRY->G2_FERRAM) + " - "	+ QRY->H4_DESCRI,oFont02,100)
oPrn:Say(450, 1300, "Opera玢o: ",oFont02i,100)
oPrn:Say(450, 1510, AllTrim(QRY->G2_OPERAC) + " - " + QRY->G2_DESCRI,oFont02,100)

oPrn:Line( 500,100,500,2350 )

oPrn:Say(510 ,100 , "PRODU敲O:"				,oFont03n,100)
oPrn:Say(510 ,410 , "TURNO: _____"	,oFont05,100)
oPrn:Say(510 ,730 , "DATA: ___/ ___/ _____ "	,oFont05,100)
oPrn:Say(510 ,1720, "DOSAGENS MASTER:  _____"	,oFont05,100)

oPrn:Say(560 ,100, "IN虲IO: ___/ ___/ _____   ___:___"							,oFont05,100)
oPrn:Say(610 ,100, "CONTADOR IN虲IO: __________"							,oFont05,100)
oPrn:Say(560 ,1720, "TEMPO DE CICLO:   _____"	,oFont05,100)

oPrn:Say(560 ,730, "FINAL : ___/ ___/ _____   ___:___"							,oFont05,100)
oPrn:Say(610 ,730, "CONTADOR FINAL : __________=__________"							,oFont05,100)
oPrn:Say(610 ,1720, "TOTAL BORRA (Kg): _____"	,oFont05,100)

oPrn:Line( 675,100,675,1100 )	//Linha horizontal 1
oPrn:Line( 750,100,750,1100 )   //Linha horizontal 2
oPrn:Line( 825,100,825,1100 )	//Linha horizontal 3

oPrn:Line( 675,100,825,100 )	//Linha vertical 1
oPrn:Line( 675,200,825,200 )   	//Linha vertical 2
oPrn:Line( 675,500,825,500 )	//Linha vertical 3
oPrn:Line( 675,800,825,800 )	//Linha vertical 4
oPrn:Line( 675,1100,825,1100 )	//Linha vertical 5

oPrn:Say(675 ,300, "A"							,oFont02,100)
oPrn:Say(675 ,600, "C"							,oFont02,100)
oPrn:Say(675 ,900, "D"	,oFont02,100)

oPrn:Say(750 ,100, " Qtd."	,oFont02,100)

oPrn:Line( 675,1450,675,1650 )	//Linha horizontal 1
oPrn:Line( 750,1450,750,1650 )  //Linha horizontal 2
oPrn:Line( 825,1450,825,1650 )	//Linha horizontal 3

oPrn:Line( 675,1450,825,1450 )	//Linha vertical 1
oPrn:Line( 675,1650,825,1650 )  //Linha vertical 2

oPrn:Say(675 ,1450, "  TOTAL"							,oFont02,100)

oPrn:Line( 675,1720,675,1970 )	//Linha horizontal 1
oPrn:Line( 750,1720,750,1970 )  //Linha horizontal 2
oPrn:Line( 825,1720,825,1970 )	//Linha horizontal 3

oPrn:Line( 675,1720,825,1720 )	//Linha vertical 1
oPrn:Line( 675,1970,825,1970 ) 	//Linha vertical 2

oPrn:Say(675 ,1720, "  PESO (D)"							,oFont02,100)

oPrn:Line( 850,100,850,2350 )

oPrn:Say(875,100, "VERIFICA钦ES"	,oFont03n,100)				//VERIFICA钦ES

oPrn:Say(925,100, "N韛el do Lubrificante: ( )Alto   ( )Normal   ( )Baixo                  M醧uina: ( )Limpa   ( )Suja                  Mat閞ia Prima: ( )OK",oFont02,100)

oPrn:Line( 1025,100,1025,2350 )

oPrn:Say(1025 ,100, "M罳UINA PARADA"	,oFont03n,100)
oPrn:Say(1075 ,100, " Hora Parada"		,oFont04,100)
oPrn:Say(1075 ,340, " Hora Retorno"	,oFont04,100)
oPrn:Say(1075 ,590, " Motivo"		,oFont04,100)

For i:=1125 To 1275 Step 50
	oPrn:Line(i,100,i,2350 )
	oPrn:Say(i ,600, "( )Manuten玢o     ( )Troca Molde     ( )Desligada     ( )Outros (Descrever em Observa玢o)"		,oFont04,100)
Next i

oPrn:Line(1075,100,1075,2350 )		//Linha horizontal 1
oPrn:Line(1325,100,1325,2350 )		//Linha horizontal 2
oPrn:Line(1075,100,1325,100 )		//Linha vertical 1
oPrn:Line(1075,340,1325,340 )		//Linha vertical 2
oPrn:Line(1075,590,1325,590 )		//Linha vertical 3
oPrn:Line(1075,2350,1325,2350 )		//Linha vertical 4

oPrn:Say(1350 ,100, "MAT蒖IA PRIMA"	,oFont03n,100)
oPrn:Say(1400 ,100, "   Descri玢o"		,oFont02,100)
oPrn:Say(1400 ,1200, "Lote 01"		,oFont02,100)
oPrn:Say(1400 ,1500, "Lote 02"		,oFont02,100)
oPrn:Say(1400 ,1800, "Lote 03"		,oFont02,100)
oPrn:Say(1400 ,2100, "Lote 04"		,oFont02,100)

oPrn:Line(1400,100,1775,100 )		//Linha vertical 1
oPrn:Line(1400,1190,1775,1190 )		//Linha vertical 2
oPrn:Line(1400,1490,1775,1490 )		//Linha vertical 3
oPrn:Line(1400,1790,1775,1790 )		//Linha vertical 4
oPrn:Line(1400,2090,1775,2090 )		//Linha vertical 5
oPrn:Line(1400,2350,1775,2350 )		//Linha vertical 6

oPrn:Line(1400,100,1400,2350 )		//Linha horizontal 1

For i:=1400 To 1775 Step 75
	oPrn:Line(i,100,i,2350 )
Next i

oPrn:Say(1800 ,100, "OBSERVA敲O:"	,oFont03n,100)

oPrn:Line(2050,100,2050,2350 )

oPrn:Say(2100 ,300 , "_____________________"						,oFont02,100)
oPrn:Say(2100 ,1000 , "_____________________"						,oFont02,100)
oPrn:Say(2100 ,1700, "_____________________"						,oFont02,100)
oPrn:Say(2150 ,300 , "Auxiliar de Produ玢o"	,oFont02,100)
oPrn:Say(2150 ,1000 , "Encarregado Produ玢o"	,oFont02,100)
oPrn:Say(2150 ,1700, "Respons醰el Produ玢o"	,oFont02,100)

oPrn:Line(2225,100,2225,2350 )

oPrn:Say(2275,100 , "CONTROLE DE QUALIDADE"						,oFont03n,100)
oPrn:Say(2325,100 , "AN罫ISE VISUAL:",oFont02i,100)

oPrn:Say(2375,100 , "Colora玢o/Inspe玢o em Linha: ( )Homog阯ea   ( )N鉶 Homog阯ea"		,oFont04,100)
oPrn:Say(2425,100 , "Manchas/Inspe玢o em Linha:   ( )Aus阯cia       ( )Presen鏰"				,oFont04,100)
oPrn:Say(2475,100 , "Poeira/Inspe玢o em Linha:       ( )Aus阯cia       ( )Presen鏰"			,oFont04,100)
oPrn:Say(2525,100 , "Rebarbas/Inspe玢o em Linha:  ( )Muitas      ( )Nenhuma         ( )Poucas"	,oFont04,100)

oPrn:Say(2600,100 , "MEDIDAS:",oFont02i,100)

If "TAMPA" $ c_Desc
	oPrn:Say(2650,100 , "Comprimento:" + cvaltochar(QRY->BM_FSCTAMP) + "mm     +/- " + cvaltochar(QRY->BM_FSVCTAM) + "mm",oFont04,100)
	oPrn:Say(2700,100 , "Espessura:" + cvaltochar(QRY->BM_FSETAMP) + "mm     +/- " + cvaltochar(QRY->BM_FSVETAM) + "mm",oFont04,100)
	oPrn:Say(2750,100 , "Largura:" + cvaltochar(QRY->BM_FSLTAMP) + "mm     +/- " + cvaltochar(QRY->BM_FSVLTAM) + "mm",oFont04,100)
	oPrn:Say(2800,100 , "Peso:" + cvaltochar(QRY->BM_FSPTAMP) + "g     +/- " + cvaltochar(QRY->BM_FSVPTAM) + "g",oFont04,100)
Else
	oPrn:Say(2650,100 , "Altura do Balde: " + cvaltochar(QRY->BM_FSALTB) + "mm     +/- "+ cvaltochar(QRY->BM_FSVALTB) + "mm",oFont04,100)
	oPrn:Say(2700,100 , "Di鈓etro do Fundo do Balde: " + cvaltochar(QRY->BM_FSDFUNB) + "mm     +/- "+ cvaltochar(QRY->BM_FSVDFB) + "mm",oFont04,100)
	oPrn:Say(2750,100 , "Di鈓etro Externo da Boca do Balde (A): " + cvaltochar(QRY->BM_FSDEBB) + "mm     +/- "+ cvaltochar(QRY->BM_FSVDEBB) + "mm",oFont04,100)
	oPrn:Say(2800,100 , "Di鈓etro Externo M醲imo: " + cvaltochar(QRY->BM_FSDEMB) + "mm     +/- "+ cvaltochar(QRY->BM_FSVDEMB) + "mm",oFont04,100)
	oPrn:Say(2850,100 , "Di鈓etro Interno da Boca do Balde (B): " + cvaltochar(QRY->BM_FSDIBB) + "mm     +/- "+ cvaltochar(QRY->BM_FSVDIBB) + "mm",oFont04,100)
	oPrn:Say(2900,100 , "Espessura da Parede Lateral do Balde: " + cvaltochar(QRY->BM_FSEPLB) + "mm     +/- "+ cvaltochar(QRY->BM_FSVEPLB) + "mm",oFont04,100)
	oPrn:Say(2950,100 , "Peso do Balde sem Al鏰: " + cvaltochar(QRY->BM_FSPESOB) + "g     +/- "+ cvaltochar(QRY->BM_FSVPESB) + "g",oFont04,100)
	oPrn:Say(3000,100 , "Volume Nominal: " + cvaltochar(QRY->BM_FSVNB) + "ml     +/- "+ cvaltochar(QRY->BM_FSVVN) + "ml",oFont04,100)
	oPrn:Say(3050,100 , "Volume Real: " + cvaltochar(QRY->BM_FSVRB) + "ml     +/- "+ cvaltochar(QRY->BM_FSVVR) + "ml",oFont04,100)
	oPrn:Say(3100,100 , "Volume Total: " + cvaltochar(QRY->BM_FSVTB) + "ml     +/- "+ cvaltochar(QRY->BM_FSVVT) + "ml",oFont04,100)
Endif

oPrn:Say(3050,600 , "_____________________",oFont02,100)
oPrn:Say(3100,600 , "Conferido/Encarregado",oFont02,100)

oPrn:Say(2275,1180 , " HORA"		,oFont04,100)
oPrn:Say(2275,1320 , " PESO I"				,oFont04,100)
oPrn:Say(2275,1460 , " PESO II"			,oFont04,100)
oPrn:Say(2275,1600 , " CICLO"	,oFont04,100)

oPrn:Say(2275,1790 , " HORA"		,oFont04,100)
oPrn:Say(2275,1930 , " PESO I"				,oFont04,100)
oPrn:Say(2275,2070 , " PESO II"			,oFont04,100)
oPrn:Say(2275,2210 , " CICLO"	,oFont04,100)

For i:= 2275 To 2815 Step 60
	oPrn:Line(i,1180,i,1740 )
	oPrn:Line(i,1790,i,2350 )
Next i

oPrn:Line(2275,1180,2815,1180 ) //Linha Vertical 1
oPrn:Line(2275,1320,2815,1320 ) //Linha Vertical 2
oPrn:Line(2275,1460,2815,1460 ) //Linha Vertical 3
oPrn:Line(2275,1600,2815,1600 ) //Linha Vertical 4
oPrn:Line(2275,1740,2815,1740 ) //Linha Vertical 5

oPrn:Line(2275,1790,2815,1790 ) //Linha Vertical 6
oPrn:Line(2275,1930,2815,1930 ) //Linha Vertical 7
oPrn:Line(2275,2070,2815,2070 ) //Linha Vertical 8
oPrn:Line(2275,2210,2815,2210 ) //Linha Vertical 9
oPrn:Line(2275,2350,2815,2350 ) //Linha Vertical 10

oPrn:Say(2865,1230 , "Inje玢o/Sopro:"		,oFont04,100)
oPrn:Say(2865,1460 , "CLASSE A = Produtos Conforme Amostra"		,oFont04,100)
oPrn:Say(2915,1460 , "CLASSE C = Produtos N鉶 Conforme"				,oFont04,100)
oPrn:Say(2965,1460 , "CLASSE D = Falha Inje玢o, Amassados ou Furados"			,oFont04,100)

Return

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篜rograma  砅ULAPAG   篈utor  矯HRISTIAN ROCHA     ? Data ? Abril/2011  罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矲uncao responsavel por gerar nova pagina e imprimir as      罕?
北?          砳nformacoes restantes.                                      罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? SIGAFAT                                                    罕?
北掏屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北?                     A L T E R A C O E S                               罕?
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篋ata      篜rogramador       篈lteracoes                               罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
*/

Static Function PulaPag

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砈o deve imprimir o total de paginas quando for a 2 vez?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If L == 2
		oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)  
	EndIf

	oPrn:EndPage()
	n_Pag++

	oPrn:StartPage()

Return

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篜rograma  矯riaPerg  篈utor  矯HRISTIAN ROCHA     ? Data ? Abril/2011  罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矲uncao responsavel imprimir a observacao do orcamento confor罕?
北?          砿e a largura da pagina.                                     罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? SIGAEST/SIGAPCP                                            罕?
北掏屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北?                     A L T E R A C O E S                               罕?
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篋ata      篜rogramador       篈lteracoes                               罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
*/

Static Function CriaPerg(c_Perg)

//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c_Perg,"01","Ord. Produ玢o de ?"   ,"","","mv_ch1","C",11,0,0,"G","","SC2","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(c_Perg,"02","Ord. Produ玢o at? ?"  ,"","","mv_ch2","C",11,0,0,"G","","SC2","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(c_Perg,"03","Recurso ?"   	  ,"","","mv_ch3","C",06,0,0,"G","","SH4","","","mv_par03","","","","","","","","","","","","","","","","")

Return()

Static Function f_Qry()

c_Qry := " SELECT * FROM " + RetSqlName("SC2") + " SC2 " + chr(13)
c_Qry += " JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " JOIN " + RetSqlName("SBM") + " SBM ON BM_GRUPO = B1_GRUPO AND BM_FILIAL = '" + XFILIAL("SBM") + "' AND SBM.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " LEFT JOIN " + RetSqlName("SG2") + " SG2 ON (G2_CODIGO = C2_ROTEIRO OR G2_RECURSO = C2_RECURSO) AND G2_FILIAL = '" + XFILIAL("SG2") + "' AND G2_PRODUTO = B1_COD AND SG2.D_E_L_E_T_<>'*' " + chr(13)
If Empty(MV_PAR03)
	c_Qry += " LEFT JOIN " + RetSqlName("SH1") + " SH1 ON (H1_CODIGO = C2_RECURSO OR H1_CODIGO = G2_RECURSO) AND H1_FILIAL = '" + XFILIAL("SH1") + "' AND SH1.D_E_L_E_T_<>'*' " + chr(13)
Else
	c_Qry += " JOIN " + RetSqlName("SH1") + " SH1 ON (H1_CODIGO = C2_RECURSO OR H1_CODIGO = G2_RECURSO) AND H1_FILIAL = '" + XFILIAL("SH1") + "' AND SH1.D_E_L_E_T_<>'*' " + chr(13)
	c_Qry += " AND H1_CODIGO = '" + MV_PAR03 + "' " + chr(13)
Endif
c_Qry += " LEFT JOIN " + RetSqlName("SH4") + " SH4 ON H4_CODIGO = G2_FERRAM AND H4_FILIAL = '" + XFILIAL("SH4") + "' AND SH4.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " WHERE (C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') AND (SC2.D_E_L_E_T_<>'*') " + chr(13)
c_Qry += " AND (C2_STATUS <> 'U') AND (C2_QUJE < C2_QUANT) AND (C2_TPOP = 'F') AND (C2_DATRF = '') AND C2_FILIAL = '" + XFILIAL("SC2") + "' " + chr(13)
c_Qry += " ORDER BY C2_NUM "

MemoWrit("C:\TEMP\FESTR002.SQL",c_Qry)

Return c_Qry