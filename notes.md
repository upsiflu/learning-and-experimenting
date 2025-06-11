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


### **A.T.M.**: Distribute money within your communities

## How it works

1. Connect with peers you trust
2. Form an A.T.M. with them
3. **Deposit money** any time you have more than you need
4. **Withdraw money** whenever you need it (and receive it almost instantly)
5. Never feel bad or worried about your money situation again!

## Preconditions

- Sometimes some of us are in dire straits, but overall, we have an **abundance** of wealth. We don't need or want to hoard money individually (for example because it makes us sick or because we don't believe in "earning" money)
- We **trust** the community to make good money decisions. I may have some ideas where we put our money, and so do my friends. We don't need hierarchies or majority decisions because we trust each member of the community to make the right call, and we can always talk to each other.
- We acknowledge that wage-labor and debt and violent dispossession are the tools of the ultra-rich and the warlords to exploit the planet and all living beings. Among each other, we can simply gift instead of sell. But when we want to interact with money-based economies, we need to cultivate money-practices that serve our communities and not the extraction-machine.

## Scope

**How can a community with TRUST and ABUNDANCE manage money?**

The A.T.M. is one way to deal with money in a less harmful way than, say, having private bank accounts. Participants of an A.T.M. simply tell each other, "I have more money than I currently need", or "I need more money than I currently have", and then they transfer money among each other.

Many of us grew up with the idea that money has to be earned. The flipside being that poverty is your own fault. But we clearly see that poverty and dispossession and inequality and scarcity are created by the wealthy in order to enslave the global majority. So let's decouple money from individual "financial success" and instead celebrate our collective abundance. There are many viable practices of collective finances. 

**Here's what makes the A.T.M. special:**

1. **Autonomous:** Every participant of an ATM is only accountable to themselves. No majority decisions, no scrutiny or judgement.
2. **Informal:** We don't need banks or contracts. We build on the mutual trust and care and love and patience and capacities we already have.
3. **Temporary:** A.T.M.s are meant to fail. Leave when you feel like it, with grace. The risk is quite limited for everyone.

The A.T.M. does not come with instructions on how to spend or get money, or how to self-organize as a community. That's outside of the scope. It's just about distributing money within a community in an easy and useful way.

## Should we start an A.T.M.

... or find a different way to manage money collectively? 

1. You have **strong mutual trust and some financial abundance** within the group? Only then: YES, start your A.T.M!
2. You still need to build trust, but have a shares purpose? Then find a more formal way to make decisions about collective spending.
3. You have trust and shared purpose but no abundance? Probably, fundraising, Soli events, or (careful!) seeking NGO money are ways for you to get the money you need
4. You have abundance but no mutual trust? Then be charitable and give to fundraisers.
5. You have strong mutual trust but neither shared purpose nor financial abundance? Leave Babylon immediately and live the rest of your lives on the rainbow gatherings. Or join some industrious community if that's more your thing.

## Comparison

Why not keep **a shared bank account**?

- **Discrimination:** With a shared bank account, the bank manages the access. This enforces a specific scheme for decisionmaking. In addition, banks manage credit ratings of everyone, and report to governments and private corporations. With an A.T.M., all those players are out of the equation. It's just the community and some money. You can decide how to make decisions. And nobody is barred from access due to low credit rating or political discrimination.
- **Speculation:** With a shared bank account, the bank is using the deposited money to speculate on the market, contributing to wars and climate change. In contrast, with an A.T.M., your money 100% goes towards community causes instead.

Why not have **a jar with money**?

- **No idle money:** Once you put money into the jar, it just sits there (until someone has a use for it) In contrast, when you use the A.T.M., you still have all your money on your own account (or purse). If you get an unexpected invoice, you still have the money you need. Only when someone in the community withdraws the money to use it, you actually transfer it. The collective wealth in the A.T.M. is not actual money but rather the promise of money. By the way, this is similar to how banks "create" money.
- **Move money around:** An A.T.M. can span many locations. You can share money with friends in different continents. The only precondition is that there is a way to make money transfers once someone "withdraws" money.

Why not **make collective decisions about spending**?

