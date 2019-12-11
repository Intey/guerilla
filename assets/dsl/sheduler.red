spawnEvent: [spawn 2 Animal every 8 seconds in +SpawnArea]
runAttack: [when +SpawnArea has 4 Animal target them to +MainCamp]
defenceQuest: [
  when event.runAttack +Commander takes quest "Defence": [
    kill all Animal in 5km around +MainCamp
  ]
]
