#Include 'Totvs.ch'
#Include 'Ap5mail.ch'

/*/{Protheus.doc} MA650EMP
	Ponto de entrada desenvolvido para preencher campos personalizados na SD4
	e excluir as Op's e Empenhos que não querem que gere.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 05/10/2021
/*/
User Function MA650EMP()

    Local i,j,k			:= 0
    Local cOp			:= SD4->D4_OP //SD4 está posicionada na ultima op gerada
	Local cProd			:= SD4->D4_PRODUTO
    Local nResori := 0   //Quantidade origem da Resina
    Local nMasori := 0   //Quantidade origem da Master
    Local nTotal  := 0   //Total Master+Resina
    Local nPerc   := 0   //Percentual de Master e Resina
    Private lMsErroAuto := .F.

	If !Empty(cOp)

		For i:=1 To Len(aCols)
			// Fecha a tabela de pedidos em aberto caso o alias esteja em uso
			If (Select("PEGALA") > 0)
				DBSelectArea("PEGALA")
				DBCloseArea()
			EndIf

			BEGINSQL ALIAS "PEGALA"
				SELECT 
					B1.B1_DESC AS BRITO, 
					B1.B1_BRTPPR AS BRITO1,
					G1.G1_QUANT AS BRITO2
				FROM  %TABLE:SD4% D4 (NOLOCK)
					INNER JOIN %TABLE:SB1% B1 (NOLOCK)
					ON B1.B1_FILIAL = %XFILIAL:SB1%
					AND B1.%NOTDEL%
					AND B1.B1_COD = %EXP:aCols[i][1]%
					LEFT JOIN %TABLE:SG1% G1 (NOLOCK)
					ON G1.G1_FILIAL=%XFILIAL:SG1% AND
					D4.%NOTDEL% AND G1.G1_COMP=%EXP:aCols[i][1]%
					AND G1.G1_COD=D4.D4_PRODUTO
				WHERE D4.D4_FILIAL = %XFILIAL:SD4%
					AND D4.%NOTDEL%
					AND D4.D4_QUANT <> 0
					AND D4.D4_OP = %EXP:cOp%
					AND D4.D4_COD = %EXP:aCols[i][1]%
			ENDSQL

			DbSelectArea("SD4")
			DbSetOrder(1)
			If dbSeek(FwXFilial("SD4")+aCols[i][1]+cOp)
				RecLock("SD4", .F.)
					SD4->D4_FSDSC := PEGALA->BRITO
					SD4->D4_FSTP  := PEGALA->BRITO1
					SD4->D4_FSQTDES := PEGALA->BRITO2
				MsUnlock()
			EndIf
			SD4->(DBCloseArea())

			DBSelectArea("SB1")
			DbSetOrder(1)
			If DbSeek(FWXFILIAL("SB1")+cProd)
				cPeso := SB1->B1_FSPESOP
				cQb	  := SB1->B1_QB
			EndIf

			DbSelectArea("SD4")
			DbSetOrder(1)
			If dbSeek(FwXFilial("SD4")+aCols[i][1]+cOp)
				RecLock("SD4", .F.)
					SD4->D4_FSPESO  := cPeso
					SD4->D4_FSQTDBS := cQb
				MsUnlock()
			EndIf
			SD4->(DBCloseArea())
		Next

		For j:=1 to Len(Acols)
			If "RESINA" $ AllTrim(Acols[j][14])
				nResori := nResori + Acols[j][2] //Soma se tiver mais de uma resina no Acols
			EndIf
			If "MASTER" $ Alltrim(Acols[j][14])
				nMasori := nMasori + Acols[j][2] //Soma caso algum dia tenha mais de uma master
			EndIf
		Next j

		nTotal := nResori + nMasori

		For k:=1 to Len(Acols)
			If ("MASTER" $ Alltrim(Acols[k][14]) .Or. "RESINA" $ Alltrim(Acols[k][14]))
				nPerc := ((Acols[k][2]) / nTotal) * 100 //Calcula o percentual de cada Master / resina
				DbSelectArea("SD4")
				DbSetOrder(1)
				If DbSeek(FwXFilial("SD4") + Acols[k][1] + cOp)
				RecLock("SD4", .F.)
					SD4->D4_FSPM_R := Round(nPerc,2) //Grava no campo específico a proporção de cada item
				MsUnlock()
				EndIf
			EndIf
		Next k
		SD4->(DBCloseArea())
	EndIf

Return (Nil)
