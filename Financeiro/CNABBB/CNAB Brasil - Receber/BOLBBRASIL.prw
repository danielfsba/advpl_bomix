#INCLUDE "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � BOLBBRASIL												  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO BANCO BRASIL COM CODIGO DE BARRAS      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BOLBBRASIL()

LOCAL	aPergs := {} 
PRIVATE lExec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''

Tamanho  := "M"
titulo   := "Impressao de Boleto do Banco do Brasil"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras do Banco do Brasil."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLBBRASIL"
lEnd     := .F.
cPerg     :="BOLBBRASIL"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0    

cCart   := "17"  //Numero da Carteira

dbSelectArea("SE1")

Aadd(aPergs,{"Banco         ?","","","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})
Aadd(aPergs,{"Agencia       ?","","","mv_ch2","C",05,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Conta         ?","","","mv_ch3","C",10,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Sub Conta     ?","","","mv_ch4","C",03,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Prefixo       ?","","","mv_ch5","C",03,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate o Prefixo ?","","","mv_ch6","C",03,0,0,"G","","MV_PAR06","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Titulo     ?","","","mv_ch7","C",09,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate o Titulo  ?","","","mv_ch8","C",09,0,0,"G","","MV_PAR08","","","","ZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bordero    ?","","","mv_ch9","C",06,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bordero   ?","","","mv_cha","C",06,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Sobrepoe N.Num?","","","mv_chb","N",01,0,2,"C","","MV_PAR11","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento?","","","mv_chc","D",08,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
Aadd(aPergs,{"Ate Vencimento?","","","mv_chd","D",08,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//AjustaSx1("BOLBBRASIL",aPergs)

Pergunte (cPerg,.F.)

Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif


cIndexName	:= Criatrab(Nil,.F.)
//cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)+E1_PORTADO+E1_CLIENTE"
cFilter		+= "E1_FILIAL='"+xFilial("SE1")+"' .And. (E1_SALDO>0 .Or. E1_SITUACA='2') .And. " //Tem saldo ou em cobranca descontada
//cFilter		+= "E1_PORTADO='"+MV_PAR01+"' .And. "// .And." E1_AGEDEP='"+MV_PAR02+"' .And. "
//cFilter		+= "E1_CONTA='"+MV_PAR03+"' .And."
cFilter		+= "E1_PREFIXO>='"+MV_PAR05+"' .And. E1_PREFIXO<='"+MV_PAR06+"' .And. " 
cFilter		+= "E1_NUM>='"+MV_PAR07+ "' .And. E1_NUM<='"+MV_PAR08+"' .And. "
cFilter		+= "E1_NUMBOR>='"+MV_PAR09+"' .And. E1_NUMBOR<='"+MV_PAR10+"' .And. "
cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(MV_PAR12)+"'.and.DTOS(E1_VENCREA)<='"+DTOS(MV_PAR13)+"'.And." 
//cFilter		+= "E1_NUMBOR='      ' .and. " 
cFilter		+= "(E1_TIPO='NF' .Or. E1_TIPO='BOL' .Or. E1_TIPO='DP' .Or. E1_TIPO='FT')"

If !Empty(MV_PAR01)
	cFilter		+= ".And. (E1_PORTADO=='" + MV_PAR01 + "'  .Or. Empty(E1_PORTADO))"
Endif

If !Empty(MV_PAR02)
	cFilter		+= ".And. (E1_AGEDEP=='" + MV_PAR02 + "' .Or. Empty(E1_AGEDEP)) "
Endif

If !Empty(MV_PAR03)
	cFilter		+= ".And. (E1_CONTA=='" + MV_PAR03 + "' .Or. Empty(E1_CONTA)) "
Endif

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()
@ 001,001 TO 400,700 DIALOG oDlg TITLE "Sele��o de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
	
dbGoTop()
If lExec
	Processa({|lEnd|MontaRel()})
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MontaRel� Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS			     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaRel()
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "
LOCAL aDadosEmp    := {	ALLTRIM(SM0->M0_NOMECOM)                                    ,; //[1]Nome da Empresa
								ALLTRIM(SM0->M0_ENDCOB)                                     ,; //[2]Endere�o
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
								"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
								Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat		:= 0

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova p�gina

dbSelectArea("SE1")
SE1->(dbGoTop())
ProcRegua(RecCount())
Do While SE1->(!EOF())
	If Marked("E1_OK")  // Imprime apenas os que foram marcado para impress�o 
		If Empty(MV_PAR01)
			//Posiciona o SA6 (Bancos)
			DbSelectArea("SA6")
			DbSetOrder(1)                                    
			If DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)) == .F.
				ShowHelpDlg(SM0->M0_NOME,;
					{"Banco/Ag�ncia/Conta inv�lido."},5,;
					{"Verifique se os par�metros est�o preenchidos corretamente."},5)
				Return
			Endif

			//Posiciona na Arq de Parametros CNAB
			DbSelectArea("SEE")
			DbSetOrder(1)
			If DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)+MV_PAR04) == .F.
				ShowHelpDlg(SM0->M0_NOME,;
					{"Par�metros de Banco do Banco/Ag�ncia/Conta/Sub-Conta inv�lido."},5,;
					{"Verifique se os par�metros est�o preenchidos corretamente."},5)
				Return
			Endif
		Else
			//Posiciona o SA6 (Bancos)
			DbSelectArea("SA6")
			DbSetOrder(1)
			If DbSeek(xFilial("SA6")+MV_PAR01+MV_PAR02+MV_PAR03) == .F.
				ShowHelpDlg(SM0->M0_NOME,;
					{"Banco/Ag�ncia/Conta inv�lido."},5,;
					{"Verifique se os par�metros est�o preenchidos corretamente."},5)
				Return
			Endif

			//Posiciona na Arq de Parametros CNAB
			DbSelectArea("SEE")
			DbSetOrder(1)
			If DbSeek(xFilial("SEE")+MV_PAR01+MV_PAR02+MV_PAR03+MV_PAR04) == .F.
				ShowHelpDlg(SM0->M0_NOME,;
					{"Par�metros de Banco do Banco/Ag�ncia/Conta/Sub-Conta inv�lido."},5,;
					{"Verifique se os par�metros est�o preenchidos corretamente."},5)
				Return
			Endif
		Endif

		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)      	
		DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
		DbSelectArea("SE1")
	/*
		aDadosBanco  := {  "001" ,;                   //SA6->A6_COD 					// [1]Numero do Banco
								"BANCO DO BRASIL S/A" ,;  //SA6->A6_NREDUZ              // [2]Nome do Banco
		                  SUBSTR(SA6->A6_AGENCIA, 1, 4)                        ,; 		// [3]Ag�ncia
	                      AllTrim(SA6->A6_NUMCON),; 	                                // [4]Conta Corrente
	                      Alltrim(SA6->A6_DVCTA),; 	// 								// [5]D�gito da conta corrente
	                      Alltrim(cCart)                             	 ,;		// [6]Codigo da Carteira
	                      AllTrim(SA6->A6_DVAGE)	}		// [7]Digito da agencia
	*/
		aDadosBanco  := { SA6->A6_COD,; 		  										// [1]Numero do Banco
						  SA6->A6_NREDUZ,;		    	    	      					// [2]Nome do Banco
		                  SUBSTR(SA6->A6_AGENCIA, 1, 4),; 								// [3]Ag�ncia
	                      AllTrim(SA6->A6_NUMCON),; 	                                // [4]Conta Corrente
	                      Alltrim(SA6->A6_DVCTA),; 	 									// [5]D�gito da conta corrente
	                      Alltrim(cCart),;												// [6]Codigo da Carteira
	                      AllTrim(SA6->A6_DVAGE)	}									// [7]Digito da agencia    
	 	
		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      		// [1]Raz�o Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      		// [2]C�digo
			AllTrim(SA1->A1_END )+" - "+AllTrim(SA1->A1_BAIRRO),;      		// [3]Endere�o
			AllTrim(SA1->A1_MUN )                            ,;  			// [4]Cidade
			SA1->A1_EST                                      ,;     		// [5]Estado
			Subs(SA1->A1_CEP,1,5)+"-"+Subs(SA1->A1_CEP,6,3)  ,;      		// [6]CEP
			SA1->A1_CGC										          ,;  	// [7]CGC
			SA1->A1_PESSOA										}       	// [8]PESSOA
		Else          
			aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   				// [1]Raz�o Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   				// [2]C�digo
			AllTrim(SA1->A1_ENDCOB)+" - "+AllTrim(SA1->A1_BAIRROC),;   				// [3]Endere�o
			AllTrim(SA1->A1_MUNC)	                             ,;   				// [4]Cidade
			SA1->A1_ESTC	                                     ,;   				// [5]Estado
			Subs(SA1->A1_CEPC,1,5)+"-"+Subs(SA1->A1_CEPC,6,3)  ,;      				// [6]CEP
			SA1->A1_CGC												 		 ,;		// [7]CGC
			SA1->A1_PESSOA												 }			// [8]PESSOA
		Endif
		
		nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
		cNroDoc	:= STRZERO(Val(cNroDoc),11)
	
		//Monta codigo de barras
		aCB_RN_NN    :=Ret_cBarra(	SE1->E1_PREFIXO	,SE1->E1_NUM	,SE1->E1_PARCELA	,SE1->E1_TIPO	,;
							Subs(aDadosBanco[1],1,3)	,aDadosBanco[3]	,aDadosBanco[4] ,aDadosBanco[5]	,;
							cNroDoc		,(IF(E1_SITUACA='2',E1_VALOR,E1_SALDO)-nVlrAbat)	, Alltrim(cCart)	,"9"	)
	                          
	    
		DbSelectArea("SE1")
		If Empty(E1_PARCELA)		 
	    	NumTit := AllTrim(E1_NUM)
		Else                     
		    NumTit := AllTrim(E1_NUM)+"-"+AllTrim(E1_PARCELA)
	    Endif
	
		aDadosTit	:= {NumTit														,;  // [1] N�mero do t�tulo
							E1_EMISSAO                              				,;  // [2] Data da emiss�o do t�tulo
							dDataBase                    							,;  // [3] Data da emiss�o do boleto
							E1_VENCTO                               				,;  // [4] Data do vencimento
							(IF(E1_SITUACA='2',E1_VALOR,E1_SALDO) - nVlrAbat)       ,;  // [5] Valor do t�tulo
							aCB_RN_NN[3]											,;  // [6] Nosso n�mero (Ver f�rmula para calculo)
							E1_PREFIXO                               				,;  // [7] Prefixo da NF
							E1_TIPO	                                 				,;  // [8] Tipo do Titulo
							aCB_RN_NN[4]                       						}   // [9] Digito verificar do nosso numero
		
		If Marked("E1_OK")
			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aCB_RN_NN)
			nX := nX + 1
		EndIf
	Endif	

	dbSelectArea("SE1")
	SE1->(dbSkip())
	IncProc()
	nI := nI + 1
