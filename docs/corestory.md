# Сюжетная линия

## Приход в отряд и обучения
ГГ является деревенским парнем. В начале игры, происходит немного паникующая
ситуация, но в целом обыденная история: нужно пасти скот, косить сено, кормить
коров. В этом прологе ГГ знакомится с базовым упрвлением: перемещение,
взаимодействие с предметами и НИПами, езда на лошади и др.

## Eventline

```
; MainLine
Tutorial: Run quest "tutorial"
CallToArm: in each @village when enemy in 5km
CallToHarvest: in each @village when @storage full
TrainDiversion: in each @camp when @train in 15km 
; enemy events
SeekForGuerilla: in each @enemy-camp when message: @train is dead
SeekForGuerilla: in each @enemy-camp every 5min
```
