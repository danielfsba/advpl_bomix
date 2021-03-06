#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

User Function CNABBB02()        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP5 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("CALIAS,NORD,NREG,XCONT,NPROX,")

// Execblock ITAFIN10.PRW usado no CNAB para efetuar a
// contagem dos segmentos, de acordo com exigencias BB.
// Paula Nolasco


cAlias := Alias()
nOrd := dbSetOrder()
nReg := Recno()


If FUNNAME() == "FINA150" .or. FUNNAME() == "FINA740"
  xCont := GetMv("MV_CNABCR")
else
   If FUNNAME() == "FINA420" .or. FUNNAME() == "FINA750"
      xCont := GetMv("MV_CNABCP")
   else
      If FUNNAME() == "GPEM410"
         xCont := GetMv("MV_CNABFOL")
      Endif
   Endif
Endif
nProx := Val(xCont)+1

If FUNNAME() == "FINA150"
  PutMV("MV_CNABCR",StrZero(nProx,5))
else
   If FUNNAME() == "FINA420"  .or. FUNNAME() == "FINA750"
      PutMV("MV_CNABCP",StrZero(nProx,5))
   else
      If FUNNAME() == "GPEM410"
         PutMV("MV_CNABFOL",StrZero(nProx,5))
      Endif
   Endif
Endif

dbSelectArea(cAlias)
dbSetOrder(nOrd)
dbGoTo(nReg)

RETURN(nProx)