EndDo

oPrint:EndPage()     // Finaliza a p�gina
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  Impress � Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aCB_RN_NN)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16  := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova p�gina

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 0
 
oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-9",oFont16 )		// [1]Numero do Banco

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0150,100 ,"Cedente",oFont8)
oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0150,1060,"Ag�ncia/C�digo Cedente",oFont8)
oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0200,1510,aDadosTit[1],oFont10) //Numero+Parcela

oPrint:Say  (nRow1+0250,100 ,"Sacado",oFont8)
oPrint:Say  (nRow1+0300,100 ,aDatSacado[1],oFont10)				//Nome

oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/t�tulo",oFont10)
oPrint:Say  (nRow1+0450,0100,"com as caracter�sticas acima.",oFont10)
oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (nRow1+0245,1910,"(  )N�o existe n� indicado"                  	,oFont8)
oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0325,1910,"(  )N�o procurado"                              ,oFont8)
oPrint:Say  (nRow1+0365,1910,"(  )Endere�o insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)
           

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0

//Pontilhado separador
For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
Next nI

oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont9 )		// [2]Nome do Banco
oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-9",oFont16 )	// [1]Numero do Banco
oPrint:Say  (nRow2+0644,1800,"Recibo do Sacado",oFont10)

oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0750,100 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO",oFont10)
oPrint:Say  (nRow2+0765,400 ,"",oFont10)

