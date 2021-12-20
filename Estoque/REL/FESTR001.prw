#INCLUDE "MATR820.CH"
#INCLUDE "FIVEWIN.CH"

Static cAliasTop

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FESTR001 � Autor � Paulo Boschetti       � Data � 07.07.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ordens de Producao                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR820(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function FESTR001()
Local titulo  := STR0039 //"Ordens de Producao"
Local cString := "SC2"
Local wnrel   := "FESTR001"
Local cDesc   := STR0001	//"Este programa ira imprimir a Rela��o das Ordens de Produ��o"
Local aOrd    := {STR0002,STR0003,STR0004,STR0005}	//"Por Numero"###"Por Produto"###"Por Centro de Custo"###"Por Prazo de Entrega"
Local tamanho := "M"

Private aReturn  := {STR0006,1,STR0007, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private cPerg    :="MTR820"
Private nLastKey := 0
Private lItemNeg := .F.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//AjustaSX1()
pergunte("MTR820",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Da OP                                 �
//� mv_par02            // Ate a OP                              �
//� mv_par03            // Da data                               �
//� mv_par04            // Ate a data                            �
//� mv_par05            // Imprime roteiro de operacoes          �
//� mv_par06            // Imprime codigo de barras              �
//� mv_par07            // Imprime Nome Cientifico               �
//� mv_par08            // Imprime Op Encerrada                  �
//� mv_par09            // Impr. por Ordem de                    �
//� mv_par10            // Impr. OP's Firmes, Previstas ou Ambas �
//� mv_par11            // Impr. Item Negativo na Estrutura      �
//� mv_par12            // Imprime Lote/Sub-Lote                 �
//����������������������������������������������������������������
//-- Verifica se o SH8 esta locado para atualizacao por outro processo                
If !IsLockSH8()
	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SETPRINT                        �
	//����������������������������������������������������������������
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,.F.,Tamanho)
	
	lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1
	
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		dbSelectArea("SH8")
		dbClearFilter()
		dbCloseArea()
		dbSelectArea("SC2")
		Return
	Endif
	
	RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

EndIf
	
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R820Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local CbCont,cabec1,cabec2
Local limite     := 80
Local nQuant     := 1
Local nomeprog   := "FESTR001"
Local nPagina	 := 1
Local nTipo      := 18
Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
Local cQtd,i,nBegin
Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2

#IFDEF TOP
	Local bBlockFiltro := {|| .T.}
#ENDIF	

Private aArray   := {}
Private li       := 80

cAliasTop  := "SC2"

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1
//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
cabec1 := ""
cabec2 := ""

dbSelectArea("SC2")

#IFDEF TOP
	cAliasTop := GetNextAlias()
	cQuery := "SELECT SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF, "
	cQuery += "SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE, "
	cQuery += "SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF, "
	cQuery += "SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP, SC2.C2_FSQTDPE, "
	cQuery += "SC2.R_E_C_N_O_  SC2RECNO FROM "+RetSqlName("SC2")+" SC2 WHERE "
	cQuery += "SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
	If	Upper(TcGetDb()) $ 'ORACLE,DB2,POSTGRES,INFORMIX'
		cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD >= '" + mv_par01 + "' AND "
		cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD <= '" + mv_par02 + "' AND "
	Endif
	cQuery += "SC2.C2_DATPRF BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' "
	If mv_par08 == 2
		cQuery += "AND SC2.C2_DATRF = ' '"
	Endif	
	If aReturn[8] == 4
		cQuery += "ORDER BY SC2.C2_FILIAL, SC2.C2_DATPRF"
	Else
		cQuery += "ORDER BY " + SqlOrder(SC2->(IndexKey(aReturn[8])))
	EndIf
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SC2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
	dbSelectArea(cAliasTop)
#ELSE
	If aReturn[8] == 4
		IndRegua("SC2",cIndSC2,"C2_FILIAL+DTOS(C2_DATPRF)",,,STR0008)	//"Selecionando Registros..."
	Else
		dbSetOrder(aReturn[8])
	EndIf
	dbSeek(xFilial("SC2"))
#ENDIF

If ! Empty(aReturn[7])
	bBlockFiltro := &("{|| " + aReturn[7] + "}")
Endif	

SetRegua(SC2->(LastRec()))

While !Eof()
	
	IF lEnd
		@ Prow()+1,001 PSay STR0009	//"CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	

	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial('SC2')+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial('SC2')+mv_par02
		dbSkip()
		Loop
	EndIf   
		
	#IFNDEF TOP		
		If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
			dbSkip()
			Loop
		Endif
		
		If !(Empty(C2_DATRF)) .And. mv_par08 == 2
			dbSkip()
			Loop
		Endif
	#ENDIF

	If !Empty(aReturn[7])
		#IFDEF TOP
			SC2->(dbGoto((cAliasTop)->SC2RECNO))
		#ENDIF	

		If !(SC2->(Eval(bBlockFiltro)))
			(cAliasTop)->(dbSkip())
			Loop                 
		EndIf	
	Endif	

	//-- Valida se a OP deve ser Impressa ou n�o
	If !MtrAValOP(mv_par10,"SC2",cAliasTop)
		dbSkip()
		Loop
	EndIf
	
	cProduto  := C2_PRODUTO
	nQuant    := aSC2Sld(cAliasTop)
	
	dbSelectArea("SB1")
	dbSeek(xFilial()+cProduto)
	
	//��������������������������������������������������������������Ŀ
	//� Adiciona o primeiro elemento da estrutura , ou seja , o Pai  �
	//����������������������������������������������������������������
	AddAr820(nQuant)
	
	MontStruc((cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),nQuant)
	
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	ENDIF
	
	//���������������������������������������������������������Ŀ
	//� Imprime cabecalho                                       �
	//�����������������������������������������������������������
	nPagina := 1
	cabecOp(Tamanho, nPagina)
	
	For I := 2 TO Len(aArray)
		
		@Li,   0 PSay aArray[I][1]    	 				   	// CODIGO PRODUTO
		For nBegin := 1 To Len(Alltrim(aArray[I][2])) Step 31
			@li,031 PSay Substr(aArray[I][2],nBegin,31)
			li++
		Next nBegin
		Li--
		cQtd := Transform(aArray[I][5],PesqPictQt("D4_QUANT",TamSX3("D4_QUANT")[1]))
		@Li ,  (61+14-Len(cQtd))  PSay cQtd					// QUANTIDADE
		@Li ,  76 PSay "|"+aArray[I][4]+"|"			  	// UNIDADE DE MEDIDA
		@li ,  81 PSay aArray[I][6]+"     |"                  	// ALMOXARIFADO
		@li ,  90 PSay Substr(aArray[I][7],1,12)         	// LOCALIZACAO
		@li , 103 PSay "| "+aArray[I][8]                  	// SEQUENCIA
		If mv_par12 == 1
			@li , 109 PSay "| "+aArray[I][10]                  	// LOTE
			@li , 122 PSay "| "+aArray[I][11]                  	// SUB-LOTE
		EndIf
		Li++
		@Li ,  00 PSay __PrtThinLine()
		Li++
		   
		//���������������������������������������������������������Ŀ
		//� Se nao couber, salta para proxima folha              ADMIN   �
		//�����������������������������������������������������������
		IF li > 59
			Li := 0
			nPagina++
			CabecOp(Tamanho, nPagina)		// imprime cabecalho da OP
		EndIF
		
	Next I
	
	If mv_par05 == 1
		RotOper()   	// IMPRIME ROTEIRO DAS OPERACOES
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  �
	//����������������������������������������������������������������
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SMX")
	If Found() .And. (cAliasTop)->C2_DESTINA == "P"
		R820Medidas()
	EndIf
	
	m_pag++
	Li := 0					// linha inicial - ejeta automatico
	aArray:={}
	
	dbSelectArea(cAliasTop)
	dbSkip()
	
EndDO

dbSelectArea("SH8")
dbCloseArea()

dbSelectArea("SC2")
#IFDEF TOP
	(cAliasTop)->(dbCloseArea())
#ELSE	
	If aReturn[8] == 4
		RetIndex("SC2")
		Ferase(cIndSC2+OrdBagExt())
	EndIf
#ENDIF
dbClearFilter()
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � AddAr820 � Autor � Paulo Boschetti       � Data � 07/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Adiciona um elemento ao Array                              ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � AddAr820(ExpN1)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 = Quantidade da estrutura                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function AddAr820(nQuantItem)
Local cDesc   := SB1->B1_DESC
Local cLocal  := ""
Local cKey    := ""
Local cRoteiro:= ""  

Local lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)
//�����������������������������������������������������������Ŀ
//� Verifica se imprime nome cientifico do produto. Se Sim    �
//� verifica se existe registro no SB5 e se nao esta vazio    �
//�������������������������������������������������������������
If mv_par07 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
	//�����������������������������������������������������������Ŀ
	//� Verifica se imprime descricao digitada ped.venda, se sim  �
	//� verifica se existe registro no SC6 e se nao esta vazio    �
	//�������������������������������������������������������������
	If (cAliasTop)->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO+(cAliasTop)->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO # SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
			EndIf
		EndIf
	EndIf
EndIf

//�����������������������������������������������������������Ŀ
//� Verifica se imprime ROTEIRO da OP ou PADRAO do produto    �
//�������������������������������������������������������������
If !Empty((cAliasTop)->C2_ROTEIRO)
	cRoteiro:=(cAliasTop)->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial()+(cAliasTop)->C2_PRODUTO+"01")
			cRoteiro:="01"
		EndIf
	EndIf
