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
jj describe -m 
```