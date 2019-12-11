Red [ "Event Grammar" ]

event: [ 
  event-title newline 
  event-when newline
  event-what
]
event-title: ["#" space some sentence]
event-when: [ "When:" space event-condition ]
event-what: [ "What:" space event-action ]

event-action: [spawn-action | start-quest]

spawn-action: ["Spawn" space count space target space event-condition]
count: [any non-zero]
start-quest: ["Start quest" space quest-name]
quest-name: [some sentence]

spawn-where: [
	"in each" space place space game-object
]

place: [ game-object place-object any [place-modifier "," place-modifier | place-modifier] ]
place-modifier: ["("condition ")"]

event-condition: [
    how-often
  | condition
]
how-often: [ 
    "every" space [some digit] ["sec" | "min" | "hour"] 
]
condition: [
 		game-object space "enters" space game-object
	| "in vision of" space game-object
]

game-object: ["$" keep identifier ]
target: [":" keep identifier]
sentence: [keep [any-char some [any-char | space]]]
; identifier: [copy idnt [letter some [letter | digit]] keep (load idnt)]
identifier: [letter some [letter | digit]]
special: charset [#"^"" #"'" #"-"]
letter: charset [#"A" - #"z"]
non-zero: charset "123456789"
digit: union non-zero charset "0"
any-char: union letter union digit special
