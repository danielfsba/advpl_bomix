/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � MT110ENDC  篈utor  � VICTOR SOUSA       �      �           罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � Ponto de entrada disponibilizado para grava玢o de valores  罕�
北�          � e campos espec韋icos na SC1. Executado durante a aprovacao 罕�
北�          � bloqueio ou rejei玢o da Solicita玢o de Compras.            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � SIGACOM - Compras									      罕�
北�          � Este ponto de entrada est� sendo utilizado para incluir    贡�
北�          � a data de aprova玢o caso seja aprovado ou remover a data   贡�
北�          � caso seja rejeitado o bloqueado.                           罕�
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篋ata      篜rogramador       篈lteracoes                               罕�
北�25/07/19  �                  �                                         罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�    

*/                                          

                                    

User Function MT110END()

Local nNumSC := PARAMIXB[1]       // Numero da Solicita玢o de compras 
Local nOpca := PARAMIXB[2]       // 1 = Aprovar; 2 = Rejeitar; 3 = Bloquear
dbSelectArea("SC1")     
	RECLOCK("SC1",.F.)     
	IF nOpca == 1         
		SC1->C1_DATAAP := DDATABASE   
	ELSE
		SC1->C1_DATAAP := CTOD("  /  /  ")
	ENDIF
	 MSUNLOCK()

Return() 