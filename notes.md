# Notes

## Initial choices

Since this is an experimental repo, I'm toying around with the hottest stuff here :-)

### Languages and libraries

- **Gleam**, functional, strongly typed metalanguage
  - **Lustre**, full-stack MVU framework
  - Server compile target: **Erlang on the Beam**
    - **rebar** (for tests and more?)
  - Client compile target: **JavaScript**

### Tooling

- **Zed** because it's beautiful
  - **Gleam language server** for static analysis
  - Slate Light theme
  - Iosevka Aile font
- **gleam-dev-tools**, minimalistic `dev` server

### Version control

- **jj** (co-located with git)
- **asdf** (Gleam, Erlang)

## Journal

This is the initial entry. I set up this repo yesterday. Took me about a half hour. Installing erlang and gleam on a borrowed Kali Linux laptop (Thank you Pedro!) through `asdf` was not so trivial but still fun.

The initial gleam app is just the Counter example from the Lustre walkthrough. I plan to continue that tutorial and make a server+client app. That'll be exciting. Here are some of my expectations, eager to be disappointed:

- Running the same functions on a client browser and on a BEAM server, with exactly the same behavior
- Strongly typed messages flowing back and forth between several live Lustre programs, with no need for manual parsers and serializers
- p2p message passing?

Today I set up `jj` and I'm excited to learn more about it. I decided to co-locate this with a traditional `git` repo because Gleam creates a Github scaffold by default. As noted [in jj's docs on that matter](https://github.com/jj-vcs/jj/blob/main/docs/git-compatibility.md), it is possible (and so convenient!) to interleave `git` and `jj` commands freely, but using mutating `git` commands is not recommended. Let's hope I'll not accidentally use any of those!

```shell
jj st
```

Lists the files changed since the last commit.

```shell
jj describe -m "{Conventional commit message}"
jj new
jj log
```

```shell
@  spnupstm upsiflu@gmail.com 2025-05-01 15:29:44 f6aec9db
│  (empty) (no description set)
○  mrnmpqlz upsiflu@gmail.com 2025-05-01 15:28:48 git_head() adab00d5
│  🎉
◆  zzzzzzzz root() 00000000
```

`@`: The current state (potentially dirty from Git's perspective)

`spnupstm`: Change ID

`{Author, Date}`

`f6aec9db`: Commit ID

`root()`: A "revset" function (What's that?)

### `jj`: Squash workflow vs. Edit workflow

These are described in [Steve Klabnik's tutorial](https://steveklabnik.github.io/jujutsu-tutorial/real-world-workflows/the-squash-workflow.html) which I'm reproducing here. Let's see which of the two workflows I prefer.

#### Squash workflow

We begin with a new (empty) change.

1. `describe` the intended change
2. Start another `new` (empty) change

```shell
└─$ jj new
Working copy  (@) now at: vmoytrnn e90b13ac (empty) (no description set)
Parent commit (@-)      : upsxxwqx a69f36c5 (empty) docs(notes): Try out the Squash workflow
```

3. Edit
4. `jj squash` `{optional: files to include}`

If we want to be granular about what to squash, we use

```shell
jj squash -i
```

This is a TUI similar to `git rebase` but much simpler and friendlier!

### Edit workflow

This one is for inserting commits before the current one!

```shell
jj new -B @ -m "docs(notes): Use semantic sub-headlines instead of markup"
```

I am now in a new edit between "Try out the Squash workflow" and "Try out the Edit workflow". I then intenionally edit the heading that was also edited by the succeeding "Try out the Edit workflow" edit. Of course this creates a conflict at the Headline with 3 possible resolutions (Pre-edits, Edit A, or Edit B).

```shell
jj next --edit
jj resolve
```

With `next`, I am moving my cursor to the last edit in the chain ("Try out the Edit workflow"). With `resolve`, I am opening the cute TUI and select the currect version of the Headline. Of course, I can also just resolve the conflict in the editor buffer directly, but the TUI really removes the clutter :-)

### Editing old commits

This is quite elegant. We first navigate through the tree by selecting old commits and appending new changes to them, then confirm these changes with `squash`. To get back to the latest edit, we can `jj new {latest commit}` and see the complete result.

```
jj log
jj new {single letter or 2 letters as highlighted in the output}
(Edit)
jj squash
jj new {letter or 2 letters of latest empty commit}
```

### Publishing to `git` repositories

I want to publish this project both to GitBerg and GitHub.

I know this will open a can of worms (which one manages the issues, etc.) but:

- GitHub can do the GitHub Actions
- I want to learn CodeBerg
- Maybe CodeBerg has its own CI infrastructure? Probably not.
- CodeBerg is FOSS and not MS.

1. Set a "bookmark" (equivalent to git's "branch", except that new commits are not automatically added to it)

```shell
jj bookmark set main
```

2. Add a remote

```shell
jj git remote add origin https://codeberg.org/upsiflu/learning-and-experimenting.git
```

3. Push to the remote

```shell
jj git push --remote origin --allow-new
```

To make future pushes more convenient and safe, I follow [CodeBerg's guide to SSH auth]. The following command then informed `jj` about the new authentication method:

```shell
jj git remote set-url origin ssh://git@codeberg.org/upsiflu/learning-and-experimenting.git
```

Finally, to get the code to GitHub (where it can be found by, e.g., [Render](render.com)), I tried two approaches which both failed:

1. Letting Codeberg push to a mirror on Github. This failed because of very confusing UX. I was not able to select SSH authentication and enter the public key.

2. Using `jj` to push to two destinations. There is an arbitrary and unnecessary limitation in `jj` where `jj config set --repo git.fetch '["origin", "github"]'` is valid but `jj config set --repo git.push '["origin", "github"]'` [is, arbitrarily, not](https://jj-vcs.github.io/jj/latest/config/#git-settings):

> "Note that unlike git.fetch, git.push can currently only be a single remote. This is not a hard limitation, and could be changed in the future if there is demand."

Final try. This time, I told Github to trust the Codeberg-generated public key (leaving the login field empty). And it works. I just wonder how many permissions Codeberg now has over my Github...

**Note:** After each push, old changes become immutable. This is where the flag `--ignore-immutable` comes in. Let's try it out by editing a pre-push change.

### Verdict: `jj` is easier to learn and more expressive than `git`

- Instead of many commands for special conditions, it has just ca. 5, highly composable ones
- The state of the tree is much easier to understand
- It's trivial and safe to edit past commits
- All the interactions only give me the information I need; there is no noise that confuses me
- The naming of commands and objects actually makes sense (!)
- The integration with the `git` backend is seamless. Which makes me want to use the `jj` CLI in all my git-backed projects

## Back to Lustre!

I love, love, love how hayleigh designed lustre-ui.

See the last paragraph of https://github.com/lustre-labs/ui/blob/main/pages/components.md

- Important ui state such as collapsing is handled by the app (like in elm)
- Internal details such as keybord input are hidden

For context, the extremes here are "Single-source-of-truth" vs. "Component tree".

The approach that the elm community has gravitated towards: having a single source of truth for all of the UI. This makes all interactions easy to understand at the cost of coupling. Note that the cost of coupling and refactoring is much less than in unsound languages such as typescript.

The mainstream approach goes towards the other extreme: each module manages its own state; complex infrastructure is needed in addition just to pass information across components. For example, in Vue we have:

- parent-child component synchronization through props, events and 2-way bindings
- ancestor-grandchildren synchronization ("inject")
- global stores (pinia, vuex)

Issues with both approaches include:

- UX that is not tree-shaped requires undeclarative code (I solved that issue with less-ui)
- Some HTML elements contain browser-tab state, which often introduces synchronization problems with other loci of state (I'm curious to what extent such problems affect Lustre-ui)

Hayleigh's approach is pragmatic and will lead to very clean and declarative code.

Unfortunately the lustre-ui library is currently broken and can't be installed.

Let's clone the repo and try to solve the issue!

I was not able to solve the issues. Will have to wait for hayleigh to release lustre-ui v1.0.0... In the meantime, let's check what they are scheming on the discord.

OK, found the thread. Hayleigh recommends to use [gleez](https://gleez.netlify.app/docs/components/select/) until 1.0.0 is published. Gleez seems ok. I like the shadcn-inspired approach of copy+paste. I don't like the default style. For example, text in buttons sits too low. I also still dislike the obscurantist tailwind naming conventions. The scope of gleez seems to be much narrower than lustre-ui's. No state encapsulation; less research; less patterns implemented. Its domain seems to be simple websites as opposed to web apps.

## Libraries and apps

### **less_ux**: a Gleam library for composing UX patterns

Instead of writing and wiring a user interface, specify and compose UX patterns such as: 

- page transition
- expand/collapse
- toolbar 
- property pane
- user
- help
- warning
- procedure
- view mode
- view option
- form
- ...

Each pattern is a reversible transition in a state machine.

Each pattern also implements conventional controls for web clients.

The goals are:
- One composable type for the UX (no more fickle with Html tags, attributes, properties, styles, events and messages)
- Structure your app according to your domain, not around a (DOM) tree structure. For example, a module "Editor" can contain the whole UX including toolbars, dialogs, messages, help pages, settings... without the need to explicitly register it with the global page skeleton.

#### Example

```Gleam
Pages([
  #("Welcome", [Markdown(ReadOnly("
    **Hi there!** This is the start page.
    ")),
    Link("Recent project", RouteToRecentProject)
  ]),
  #("Editor", [Toolbar(...), Help(...), Markdown(Writable(...), ...])
])
```

### **Pats**: a distributed infinite canvas for patterns and stories

Patterns are small pieces with a graphic or image on top and 
structured text below (classic pattern form). `strings` can
show these patterns in context. Users create "strings" between
patterns. As a reader, I can follow strings to read stories.
Strings can be annotated. Crawlers can accumulate and index stories.

Features:
- Collaborative (yjs?) editing of patterns and strings
- Link back to the source of a graphic or text block
  - The build tool can auto-extract text and graphics
    from web resources ("transclusion"), re-fetching on each read
- Presentation mode
- Data source: IPFS? Would be super cool!

### **Freevey**: Make delightful surveys (like typeforms)

Alternative name: **Furvey** (also funny)

How it works:
- Add text nodes on a free canvas (no clutter!)
- Add possible answers in the last line of the textbox
  (with clickable suggestions, aiding discoverability)
  Example: `Yes OR No OR Undecided OR Other (specify): INPUT`
  - a OR b: user can select either
  - a AND b: user must fill both
  - INPUT: text input field
    - An INPUT may come with suggestions
- Connect the nodes or answers with arrows
- Configure the survey
  - Colors, fonts and spacing
  - Mode (Scrolling form or single typeform-esque input)
  - Result visibility (public or private)
  - Autodelete (1 day, 1 month, 1 year, 10 years)
- Each survey has an auto-generated URL. You can copy the
  URL and find the latest version of your survey when your
  paste it.
- You can click the View/Edit/Results toggle at any time

Implementation:

A straightforward implementation (without the canvas feature)
would be:
1. Define the possible types with holes:

```Gleam
type Step { Step(question: Md, answer: Answer) }
type Answer { Answer(options: #(Option, Option[], number_of_choices: Int)) }
type Option {
  Option(label: NonEmptyString, input: Input)
}
type Input {
  Preset
  StringInput
  RangeInput(min: Int, max: Int)
}
```

The TUI allows the user to navigate across the holes with the cursor keys.

For example, a typical composition workflow will be:
- I am inside the first step and start writing immediately (hole: `question`)
- When I press Enter, I add a new paragraph
- When I press Enter twice, I get to the hole `answer.options[0].label`
- I can leave the options empty by pressing Enter. This will bring
  me directly to Step2.question.
- Or I fill in the label for the first option, press Enter, then
  select an Input type (with their initial unique letter), then
  (if applicable) their properties.
- When I'm at the beginning of a hole, I can delete my choice with Backspace,
  selecting the previous hole.
- I can directly select holes by clicking them, their text content being selected
- Markdown content is not select-all-ed when I navigate to it
- The focus is in the text field I am editing. The result is visible above.
- All controls I am editing are live immediately.
- Shift+Enter is the opposite of Enter in that it walks back one hole.
  You can also press the "Left arrow" at the beginning of any hole.
- Pressing ALT condenses the questions and answers to a dense grid and
  gives each element a unique identifier. Type the identifier to walk there.
  This navigation is recorded in the browser history so you can walk back
  by pressing Alt+Left.
- In addition to the linear sequence of holes, there are auxiliary holes.
  A "properties pane" on the bottom of the screen shows metadata as well as
  buttons for adding auxiliary properties to the current hole.
  Example: By default, each option leads to the next step. You can
  redirect all options of an answer or a subset to different steps.
- You can reach the auxiliary options not with Enter but with "right arrow".
- You can select an arbitrary group of holes with these methods:
  - Hold Shift while navigating left (with the left arrow or Shift+Enter)
  - Hold Shift while clicking different holes
  - Hold Shift and Alt while clicking differen holes (dense view)
  - Hold Shift and Alt while typing the unique letter of the holes you want
  - Type Ctrl+A and then select the auto-subselection "Options" in
    the properties pane to select all options in the form
  - Type / and enter fulltext to highlight some holes, then press
    Enter to select the holes and then press the auto-subselection "Options" in
    the properties pane
- Once a hole is selected, you can press BACKSPACE to delete it.
- If more than 1 hole is selected, deletion becomes "dangerous" and
  you have to confirm it.
- Since we are editing a directed graph of steps, we also want to 
  navigate "up" (previous step) and "down" (next step).
  Obviously, we'll use the arrow keys for that.
- Since there may be more than one step "up" or "down", the key
  brings us to the space of connections first. It is a list of holes.
  The previously walked connection is preselected.

Example:
```
STEP 1
 Q: Why are you here?
 A: [PRESET "I don`t know" -> 2, 
      TEXTINPUT "Other (describe):" -> 3,
      PRESET "This is silly. Get me out of here" -> 3],
     number of choices: 1

STEP 2
 Q: Do you know your name?
 A: [SINLGE LINE TEXT INPUT -> 3],
     number of choices: 1

STEP 3
 Q: Thank you!
 A: []
```

In the above example, going "up" from Step3 gives you two options.
This will be visualized with 3 arrows, coming from different answers.
One will be preselected. Left and right cycle through them.
Typing "up" another time selects the connected answer.

What happens if I delete the selected arrow? Then I end up inside
its hole and a preset is filled-in (because it may not be empty) and
the preset is select-all-ed.

Questions:
- Is it nicer to edit inside the properties pane and keep the main view
  exacly WYSIWYG?
- Or do we want extensive overlays?l

Ideas:
https://github.com/giacomocavalieri/graph is beautiful.
- Questions are modeled as node values
- Answers are modeled as edge labels

Problem: The answers per question are unsorted.

Solution: As long as answers are unique, there is exactly
one lexical order. There are n permutation to the lexical 
order of answers. An integer 0..n-1 selects the desired
permutation. We can implement this with a "shuffle" button.
Alternatively, we can add an optional "ordinal prefix" (default: "")
to each answer.

Just finalized the designs. Or did I?
- No nesting. I.e. "Enter" confirms edit and goes to next hole.
- Scrolling changes selection. Yes, that is against good taste
  but it's cool and it's done in the DB navigator app.
- Up/Down and Enter/Shift+Enter navigate through the sequence.
  This may be a nesting or a graph edge.
- Left/Right navigates through the fields of the current type.
  This may be alternatives, list elements, or parameters.
- A list can define its orientation (horizontal or vertical) so then
  we can define:
  - Single-choice options are horizontal
    - They are nonempty lists so we can create forms
  - Multiple-choice options are vertical
    - They are also nonempty lists which sepread horizontally
- Alternatively, we keep it simpler and define each allowed
  variant as a record, with
  - List entries horizontal, with the rightmost hole being "_" for "new"
  - Record fields vertical

This seems to make most sense. Alternatives can be put in the
margins (wide screens) or a property pane (narrow screens).
Alternatives can be accessed with ENTER.

For example, I add an Answer by typing "Other:", then I
press Enter to select an alternative type for this string (INPUT).
Similarly, I select an arrow under my answer, then hit ENTER
and type the intended destination node.

To make it consistent, each time I press ENTER, I get to type.
For limited selections, I use number input. Perhaps we want to use
different selection methods on touch devices. It could be shiny
to show a numpad (0..9) which actually has clickable buttons.
Each number contains one option. Typing that number selects it.

Or a grid:

```
 U I O
  J K L
N M ,
```

Then typing ENTER would be unnecessary. The numpad would appear
on the side of the screen on large screens, and on the bottom on
small screens.

2. Define views for each type, making the holes interactive

3. Add a database

4. Publish


### **A.T.M.**: Share the wealth within your community

How it works:
- Connect with peers you trust
- Form "ATM"s with them
- Deposit money if you currently have more than you need
- Withdraw money when you need it, and receive it instantly
- Never feel bad about your money situation again!

## Thoughts about UX and data patterns in an app

- Apps exist within the internet and within communities. Their purpose always lies in leveraging the infrastructure to foster liberatory community practices:

```
Liberatory   |→ App story, Epic        ←→   App vision
community    |                                ↓     ↓
practice     |→               Community/User story  ↓
                                              ↓     ↓
                                        Implementation cycle
                                                 ↓
                      Appropriation by the communities
```

#### UX Patterns

- The UX is a composition of UX patterns and can be formalized as such.

- Patterns are grounded in practical experience. Their creation is neither invention nor generalization but something more akin to "finding the typical exception".

- Since patterns strive beyond conventions, they sit halfway outside of their field, and poetic naming is unavoidable.

#### Data

- Data is matter shared by groups of people and machines. It always comes in a form/representation.
  - Units of data can often be composed and split without any loss of information
  - Units of data can often be trans-formed
  - Code can be regarded as recipies for such trans-formation
  - Data abuts unruly interfaces (such as "users")
  - Data makes sense only in the context of unruly interfaces (otherwise it effectively equals `Unit`)

#### Software

- The task of software is to open a space for the unruly interface
  - Software can exclude through barriers
  - Software can frustrate through misguidance
  - Software can manipulate through suggestion

----






# jj

Graphical CheatSheet <3 <3 https://justinpombrio.net/src/jj-cheat-sheet.pdf

# Zed

## Shortcuts

### UI

- Ctrl Shift O shows symbols/outline
- Ctrl Shift V shows preview
- Ctrl B and Ctrl Shift B toggle left/right panels
- Ctrl+Shift+E opens the project explorer <- -> =>

### Selection

- Shift Alt Left/Right: expand/condense selection