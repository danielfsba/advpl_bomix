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
���Fun��o    � BXCDSZO     �Autor �TBA001 -XXX     � Data �  02/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Plus Produtos - Bomix.						  ���
�������������������������������������������������������������������������͹��
���Uso       � BXCDSZO			                                          ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

User Function BXCDSZO


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZO"

dbSelectArea("SZO")
dbSetOrder(2)

AxCadastro(cString,"Cadastro de Medidas e Analise",cVldExc,cVldAlt)

Return
