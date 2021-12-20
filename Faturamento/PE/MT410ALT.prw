#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410ALT  º Autor ³ Christian Rocha    º Data ³Novembro/2012º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada acionado após a gravação das informações  º±±
±±º          ³ do pedido de venda.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bloqueia a arte caso o PV defina a situação da arte como   º±±
±±º          ³ nova ou alterada.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A T U A L I Z A C O E S                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ºANALISTA           ºALTERACOES                              º±±
±±º          º                   º                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT410ALT

	//testa filial atual
	Local i
	private cfil :="      "

	cFil := FWCodFil()
	c_CRLF := chr(13) + chr(10)
	if cFil = "030101"
		Return Nil
	endif

	If ALTERA
		For i:=1 To Len(aCols)
			If aCols[i][Len(aHeader) + 1] == .F.
				c_Produto := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_PRODUTO' })]
				c_Item := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_ITEM' })]
				c_OP := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_NUMOP' })]
				c_SitArte := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })]

			Endif
		Next i

		dbSelectArea("SC2")
		dbGoTop()
		dbSetOrder(9)
		If dbSeek(xFilial("SC2")+c_OP+c_Item+c_Produto)
			IF(SC2->C2_QUJE = 0 .OR. SC2->C2_QUJE < SC2->C2_QUANT) .AND. EMPTY(SC2->C2_DATRF) .AND. (!EMPTY(SC2->C2_DATAPCP) .OR. SC2->C2_PRIOR<"500") .And. c_SitArte='1'
				c_Qry := " UPDATE SC6010						" + c_CRLF
				c_Qry += " SET C6_FSTPITE='2'                   " + c_CRLF
				c_Qry += " WHERE C6_NUM='"+ M->C5_NUM +"'"    + c_CRLF
				c_Qry += " AND C6_PRODUTO='"+c_Produto+"'"        + c_CRLF
				c_Qry += " AND C6_ITEM='"+c_Item+"'"           + c_CRLF
				c_Qry += " AND D_E_L_E_T_<>'*' AND C6_FILIAL = '" + xFilial("SC6") + "'" + c_CRLF
		
				// TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ACIMA DE GRAVAÇÃO  ESTAVA GERANDO ERRO NO DBACCESS ATUAL
				TRYEXCEPTION

					TcCommit(1,ProcName())    //Begin Transaction

					IF ( TcSqlExec( c_Qry ) < 0 )
						cTCSqlError := TCSQLError()
						cMsgOut += ( "[ProcName: " + ProcName() + "]" )
						cMsgOut += cCRLF
						cMsgOut += ( "[ProcLine:" + Str(ProcLine()) + "]" )
						cMsgOut += cCRLF
						cMsgOut += ( "[TcSqlError:" + cTCSqlError + "]" )
						cMsgOut += cCRLF
						FWLogMsg("ERROR", /*cTransactionId*/, "BOMIX", /*cCategory*/, /*cStep*/, /*cMsgId*/, cMsgOut, /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
						UserException( cMsgOut )
					EndIF

					TcCommit(2,ProcName())    //Commit
					TcCommit(4)                //End Transaction

				CATCHEXCEPTION

					TcCommit(3) //RollBack
					TcCommit(4) //End Transaction

				ENDEXCEPTION

				// FIM TRECHO ALTERADO POR VICTOR SOUSA 28/06/20 O TRATAMENTO ANTERIOR DE GTRAVAÇÃO ESTAVA GERANDO ERRO NO DBACCESS ATUAL
				//						aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'C6_FSTPITE' })]=="2"
				c_SitArte="2"
			EndIf
		Endif
	Endif
Return Nil