oPrint:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0810,1810,"Ag�ncia/C�digo Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow2+0940,605 ,aDadosTit[1]						,oFont10) //Numero+Parcela

oPrint:Say  (nRow2+0910,1005,"Esp�cie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+0940,1050,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0910,1810,"Nosso N�mero"                                   ,oFont8)
IF EMPTY(SE1->E1_NUMBCO)
	If Empty(aDadosTit[9])
		oPrint:Say  (nRow2+0940,1850,Alltrim(aDadosTit[6]),oFont10)
	Else
		oPrint:Say  (nRow2+0940,1850,Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9]),oFont10)
	Endif
ELSE
	If Empty(aDadosTit[9])
		oPrint:Say  (nRow2+0940,1850,SE1->E1_NUMBCO,oFont10)
	Else
		oPrint:Say  (nRow2+0940,1850,SUBSTR(SE1->E1_NUMBCO,1,LEN(SE1->E1_NUMBCO)-1)+"-"+SUBSTR(SE1->E1_NUMBCO,LEN(SE1->E1_NUMBCO),1),oFont10)
	Endif
ENDIF
oPrint:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6]+"- 019"                         	 ,oFont10)

oPrint:Say  (nRow2+0980,755 ,"Esp�cie"                                        ,oFont8)
oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+1050,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",oFont8)

