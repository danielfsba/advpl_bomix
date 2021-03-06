#INCLUDE 'TOPCONN.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FFATV002   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o para edi��o do campo Sit. Arte no item do PV.    ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT - Faturamento									  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/* VERS�O EM PRODU��O ANTES DA ALTERA��O DA ROTINA DE ARTE
User Function FFATV002
	Local c_Produto := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_PRODUTO' })]
	Local l_Ret 	:= .T.

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+c_Produto)
	If !Empty(SB1->B1_FSARTE) 				//Verifica se o produto possui arte
		If SB1->B1_FSARTE <> '99999'	    //Verifica se a arte do produto � diferente de 99999
			dbSelectArea("SZ2")
			dbGoTop()
			dbSetOrder(1)
			dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
			If SZ2->Z2_BLOQ == '1'          //Verifica se a arte do produto est� bloqueada
				l_Ret := .F.                //Desabilita a edi��o do campo de situa��o da arte
			Endif
		Endif
	Endif

Return(l_Ret)
*/

User Function FFATV002
	Local c_Produto := aCols[n][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_PRODUTO' })]
	Local a_Area    := GetArea()
	Local l_Ret 	:= .T.                                         
	
	//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return(l_Ret)
endif

////////

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+c_Produto)
	If !Empty(SB1->B1_FSARTE) 				//Verifica se o produto possui arte
		dbSelectArea("SZ2")
		dbGoTop()
		dbSetOrder(1)
		dbSeek(xFilial("SZ2")+SB1->B1_FSARTE)
		If SZ2->Z2_BLOQ == '1' .Or. SZ2->Z2_BLOQ == '2'         //Verifica se a arte do produto est� bloqueada
			l_Ret := .F.                						//Desabilita a edi��o do campo de situa��o da arte
		Endif
	Else
		l_Ret := .F.
	Endif

	If l_Ret
		a_Grupos := UsrRetGrp(, __CUSERID)

		If aScan(a_Grupos, {|x| x $ GetMv("BM_ALTARTE") }) > 0
			l_Ret := .T.
		Else
			l_Ret := .F.
		Endif
	Endif

	RestArea(a_Area)

Return(l_Ret)