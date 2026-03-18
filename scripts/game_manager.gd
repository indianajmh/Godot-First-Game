extends Node

var score = 0

@onready var score_label: Label = $ScoreLabel
@onready var score_hud: Label = $"../Player/Camera2D/ScoreHUD"

func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins"
	score_hud.text = "Coins: " + str(score)
