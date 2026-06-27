extends Node
## Signal Bus

signal team_core_entered_base(team)
signal team_core_exited_base(team)

signal evaluate_control()

signal pushing_barrier(team : Team.type)
signal stopped_pushing_barrier()

signal owner_changed(team : Team.type)
signal progress_changed(team : Team.type, progress : float)
signal contested
