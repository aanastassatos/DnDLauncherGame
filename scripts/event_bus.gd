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
signal enemy_hit(enemy)
signal enemy_missed(enemy)

#Player Signals
signal player_launched
signal player_landed
signal player_died
