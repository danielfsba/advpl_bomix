#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

User Function codbar()        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � RPCODBAR � Autor � Patricia P. Santos    � Data � 08/11/99 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Converte Cod. Barras p/ Linha Digitavel e o contrario      潮�
北�          � Desenvolvido para ROYALPLAS- Gatilho                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北矨lteacao  � Alterado em 20/09/00 para validar novo padrao de Codigo de 潮�
北�          � Barras da FEBRABAN de 01/09/00 - Vitor Luis Fattori        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/

SetPrvt("_CRETORNO,")

_cRetorno := M->E2_CODBAR

IF LEN(ALLTRIM(M->E2_CODBAR))== 47
   _cRetorno := Substr(M->E2_CODBAR,1,4) + ;             // BANCO + MOEDA
   Substr(M->E2_CODBAR,33,1) + ;                      // DV GERAL
   Substr(M->E2_CODBAR,34,4) + ;                       // FATOR VENCIMENTO
   StrZero(Val(Alltrim(Substr(M->E2_CODBAR,38,10))),10) + ; // VALOR
   Substr(M->E2_CODBAR,5,5) + ;                              // CAMPO LIVRE
   Substr(M->E2_CODBAR,11,10) + ;
   Substr(M->E2_CODBAR,22,10)
ELSEIF LEN(ALLTRIM(M->E2_CODBAR)) <> 47 .AND. LEN(ALLTRIM(M->E2_CODBAR)) <> 44
// Concessionarias e tributos
   _cRetorno := Substr(M->E2_CODBAR,1,11) + Substr(M->E2_CODBAR,13,11) + Substr(M->E2_CODBAR,25,11) + Substr(M->E2_CODBAR,37,11)
ENDIF
Return(_cRetorno)

