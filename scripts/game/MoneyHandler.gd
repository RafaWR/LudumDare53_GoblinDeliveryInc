extends Node
class_name MoneyHandler

@export var starting_money : int
@export var money_change_per_second : float

@onready var coins_label : Label = $Coins
@onready var particles : CPUParticles2D = $Particles

var money : int
var _displayed_money : float

func _ready() -> void:
	money += starting_money

func add_money(amount : int) -> void:
	money += amount
	SoundSystem.play(Sound.COIN)
	
	particles.amount = amount / 3
	particles.emitting = true

func take_money(amount : int) -> bool:
	if amount > money:
		return false
	money -= amount
	return true

func _process(delta : float) -> void:
	if roundi(_displayed_money) != money:
		if _displayed_money < money:
			_displayed_money = min(money, _displayed_money + money_change_per_second * delta)
		else:
			_displayed_money = max(money, _displayed_money - money_change_per_second * delta)
		coins_label.text = str(roundi(_displayed_money))