- This can work, too. You can form an informal collective and manage part of your money in a regular budget circle. What's special about the A.T.M. is that it allows each peer completely autonomous decisions. It's your decision what model works best for each of the communities you are part of. In communities with a shared purpose, the collective decisionmaking model might work better, whereas in a community based primarily on mutual trust, the A.T.M. may give each of you more agency and simplicity.

Why not **just transfer money directly to those in need**?

- This is what I see a lot in the communities. People and groups in need start a GoFundMe campaign or a fundraiser, and those who have more than they need chime in with their money. In rarer occasions, people who just got big money themselves ask around who needs money. In an A.T.M., you can skip much of the work. You just **deposit** or **withdraw**, and that's it. No need to create elaburate narratives for a fundraiser, no need to compete with fellow fundraisers, no need to ask everyone if they need something. **It's the same, just easier**.

## Questions and Answers

**Our A.T.M. is dead.** What can we do?

Is seems you either ran out of money or out of trust. Just start over with new constellations. A.T.M.s are meant to be short-lived!

**One of our members always withdraws all of the A.T.M. money!**

Good for them :-)

Also, if their neediness makes you uneasy, ask yourself whether you still want to be in an A.T.M. with them. From my side, you don't have any moral obligations.

**Can I deposit money I don't actually have?**

Yes, but it's risky. In case someone withdraws your deposit, one of the following may happen:

(a) You take an expensive loan from your bank to fulfill the trasfer of money

(b) You cancel the transfer (undoing your deposit)

Both may lead to frustration and less mutual trust. Only go that route if you are sure you will be able to fulfill the transfer, and be frank about it with your peers.

In the future, it may be interesting to distribute risks collectively (like the banks and nation-states do).

**Can I leave an A.T.M.?**

Yes, at any time, with grace, and without an explanation. It's part of the deal.

**Do I need to justify my spending?**

Yes, always! But only to yourself. Your A.T.M. community trusts you to do the right thing. And your peers are always there to if you need their help with financial decisions. But they will never scrutinize and judge your call. That's really what sets this form apart from other ways of collective finance.

**What does "A.T.M." mean?**

It means "Autonomous Collective Liquidity Machine", abbreviated _ColFin_ (like the dolphin, just with collective fin(ance)s). Alternative spelling: CoFi Machine. It can be automated.

Joking aside, yeah, the name A.T.M. _is_ kinda lame. Please send better ideas!

**Do I need to install an app to join an A.T.M.?**

No. We have a functioning A.T.M. that uses a Signal chat, and we could do the same by telephone or on a sheet of paper. An A.T.M. requires very little bookkeeping. You just have to remember the current amount of **deposit** for each participant, and any time there is a **withdrawal**, some algorithm decides who transfers their deposit to fulfill it. Also, you cannot withdraw more than there is in deposits. And when you withdraw all of your deposit, it just makes deposit equal zero (no actual money transfer needed).

(I'd love to make an app, though. Just to make it even more convenient and safe.)

**What? Algorithm?**

Yes. When there is a withdrawal, someone has to pay. To prevent confusion, the community has to decide upfront how they share the transfers. The easiest algorithm ("Quickest responder") just says, once a depositor sees there is an open withdrawal, they immediately fulfill it.

Here is a list of some useful algorithms:

- "Quickest responder": When there is a withdrawal, the quickest depositor to respond pays. If the withdrawal is larger than that deposit, the next depositor to respond pays. Etc.
- "First-in-first-out": When there is a withdrawal, the oldest deposit has to pay it. If the withdrawal is higher, then the second oldest deposit pays. Etc.
- "Last-in-first-out": When there is a withdrawal, the most recent deposit has to pay it. If the withdrawal is higher, then the second most recent deposit pays. Etc.
- "Dice roll": When there is a withdrawal, a dice roll decides which deposit needs to pay. If that deposit is not enough, the procedure is repeated. And so on.
- "Equal share: When there is a withdrawal, each deposit is reduced by the same percentage.

There are also a lot of possible-but-not-useful algorithms. For example, an algorithm "Fairness" would keep a record of past transfers and try to balance everyone's share. This runs counter to the whole idea of the A.T.M.



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