oPrint:Say  (nRow2+1150,100 ,"APOS O VENCIMENTO COBRAR JUROS DE R$ "+AllTrim(Transform((aDadosTit[5]*0.09)/30,"@E 99,999.99"))+ " AO DIA",oFont10)
oPrint:Say  (nRow2+1250,100 ,"PROTESTAR APOS 3 DIAS DE ATRASO. ",oFont10)

oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow2+1120,1810,"(-)Outras Dedu��es"                             ,oFont8)
oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow2+1260,1810,"(+)Outros Acr�scimos"                           ,oFont8)
oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow2+1400,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow2+1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (nRow2+1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1589,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+1589,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow2+1589,1850,aDadosTit[6]  ,oFont10)

oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow2+1645,1500,"Autentica��o Mec�nica",oFont8)

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 ) 
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 0

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont9 )		// 	[2]Nome do Banco
oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-9",oFont16 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)			//	Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+2040,100 ,"PAG�VEL EM QUALQUER BANCO AT� O VENCIMENTO",oFont10)
oPrint:Say  (nRow3+2055,400 ,"",oFont10)
           
oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+2100,1810,"Ag�ncia/C�digo Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)


oPrint:Say  (nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[1]						,oFont10) //Numero+Parcela

oPrint:Say  (nRow3+2200,1005,"Esp�cie Doc."                                   ,oFont8)
oPrint:Say  (nRow3+2230,1050,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+2230,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+2200,1810,"Nosso N�mero"                                   ,oFont8)
IF EMPTY(SE1->E1_NUMBCO)
	If Empty(aDadosTit[9])
		oPrint:Say  (nRow3+2230,1850,Alltrim(aDadosTit[6]),oFont10)
	Else
		oPrint:Say  (nRow3+2230,1850,Alltrim(aDadosTit[6])+"-"+Alltrim(aDadosTit[9]),oFont10)
	Endif
ELSE
	If Empty(aDadosTit[9])
		oPrint:Say  (nRow3+2230,1850,SE1->E1_NUMBCO,oFont10)
	Else
		oPrint:Say  (nRow3+2230,1850,SUBSTR(SE1->E1_NUMBCO,1,LEN(SE1->E1_NUMBCO)-1)+"-"+SUBSTR(SE1->E1_NUMBCO,LEN(SE1->E1_NUMBCO),1),oFont10)
	Endif
ENDIF
oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]+"- 019"                           ,oFont10)

oPrint:Say  (nRow3+2270,755 ,"Esp�cie"                                        ,oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2340,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",oFont8)
                                                     
oPrint:Say  (nRow2+2490,100 ,"APOS O VENCIMENTO COBRAR JUROS DE R$ "+AllTrim(Transform((aDadosTit[5]*0.09)/30,"@E 99,999.99"))+ " AO DIA",oFont10)
oPrint:Say  (nRow2+2540,100 ,"PROTESTAR APOS 3 DIAS DE ATRASO. ",oFont10)

oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow3+2410,1810,"(-)Outras Dedu��es"                             ,oFont8)
oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+)Outros Acr�scimos"                           ,oFont8)
oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow3+2690,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow3+2753,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2806,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (nRow3+2806,1750,aDadosTit[6]  ,oFont10)