EndIf
 
If lVer116
	dbSelectArea("NNR")
	dbSeek(xFilial()+SD4->D4_LOCAL)
Else
	dbSelectArea("SB2")
	dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL) 
EndIf

dbSelectArea("SD4")
cKey:=SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE
cLocal:=SB2->B2_LOCALIZ

DbSelectArea("SDC")
DbSetOrder(2)
DbSeek(xFilial("SDC")+cKey)
If !Eof() .And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey
	cLocal:=DC_LOCALIZ
EndIf

dbSelectArea("SD4")

If lVer116
	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,NNR->NNR_DESCRI,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,"") } )
Else
	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(mv_par12 == 1,SD4->D4_LOTECTL,""),If(mv_par12 == 1,SD4->D4_NUMLOTE,"") } )
EndIf

Return
/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � MontStruc� Autor � Ary Medeiros          � Data � 19/10/93 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta um array com a estrutura do produto                  ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � MontStruc(ExpC1,ExpN1,ExpN2)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto a ser explodido                  ���
���          � ExpN1 = Quantidade base a ser explodida                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//���������������������������������������������������������Ŀ
	//� Posiciona no produto desejado                           �
	//�����������������������������������������������������������
	dbSelectArea("SB1")
	If dbSeek(xFilial()+SD4->D4_COD)
		If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
			AddAr820(SD4->D4_QUANT)
		EndIf
	Endif
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � CabecOp  � Autor � Paulo Boschetti       � Data � 07/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Monta o cabecalho da Ordem de Producao                     ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � CabecOp()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
Static Function CabecOp(Tamanho, nPagOp)

