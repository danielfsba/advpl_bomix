#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  PEGAPROD     � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para gerar o c�digo do produto                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PEGAPROD
	a_Area   := GetArea()
	c_Codigo := M->H6_PRODUTO
	dbSelectArea("SB1")
	DBGOTOP()
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+c_CODIGO)
       c_desc := SB1->B1_DESC
    ELSE
       c_desc := "  "
    ENDIF

	RestArea(a_Area)

Return c_desc
