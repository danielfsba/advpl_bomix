#INCLUDE "rwmake.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北砅rograma  ? TABSZ6  ? Autor ? Diogenes Alves Cocaveli          ? Data ? 23/01/13 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Ax Cadastro para Inclusao de Usuarios para Filtro Faturamento        潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ? Cadastro Usuarios para Filtro no Pedido de Vendas                    潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 						                                                潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砇etorno   ?                                                                      潮?
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北媚哪哪哪哪哪哪哪哪哪哪? HISTORICO DE ATUALIZACOES DA ROTINA 哪哪哪哪哪哪哪哪哪哪哪幢?
北媚哪哪哪哪哪哪哪哪履哪哪哪穆哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Desenvolvedor   ? Data   砈olic.? Descricao                                     潮?
北媚哪哪哪哪哪哪哪哪拍哪哪哪呐哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Diogenes        ?23/01/13?      ? Inclusao                                      潮?
北?                 ?        ?      ?                                               潮?
北?                 ?        ?      ?                                               潮?
北?                 ?        ?      ?                                               潮?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
*/

User Function TABSZ6()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Declaracao de Variaveis                                             ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

Private cString := "SZ6"     

//testa filial atual

private cfil :="      "
cFil := FWCodFil()
if cFil = "030101"
   return
endif

////////





DbSelectArea("SZ6")
DbSetOrder(1) // SZ6_FILIAL+Z6_CODVEND

AxCadastro(cString,"Filtro Pedido Vendas")

Return()