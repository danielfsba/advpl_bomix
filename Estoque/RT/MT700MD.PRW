#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'    


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

User Function MT700MD
/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
Private var_mat   := " "
Private var_cc    := " "
	 
dbSelectArea("SB1") 
SET ORDER TO 1
dbGoTop()        
While !EOF()
     VAR_FILIAL  = ALLTRIM(SB1->B1_FILIAL)+"01"         
     VAR_COD     = SB1->B1_COD
     VAR_DESC    = SB1->B1_DESC
     VAR_GRUPO   = SB1->B1_GRUPO 
     VAR_PRECOUNIT = 0.00         
     VAR_QTD = 0.00      
     VAR_DATA  = CTOD("  /  /  ")      
     VAR_TOTSLD  = 0.00
     
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
           VAR_TOTSLD = VAR_TOTSLD + B2_QATU
           DBSkip()     
        ENDDO
     
     ENDIF
     
     
     /////////////////////VALORIZA��O DOS ESTOQUES /////////////////////
     
     IF SUBSTR(SB1->B1_GRUPO,1,1) = "B" .OR. SUBSTR(SB1->B1_GRUPO,1,1) = "T"
        dbSelectArea("SD2")
        SET ORDER TO 1
        dbGoTop()
        dbSeek(var_filial+var_COD)
        IF  Eof()     
            
        ELSE    
            VAR_PRECOUNIT = 0.00
            DbSelectArea("SD2")
            DO WHILE SD2->D2_FILIAL = VAR_FILIAL .AND. SD2->D2_COD = VAR_COD
               VAR_PRECOUNIT = SD2->D2_PRCVEN
               VAR_DATA      = SD2->D2_EMISSAO 
               DBSkip()    
            ENDDO 
        ENDIF
                 
        
     ELSE
             
        dbSelectArea("SD1")
        SET ORDER TO 7
        dbGoTop()
        dbSeek(var_filial+var_COD)
        IF !Eof()     
                           
          VAR_PRECOUNIT = 0.00
          DbSelectArea("SD1")
          DO WHILE SD1->D1_FILIAL = VAR_FILIAL .AND. SD1->D1_COD = VAR_COD
             VAR_PRECOUNIT = SD1->D1_VUNIT
             VAR_DATA      = SD1->D1_DTDIGIT 
             DBSkip()    
          ENDDO             
     
        ENDIF
     ENDIF 
     
     RecLock("ZW4", .T.)
     TOT = 0.00
     TOT = VAR_PRECOUNIT *  VAR_TOTSLD 
     ZW4->ZW4_FILIAL = VAR_FILIAL
     ZW4->ZW4_COD    = VAR_COD
     ZW4->ZW4_DESC   = VAR_DESC  
     ZW4->ZW4_QTD    =  VAR_TOTSLD 
     ZW4->ZW4_VLR    = VAR_PRECOUNIT
     ZW4->ZW4_VLRTOT = TOT
     ZW4->ZW4_DATA   = VAR_DATA  
     MsUnlock()   
                   
     dbSelectArea("SB1")
     DBSkip()
     IF EOF()
        EXIT
     ENDIF        
enddo          
          
     
          
    
    Alert("Atualiza��o efetuada com sucesso.")
    
   