Local cTitulo := If(mv_par12 == 2,STR0010,STR0054)+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Local cCabec1 := STR0066+RTrim(SM0->M0_NOME)+" / "+STR0067+Alltrim(SM0->M0_FILIAL)
Local cCabec2 := If(mv_par12 == 2,STR0068,STR0070)	//"  C O M P O N E N T E S                                                 |  |  |            |   "
Local cCabec3 := If(mv_par12 == 2,STR0069,STR0071)	//"CODIGO                         DESCRICAO                      QUANTIDADE|UM|AL|LOCALIZACAO |SEQ"
													// 012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      						  		//	       1         2         3         4         5         6         7         8
Local nBegin
Local nLinha   := 0
Local nomeprog := "FESTR001"

//����������������������������������������������Ŀ
//�Verificar se o ambiente � cliente ou servidor.�
//������������������������������������������������
//If SetPrintEnv() == 1
	nLinha := 2.0
//Else
//	nLinha := 0.8
//EndIf

If li # 5
	li := 0
Endif

Cabec(cTitulo,cCabec1,"",NomeProg,Tamanho,18,,.F.)

Li+=2
IF (mv_par06 == 1) .And. aReturn[5] # 1
	//���������������������������������������������������������Ŀ
	//� Imprime o codigo de barras do numero da OP              �
	//�����������������������������������������������������������
	oPr := ReturnPrtObj()   
	cCode := (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
	MSBAR3("CODE128",nLinha,0.5,Alltrim(cCode),oPr,Nil,Nil,Nil,nil ,1.5 ,Nil,Nil,Nil)
	Li += 5
ENDIF

c_Grupo := Posicione("SB1", 1, xFilial("SB1") + aArray[1][1], "B1_GRUPO")
c_Desc  := aArray[1][2]

@Li,00 PSay STR0013+aArray[1][1]+ " " +aArray[1][2]	//"Produto: "
Li++
@Li,00 PSay STR0014+DTOC(dDatabase)					//"Emissao:"
@Li,26 PSay "Turno     : ( )01   ( )02   ( )03"		//"Turno:"
@Li,73 PSay STR0015+TRANSFORM(nPagOp,'999')			//"Fol:"
Li++

//���������������������������������������������������������Ŀ
//� Imprime nome do cliente quando OP for gerada            �
//� por pedidos de venda                                    �
//�����������������������������������������������������������
If (cAliasTop)->C2_DESTINA == "P"
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO,.F.)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		@Li,00 PSay STR0016	//"Cliente :"
		@Li,10 PSay SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+" "+A1_NOME
		dbSelectArea("SG1")
		Li++
	EndIf
