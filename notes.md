# Notes

## Initial choices

Since this is an experimental repo, I'm toying around with the hottest stuff here :-)

### Languages and libraries

- **Gleam** functional, strongly typed metalanguage
  - **Lustre** full-stack MVU framework
  - Server compile target: **Erlang on the Beam**
    - **rebar** (for tests and more?)
  - Client compile target: **JavaScript**
    
### Tooling

- **Zed** because it's beautiful
  - **Gleam language server** for static analysis
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
