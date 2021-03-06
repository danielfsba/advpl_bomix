#Include "TOTVS.CH"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篜rograma  矴QREENTR  篈utor  砈andro Santos       ? Data ?  17/01/2012 罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篋esc.     砅onto de Entrada no documento de entrada. Apos gravacao das 罕?
北?          硉abelas                                                     罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篣so       ? SIGACOM                                                    罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北?                     A L T E R A C O E S                               罕?
北? Utilizando o mesmo Ponto de Entrada para ajusta os LOTES+ VALIDADE    罕?
北? no momento da grava玢o dos itens.                                     罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
*/        

User Function GQREENTR()

Local a_AreaSF1 	:= SF1->(GetArea())	//Salva Area do Cabecalho do Documento de Entrada
Local a_AreaSD1 	:= SD1->(GetArea())	//Salva Area dos Itens do Documento de Entrada

IF SF1->F1_TIPO $ "N|C"						//Verifica se os tipos da nota sao Normal ou Complemento

	IF ALLTRIM( SF1->F1_ESPECIE ) == 'SPED'	//Verifica se trata de Especie SPED
	
		IF SF1->F1_EST == 'EX'				//Verifica a UF Origem do Fornecedor
		
			//北北北北北北北北北北北北北北北北北北北北北北北北北北北
			//矱xecuta a rotina de complementos do documento fiscal?
			//北北北北北北北北北北北北北北北北北北北北北北北北北北北
			MATA926( SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_ESPECIE,SF1->F1_FORNECE,SF1->F1_LOJA,"E",SF1->F1_TIPO )
			
		ENDIF
		
	ENDIF
	       
	/*   
	cDtvalid:= SB8->B8_DTVALID 
	cData:= SD1->D1_LOTECTL
	
	DBSELECTAREA("SB8")
	cDtvalid(DBGOTOP())
	WHILE cDtvalid->(!EOF())
	IF S->B8_DTVALID ==	D1_LOTECTL					
       //Reclock
	IF ALLTRIM( SB8->B8_DTVALID ) == '31\12\2050'	
						
		ENDIF
	  */ 
	  
ENDIF

RestArea(a_AreaSF1)
RestArea(a_AreaSD1)

Return()