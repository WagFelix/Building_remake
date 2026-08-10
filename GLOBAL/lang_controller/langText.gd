extends Node2D

var langText = "res://language_texts/lang_"
var langTextFallBack = "res://language_texts/lang_Eng.txt"
var arquivoTXT = ConfigFile.new()
var arquivoFB = ConfigFile.new()
var loadOK
var loadFB

func _ready():
	loadLanguage()

func loadLanguage():
	var nLangText = langText+functions.langChoice+".txt"
	arquivoTXT.clear() 
	loadOK = arquivoTXT.load(nLangText) 
	loadFB = arquivoFB.load(langTextFallBack) 

func loadValue(textSection, textValue, _forceLanguage=""):
	var qValue = arquivoTXT.get_value(textSection, textValue)
	if qValue==null:
		qValue = arquivoFB.get_value(textSection, textValue)
		print("failsafe: ", textSection, " - ", textValue)
	print("QVALUEEEE ", qValue)
	return(qValue.replace("\r",""))
	#return(qValue)

func loadTextSection(textSection, _tSize=0, _forceLanguage=""):
	var theSection = arquivoTXT.get_section_keys(textSection)
	if theSection==null:
		theSection = arquivoFB.get_section_keys(textSection)
	return(theSection)

func loadTextSectionValues(textSection, wExpression=false, _forceLanguage=""):
	var theSection = arquivoTXT.get_section_keys(textSection)
	var theValues = []
	var fallb = false
	if theSection.size()<=0:
		fallb=true
		theSection = arquivoFB.get_section_keys(textSection)
		
	var arquivo
	if fallb==true:
		arquivo = arquivoFB
	else:
		arquivo = arquivoTXT
	for i in range(theSection.size()):
		theValues.push_back(arquivo.get_value(textSection, theSection[i]).replace("\r", "") )
	if wExpression==false:
		return(theValues)
	else:
		return([theValues, theSection])
