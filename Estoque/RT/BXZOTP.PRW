#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#include "msobject.ch"
#include "tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � BXZOTP     �Autor �TBA001 -XXX     � Data �  02/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Plus Produtos - Bomix.						  ���
�������������������������������������������������������������������������͹��
���Uso       � BXZOTP			                                          ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BXZOTP

	Local cTitulo:="Tipos"
	Local MvPar
	Local MvParDef:=""
	Local nX := 0
	Local aRetSX5 := {}

	Private aSit:={}

	l1Elem  := .F.
	//	VAR_IXB := "************   "

	cAlias := Alias() 					 // Salva Alias Anterior

	MvPar   := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	MvRet   := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	//	VAR_IXB := MvPar

	aRetSX5:=FWGetSX5( "XT")
	If ValType(aRetSX5) == "A" .AND. Len(aRetSX5) >= 1
		CursorWait()

		for nX :=  1 to len(aRetSX5)
			Aadd(aSit, TRIM(aRetSX5[3]) + " - " + Alltrim(aRetSX5[4]))
			MvParDef += TRIM(aRetSX5[3])
		NEXT nX
		CursorArrow()
	ENDIF
	
	IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem,2)  // Chama funcao f_Opcoes
		VAR_IXB := MvPar
		//&MvRet := MvPar                                                                          // Devolve Resultado
	EndIF

	dbSelectArea(cAlias) 								 // Retorna Alias

Return .T.
