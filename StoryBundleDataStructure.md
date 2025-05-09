- [_Implements:_ UX pattern "A bundle of stories unfolding around me"](./StoryBundle.md)
- [_Motivation:_ Compose pattern sequences into pattern languages](./ComposingPatterns.md)
- [_Used in:_ Prototype for testing](./Snurvey.md)

▲

# Story bundle (data structure)

▽

---

Draft of an in-memory representation of a story bundle

> As an experimenter, I want the state, its structure and its transitions to be _explicit_, _local_, and _declarative_ so that I can easily understand and evolve it.

> As someone curiously reading the code, I want it to contain as few transformations between different structures as possible so that I quickly understand the whole app and learn from it.

> As a code maintainer, contributor, and/or future me, I need the code to have a low cognitive load so that I can jump right in and make assessments and changes with confidence.

---

- **Code Locality** - Avoid context switches by keeping module surfaces tiny:
  - Keep all documentation in the code
  - Only import self-descriptive, exhaustive functions from other modules
  - Let all code in a module operate on the same type: `fn x(param, T): T`.
    Use phantom types to limit a function's domain on compile time
- **Eloquence** - Model the problem declaratively and avoid intermediate shapes to make data structures speak for themselves:
  - Build the type to cover the design space between the two interfaces
    [`UX`](StoryBundle) and [the `yjs Api`](https://hexdocs.pm/ygleam/)
  - Identify orthogonal pieces within a type and write reducers bottom-up,
    then compose them with `>` into a **Single-pass reducer**
- **Maintainability** - Optimize for collaboration and longevity:
  - Reduce extraneous (avoidable) [cognitive load (-> perfect introduction by Artem Zakirullin)](https://minds.md/zakirullin/cognitive#long):
    - [Write deep modules](https://minds.md/zakirullin/cognitive#shallow-modules)
    - Have all logic run in only one place: build either a dumb client with a smart server, or the other way around
    - Prefer copying (code duplication) over dependency (library import) — ["All your dependencies are your code"](https://minds.md/zakirullin/cognitive#dry)
    - [Reconsider abstraction layers](https://minds.md/zakirullin/cognitive#layers)
    - Reduce the number of mental models required to understand the code but do not hide complexity intrinsic to the problem
  - Use appropriate languages and frameworks
    - [Design patterns often smell](https://wiki.c2.com/?LanguageSmell)
    - Avoid [feature-rich languages and libraries](https://minds.md/zakirullin/cognitive#lang)

---

- [ ] **Mutual awareness** -
  Multiple users (typically 2-7) are co-authoring this structure simultaneously
  - Can see each other
  - Are identified only by a cursor with a unique color
  - Can join and exit at any time
- [ ] **Evolving survey** -
  Stories are the totality of distinct sequences of questions
  - Several answers may connect two questions
  - The order of questions and answers is total (i.e. alternative stories cannot have distinct sequences of the same answers or questions)
  - Closure: each user can transform any survey into any other survey 
- [ ] **Positionality**
  Each user is _positioned at_ an answer between two consecutive questions in a story
  - Sees the immediate surroundings
  - Can navigate freely: go to previous or next question and choose alternative answers (which may change which story they are following)
  - Can edit how the bundle of stories is connected "here" by creating and deleting connections between questions

---

```gleam

/// Note that the content is saved as a separate CRDT.
/// We need to make sure that it contains values for each possible Hash.
pub type StoryBundle {
  StoryBundle(
    fingerprint: Hash,
    content: Dict(Hash, YDoc)
    mode: Mode
    published_versions: List(Date, PublicKey, StoryBundle)
    
    up: List(Next),
    current: (me: Peer, question: Maybe(String)),
    down: List(Next)
  )
}

pub type Mode {
  Authoring(SymmetricKey, editing_doc: Maybe(Hash))
  Published(PublicKey, editing_doc: Maybe(Hash))
}

pub type Next {
  SamePeerSameQuestion(List(Answer(Bool)))
  NextQuestion(String, List(Answer(Bool)))
  NextPeer(Peer, List(Answer(True)))
}

pub type Peer { 
  Peer(color: Int, answer: Answer(True)) 
}

/// Make sure that the number of stories stays in sync!
/// This is an invariant I don't know how to represent in the type. I feel the easiest would be like `One | Two | Three`...
pub type Answer(belongs_to_current_story) {
  Answer(
    content: Hash,
    left_stories: List(Bool),
    belongs_to_current_story: belongs_to_current_story,
    right_stories: List(Bool))
}
```

With this data structure, we can easily implement mutations:

```gleam

// Navigation

fn prev_peer(StoryBundle): StoryBundle {}
fn prev_question(StoryBundle): StoryBundle {}
fn prev_answer(StoryBundle): StoryBundle {}

fn next_answer(StoryBundle): StoryBundle {}
fn next_question(StoryBundle): StoryBundle {}
fn next_peer(StoryBundle): StoryBundle {}

// Editing
// Note that the YDocs in `content` are mutated separately, so we don't need an edit function!

/// Add or remove an unselected answer to/from the current story
fn toggle_connection(local_answer_index: Int, StoryBundle): StoryBundle {}

/// Add or remove the current item. Fall back to previous if it removed current.
fn toggle_peer(Int, StoryBundle): StoryBundle {}
fn toggle_question(Hash, StoryBundle): StoryBundle {}
fn toggle_answer(Hash, StoryBundle): StoryBundle {}

/// This may not be necessary -- if the yjs undo is fine
fn undo(): StoryBundle {}
fn redo(): StoryBundle {}
```

## What we want to display:

- all previous peers
- previous question
- answers for the previous story, to the left
- alternative answers to the left
- current answer
- alternative answers to the right
- answers for the next story, to the right
- next question
- next questions reachable from alternative answers
- all next peers

## Operations available to the user:

- go to previous question (UP)
- choose closest answer of previous story (Alt+LEFT)
- choose previous answer (LEFT)
- choose next answer (RIGHT)
- choose closest answer of next story (Alt+RIGHT)
- go to next question (DOWN)

- start/stop editing question above current answer (empty = delete) (click)
- start/stop editing current answer (empty = delete) (click)
- start/stop editing question below current answer (empty = delete) (click)

- undo (Ctrl+Z)
- redo (Ctrl+Shift+Z)
- cut answer (Ctrl+X)
- copy answer (Ctrl+C)
- paste answer (Ctrl+V)

- toggle association with current story (if disassociated from all stories, it will implicitly add and edit a new question) (click)

For each alternative answer:
- choose (becomes a sequence of next_answer or previous_answer)
- toggle association with current story 

## Open questions

How do we want to edit stories?

As of now, we can navigate to a junction and choose an option that brings us to another story. We can then make it wider or narrower by toggling the answer associations.

Of course, a story only exists as a unique sequence of questions.
-> To delete a story, remove its divergence from any other story
-> To add a story, divert it from every other story
