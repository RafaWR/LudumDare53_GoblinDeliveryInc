extends RefCounted
class_name QuestItem

var to : Vector2i

var from_name : String
var to_name : String

var item_name : String
var reward : int
var size : int
var base_sprite : int
var stamp_sprite : int

func inspect() -> String:
	var lines : Array[String] = [
		item_name,
		"From: " + from_name + "    To: " + to_name + " " + str(to),
		"Reward: " + str(reward)
	]
	return lines[0] + "\n" + lines[1] + "\n" + lines[2]
