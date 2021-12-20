#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

User Function CNABBB03()        // incluido pelo assistente de conversao do AP5 IDE em 09/01/02

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
   //³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
   //³ identificando as variaveis publicas do sistema utilizadas no codigo ³
   //³ Incluido pelo assistente de conversao do AP5 IDE                    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   SetPrvt("CALIAS,NORD,NREG,CRET,")

   // Execblock ITAFIN11.PRW usado no CNAB para efetuar a contagem
   // dos segmentos, de acordo com exigencias do BB.
   // Paula Nolasco



   cAlias := Alias()
   nOrd := dbSetOrder()
   nReg := Recno()

   If FUNNAME() == "FINA150"
      PutMV("MV_CNABCR","00000")
   else
      If FUNNAME() == "FINA420"
         PutMV("MV_CNABCP","00000")
      else
         If FUNNAME() == "GPEM410"
            PutMV("MV_CNABFOL","00000")
         Endif
      Endif
   Endif


   cRet := Space(9)
   dbSelectArea(cAlias)
   dbSetOrder(nOrd)
   dbGoTo(nReg)

RETURN(cRet)
