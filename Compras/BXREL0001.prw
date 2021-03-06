#INCLUDE "rwmake.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篜rograma  矪XREL0001 ? Autor ? AP6 IDE            ? Data ?  27/08/13   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋escricao ? Codigo gerado pelo AP6 IDE.                                罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? AP6 IDE                                                    罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
/*/

User Function BXREL0001

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Declaracao de Variaveis                                             ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Ultimas Compras"
Local cPict          := ""
Local titulo       	 := "Ultimas Compras"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "BXREL0001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "BXREL0001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SF1"

DbSelectArea("SF1")
DbSetOrder(1)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Monta a interface padrao com o usuario...                           ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Processamento. RPTSTATUS monta janela com a regua de processamento. ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篎un噭o    砇UNREPORT ? Autor ? AP6 IDE            ? Data ?  27/08/13   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋escri噭o ? Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS 罕?
北?          ? monta a janela com a regua de processamento.               罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Programa principal                                         罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? SETREGUA -> Indica quantos registros serao processados para a regua ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

SetRegua(RecCount())

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Posicionamento do primeiro registro e loop principal. Pode-se criar ?
//? a logica da seguinte maneira: Posiciona-se na filial corrente e pro ?
//? cessa enquanto a filial do registro for a filial corrente. Por exem ?
//? plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ?
//?                                                                     ?
//? dbSeek(xFilial())                                                   ?
//? While !EOF() .And. xFilial() == A1_FILIAL                           ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

dbGoTop()
While !EOF()
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//? Verifica o cancelamento pelo usuario...                             ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//? Impressao do cabecalho do relatorio. . .                            ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	
	If nLin > 55 // Salto de P醙ina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	// @nLin,00 PSAY SA1->A1_COD
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Finaliza a execucao do relatorio...                                 ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

SET DEVICE TO SCREEN

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Se impressao em disco, chama o gerenciador de impressao...          ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return