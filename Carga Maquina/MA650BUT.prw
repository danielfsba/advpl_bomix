#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function MA650BUT
    (long_description)
    @type  Function
    @author user
    @since 21/12/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MA650BUT()
    
    aAdd(aRotina,{"Ajustar Prioridade",'U_MY650PRIOR()',0,4 })

Return aRotina


User Function MY650PRIOR()
    //montar tela com todas ordem de produção ainda em aberto 
    Local I  := 0
    Local II := 0
    Local nUsado:=0
    Local aSX3Cpo := {}
    
    Local aAdvSize		:= {}
    Local aInfoAdvSize	:= {}
    Local aObjSize		:= {}
    Local aObjCoords	:= {}
    Private aCols   := {}
    Private aHeader :={}
    Private oGet1

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Montando aHeader                                             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    //aSX3Cpo := FwSX3Util():GetAllFields("SC2") 
    asx3cpo := {"C2_FILIAL","C2_NUM","C2_ITEM","C2_SEQUEN","C2_PRODUTO","C2_PRIOR","C2_EMISSAO","C2_DATPRF","C2_QUANT","C2_QUJE","C2_VATU1"}

    For i := 1 To Len(aSX3Cpo)                     
        If(/*X3Uso(GetSx3Cache(aSX3Cpo[i], 'X3_USADO')) .And. */(AllTrim(GetSx3Cache(aSX3Cpo[i], 'X3_CAMPO')) $ "C2_FILIAL#C2_NUM#C2_ITEM#C2_SEQUEN#C2_PRODUTO#C2_DATPRF#C2_PRIOR#C2_EMISSAO#C2_QUANT#C2_QUJE#C2_VATU1"))
            nUsado:=nUsado+1
            aAdd(aHeader, {IIF(AllTrim(GetSx3Cache(aSX3Cpo[i], 'X3_CAMPO'))=='C2_VATU1' ,'RECNO',AllTrim(GetSx3Cache(aSX3Cpo[i], 'X3_TITULO')) ),;
                           IIF(AllTrim(GetSx3Cache(aSX3Cpo[i], 'X3_CAMPO'))=='C2_VATU1' ,'C2_RECNO', AllTrim(GetSx3Cache(aSX3Cpo[i], 'X3_CAMPO'))),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_PICTURE'),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_TAMANHO'),;
                            IIF(AllTrim(GetSx3Cache(aSX3Cpo[i], 'X3_CAMPO'))=='C2_VATU1',0,GetSx3Cache(aSX3Cpo[i], 'X3_DECIMAL') ),;
                            "AllWaysTrue()",;
                            GetSx3Cache(aSX3Cpo[i], 'X3_USADO'),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_TIPO'),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_F3'),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_CONTEXT'),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_CBOX'),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_RELACAO'),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_WHEN'),;
                            IIF(AllTrim(GetSx3Cache(aSX3Cpo[i], 'X3_CAMPO'))=='C2_PRIOR',"A","V"),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_VLDUSER'),;
                            GetSx3Cache(aSX3Cpo[i], 'X3_PICTVAR'),;
                            If(GetSx3Cache(aSX3Cpo[i], 'X3_OBRIGAT') == "€", .T., .F.),;
                            /*Val(GetSx3Cache(aSX3Cpo[i], 'X3_ORDEM'))  */ i                    })
        Endif
    Next i

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Selecionando dados para montagem da aCols                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cAliasC2		:= GetNextAlias()
    cAuxSQL := "% AND SC2.C2_QUANT-SC2.C2_QUJE > 0%"
    BeginSQL Alias cAliasC2
        SELECT 	C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_PRIOR, C2_EMISSAO, C2_DATPRF, C2_QUANT, C2_QUJE, R_E_C_N_O_ AS C2_RECNO
            FROM %Table:SC2% SC2                            
            WHERE C2_FILIAL = %xFilial:SC2% %exp:cAuxSQL% AND SC2.%NotDel%   
        ORDER BY C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN				
    EndSQL
    TCSETFIELD(cAliasC2,"C2_EMISSAO","D",8,0)
    TCSETFIELD(cAliasC2,"C2_DATPRF","D",8,0)
    DbselectArea(cAliasC2)       
    (cAliasC2)->(DBGoTop())

    Do While !eof()
        aAux :={}
        For I := 1 to fcount()
            For II := 1 to len(aHeader)
                If trim(Field(I)) == trim(aHeader[II,2])
                    aadd(aAux,FieldGet(I))
                Endif
            Next
        Next
        aadd(aAux,.F.)
        aadd(aCols,aAux)
        
        DbSkip(1)
    Enddo

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Titulo da Janela                                             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cTitulo:='ORDEM DE PRODUÇÃO EM ABERTO'

    aAdvSize		:= MsAdvSize()
    aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
    aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )
    aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
    aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

    DEFINE FONT oFnt    NAME "Courier New"
    DEFINE FONT oFnt2	NAME "Arial" BOLD
    DEFINE FONT oFnt3   NAME "Verdana" SIZE 0,-20 BOLD                          
    DEFINE FONT oFnt4   NAME "Verdana" SIZE 0,-14 BOLD                          
    DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
    DEFINE MSDIALOG oDlg TITLE OemToAnsi("ORDEM DE PRODUÇÃO EM ABERTO") FROM aAdvSize[7],0 TO aAdvSize[6]-200,aAdvSize[5]-250 OF oMainWnd PIXEL 

    @ 05,430 BUTTON oBtnFP PROMPT "Atualizar"       SIZE 050,020 FONT oFnt4 ACTION (U_GRATUAL(),oDlg:End())	OF oDlg 	PIXEL
    @ 05,490 BUTTON oBtnFP PROMPT "Finalizar"       SIZE 050,020 FONT oFnt4 ACTION oDlg:End()	OF oDlg 	PIXEL
    
    nGetd := GD_UPDATE
    oGet1 := MsNewGetDados():New(30, 5, 190, 540 ,nGetd,,,,,,9999,,,,oDlg,aHeader,aCols)       
    oGet1:ForceRefresh ( ) 
    Activate msdialog oDlg centered


RETURN

USER FUNCTION GRATUAL()
    Local I

    For I := 1 to len(aCols)
        DbSelectArea("SC2")
        DBGOTO( GdFieldGet("C2_RECNO",I) )

        If SC2->C2_PRIOR <> oGet1:aCols[I][aScan( aHeader, { |x| x[2] == "C2_PRIOR"})]
            If RecLock("SC2", .F.)
                Replace SC2->C2_PRIOR With oGet1:aCols[I][aScan( aHeader, { |x| x[2] == "C2_PRIOR"})]
            
                MsUnlock()
            Endif
        EndIf
    next

    MsgInfo("Atualização Realizada com Sucesso", "Aviso")
RETURN NIL
