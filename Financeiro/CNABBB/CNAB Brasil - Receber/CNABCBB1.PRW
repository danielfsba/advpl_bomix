#INCLUDE "rwmake.ch"

/*      
PROGRAMA  : CNABCBB1
DATA      : 17/12/09
DESCRI��O : Zera o parametro de controle dos numeros sequenciais de registro.
UTILIZA��O: CNAB Banco Brasil - Cobran�a
*/

USER FUNCTION CNABCBB1

cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()

PutMV("MV_CNABCR",'00000')

cRet := Space(6)
dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

RETURN(cRet)
