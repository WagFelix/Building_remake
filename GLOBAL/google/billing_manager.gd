extends Node

#var billing = BillingClient.new()

signal purchase_check_finished(has_access)

var billing 
var status := "Não iniciado"


func get_status() -> String:
	return "Ainda não implementado"
	
func _ready():
	billing = BillingClient.new()

	add_child(billing)

	billing.connected.connect(_on_connected)
	billing.connect_error.connect(_on_connect_error)
	billing.query_purchases_response.connect(_on_purchases)
	billing.query_product_details_response.connect(_on_products)

	billing.start_connection()

func _on_products(response):
	status = "PRODUCTS -> " + JSON.stringify(response)


func _on_connected():

	status = "ENTROU NO QUERY_PURCHASES"

	billing.query_purchases(
		BillingClient.ProductType.INAPP
	)
#func _on_connected():
#
	#status = "Billing conectado"
#
	#billing.query_product_details(
		#PackedStringArray(["abfoc2_full_game"]),
		#BillingClient.ProductType.INAPP
	#)

func _on_connect_error(code, message):

	status = "Erro %s - %s" % [str(code), message]


func _on_purchases(response):

	status = "PURCHASES -> " + JSON.stringify(response)

	var has_access := false

	if response.has("purchases"):
		has_access = response.purchases.size() > 0

	purchase_check_finished.emit(has_access)
