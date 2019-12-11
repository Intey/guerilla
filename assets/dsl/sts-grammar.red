Red [ "Enchanted grammars, that should be used with 'collect' to build an AST" ]

#include %grammar.red

event-title: ["#" space copy event-name [some sentence] keep (rejoin ['{"' [load event-name] '}') ]
event-when: [ "When:" space event-condition ]
event-what: [ "What:" space event-action ]
