#INCLUDE "rwmake.ch"

/*      
PROGRAMA  : CNABCBB1
DATA      : 17/12/09
DESCRIÇÃO : Zera o parametro de controle dos numeros sequenciais de registro.
UTILIZAÇÃO: CNAB Banco Brasil - Cobrança
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
