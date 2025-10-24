extends Node

#Store signals
signal store_opened
signal store_closed

#Stat signals
signal stats_changed
signal money_changed(money: int)
signal health_changed(health: float)

#Enemy Interaction signals
signal player_touched_enemy(enemy)

#Player Signals
signal player_launched
signal player_landed