EndIf

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
	@Li,00 PSay STR0017                 //"Qtde Prod.:"
	@Li,11 PSay aSC2Sld(cAliasTop)		PICTURE PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
	@Li,26 PSay STR0018                 //"Qtde Orig.:"
	@Li,37 PSay (cAliasTop)->C2_QUANT	PICTURE PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
Else
	@Li,00 PSay STR0019			//"Quantidade :"
	@Li,15 PSay (cAliasTop)->C2_QUANT - (cAliasTop)->C2_QUJE	PICTURE PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
Endif

@Li,56 PSay STR0020	//"INICIO             F I M"
Li++
@Li,00 PSay STR0021+aArray[1][4]			//"Unid. Medida : "
@Li,42 PSay "Prev.   : "+DTOC((cAliasTop)->C2_DATPRI)	//"Prev.   : "
@Li,64 PSay "Prev.   : "+DTOC((cAliasTop)->C2_DATPRF)	//"Prev.   : "
Li++
@Li,00 PSay STR0023+(cAliasTop)->C2_CC				//"C.Custo: "
@Li,42 PSay "Ajuste  : "+DTOC((cAliasTop)->C2_DATAJI)	//"Ajuste  : "
@Li,64 PSay "Ajuste  : "+DTOC((cAliasTop)->C2_DATAJF)	//"Ajuste  : "
Li++
If (cAliasTop)->C2_STATUS == "S"
	@Li,00 PSay STR0025						//"Status: OP Sacramentada"
ElseIf (cAliasTop)->C2_STATUS == "U"
	@Li,00 PSay STR0026						//"Status: OP Suspensa"
ElseIf (cAliasTop)->C2_STATUS $ " N"
	@Li,00 PSay STR0027						//"Status: OP Normal"
EndIf
@Li,42 PSay "Real    :   /  /      Real    :   /  / "	//	"Real    :   /  /      Real    :   /  / "
Li++

@Li,00 PSay "Qtde p/ Embalagem: " + Transform((cAliasTop)->C2_FSQTDPE, "@R 99999")	//"Qtde p/ Embalagem: "
@Li,42 PSay "Contador:___________"		//"Cont. : "
@Li,64 PSay "Contador:___________"		//"Cont. : "
Li++

If !(Empty((cAliasTop)->C2_OBS))
	@Li,00 PSay STR0029						//"Observacao: "
	For nBegin := 1 To Len(Alltrim((cAliasTop)->C2_OBS)) Step 65
		@li,012 PSay Substr((cAliasTop)->C2_OBS,nBegin,65)
		li++
	Next nBegin
EndIf

@Li,00 PSay __PrtFatLine()
Li++

@Li,00 PSay "VERIFICA��ES"				//VERIFICA��ES
Li++

@Li,00 PSay "N�vel do Lubrificante: ( )Alto   ( )Normal   ( )Baixo                  M�quina: ( )Limpa   ( )Suja                  Mat�ria Prima: ( )Ok"
Li++

@Li,00 PSay __PrtFatLine()
Li++

