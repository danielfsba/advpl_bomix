//#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
//#INCLUDE "TOPCONN.CH"    
#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �A010TOK      � Autor � VICTOR SOUSA       � Data �  11/11/19  ���
���������������������������������������������������������������������������͹��
���Descricao � Valida��o da Transfer�ncia	                                ���
���          � Apos confirmada a altera��o do produto no campo de bloqueio  ���
���          � o sistema verificar� se existe Or�amento / OP / Pedido de    ���
���          � Venda e Pedido de Compra em aberto. Caso exista, o sistema   ���
���          � n�o permitir� bloquear o produto                         	���
���������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                      ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/


User Function A010TOK()

	// Valida��es do usu�rio para inclus�o ou altera��o do produto
	Local l_Ret := .T.
	Local a_Area := GetArea()
	Local cQry        := ""
	Local m_quant        := ""

	/*	
	cQry:="SELECT COUNT(*) AS TOTAL    "+ chr(13)
	cQry+="FROM "+RetSqlName("SC2")+" SC2 WITH (NOLOCK) "+ chr(13)
	cQry+="WHERE SC2.C2_FILIAL='"+xFilial("SC2")+"'  "+ chr(13)
	cQry+="AND C2_PRODUTO='"+M->B1_COD+"'"+ chr(13)
	cQry+="AND D_E_L_E_T_<>'*'         "+ chr(13)
	cQry+="AND (C2_DATAPCP='' OR C2_PRIOR<500) "+ chr(13)
	cQry+="AND C2_QUJE < C2_QUANT      "
	*/
	If M->B1_MSBLQL="1" 

		//VERIFICA OR�AMENTOS ABERTOS

		/*
		cQry:="SELECT count(*) AS TOTAL FROM "+RetSqlName("SCK")+" SCK WITH (NOLOCK) "+ chr(13)
		cQry+="WHERE CK_NUMPV=''                                     "+ chr(13)
		cQry+="AND CK_FILIAL='"+xFilial("SCK")+"'                    "+ chr(13)
		cQry+="AND D_E_L_E_T_<>'*'                                   "+ chr(13)
		cQry+="AND CK_PRODUTO='"+M->B1_COD+"'                        "+ chr(13)

		MemoWrit("QUANT_ORCA.SQL",cQry)

		TCQuery cQry New Alias "QRYPRO"

		m_quant=ALLTRIM(STR(QRYPRO->TOTAL))


		If VAL(m_quant)>0
		ShowHelpDlg(SM0->M0_NOME, { "Produto com ( " +m_quant+ " ) Or�amentos em aberto."}, 5, {"� necess�rio verificar a situa��o. Solicite ao Setor Respons�vel"},5)
		l_Ret := .F.
		Endif

		QRYPRO->(DbCloseArea())	

		*/
		
		m_quant        := ""
		cQry        := ""
		//VERIFICA PEDIDOS DE VENDAS ABERTOS
		cQry:="SELECT COUNT(*) AS TOTAL FROM "+RetSqlName("SC6")+" SC6 WITH (NOLOCK)"+ chr(13)
		cQry+="WHERE D_E_L_E_T_<>'*'                                       "+ chr(13)
		cQry+="AND C6_FILIAL='"+xFilial("SC6")+"'                          "+ chr(13)
		cQry+="AND C6_NOTA=''                                              "+ chr(13)
		cQry+="AND C6_PRODUTO='"+M->B1_COD+"'                              "+ chr(13)
		cQry+="AND C6_BLQ<>'R'                                             "+ chr(13)

		MemoWrit("QUANT_PEDV.SQL",cQry)

		TCQuery cQry New Alias "QRYPRO"

		m_quant=ALLTRIM(STR(QRYPRO->TOTAL))


		If VAL(m_quant)>0
			ShowHelpDlg(SM0->M0_NOME, { "Produto com ( " +m_quant+ " ) Pedidos de Vendas em uso."}, 5, {"� necess�rio verificar a situa��o. Solicite ao Setor Respons�vel"},5)
			l_Ret := .F.
		Endif

		QRYPRO->(DbCloseArea())	

		m_quant        := ""
		cQry        := ""

		//VERIFICA OPs ABERTAS
		cQry:="SELECT COUNT(*) AS TOTAL    "+ chr(13)
		cQry+="FROM "+RetSqlName("SC2")+" SC2 WITH (NOLOCK) "+ chr(13)
		cQry+="WHERE SC2.C2_FILIAL='"+xFilial("SC2")+"'  "+ chr(13)
		cQry+="AND C2_PRODUTO='"+M->B1_COD+"'"+ chr(13)
		cQry+="AND D_E_L_E_T_<>'*'         "+ chr(13)
		cQry+="AND C2_DATRF=''             "+ chr(13)
		cQry+="AND C2_QUJE < C2_QUANT      "

		MemoWrit("QUANT_OP.SQL",cQry)

		TCQuery cQry New Alias "QRYPRO"

		m_quant=ALLTRIM(STR(QRYPRO->TOTAL))

		If VAL(m_quant)>0
			ShowHelpDlg(SM0->M0_NOME, { "Produto com ( " +m_quant+ " ) OPs em aberto."}, 5, {"� necess�rio encerrar a OP para bloquear este produto. Solicite ao Setor do PCP"},5)
			l_Ret := .F.
		Endif

		QRYPRO->(DbCloseArea())


		m_quant        := ""
		cQry        := ""
		//VERIFICA PEDIDOS DE COMPAS ABERTOS
		cQry:="SELECT COUNT(*) AS TOTAL  FROM "+RetSqlName("SC7")+" SC7 WITH (NOLOCK) "+ chr(13)
		cQry+="WHERE D_E_L_E_T_<>'*'                 "+ chr(13)
		cQry+="AND C7_FILIAL='"+xFilial("SC7")+"'  "+ chr(13)
		cQry+="AND C7_EMITIDO<>'S'                   "+ chr(13)
		cQry+="AND C7_ENCER<>'E'                     "+ chr(13)
		cQry+="AND C7_RESIDUO=''                     "+ chr(13)
		cQry+="AND C7_PRODUTO='"+M->B1_COD+"'        "+ chr(13)
		cQry+="AND C7_QUJE<C7_QUANT                  "+ chr(13)

		MemoWrit("QUANT_PEDC.SQL",cQry)

		TCQuery cQry New Alias "QRYPRO"

		m_quant=ALLTRIM(STR(QRYPRO->TOTAL))


		If VAL(m_quant)>0
			ShowHelpDlg(SM0->M0_NOME, { "Produto com ( " +m_quant+ " ) Pedidos de Compra em uso."}, 5, {"� necess�rio verificar a situa��o. Solicite ao Setor Respons�vel"},5)
			l_Ret := .F.
		Endif

		QRYPRO->(DbCloseArea())	


	Endif

	RestArea(a_Area)			
Return l_Ret
