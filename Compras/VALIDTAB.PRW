#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  VALIDTAB     � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para validar tabela de pre�o de Compras            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������    

/*/            

User Function VALIDTAB
  	a_Area   = GetArea()
//	c_prod   := M->C7_PRODUTO
	c_preco  := 0.00
    c_prod   := GdFieldGet("C7_PRODUTO") 
		
		
				
	DBSELECTAREA("AIB")      
	dbgotop()         

	DO while .NOT. EOF()
	   if AIB->AIB_CODPRO = C_PROD
	      c_preco = AIB->AIB_PRCCOM 
          Alert("Produto com preco tabelado, pre�o minimo sera o da tabela cadastro!!!")    
          IF DDATABASE > AIB->AIB_DATVIG  
             Alert("Validade do pre�o do produto na tabela, finalizou !!!") 
             c_preco = 0.00
	      endif
	      exiT
	   endif
	   dbskip()
   	enddo        
	
	RestArea(a_Area)
Return c_preco