@Li,00 PSay "                          ______________________________          ______________________________          ______________________________"
Li++
@Li,00 PSay "                               Auxiliar da Produ��o                    Encarregado Produ��o                    Respons�vel Produ��o"
Li++

@Li,00 PSay __PrtFatLine()
Li++

dbSelectArea("SBM")
dbSetOrder(1)
dbSeek(xFilial("SBM") + c_Grupo)

@Li,00 PSay "Controle de Qualidade"
Li++
@Li,00 PSay "AN�LISE VISUAL:"
Li++
@Li,00 PSay "Colora��o/Inspe��o em Linha: ( )Homog�nea   ( )N�o Homog�nea                  Manchas/Inspe��o em Linha : ( )Aus�ncia   ( )Presen�a"
Li++
@Li,00 PSay "Poeira/Inspe��o em Linha   : ( )Aus�ncia    ( )Presen�a                       Rebarbas/Inspe��o em Linha: ( )Muitas     ( )Nenhuma    ( )Poucas"
Li+=2

@Li,00 PSay "MEDIDAS:"
Li++

If "TAMPA" $ c_Desc
	@Li,00 PSay "Comprimento:" + Str(SBM->BM_FSCTAMP) + "     Espessura:" + Str(SBM->BM_FSETAMP) + "     Largura:" + Str(SBM->BM_FSLTAMP) + "     Peso:" + Str(SBM->BM_FSPTAMP)
Else
	@Li,00 PSay "Altura            :" + Str(SBM->BM_FSALTB) + "     Di�metro Fundo:" + Str(SBM->BM_FSDFUNB) + "     Di�metro Ext. Boca:" + Str(SBM->BM_FSDEBB) + "     Di�metro Ext. Max:" + Str(SBM->BM_FSDEMB) + "    Peso:" + Str(SBM->BM_FSPESOB)
	Li++
	@Li,00 PSay "Di�metro Int. Boca:" + Str(SBM->BM_FSDIBB) + "     Volume Nominal:" + Str(SBM->BM_FSVNB)   + "     Volume Real       :" + Str(SBM->BM_FSVRB)  + "     Volume Total     :" + Str(SBM->BM_FSVTB)
Endif
Li++
@Li,00 PSay __PrtFatLine()
Li++

@Li,00 PSay "                                                                  ______________________________"
Li++
@Li,00 PSay "                                                                       Conferido/Encarregado"
Li++

@Li,00 PSay __PrtFatLine()
Li++

@Li,00 PSay cCabec2
Li++
@Li,00 PSay cCabec3
Li++
@Li,00 PSay __PrtFatLine()
Li++

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function RotOper()
Local cSeekWhile := "SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO)"
dbSelectArea("SG2")
If a630SeekSG2(1,aArray[1][1],xFilial("SG2")+aArray[1][1]+aArray[1][9],@cSeekWhile) 
	
	cRotOper()
	
	While !Eof() .And. Eval(&cSeekWhile)
		
		dbSelectArea("SH4")
		dbSeek(xFilial()+SG2->G2_FERRAM)
		
		dbSelectArea("SH8")
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC)
		lSH8 := IIf(Found(),.T.,.F.)
		
		If lSH8
			While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == xFilial()+(cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)+SG2->G2_OPERAC
				ImpRot(lSH8)
				dbSelectArea("SH8")
				dbSkip()
			End
		Else
			ImpRot(lSH8)
		Endif
		
		dbSelectArea("SG2")
		dbSkip()
		
	EndDo
	
Endif

Return Li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � ImpRot   � Autor � Marcos Bregantim      � Data � 10/07/95 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � ImpRot()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function ImpRot(lSH8)
Local nBegin

dbSelectArea("SH1")
dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

Verilim()

@Li,00 PSay IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25)
@Li,33 PSay SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20)
@Li,61 PSay SG2->G2_OPERAC

For nBegin := 1 To Len(Alltrim(SG2->G2_DESCRI)) Step 16
	@li,064 PSay Substr(SG2->G2_DESCRI,nBegin,16)
	li++

   IF li > 60
		Li := 0
		cRotOper()
	EndIF
Next nBegin