oPrint:Say  (nRow3+2815,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow3+2855,1500,"Autentica��o Mec�nica - Ficha de Compensa��o"                        ,oFont8)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )

oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )
     
MSBAR3("INT25",25,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
//MSBAR("INT25",25.5,1,aCB_RN_NN[1],oPrint,NIL,NIL,.t.,,1.3,NIL,NIL,NIL,.F.)//OK

DbSelectArea("SE1")                         
RecLock("SE1",.F.)
IIF(EMPTY(SE1->E1_NUMBCO), SE1->E1_NUMBCO :=	aCB_RN_NN[3]+aCB_RN_NN[4], SE1->E1_NUMBCO)      
SE1->E1_PORTADO :=	aDadosBanco[1]
SE1->E1_AGEDEP  :=	aDadosBanco[3]
SE1->E1_CONTA   :=	aDadosBanco[4] 
MsUnlock()

oPrint:EndPage() // Finaliza a p�gina
Return Nil
                                 



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RetDados  �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera SE1                        					          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ret_cBarra(	cPrefixo	,cNumero	,cParcela	,cTipo	,;
						cBanco		,cAgencia	,cConta		,cDacCC	,;
						cNroDoc		,nValor		,cCart		,cMoeda	)

Local cNosso		:= ""
Local cDigNosso		:= ""
Local NNUM			:= ""
Local cCampoL		:= ""
Local cFatorValor	:= ""
Local cLivre		:= ""
Local cDigBarra		:= ""
Local cBarra		:= ""
Local cParte1		:= ""
Local cDig1			:= ""
Local cParte2		:= ""
Local cDig2			:= ""
Local cParte3		:= ""
Local cDig3			:= ""
Local cParte4		:= ""
Local cParte5		:= ""
Local cDigital		:= ""
Local aRet			:= {}

If Empty(SE1->E1_NUMBCO) .or. MV_PAR11 = 1	
	If Len(AllTrim(SEE->EE_CODEMP)) == 6		//Conv�nio de 6 posi��es
		NNUM      := Strzero(Val(SEE->EE_FAXATU),5)
	  	cNosso    := Strzero(Val(SEE->EE_CODEMP),6)+NNUM
	  	cDigNosso := U_CALC_di9(cNosso)
	Elseif Len(AllTrim(SEE->EE_CODEMP)) == 7	//Conv�nio de 7 posi��es
		NNUM      := Strzero(Val(SEE->EE_FAXATU),10)
	  	cNosso    := Strzero(Val(SEE->EE_CODEMP),7)+NNUM
	  	cDigNosso := ""
	Endif

  	DbSelectArea("SEE")
  	RecLock("SEE",.F.)
  	SEE->EE_FAXATU:= StrZero(Val(NNUM)+1,10)
  	MsUnlock()  
Else
	If Len(AllTrim(SEE->EE_CODEMP)) == 6		//Conv�nio de 6 posi��es
   		cNosso     := Substr(SE1->E1_NUMBCO,1,Len(Alltrim(SE1->E1_NUMBCO))-1)
   		cDigNosso  := Substr(SE1->E1_NUMBCO,Len(Alltrim(SE1->E1_NUMBCO)),1)
 	Elseif Len(AllTrim(SEE->EE_CODEMP)) == 7	//Conv�nio de 7 posi��es
   		cNosso     := SE1->E1_NUMBCO
   		cDigNosso  := ""
	Endif
Endif

cAgencia:=STRZERO(Val(cAgencia),4)
cConta  :=STRZERO(Val(cConta),8)

If Len(AllTrim(SEE->EE_CODEMP)) == 6		//Conv�nio de 6 posi��es
	cCampoL := cNosso + cAgencia + cConta + cCart
Elseif Len(AllTrim(SEE->EE_CODEMP)) == 7	//Conv�nio de 7 posi��es
	cCampoL := "000000" + cNosso + cCart
Endif	
	
//campo livre do codigo de barra                   // verificar a conta
If nValor > 0
	cFatorValor  := u_fator()+strzero(nValor*100,10)
Else
	cFatorValor  := u_fator()+strzero(SE1->E1_VALOR*100,10)
Endif
	
cLivre := cBanco+cMoeda+cFatorValor+cCampoL
	
// campo do codigo de barra
cDigBarra := U_CALC_5p( cLivre )          
	
cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5,43)
//msgbox(cBarra) //mostra o codigo de barras na tela
	
