#include "rwmake.ch"

User Function SISP001()
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � SISP001  � Autor � Anderson Reis         � Data � 20/01/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock disparado do 341REM.PAG para retornar agencia e  ���
���          � conta do fornecedor.                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNAB SISPAG SANKYO                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
IF AT("-",SA2->A2_NUMCON) == 0 
//	If	SA2->A2_BANCO <> '399'
		_cReturn :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,Len(Alltrim(SA2->A2_NUMCON))-1)),12)
//	Else
//		_cReturn :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,Len(Alltrim(SA2->A2_NUMCON))-2)),12)
//	Endif
Else
	_cReturn :=StrZero(Val(Alltrim(SA2->A2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SA2->A2_NUMCON,1,AT("-",SA2->A2_NUMCON)-1)),12)
Endif

Return(_cReturn)