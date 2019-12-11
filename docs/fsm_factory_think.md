# Configuring FSM in object

To configure FSM in object, now i just declare some fields in root object, and
then just bypass them in concrete state.

## Whats bad?
- duplication & boilerplate
- root object has very much params (state_count * state_params)
- after initialization, state from root not delegated; needs invalidation

## Better way?

### Setters
That setup states and etc. Now, states sync always. But boilerplate
exist anyware.

### FSM polymorf method

FSM method to set property by name. 

nice: less boilerplate
ugly: less static checking - more runtime errors

### Direct setter to states

More coupling. More changes require changes in both, client and host of API.

### Factories

Factory bilds objects by direct setters to states or builds FSMs.
When building FSM we need states, bindings(signal/slot) for sync states(as
Setters) and params.
