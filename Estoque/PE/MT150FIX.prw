#INCLUDE "PROTHEUS.CH"
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篜rograma  矼T150FIX  篈utor  矨driano Alves      ? Data 砄utubro/2011  罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯屯贡?
北篋esc.     砅onto de entrada utilizadao fixar o campo C8_FSNOMEF no     罕?
北?          硁o browser da tela de atualiza cotacao                       罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? Compras                                                    罕?
北掏屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北?                     A L T E R A C O E S                               罕?
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篋ata      篜rogramador       篈lteracoes                               罕?
北?          ?                  ?                                         罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
*/

User Function MT150FIX(a_Campos)

Local a_Campos	:= PARAMIXB
Local a_Camp	:= {}

For I:= 1 to Len(a_Campos)	
	aAdd(a_Camp, {a_Campos[I][1],a_Campos[I][2]})
	
	If (Alltrim(a_Campos[I][2]) == "C8_LOJA")
		aAdd(a_Camp, {"N Fantasia","C8_NREDUZ"})
	Endif
Next            

Return(a_Camp)