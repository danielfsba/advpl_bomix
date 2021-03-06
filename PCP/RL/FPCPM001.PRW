#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "STDWIN.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |FPCPM001  �Autor  � Christian Rocha    � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     �															  ���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAPCP                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���			 �					�										  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FPCPM001

	Local oReport
	
	Processa({ || xPrintRel(),OemToAnsi('Gerando a etiqueta de encerramento.')}, OemToAnsi('Aguarde...'))
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xPrintRel �Autor  �Microsiga           � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o de Etiquetas de Encerramento de OP.	          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function xPrintRel()  

	Local nX 		:= 0
	Local nQtdPag 	:= 1
 	Local c_NumOp	:= 'tst00103001'	//SH6->H6_OP
 	Local c_DescPro	:= ""
 	Local n_QtdPro	:= 100 //SH6->H6_QTDPROD   
    
	Private oPrint
	Private cAlias 	    := getNextAlias() //cria um alias tempor�rio
	Private oFont6		:= TFont():New('Arial',,6,,.F.,,,,.F.,.F.)
	Private oFont6n		:= TFont():New('Arial',,6,,.T.,,,,.F.,.F.)
	Private oFont8		:= TFont():New('Arial',,8,,.F.,,,,.F.,.F.)
	Private oFont8n		:= TFont():New('Arial',,8,,.T.,,,,.F.,.F.)
	Private oFont10		:= TFont():New('Arial',,10,,.F.,,,,.F.,.F.)
	Private oFont10n	:= TFont():New('Arial',,10,,.t.,,,,.F.,.F.)
	Private nLin		:= 0 

	dbSelectArea("SB1")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + 'A00M00001                     ')//SH6->H6_PRODUTO)

	c_DescPro := SB1->B1_DESC

	oPrint := TMSPrinter():New(OemToAnsi('Etiqueta de Encerramento de Ordem de Produ��o'))
	oPrint:SetPortrait()  

	For nX := 1 to nQtdPag
		oPrint:StartPage()  

		oPrint:Box( 020,045,325,585 )           

		oPrint:Box( 020,605,325,1145 )	 			 

		nLin  := 0030
		oPrint:Say(nLin,0050,"ENCERRAMENTO DE OP",oFont8n,,,,0)
		oPrint:Say(nLin,0610,"ENCERRAMENTO DE OP",oFont8n,,,,0)		

		nLin += 0040
									 			        			
		oPrint:Say(nLin,0050,"OP: " + c_NumOP,oFont8,,,,0)
		oPrint:Say(nLin,0610,"OP: " + c_NumOP,oFont8,,,,0)

		oPrint:Say(nLin,0280,"Data: " + Dtoc(DDATABASE),oFont8,,,,0)
		oPrint:Say(nLin,0840,"Data: " + Dtoc(DDATABASE),oFont8,,,,0)
		
		nLin += 0030
		
		oPrint:Say(nLin,0050,"Quantidade: " + Transform(n_QtdPro, "@E 999,999,999"),oFont8,,,,0)
		oPrint:Say(nLin,0610,"Quantidade: " + Transform(n_QtdPro, "@E 999,999,999"),oFont8,,,,0)

		nLin += 0040

  		For i:=1 To MLCount(c_DescPro,30)
			oPrint:Say(nLin,0050,MemoLine(c_DescPro,30,i),oFont8,,,,0)
			oPrint:Say(nLin,0610,MemoLine(c_DescPro,30,i),oFont8,,,,0)		

			nLin += 0030
		Next i
/*
		oPrint:Say(nLin,0050,MemoLine(c_DescPro,35,2),oFont8,,,,0)
		oPrint:Say(nLin,0610,MemoLine(c_DescPro,35,2),oFont8,,,,0)

		nLin += 0030

		oPrint:Say(nLin,0050,MemoLine(c_DescPro,35,3),oFont8,,,,0)
		oPrint:Say(nLin,0610,MemoLine(c_DescPro,35,3),oFont8,,,,0)
*/
		nLin += 0030

		oPrint:Say(nLin,0050,"BOMIX Ind�stria de Embalagens Ltda.",oFont8,,,,0)
		oPrint:Say(nLin,0610,"BOMIX Ind�stria de Embalagens Ltda.",oFont8,,,,0) 			

		oPrint:EndPage()
	Next nX

//	oPrint:Preview()
	oPrint:Print({1},nQtdPag)
	oPrint:end()

Return