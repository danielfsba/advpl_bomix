#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北砅rograma  � MT415BRW � Autor � Diogenes Alves Cocaveli         � Data � 23/01/13 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Executado antes da abertura do Browse de Orcamento                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Utilizado para realizar filtro na tela de Orcamento                 � 北
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� 						                                                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   �                                                                      潮�
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北媚哪哪哪哪哪哪哪哪哪哪� HISTORICO DE ATUALIZACOES DA ROTINA 哪哪哪哪哪哪哪哪哪哪哪幢�
北媚哪哪哪哪哪哪哪哪履哪哪哪穆哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Desenvolvedor   � Data   砈olic.� Descricao                                     潮�
北媚哪哪哪哪哪哪哪哪拍哪哪哪呐哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Diogenes        �23/01/13�      � Geracao do codigo fonte                       潮�
北�                 �        �      �                                               潮�
北�                 �        �      �                                               潮�
北�                 �        �      �                                               潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User function MT415BRW()




Local _cQry	   := ""
Local _cFiltro := ""
Local _nRecTot := 0

//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   Return(_cFiltro)
endif

////////




_cQry += " SELECT Z6_CODVEND AS CODVEND, Z6_CUSERID AS IDUSR "
_cQry += " FROM " + RetSqlName("SZ6") + " "
_cQry += " WHERE D_E_L_E_T_ <> '*' AND Z6_CUSERID = '" + __CUSERID + "' "

TcQuery _cQry New Alias "QRY"

DbSelectArea("QRY")
Count to _nRecTot
QRY->( DbGoTop() )

If _nRecTot > 0
	While QRY->( !Eof() )
		If !Empty(QRY->CODVEND)
			_cFiltro += QRY->CODVEND + "/"
		EndIf
		
		QRY->( DbSkip() )	
	Enddo
	
	If !Empty(_cFiltro)
		_cFiltro := "CJ_TBCODVE $ '" + _cFiltro + "'"
	EndIf
	
	DbSelectArea("QRY")
	DbCloseArea()
	
Else
	DbSelectArea("QRY")
	DbCloseArea()
	Return()
EndIf

Return(_cFiltro)