Li+=1
@Li,00 PSay STR0032+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+STR0033+" ____/ ____/____ ___:___"	//"INICIO  ALOC.: "###" INICIO  REAL :"
Li++
@Li,00 PSay STR0034+IIF(lSH8,DTOC(SH8->H8_DTFIM),Space(8))+" "+IIF(lSH8,SH8->H8_HRFIM,Space(5))+" "+STR0035+" ____/ ____/____ ___:___"	//"TERMINO ALOC.: "###" TERMINO REAL :"
Li++
@Li,00 PSay STR0019	//"Quantidade :"
@Li,13 PSay IIF(lSH8,SH8->H8_QUANT,aSC2Sld(cAliasTop)) PICTURE PesqPictQt("H8_QUANT",14)
@Li,28 PSay STR0036	//"Quantidade Produzida :               Perdas :"
Li++
@Li,00 PSay __PrtThinLine()
Li++

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � RotOper  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Imprime Roteiro de Operacoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � RotOper()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function cRotOper()

Local cCabec1 := SM0->M0_NOME+STR0030	//"              ROTEIRO DE OPERACOES              NRO :"
Local cCabec2 := STR0031					//"RECURSO                       FERRAMENTA               OPERACAO"

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec1
@Li,67 PSay (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay STR0013+aArray[1][1]	//"Produto: "
ImpDescr(aArray[1][2])

//���������������������������������������������������������Ŀ
//� Imprime a quantidade original quando a quantidade da    �
//� Op for diferente da quantidade ja entregue              �
//�����������������������������������������������������������
If (cAliasTop)->C2_QUJE + (cAliasTop)->C2_PERDA > 0
	@Li,00 PSay STR0017                 //"Qtde Prod.:"
	@Li,11 PSay aSC2Sld(cAliasTop)      PICTURE PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
	@Li,26 PSay STR0018                 //"Qtde Orig.:"
	@Li,37 PSay (cAliasTop)->C2_QUANT   PICTURE PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
Else
	@Li,00 PSay STR0019            //"Quantidade :"
	@Li,15 PSay aSC2Sld(cAliasTop)	PICTURE PesqPictQt("C2_QUANT",TamSX3("C2_QUANT")[1])
Endif

Li++
@Li,00 PSay STR0023+(cAliasTop)->C2_CC	//"C.Custo: "
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec2
Li++
@Li,00 PSay __PrtFatLine()
Li++
Return Li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � Verilim  � Autor � Paulo Boschetti       � Data � 18/07/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � Verilim()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 			                                          		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function Verilim()

//����������������������������������������������������������������������Ŀ
//� Verifica a possibilidade de impressao da proxima operacao alocada na �
//� mesma folha.																			 �
//� 7 linhas por operacao => (total da folha) 66 - 7 = 59					 �
//������������������������������������������������������������������������
IF Li > 59						// Li > 55
	Li := 0
	cRotOper(0)					// Imprime cabecalho roteiro de operacoes
Endif
Return Li

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpDescr � Autor � Marcos Bregantim      � Data � 31.08.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir descricao do Produto.                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpProd(Void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpDescr(cDescri)
Local nBegin

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
	@li,025 PSay Substr(cDescri,nBegin,50)
	li++
Next nBegin

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R820Medidas� Autor � Jose Lucas           � Data � 25.01.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o registros referentes as medidas do Pedido Filho. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R820Medidas(Void)                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820Medidas()
Local aArrayPro := {}, lImpItem := .T.
Local nCntArray := 0,a01 := "",a02 := ""
Local nX:=0,nI:=0,nL:=0,nY:=0
Local cNum:="", cItem:="",lImpCab := .T.
Local nBegin, cProduto:="", cDesc, cDescri, cDescri1, cDescri2

//������������������������������������������������������������Ŀ
//� Imprime Relacao de Medidas do cliente quando OP for gerada �
//� por pedidos de vendas.                                     �
//��������������������������������������������������������������
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial()+(cAliasTop)->C2_PEDIDO,.F.)
	cNum := (cAliasTop)->C2_NUM
	cItem := (cAliasTop)->C2_ITEM
	cProduto := (cAliasTop)->C2_PRODUTO
	//��������������������������������������������������������������Ŀ
	//� Imprimir somente se houver Observacoes.                      �
	//����������������������������������������������������������������
	IF !Empty(SC5->C5_OBSERVA)
		IF li > 53
			@ 03,001 PSay "HUNTER DOUGLAS DO BRASIL LTDA"
			@ 05,008 PSay "CONFIRMACAO DE PEDIDOS  -  "+IIF( SC5->C5_VENDA=="01","ASSESSORIA","DISTRIBUICAO")
			@ 05,055 PSay "No. RMP    : "+SC5->C5_NUM+"-"+SC5->C5_VENDA
			@ 06,055 PSay "DATA IMPRES: "+DTOC(dDataBase)
			li := 07
		EndIF
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
		cDescri := SC5->C5_OBSERVA
		@ li,001 PSay " OBSERVACAO: "
		@ li,018 PSay SubStr(cDescri,1,60)
		For nBegin := 61 To Len(Trim(cDescri)) Step 60
			li++
			cDesc:=Substr(cDescri,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		cDescri1 := SC5->C5_OBSERV1
		@ li,018 PSay SubStr(cDescri1,1,60)
		For nBegin := 61 To Len(Trim(cDescri1)) Step 60
			li++
			cDesc:=Substr(cDescri1,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		Li++
		cDescri2 := SC5->C5_OBSERV2
		@ li,018 PSay SubStr(cDescri2,1,60)
		For nBegin := 61 To Len(Trim(cDescri2)) Step 60
			li++
			cDesc:=Substr(cDescri2,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Carregar as medidas em array para impressao.                 �
	//����������������������������������������������������������������
	dbSelectArea("SMX")
	dbSetOrder(2)
	dbSeek(xFilial()+cNum+cProduto)
	While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
		IF M6_ITEM == cItem
			AADD(aArrayPro,M6_ITEM+" - "+M6_PRODUTO)
			nCntArray++
			cCnt := StrZero(nCntArray,2)
			aArray&cCnt := {}
			While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
				If M6_ITEM == cItem
					AADD(aArray&cCnt,{ Str(M6_QUANT,9,2)," PECAS COM ",M6_COMPTO})
				EndIf
				dbSkip()
			End
		Else
			dbSkip()
		EndIF
	End
	cCnt := StrZero(nCntArray+1,2)
	aArray&cCnt := {}
	
	For nX := 1 TO Len(aArrayPro)
		If li > 58
			R820CabMed()
		EndIF
		@ li,009 PSay aArrayPro[nx]
		Li++
		Li++
		dbSelectArea("SMX")
		dbSetOrder(2)
		dbSeek( xFilial()+cNum+Subs(aArrayPro[nX],06,15) )
		While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+Subs(aArrayPro[nX],06,15)
			If li > 58
				R820CabMed()
			EndIF
			IF M6_ITEM == Subs(aArrayPro[nX],1,2)
				@ li,002 PSay M6_QUANT
				@ li,013 PSay "PECAS COM"
				@ li,023 PSay M6_COMPTO
				@ li,035 PSay M6_OBS
				li ++
			EndIF
			dbSkip()
		End
		li++
	Next nX
	@ li,001 PSay "--------------------------------------------------------------------------------"
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R820CabMed � Autor � Jose Lucas           � Data � 25.01.94 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o cabecalho referentes as medidas do Pedido Filho. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R820CabMed(Void)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R820CabMed()
Local cCabec1 := SM0->M0_NOME+STR0037	//"               RELACAO DE MEDIDAS             NRO :"

Li := 0

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay cCabec1
@Li,67 PSay (cAliasTop)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
Li++
@Li,00 PSay __PrtFatLine()
Li++
Li++
Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Ricardo Berti         � Data �21/02/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria pergunta para o grupo			                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR820                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static Function AjustaSX1()

Local aHelpPor := {	'Opcao para a impressao do produto com  ','rastreabilidade por Lote ou Sub-Lote.  '}
Local aHelpEng := {	'Option to print the product with       ','trackability by Lot or Sub-lot.        '}
Local aHelpSpa := {	'Opcion para la impresion del producto  ','con trazabilidad por Lote o Sublote.   '}

PutSx1("MTR820","12","Imprime Lote/S.Lote ?","�Imprime Lote/Subl. ?","Print Lot/Sublot ?",;
"mv_chc","N",1,0,2,"C","","","","","mv_par12","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa) 

Return
*/
