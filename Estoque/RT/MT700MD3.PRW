#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'     

#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"     


#INCLUDE "TBICONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE 'TOTVS.CH'


 


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �         � Autor � Wellington Carvalho   � Data � 09/09/2016���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao � 			Custo atual dos Estoques    					  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT700MD3
/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
Private var_mat   := " "
Private var_cc    := " "
Private var_dt1 := CTOD("01/10/16")
Private var_dt2 := CTOD("30/10/16")
Private mData   := DDATABASE
Private VAR_DATAD1 := " "



Alert("INICIAR GERACAO.")  

	 
dbSelectArea("SB1")                                                                 
SET DELE ON
SET ORDER TO 1
dbGoTop()   

     
While !EOF()  

    IF SB1->B1_FILIAL <> "0101"
       dbSelectArea("SB1")
       DBSkip()
       LOOP
    ENDIF   
              

     
     VAR_FILIAL  = ALLTRIM(SB1->B1_FILIAL)+"01"         
     VAR_COD     = SB1->B1_COD
     VAR_DESC    = SB1->B1_DESC
     VAR_GRUPO   = SB1->B1_GRUPO
     VAR_UM      = SB1->B1_UM
     VAR_ULT     = SB1->B1_UCOM 
     VAR_PRECOUNIT = 0.00         
     VAR_QTD = 0.00      
     VAR_DATA  = CTOD("  /  /  ")      
     VAR_TOTSLD  = 0.00
     VAR_PRECOUNITD1 = 0.00
     VAR_QUANTD1     = 0.00
     VAR_QUANTSD1    = 0.00
     VAR_PRECOD2     = 0.00
     VAR_QUANTD2     = 0.00       
     VAR_QUANTD3     = 0.00  
     VAR_SALVLR      = 0.00   
     VAR_SALCM      = 0.00 
     VAR_DOC        = "   "           
     VAR_DATAD1     = "   "
     DATAD1         := " "
          
     ////////////////// SALDO ATUAL ////////////////////////////
       
     
     dbSelectArea("SB2")
     SET ORDER TO 1
     dbGoTop()
     dbSeek(var_filial+var_COD)
     IF Eof()           
                
     ELSE  
     
        VAR_TOTSLD = 0
        dbSelectArea("SB2") 
        DO WHILE SB2->B2_FILIAL = VAR_FILIAL .AND. SB2->B2_COD = VAR_COD 
           VAR_TOTSLD = VAR_TOTSLD + SB2->B2_QATU
           VAR_SALVLR = VAR_SALVLR + SB2->B2_VATU1
           VAR_MEDIO  =  SB2->B2_CM1
                    
           DBSkip()     
        ENDDO
     
     ENDIF
      
    
     
     /////////////////////VALORIZA��O DOS ESTOQUES /////////////////////
     
     /// Valorizacao das entradas       
    
	
    c_Qry := "SELECT D1_FILIAL, D1_COD, D1_VUNIT, D1_EMISSAO, D1_DOC FROM SD1010"
    c_Qry += " WHERE D1_FILIAL = '010101' AND D1_DTDIGIT >='20160601' AND D1_DTDIGIT <='20170131' AND D_E_L_E_T_<>'*'"
    c_Qry += " ORDER BY D1_FILIAL, D1_COD, D1_DTDIGIT "
	
	
    TCQUERY c_Qry NEW ALIAS QRYD1
     
    dbSelectArea("QRYD1")
	dbGoTop() 
                         
   	While QRYD1->(!EoF()) 
           
          IF D1_COD = var_COD
           
             VAR_PRECOUNITD1 =  QRYD1->D1_VUNIT                                                                 
             DATAD1          := QRYD1->D1_EMISSAO         
            
             VAR_DATAD1      =  SUBSTR(DATAD1,7,2)+"/"+SUBSTR(DATAD1,5,2)+"/"+SUBSTR(DATAD1,1,4) 
             VAR_DOC         =  QRYD1->D1_DOC
          
          ENDIF
          DBSkip()    
    ENDDO             
     
     
     
     RecLock("ZW4", .T.)      
     
       
           
     ZW4->ZW4_FILIAL = VAR_FILIAL
     ZW4->ZW4_COD    = VAR_COD
     ZW4->ZW4_DESC   = VAR_DESC  
     ZW4->ZW4_UM     = VAR_UM
     ZW4->ZW4_GRUPO  = VAR_GRUPO
     ZW4->ZW4_QTD1   = VAR_TOTSLD 
     ZW4->ZW4_PRD1   = VAR_PRECOUNITD1
     ZW4->ZW4_DTPRD1 = VAR_DATAD1
     ZW4->ZW4_DOCD1  = VAR_DOC
     
     ZW4->ZW4_MEDIO  = VAR_MEDIO  
     MsUnlock()   
     
                                       
     QRYD1->(dbCloseArea())
          
                   
     dbSelectArea("SB1")
     DBSkip()
     IF EOF()
        EXIT
     ENDIF        
enddo          
          
     
          
    
    Alert("Atualiza��o efetuada com sucesso.")
    
   