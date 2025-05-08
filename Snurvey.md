◤ [Community experience patterns](./CommunityExperience.md)
◤ [UX pattern "A bundle of stories unfolding around me"](./StoryBundle.md)
◤ [Motivation: Compose pattern sequences into pattern languages](./ComposingPatterns.md)

# Snurvey: App prototype for co-authoring story bundles

- [x] Design [a UX pattern where the co-authors are poisitioned within the stories they are writing](./StoryBundle.md).
- [ ] Implement it in a well-documented, declarative, small prototype (under 5000 lines of code)
- [ ] Test this app with 5 users and find out: **How do co-authors navigate and collaborate when they have an interface that centers the story they are writing?**

## Features

**As authors**, we open `snurvey.org` and start writing our stories.
- We can alternatively **remix** (branch off) any survey so we don't need to start from scratch.
- We **invite more co-authors** by sharing our symmetric key in a Link or app-generated HTML file.
- Anyone of us can **publish** a snapshot of the survey in a Link or HTML file and share it with prospecting respondends. The snapshot contains a public key and the publisher receives the corresponding private key. We can still edit the survey later (although this is only recommended in emergencies).

**As a group that co-creates a response** to the survey, we can navigate the questions and choose answers.
- We can **remix** the survey to start editing a copy (-> becoming authors)
- We can **invite more co-respondents** by sharing my symmetric key in a Link or app-generated HTML file.
- When we're done, we can **submit** our response. We can still edit and re-submit it later.
The submitted response, together with the respondent key, will be encrypted with the public key.

**As the publishers** of a survey, our survey will show us all responses as they are submitted.
- We can **explore** the responses.
- We can **export** the responses in CSV format.

## Implementation

- `yjs` implements [Local-first shared data structures](Snurvey#Local-first), [Mutual awareness](Snurvey#Mutual awareness) and [infinite undo and redo](Snurvey#Infinite undo and redo). It is backed by the in-browser `indexedDB` for offline persistence.
- `secsync` implements [Confidentiality](Snurvey#Confidentiality) and [Anonymity](Snurvey#Anonymity)
with an end-to-end encrypted yjs backend. There will be no domain-specific logic on the backend.
- Symmetric keys can be exchanged over
- We will build a SPA in Gleam/Lustre that processes the a multi-cursor survey data structure and renders the UX.

**Synchronization and persistence backends**

### Confidentiality

We can use [a `secsync` backend](https://www.secsync.com/) as ([Code here](https://github.com/nikgraf/secsync/tree/main/examples/backend)) to synchronize users over websocket channels with End-to-end encryption. It stores unencrypted metadata and encrypted updates and snapshots in a Postgres database. Actual content (structure, questions and answers of a survey) will never be stored or processed unencrypted. [Read more about security and privacy considerations on their docs](https://www.secsync.com/docs/security_and_privacy/considerations). Alternative (but probably more involved) solutions for e2ee synchronization of our CRDS include [`Matrix`](https://github.com/yousefED/matrix-crdt) and [`Gossip`](https://github.com/marcopolo/y-libp2p).

0. **Authoring a survey**
- Client 🔑 generates a survey-specific symmetric key for encrypting all edits
- Client offers a 'co-author' link `https://snurvey.net#{authoring_key}` (Note that the hash is not sent to the server)
- Author can share this link with co-authors through safe channels such as `Signal` chats
- `secsync` server 🔒 synchronizes the encrypted edits under the fingerprint of the symmetric key (`ws://snurvey.net/{fingerprint_of_authoring_key}`)

1. **Publishing a survey**
- Client 🔑🗝️ generates a snapshot-specific asymmetric key-pair and stores it in the survey
- Client 🔐 encrypts `private_key` with `authoring_key` and stores it in the survey to share it with co-authors
- Client offers an 'add your response' link `https://snurvey.net#{public_key}` (Note that the hash is not sent to the server)
- Author can share this link with prospective respondents publicly

2. **Responding to a survey**
- Client 🔑 generates a response-specific symmetric key for encrypting all edits
- Client offers a 'co-respond' link `https://snurvey.net#{response_key}` (Note that the hash is not sent to the server)
- Respondent shares this link with co-respondents through safe channels such as `Signal` chats
- `secsync` server 🔒 synchronizes the encrypted edits under the fingerprint of the symmetric key (`ws://snurvey.net/{fingerprint_of_response_key}`)

3. **Submitting a response**
- Client 🔐 encrypts `response_key` with `public_key`
- Client pushes the `asymmetrically_encrypted_key` to the collaborative list at `ws://snurvey.net/{fingerprint_of_public_key}` so that it can be found by publishers and other respondents

4. **Observing the results**
- Client 🔓 decrypts the `asymmetrically_encrypted_key`s from `ws://snurvey.net/{fingerprint_of_public_key}` with `private_key` to yield all `response_key`s
- Client loads each respons from `ws://snurvey.net/{fingerprint_of_response_key_n}`, encrypts them `response_key_n`, and displays the results in a nicely layouted table. _Note: This may take a while and eat a lot of Ram if processing many new responses at once. But as far as I can tell, it's the most minimalistic. No caching of intermediate views. The client can cache tabular results for decoded responses, but that cache needs to get invalidated any time a response is revised. I'm curious about real-world limits. Maybe in the 10k-100k range for responses per survey?_

### Anonymity

The app will never ask for, or store, a user's name or identity. It will store all keys that a user has selected, unencrypted, in the browser's indexedDB, together with the encrypted latest snapshots and unsynced edits of their surveys. This enables persistence beyond browser restarts without any server-side authentication. Users working on machines where third parties can read the local indexedDB, they can instead use an url-encoded key (a link with a verbatim key in the hash), to gain access to their remote survey.

### Local-first and collaboration

The most recent surveys a user is editing are persisted in the browser's indexedDB. Users can work offline as long as they want. Surveys shared between collaborators eventually become consistent. [You can learn more in `secsync`'s _Use cases_ section](https://www.secsync.com/#use-cases) and [the `yjs` indexedDB database provider docs](https://docs.yjs.dev/ecosystem/database-provider/y-indexeddb).

### Mutual awareness

Users can see each other live, as they are navigating through the same survey and editing it.
[Here is how `yjs` implements this feature](https://docs.yjs.dev/getting-started/adding-awareness).

### Infinite undo and redo

Given they keep their keys, users can always undo any of their past edits. Even if an author publishes a survey, they can still undo their edits, and anyone opening the survey will eventually receive these changes when they are online.
[Here is how `yjs` implements this feature](https://docs.yjs.dev/api/undo-manager)

-----

**App prototype**

### Experimental data structure

**Represent a survey as a bundle of stories**
- Uniqueness: Each story is a unique sequence of questions.
- Connectedness: Each question has a list of answers. Each answer is part of at least one story. Each story can be reached from any other story by choosing different answers.
- Order: If in one story, a question A leads to a question B, there can never be a story where question A comes after B.
- Multi-positionality: Every currently connected user's cursor is a center of their story bundle, and their peers are positioned in relation to that position.

### Experimental UX

**Let multiple users edit the bundle simultaneously**

-----

### Part of the Commons

- A CreativeCommons NonCommercial license saves the Code from being used for profit purposes.
- This project was inspired and motivated by projects in the Commons:
  - Federated Wiki
  - The Hologram
  - Pattern language of Commoning
- I'm happy about you chiming in. Leave a comment in [the `Issues` section](https://codeberg.org/upsiflu/learning-and-experimenting/issues) or better: [write me on Mastodon](@flupsi@degrowth.social)!

🐐💨
