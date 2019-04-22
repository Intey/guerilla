# Tasks

- [x] gathering: get resource from place
- [x] gathering: speed control
- [x] HUD: show resources
- [x] crafting: action
- [x] crafting: recipes
- [x] crafting: resources
- [x] crafting: storing items
- [x] crafting: place buiding
- [ ] player chracters: health, stamina, hungry, cooling
- [ ] HUD: show health, stamina, hungry
- [ ] craft-time: craft timer
- [ ] craft-time: reset craft on move
- [ ] craft-time: craft time progress bar
- [ ] biomes: cooling
- [ ] game-time: day-night cycles
- [ ] game-time: night cooling
- [ ] campfire: reduce cooling
- [ ] animal: spawning
- [x] animal: roaming
- [x] campfire: animal fear
- [ ] fight: player melee attack
- [ ] fight: animal melee attack
- [x] fight: player range attack
- [ ] world: static items, rocks
- [ ] animal: roaming with collisions
- [x] animal: detection range
- [x] animal: player pursuit, pursuit range
- [ ] campfire: cooking

# Thinks

## AI

ИИ одиночного врага должен выполнять следующую логику:
1. Выполнять поиск игрока
2. Если игрок обнаружен (с определенной дистанции), выполнить нападение
3. В случае опасности выполнять отступление

### Поиск 
Поиск осуществляется случайным поиском по 2Д пространству. Бот должен следовать
к самой дальней видимой точке (симуляция реального поведения) и запоминать
какие области он уже просмотрел. Крайне не желательно повторное прохождение уже
изведанных областей.

### Обнаружение и бой
У бота есть область, в которой он может обнаружить игрока. Когда игрок
обнаружен, бот входит в состояние боя. В бою, бот ищет ближайщее укрытие,
которое находится между ним и игроком. Бот перемещается в укрытие и начинает
вести огонь из него.
Бот должен открывать огонь, когда игрок далет перерывы в стрельбе. Если бот
находится под обстрелом, он должен находиться в укрытие и вести не прицельный
ответный огонь.
Бот должен уметь ранжировать ближайшие укрытия по эффективности боя и занимать
лучшую позицию. Бот может сменять укрытие, для выбора более удачной позиции. 
В случае, если у бота закончились патроны, он принимает решение: штурм или
отступление. На решение влияет количество патронов оставшихся у игрока,
местность и дистанция до игрока, а так же характеристики (смелость, скорость и
т.п.) бота.

### Utility based system

#### Bear

```
distrance to victum = dtv
health points (%) = hpp
campfire distance = cd

PURSUIT = dtv * 0.8 + cd * 0.6 + hpp * 0.9
FLEEING = hpp * 0.3 + cd * 0.8 + dtv * 0.4
ROAMING = hpp * 0.8 + cd * 0.9 + dtv * 0.6 
SEARCH_FOOD = hpp * 0.7 + cd * 0.8 + dtv * 0.6 
```
