# MainQuest
When: $Player enters $MainArea
What: Start quest "Hello Kitty"

# SpawnOneAnimal
When: every 10 sec 
What: Spawn :Animal in each :SpawnArea

# SpawnTwoAnimalsNearPlayer 
When: every 50 sec 
What: Spawn 2 :Animal in each $SpawnArea in vision of $Player

# ConditionalNewDSL
Spawn 2 :Animal
At 12:00 every day 
In each $SpawnArea (in vision of $Player)
