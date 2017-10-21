# Automata
Models and methods for representing and manipulating finite state automata. Finite state automata recognize regular languages.
Automata accept strings over a limited alphabet (set of characters). Reading the string character-by-character left-to-right, 
the automata switches between states. If the last character read transitions the current state to a "final" state, the string
is considered "accepted". Otherwise it is "rejected". Automata may have multiple "final" states but only 1 start state.

## Deterministic Finite Automata (DFA)
DFAs have exactly one transition per character in alphabet per state.

## Nondeterministic Finite Automata (NFA)
NFAs may have any number of transitions per character in alphabet per state (either 1, 0, or more than 1).
NFAs may also have "epsilon" transitions, representing a transition that occurs without reading a character
in the input string. If an input character is read and the current state does not have a transition corresponding
to it, the string is rejected. DFAs are a subset of NFAs.

## Pushdown Automata (PDA)
Pushdown automata are nondeterministic finite automata that keep track of a stack of characters. State transitions involve an input character, a character to push, and a character to pop (any of which may be epsilon). To follow a state transition, the input character must be correct *and* the character to pop must be on top of the stack. If the character to pop is epsilon, then the transition is followed without popping a character. When following a transition, the character to push is pushed on to the top of the stack (unless it is epsilon, in which case no character is pushed). PDAs are equivalent to context free grammars.

## Simple Automata Grammar
The ```AutomataParser``` struct defines methods to parse an array of strings into a finite state automata.
Each string represents a separate state. The ```toDFA``` method parses a DFA. The ```toNFA``` method parses
an NFA (due to differing rules between the two, a valid NFA is not necessarily a valid DFA, although it can be).

Each state in the grammar is defined as ```X (Annotations): Input=Output```. The first token (substring
not separated by whitespace) defines the name of the state (the identifier used by transition edges). Annotations
are specified as a comma delimeted list inside of parentheses. If the state contains no annotations, the
parentheses should be omitted. The transition function is defined after the colon. It is a **space** delimeted
list of input character - output state pairs joined by an =.

In NFAs, epsilon transitions are represented by ```\epsilon``` or ```ε``` (this is designed to be consistent with LaTeX code).

### PDA
Because PDAs include more than input characters for state transitions, the grammar is slightly different. Instead of ```input=output``` to represent which input character transitions to a given output state, PDA transitions are ```input,pop->push=output```. Input is the input character, pop is the character that must be popped from the top of the stack, push is the character that is pushed to the top of the stack, and output is resulting state.

### Annotations
* ```Final```: represents a state that should cause a string to be accepted.

### Examples
```
A: 0=B 1=A
B (Final): 0=A 1=B
```
This grammar represents a DFA recognizing the language over alphabet {0, 1} of strings
containing an odd number of zeroes.

```
A: 0=A 1=A 1=B
B: 0=C 1=C
C: 0=D 1=D
D: \epsilon=B 1=E
E (Final): 0=E 1=E
```
This grammar represents an NFA recognizing the language over alphabet {0, 1} of strings
containing a pair of 1's separated by a positive even number of symbols (examples include
1001, 1101, 1111, 010110 but not 11, 111, or 0101).

```
1: \epsilon,\epsilon->$=2
2: a,\epsilon->A=2 b,\epsilon->B=2 \epsilon,\epsilon->\epsilon=3
3: a,A->\epsilon=3 b,B->\epsilon=3 \epsilon,$->\epsilon=4
4 (Final):
```
This grammar represents a PDA recognizing the language over alphabet {a, b} of even
length palindromes.

## NFA to DFA
```NFAToDFA``` defines the ```toDFA``` method that converts a given NFA into an equivalent DFA.

## DFA Minimization
```DFAMinimizer``` defines the ```minimize``` method that reduces a given DFA into an equivalent
DFA containing a minimal number of states.
