Red [ "Test dsl" ]

#include %grammar.red

parser: :parse-trace

print ["Title parsed:" do [parser "# MainQuest" [collect event-title]]]
print ["When parsed:" do [parser "When: $Player enters $MainArea" [collect event-when]]]
print ["What parsed:" do [parser "What: Start quest 'Hello Kitty'" [collect event-what]]]

when-every-sec: parser "When: every 50 sec" [collect event-when]
what-spawn: parser "What: Spawn 2 :Animal in each $SpawnArea in vision of $Player" [collect event-what]

print ["When parsed:" when-every-sec]
print ["What parsed:" what-spawn]

data: read %../events.dsl
result: [parser data [collect any [event any [newline newline]]]]
print result

;print [parse [load %events.dsl] event]
