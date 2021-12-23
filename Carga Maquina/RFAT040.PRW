#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include "Ap5Mail.ch"

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Rotina                                                  !
+------------------+---------------------------------------------------------+
!Modulo            ! FATURAMENTO                                             !
+------------------+---------------------------------------------------------+
!Nome              ! RFAT040.PRW                                             !
+------------------+---------------------------------------------------------+
!Descricao         ! Atualização de Data de Entrega dos Pedidos de Venda     !
+------------------+---------------------------------------------------------+
!Autor             ! Alessandro Lellis                                       !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 10/12/2021                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !  
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
|                                           |           |           |        |
+-------------------------------------------+-----------+-----------+--------+
*/   

User Function RFAT040()   

   /*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
   ±± Declaração de Variaveis Private dos Objetos                             ±±
   Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

   SetPrvt("oDlg1","oBrw1","oBtn1","oBtn2","oBtn3","oBtn4","oBtn5","oBtn6")

   Private cAlias        := "SC6"
   Private cCadastro     := "Atualização de Data de Entrega dos Pedidos de Venda"
   Private aRotina       := {} 
   Private bFiltraBrw    := {|| Nil }  
   Private _cQuery       := ""      
   Private cText         := ""    
   Private aCores        := {}    
   Private aCampos       := {}
   Private cArqTrab      := ""
   Private cFiltro       := ""
   Private cCondicao     := ""
   Private cAliasTMP as char
   aPerg                 := {} 

   _Par1 := _Par2 := Space(6)   
   _Par2 := "ZZZZZZ"
   _Par3 := dDatabase - 30                         
   _Par4 := dDatabase
   _Par5 := "      "
   _Par6 := "ZZZZZZ"
   _LojDe:= "  "
   _LojAt:= "ZZ"
   _Pedid:= SPACE(06)

   IF UPPER(FUNNAME()) == 'MATA410'
      _Par1 := SC6->C6_CLI
      _Par2 := SC6->C6_CLI
      _Par3 := SC6->C6_ENTREG                      
      _Par4 := SC6->C6_ENTREG
      _Par5 := SC6->C6_FILIAL
      _Par6 := SC6->C6_FILIAL
      _LojDe:= SC6->C6_LOJA
      _LojAt:= SC6->C6_LOJA
      _Pedid:= SC6->C6_NUM
      OkConPed(_Par1,_Par2,_Par3,_Par4,_Par5,_Par6,_Pedid)
   Else
      oDlg2      := MSDialog():New( 353,745,609,1135,"Atualização de Data de Entrega dos Pedidos de Venda ",,,.F.,,,,,,.T.,,,.T. )
      oSay1      := TSay():New( 012,012,{||"Cliente De"}      ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
      oSay2      := TSay():New( 028,012,{||"Cliente Ate"}     ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
      oSay3      := TSay():New( 044,012,{||"Data Entrega De"} ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
      oSay4      := TSay():New( 060,012,{||"Data Entrega Até"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
      oSay5      := TSay():New( 076,012,{||"Filial De"}       ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
      oSay6      := TSay():New( 092,012,{||"Filial Até"}      ,oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)

      oGet1      := TGet():New( 012,064,bSetGet(_Par1),oDlg2,048,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
      oGet2      := TGet():New( 028,064,bSetGet(_Par2),oDlg2,048,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
      oGet3      := TGet():New( 044,064,bSetGet(_Par3),oDlg2,048,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
      oGet4      := TGet():New( 060,064,bSetGet(_Par4),oDlg2,048,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
      oGet5      := TGet():New( 076,064,bSetGet(_Par5),oDlg2,048,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SM0","",,)
      oGet6      := TGet():New( 092,064,bSetGet(_Par6),oDlg2,048,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SM0","",,)
      oBtn1      := TButton():New( 012,132,"Ok",oDlg2,{||OkConPed(_Par1,_Par2,_Par3,_Par4,_Par5,_Par6,_Pedid)},037,012,,,,.T.,,"",,,,.F. )
      oBtn2      := TButton():New( 036,132,"Retornar",oDlg2,{||Close(oDlg2)},037,012,,,,.T.,,"",,,,.F. )

      oDlg2:Activate(,,,.T.)
   EndIf
Return 



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Execução após confirmação dos Parâmetros                                ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function OkConPed(_Par1,_Par2,_Par3,_Par4,_Par5,_Par6,_Pedid)

   #include 'protheus.ch'

   //Local aCpoBro := {}
   Private cAliasTMP as char
   Private lInverte := .F.
   Private cMark    := GetMark()   
   Private oMark    //Cria um arquivo de Apoio

   MsAguarde({|| _ExecRot()}, "Aguarde...", "Processando Registros...")  

Return



Static Function _ExecRot()

   local oTempTable as object
   local aStruct as array
   local cQuery as char
   local cFields as char
   local nLoop as numeric
   local nTotal := 0
   local nAtual := 0

                                             
   Aadd(aRotina,{"Marcar Todos"           ,"U_RFAT4MAR()"            , 0,6})        
   Aadd(aRotina,{"Desmarcar Todos"        ,"U_RFAT4DMA()"            , 0,6})        
   Aadd(aRotina,{"Alterar Entrega"        ,"U_RFAT4ENT()"            , 0,6})        

   aFields:={}
   aadd(aFields,{"C6_FILIAL"   ,"C", 6,0})
   aadd(aFields,{"C6_ENTREG"   ,"D",10,2})
   aadd(aFields,{"C6_NUM"      ,"C", 6,0})
   aadd(aFields,{"C6_ITEM"     ,"C", 2,0})
   aadd(aFields,{"C6_PRODUTO"  ,"C",15,0})
   aadd(aFields,{"C6_DESCRI"   ,"C",45,0})
   aadd(aFields,{"C6_QTDVEN"   ,"N",12,2})
   aadd(aFields,{"C6_PRCVEN"   ,"N",12,2})
   aadd(aFields,{"C6_VALOR"    ,"N",12,2})
   aadd(aFields,{"C6_CLI"      ,"C", 6,0})
   aadd(aFields,{"C6_LOJA"     ,"C", 2,0})
   aadd(aFields,{"C6_OPC"      ,"C",35,0}) //-- Usado apenas para a dimensão do Nome
   aadd(aFields,{"C6_SDOC"     ,"C", 2,0}) //-- Usado apenas para a dimensão do Estado
   aadd(aFields,{"C6_NUMSERI"  ,"C",35,0}) //-- Usado apenas para a dimensão do Municipio
   If funname() == 'MATA410'
      aadd(aFields,{"C6_OK"  ,"C",2,0}) 
   ENDIF
   aStruct := SC6->(DBStruct())

   //Criação da tabela temporária com uma estrutura igual a do Protheus
   oTempTable := FWTemporaryTable():New()
   oTempTable:SetFields(aStruct)
   oTempTable:Create()

   cFields := ""

   //Pega todos os campos para efetuar a cópia dos dados
   for nLoop := 1 to Len(aStruct)
      If aStruct[nLoop][1] == "C6_FILIAL"  .Or.  aStruct[nLoop][1] == "C6_NUM"    .Or.  aStruct[nLoop][1] == "C6_ITEM"    .Or. ;
         aStruct[nLoop][1] == "C6_PRODUTO" .Or.  aStruct[nLoop][1] == "C6_DESCRI" .Or.  aStruct[nLoop][1] == "C6_QTDVEN"  .Or. ;
         aStruct[nLoop][1] == "C6_PRCVEN"  .Or.  aStruct[nLoop][1] == "C6_VALOR"  .Or.  aStruct[nLoop][1] == "C6_CLI"     .Or. ;
         aStruct[nLoop][1] == "C6_OPC"     .Or.  aStruct[nLoop][1] == "C6_SDOC"   .Or.  aStruct[nLoop][1] == "C6_NUMSERI" .Or. ;
         aStruct[nLoop][1] == "C6_ENTREG"  .Or.  aStruct[nLoop][1] == "C6_LOJA"   .Or.  aStruct[nLoop][1] == "C6_NUMOP"   .Or. ;
         aStruct[nLoop][1] == "C6_ITEMOP" 
         cFields += aStruct[nLoop][1] + ","//Nome do campo
      Endif   
   next

   cFields := Left(cFields, Len(cFields) -1) //Remover a ultima vírgula

   cQuery := " INSERT INTO " + oTempTable:GetRealName()
   cQuery += " ( " + cFields + ") "
   cQuery += " SELECT " + cFields
   cQuery += " FROM " + RetSqlName("SC6") + " C6 "
   cQuery += " INNER JOIN   "+ RetSqlName("SA1") + " A1 ON "
   cQuery += "     C6.C6_CLI  = A1.A1_COD  "
   cQuery += " AND C6.C6_LOJA = A1.A1_LOJA "
   cQuery += " AND A1.D_E_L_E_T_ = '' "
   cQuery += " WHERE C6.D_E_L_E_T_ = ''  "
   cQuery += " AND C6.C6_NOTA = '' "
   cQuery += " AND C6.C6_FILIAL  BETWEEN '"+_Par5+"' AND '"+_Par6+"' "
   cQuery += " AND C6.C6_CLI     BETWEEN '"+_Par1+"' AND '"+_Par2+"' "
   cQuery += " AND C6.C6_ENTREG  BETWEEN '"+DTOS(_Par3)+"' AND '"+DTOS(_Par4)+"' "
   If Upper(FUNNAME()) == 'MATA410'
      cQuery += " AND C6.C6_NUM = '"+_Pedid+"' "
   ENDIF   
   cQuery += " ORDER BY C6_FILIAL,C6_NUM,C6_ITEM, C6_PRODUTO"

   //Envia o insert into para o banco de dados, portanto toda a cópia é feita pelo banco de dados, com grande performance!
   If TCSqlExec(cQuery) < 0
      Alert("O comando SQL gerou erro")
   Else

      Count To nTotal

      cAliasTMP := oTempTable:GetAlias()

      DbselectArea(cAliasTMP)       
      (cAliasTMP)->(DBGoTop())

      While !Eof()  
                  
         Dbselectarea("SA1")
         SA1->( Dbsetorder(1) )
         If(SA1->( Dbseek(xFilial("SA1")+(cAliasTMP)->C6_CLI+(cAliasTMP)->C6_LOJA)))
            RecLock(cAliasTMP,.F.)
            (cAliasTMP)->C6_OPC     := SA1->A1_NREDUZ
            (cAliasTMP)->C6_SDOC    := SA1->A1_EST
            (cAliasTMP)->C6_NUMSERI := SA1->A1_MUN
            MsUnlock()
         Endif 

         DbselectArea(cAliasTMP)
         Dbskip(1) 
      Enddo 

      DbselectArea(cAliasTMP)       
      (cAliasTMP)->(DBGoTop())
      IF UPPER(FUNNAME())=='MATA410'
         U_RFAT4MAR()
         U_RFAT4ENT()	
      ELSE
         Aadd(aCampos, {'C6_OK'     ,'C','Ok'             ,1,0,'@!'})
         Aadd(aCampos, {'C6_FILIAL' ,'C','Filial'         ,PesqPict("SC6","C6_FILIAL")  ,TAMSX3("C6_FILIAL")[1] ,TAMSX3("C6_FILIAL")[2]})
         Aadd(aCampos, {'C6_ENTREG' ,'C','Data Entrega'   ,PesqPict("SC6","C6_ENTREG")  ,TAMSX3("C6_ENTREG")[1] ,TAMSX3("C6_ENTREG")[2]})
         Aadd(aCampos, {'C6_NUMOP'  ,'C','Ordem Produção' ,PesqPict("SC6","C6_NUMOP")   ,TAMSX3("C6_NUMOP")[1]  ,TAMSX3("C6_NUMOP")[2]})
         Aadd(aCampos, {'C6_TEMOP'  ,'C','Item OP'        ,PesqPict("SC6","C6_ITEMOP")  ,TAMSX3("C6_ITEMOP")[1] ,TAMSX3("C6_ITEMOP")[2]})
         Aadd(aCampos, {'C6_NUM'    ,'C','Pedido'         ,PesqPict("SC6","C6_NUM")     ,TAMSX3("C6_NUM")[1]    ,TAMSX3("C6_NUM")[2]})
         Aadd(aCampos, {'C6_ITEM'   ,'C','Item'           ,PesqPict("SC6","C6_ITEM")    ,TAMSX3("C6_ITEM")[1]   ,TAMSX3("C6_ITEM")[2]}) 
         Aadd(aCampos, {'C6_PRODUTO','C','Produto'        ,PesqPict("SC6","C6_PRODUTO") ,TAMSX3("C6_PRODUTO")[1],TAMSX3("C6_PRODUTO")[2]})
         Aadd(aCampos, {'C6_DESCRI' ,'C','Descrição'      ,PesqPict("SC6","C6_DESCRI")  ,TAMSX3("C6_DESCRI")[1] ,TAMSX3("C6_DESCRI")[2]})
         Aadd(aCampos, {'C6_QTDVEN' ,'C','Quantidade'     ,PesqPict("SC6","C6_QTDVEN")  ,TAMSX3("C6_QTDVEN")[1] ,TAMSX3("C6_QTDVEN")[2]})
         Aadd(aCampos, {'C6_PRCVEN' ,'C','Prc.Venda'      ,PesqPict("SC6","C6_PRCVEN")  ,TAMSX3("C6_PRCVEN")[1] ,TAMSX3("C6_PRCVEN")[2]})
         Aadd(aCampos, {'C6_VALOR'  ,'C','Valor'          ,PesqPict("SC6","C6_VALOR")   ,TAMSX3("C6_VALOR")[1]  ,TAMSX3("C6_VALOR")[2]})
         Aadd(aCampos, {'C6_CLI'    ,'C','Cliente'        ,PesqPict("SC6","C6_CLI")     ,TAMSX3("C6_CLI")[1]    ,TAMSX3("C6_CLI")[2]})
         Aadd(aCampos, {'C6_LOJA'   ,'C','Loja'           ,PesqPict("SC6","C6_LOJA")    ,TAMSX3("C6_LOJA")[1]   ,TAMSX3("C6_LOJA")[2]})
         Aadd(aCampos, {'C6_OPC'    ,'C','Nome'           ,PesqPict("SA1","A1_NREDUZ")  ,TAMSX3("A1_NREDUZ")[1] ,TAMSX3("A1_NREDUZ")[2]})
         Aadd(aCampos, {'C6_SDOC'   ,'C','Estado'         ,PesqPict("SA1","A1_EST")     ,TAMSX3("A1_EST")[1]    ,TAMSX3("A1_EST")[2]})
         Aadd(aCampos, {'C6_NUMSERI','C','Municipio'      ,PesqPict("SA1","A1_MUN")     ,TAMSX3("A1_MUN")[1]    ,TAMSX3("A1_MUN")[2]})

         MarkBrow(cAliasTMP, 'C6_OK', ,aCampos, ,cMark,'U_RFAT4MAR()',,,,,) 
      ENDIF
   Endif

   //Fecha e apaga a tabela
   oTempTable:Delete()

Return


User Function RFAT4MAR()

   Local oMark := GetMarkBrow()

   DBSELECTAREA(cAliasTMP)       
   Dbgotop()
   While !Eof()
      If IsMark( 'C6_OK', cMark )	
         RecLock(cAliasTMP,.F.)
         (cAliasTMP)->C6_OK := ""
         MSUNLOCK()
      Else	
         RecLock(cAliasTMP,.F.)
         (cAliasTMP)->C6_OK := cMark
      MsUnLock()
      EndIf

      If !UPPER(FUNNAME()) == 'MATA410'
         MarkBRefresh( )      		// atualiza o browse
      ENDIF   
      Dbskip(1)
   End  

   DBSELECTAREA(cAliasTMP)       
   Dbgotop()

Return


User Function RFAT4DMA()

   DBSELECTAREA(cAliasTMP)       
   Dbgotop()
   While !Eof()
      If Marked("C6_OK")	
         RecLock(cAliasTMP,.F.)
         (cAliasTMP)->C6_OK := ""
         MSUNLOCK()
      Endif  
      Dbskip(1)
   End  

   DBSELECTAREA(cAliasTMP)       
   Dbgotop()

Return
 


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Função que trata a alteração da data de entrega do item                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
User Function RFAT4ENT()	

   Local dGet3 := Date() // Variável do tipo Data
   Local lHasButton := .T.
   
   IF !UPPER(FUNNAME()) == 'MATA410'
      If Vazio((cAliasTMP)->C6_CLI)
         ApMsgInfo("Arquivo Vazio")
         Return 
      Endif 
   ELSE
      cAliasTMP := "SC6"
   ENDIF
   dGet3 := (cAliasTMP)->C6_ENTREG

  DEFINE MSDIALOG oDlgEnt TITLE "Atualização da Data de Entrega" FROM 000, 000  TO 150, 250 COLORS 0, 16777215 PIXEL  

  oSay1   := TSay():New( 020,009,{||"Dt Entrega"},oDlgEnt,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
  oGet3   := TGet():New( 020, 050, { | u | If( PCount() == 0, dGet3, dGet3 := u ) },oDlgEnt,060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dGet3",,,,lHasButton  )
  oSBtn4  := SButton():New( 040,050,1,{||_AtuDtE(dGet3)},oDlgEnt,,"", )
  oSBtn5  := SButton():New( 040,080,2,{||Close(oDlgEnt)},oDlgEnt,,"", )

  ACTIVATE MSDIALOG oDlgEnt CENTERED 
Return


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Função que executa a alteração da data de entrega do item               ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function _AtuDtE(dGet3)

   If MSGYESNO("Confirma Atualizar a Data de Entrega do "+iif(FUNNAME()=='MATA410','pedido','Item')+" Selecionado ??")
     
      _FlgExec := .F.
      
      DBSELECTAREA(cAliasTMP)       
      Dbgotop()
      cChaveSC6 := (cAliasTMP)->C6_FILIAL+(cAliasTMP)->C6_NUM+(cAliasTMP)->C6_ITEM+(cAliasTMP)->C6_PRODUTO
      While !Eof()

            If Marked("C6_OK")	.OR. UPPER(FUNNAME())=='MATA410'

               cAlias := Alias()
               cReg   := Recno()           
               cOrd   := IndexOrd()

               DbselectArea("SC9")
               DbsetOrder(2)
               If Dbseek((cAliasTMP)->C6_FILIAL+(cAliasTMP)->C6_CLI+(cAliasTMP)->C6_LOJA+(cAliasTMP)->C6_NUM+(cAliasTMP)->C6_ITEM)
                  If Vazio(SC9->C9_CARGA)
                     RecLock("SC9",.F.)
                        SC9->C9_DATENT := dGet3  
                     MsUnlock()
                  Else 
                     Aviso( "Atencao", "A Data de Entrega não pode ser Alterada devido vinculo de CARGA", { "Ok" }, 2 )            
                     Return 
                  Endif 
               Endif

               DbselectArea("SC6")
               DbsetOrder(1)
               If Dbseek((cAliasTMP)->C6_FILIAL+(cAliasTMP)->C6_NUM+(cAliasTMP)->C6_ITEM+(cAliasTMP)->C6_PRODUTO)
                  RecLock("SC6",.F.)
                     SC6->C6_ENTREG := dGet3  
                  MsUnlock()

                  DbselectArea(cAliasTMP)
                  RecLock(cAliasTMP,.F.)
                  (cAliasTMP)->C6_ENTREG := dGet3
                  MsUnlock() 
                 
                  _FlgExec := .T. 
               Else 
                  MsgStop("Erro ao Atualizar a Data de Entrega - SC6 "+(cAliasTMP)->C6_FILIAL+" / "+(cAliasTMP)->C6_NUM)       
               Endif

               DbselectArea("SC2")
               DbsetOrder(1)
               If Dbseek((cAliasTMP)->C6_FILIAL+(cAliasTMP)->C6_NUMOP+(cAliasTMP)->C6_ITEMOP)
                  Do while !eof() .And. (cAliasTMP)->(C6_FILIAL+C6_NUMOP+C6_ITEMOP) == SC2->(C2_FILIAL+C2_NUM+C2_ITEM) 
                     RecLock("SC2",.F.)
                        SC2->C2_DATPRF := dGet3  
                     MsUnlock()
                     DBSKIP( 1 )
                  ENDDO
               ENDIF

               dbSelectArea(cAlias)
               dbSetOrder(cOrd)
               dbGoto(cReg)

            Endif 

            DbselectArea(cAliasTMP)
            Dbskip(1)
      End 

      //Reposiciona o SC6
      DbSelectArea("SC6")
      DbSetOrder(1)
      MsSeek(cChaveSC6, .f.)

      Close(oDlgEnt) 

      If _FlgExec 
         Aviso( "Atencao", "Atualização Finalizada!!", { "Ok" }, 2 )            
      Endif 

   Endif

Return 
