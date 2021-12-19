#INCLUDE "rwmake.ch"

/*      
PROGRAMA  : CNABCBB2
DATA      : 17/12/09
DESCRIÇÃO : Atualiza o parametro de controle dos numeros sequenciais de registro.
UTILIZAÇÃO: CNAB Banco Brasil - Cobrança
*/

USER FUNCTION CNABCBB2

cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()

nSeq := GetMv("MV_CNABCR")

nProx := StrZero(Val(nSeq)+1,5)

SetMV("MV_CNABCR",nProx)

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

RETURN(nProx)
