/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � MT160GRPC  篈utor  � Christian Rocha    �      �           罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � Ponto de entrada disponibilizado para grava玢o de valores  罕�
北�          � e campos espec韋icos na SC7. Executado durante a gera玢o   罕�
北�          � do pedido de compra na an醠ise da cota玢o.                 罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � SIGACOM - Compras									      罕�
北�          � Este ponto de entrada est� sendo utilizado para copiar a   贡�
北�          � marca do produto da cota玢o para o pedido de compra.       罕�
北掏屯屯屯屯退屯屯屯屯屯屯屯屯屯送屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篋ata      篜rogramador       篈lteracoes                               罕�
北�          �                  �                                         罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function MT160GRPC
	SC7->C7_FSMARCA := SC8->C8_FSMARCA
Return Nil