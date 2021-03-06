#INCLUDE "rwmake.ch"

/*      
PROGRAMA  : CNABCBB2
DATA      : 17/12/09
DESCRI��O : Atualiza o parametro de controle dos numeros sequenciais de registro.
UTILIZA��O: CNAB Banco Brasil - Cobran�a
*/

USER FUNCTION CNABCBB2

cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()

nSeq := GetMv("MV_CNABCR")

nProx := StrZero(Val(nSeq)+1,5)

PutMV("MV_CNABCR",nProx)

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

RETURN(nProx)
