#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*/
 Funcao:  MT120BRW
 Autor:  Marinaldo de Jesus
 Data:  22/12/2010
 Descricao: Implementacao do Ponto de Entrada MT120BRW para a Inclusao de Novas Opcoes no Menu do aRotina do programa MATA120
/*/
User Function MT120BRW()

 //Local aMnuPopUP
 
 Local cMsgHelp

 Local nIndex

 Local oException

 TRYEXCEPTION

  //Testo o Tipo
  IF !( Type( "aRotina" ) == "A" )
   BREAK
  EndIF

  PUBLIC __cSC7FMbr //Ira armazenar o Filtro Atual

  //Adiciono Novo Sub-Menu ao Menu aRotina
  aMenuPopUp := {}

  aAdd( aMenuPopUp , Array( 4 ) )
  nIndex   := Len( aMenuPopUp )

  aMenuPopUp[nIndex][1] := OemToAnsi( "Filtrar Legenda" )
  aMenuPopUp[nIndex][2] := "StaticCall( U_MT120BRW , SC7FiltLeg )"
  aMenuPopUp[nIndex][3] := 0
  aMenuPopUp[nIndex][4] := 3 

  aAdd( aMenuPopUp , Array( 4 ) )
  nIndex   := Len( aMenuPopUp )

  aMenuPopUp[nIndex][1] := OemToAnsi( "Limpar Filtro" )
  aMenuPopUp[nIndex][2] := "StaticCall( U_MT120BRW , MbrRstFilter )"
  aMenuPopUp[nIndex][3] := 0
  aMenuPopUp[nIndex][4] := 3

  //Adiciono uma nova Opcao no Menu aRotina
  aAdd( aRotina , Array( 4 ) )
  nIndex  := Len( aRotina )
  aRotina[ nIndex ][1] := "Filtro &Legenda"
  aRotina[ nIndex ][2] := aMenuPopUp
  aRotina[ nIndex ][3] := 0
  aRotina[ nIndex ][4] := 1

 CATCHEXCEPTION USING oException

  IF ( ValType( oException ) == "O" )
   cMsgHelp := oException:Description
   Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
   //Mensagem simples, de forma reduzida, somente parâmetros obrigatórios
    FWLogMsg("ERROR", /*cTransactionId*/, "BOMIX", /*cCategory*/, /*cStep*/, /*cMsgId*/, CaptureError(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

   
  EndIF

 ENDEXCEPTION

Return( NIL )

/*/
 Funcao:  SC7FiltLeg
 Autor:  Marinaldo de Jesus
 Data:  20/03/2011
 Descricao: Filtra o Browse de acordo com a Opcao da Legenda da mBrowse
/*/
Static Function SC7FiltLeg()

 Local aGetSC7
 Local aColors
 Local aLegend

 Local cSvExprFilTop

 aGetSC7   := StaticCall( U_MT120COR , GetC7Status , "SC7" , NIL , .T. )
 aColors   := aGetSC7[1]
 aLegend   := aGetSC7[2]

 cSvExprFilTop := StaticCall( u_mBrowseLFilter , BrwFiltLeg , "SC7" , @aColors , @aLegend , "Solicitação de Compras" , "Legenda" , "Duplo Clique para ativar o Filtro" , "__cSC7FMbr" )

Return( cSvExprFilTop )

/*/
 Funcao:  MbrRstFilter
 Autor:  Marinaldo de Jesus
 Data:  20/03/2011
 Descricao: Restaura o Filtro de Browse
/*/
Static Function MbrRstFilter()
Return( StaticCall( u_mBrowseLFilter , MbrRstFilter , "SC7" , "__cSC7FMbr" ) )

/*/
 Funcao:  __Dummy
 Autor:  Marinaldo de Jesus
 Data:  22/04/2011
 Descricao: __Dummy (nao faz nada, apenas previne warning de compilacao)
 Sintaxe: 
 
/*/
Static Function __Dummy( lRecursa )
 Local oException
 TRYEXCEPTION
  DEFAULT lRecursa := .F.
  IF !( lRecursa )
   BREAK
  EndIF
  SC7FiltLeg()
  MbrRstFilter()
  lRecursa := __Dummy( .F. )
 CATCHEXCEPTION USING oException
 ENDEXCEPTION
Return( lRecursa )