// composicao da linha digitavel
cParte1  := cBanco+cMoeda
cParte1  := cParte1 + SUBSTR(cCampoL,1,5)
cDig1    := U_DIGIT001( cParte1 )
cParte2  := SUBSTR(cCampoL,6,10)
cDig2    := U_DIGIT001( cParte2 )
cParte3  := SUBSTR(cCampoL,16,10)
cDig3    := U_DIGIT001( cParte3 )
cParte4  := " "+cDigBarra+" "
cParte5  := cFatorValor
	
cDigital := substr(cParte1,1,5)+"."+substr(cparte1,6,4)+cDig1+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,5)+cDig2+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,5)+cDig3+" "+;
			cParte4+;
			cParte5

Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)		
Aadd(aRet,cDigNosso)		

Return aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CALC_di9  �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Para calculo do nosso numero do banco do brasil             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CALC_di9(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
base   := 9
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	If base == 1
		base := 9
	EndIf
	auxi   := Val(SubStr(cBase, idig, 1)) * base
	sumdig := SumDig+auxi
	base   := base - 1
	iDig   := iDig-1
EndDo
auxi := mod(Sumdig,11)
If auxi == 10
	auxi := "X"
Else
	auxi := str(auxi,1,0)
EndIf
Return(auxi)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �DIGIT001  �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Para calculo da linha digitavel do Banco do Brasil          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DIGIT001(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
umdois := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	auxi   := Val(SubStr(cBase, idig, 1)) * umdois
	sumdig := SumDig+If (auxi < 10, auxi, (auxi-9))
	umdois := 3 - umdois
	iDig:=iDig-1
EndDo
cValor:=AllTrim(STR(sumdig,12))


// Pelo pessoal da Microsiga n�o existia a linha abaixo
if sumdig<10
  nDezena=10
else 
  nDezena:=VAL(ALLTRIM(STR(VAL(SUBSTR(cvalor,1,1))+1,12))+"0")
endif
//// Aqui termina as modifica��es
  
auxi := nDezena - sumdig

If auxi >= 10
	auxi := 0
EndIf
Return(str(auxi,1,0))


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �FATOR		�Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do FATOR  de vencimento para linha digitavel.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function Fator()
If Len(ALLTRIM(SUBSTR(DTOC(SE1->E1_VENCTO),7,4))) = 4
	cData := SUBSTR(DTOC(SE1->E1_VENCTO),7,4)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
Else
	cData := "20"+SUBSTR(DTOC(SE1->E1_VENCTO),7,2)+SUBSTR(DTOC(SE1->E1_VENCTO),4,2)+SUBSTR(DTOC(SE1->E1_VENCTO),1,2)
EndIf
cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
//cFator := STR(1000+(SE1->E1_VENCREA-STOD("20000703")),4)
Return(cFator)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CALC_5p   �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do digito do nosso numero do                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CALC_5p(cVariavel)
Local Auxi := 0, sumdig := 0

cbase  := cVariavel
lbase  := LEN(cBase)
base   := 2
sumdig := 0
Auxi   := 0
iDig   := lBase
While iDig >= 1
	If base >= 10
		base := 2
	EndIf
	auxi   := Val(SubStr(cBase, idig, 1)) * base
	sumdig := SumDig+auxi
	base   := base + 1
	iDig   := iDig-1
EndDo
auxi := mod(sumdig,11)
If auxi == 0 .or. auxi == 1 .or. auxi >= 10
	auxi := 1
Else
	auxi := 11 - auxi
EndIf

Return(str(auxi,1,0))




/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSx1    � Autor � Microsiga            	� Data � 13/10/03 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica/cria SX1 a partir de matriz para verificacao          ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                    	  		���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
/*
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next
*/
