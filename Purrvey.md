
# Purrvey

An app for making Surveys.

- No log-in. No profit (CC-NC). Confidentiality (all your answers are encrypted with )
- As a survey author, concentrate on the storylines, not on technical details.
- The code is FOSS, the app is experimental, and I'm happy about you chiming in!

## Functionality

### Authoring

**As an author**, I open purrvey.org and start writing my stories.
I can click "Publish" to take a snapshot of the survey. The server will generate a
private and a public key specific to the survey.
I can copy the resulting "Invite participants" link and share it with participants.
I can check the "Results" tab, unlock the encrypted answers with my private key,
and copy the results data into a table. If I open the results on the same browser/
device I used for publishing the snapshot, the decryption is automatic.

If I want to change something, I can click "remix" to edit a copy of the survey.
I will have to tell participants to re-enter their data or I make a special "addendum"
survey for those who have already filled the old version.

### Responding

**As a participant**, I open my invitation and start answering.
Each answer is immediately encrypted and sent to the server. When I edit my response,
the new response is sent
I can click "remix" to create my own copy and become an author.

## Architecture

- A full-stack container written in Lustre
- Prerendered entrances (SSG) with hydration. Around 100k total load weight for any survey.
- Each text (future: images and attachments, too?) is stored under its checksum on the server. Only
  the data visible on the entrance is rendered into the SSG Html.
- Publishing a survey makes it accessible under its checksum ("invite link"). All surveys can be remixed.
- A survey stores the checksums of content files instead of the content itself.

### Confidentiality

The server will never store unencrypted answers. Draft surveys are stored unencrypted.

1. **Publishing a survey** -
When publishing a survey, the server creates a public and a private key.
The author can store the private key on a drive or in their browser's localstorage.
The public key is stored with the published survey.

2. **Filling out a survey** -
The web client caches answers unencrypted in the localstorage.
Before sending them to the server for archival (under the ckecksum of its unencrypted content,
the web client encrypts the respondent's answers with the public key. If a respondent revises an
answer, the new version is sent to the server with a reference to the old version's checksum.

3. **Decrypting the results** -
The author loads the "Results" page from the server. The included answers are encrypted.
With the author's private key, the web client can decrypt and show the results.

### Anonymity

The server will never store ask for a user's name or identity. To identify connected clients, it issues a
funny avatar at client startup.

### Persistence

**Offline-first**
- All surveys you are editing are stored in localstorage. The datatype is wrapped in an Undolist, meaning that
  each survey contains its full history.
- You cannot continue filling out the survey on a different device unless you know how to port your localstorage

**Collaborative authoring**
- Every survey starts as an unecrypted draft. Drafts are accessible through a unique address that is generated
  on creation (UID). Everyone who knows the UID can open the draft and edit it immediately.
- Collaborators are visible to each other (presence).
- Edits are inserted to the queue by each client according to an eventually consistent algorithm. This should be
  easy to implement because the data format is relatively simple.

### Undo history

This type accepts a list (history) of edits, an initial state, and a way to apply a single edit on a state.
It can compute and the **current_state()** from the edit history.

There are three ways to apply edits. They will affect what **undo** and **redo** do to the editlist:
1. **do** - I can undo this edit directly.
2. **navigate** - When I undo the previous `do`, all intermediate `navigate` edits are undone.
3. **remote(name)** - Not undoable. `undo` skips it.

**Memoization**

The last computation is kept in memory so that additional edits are quick to compute.

**Collaboration**

Our goal is to have an eventually consistent edit history. For this purpose, we have a serverside function
**broadcast(context: checksum, tail: [#(name, edit)])**. It will send the last `n` edits. For its own edits, it
will also broadcast its server-supplied name.

**Edit list simplification**

Long-running session may require pruning.
(a) Delete some history
(b) Simplify the history

**Alternative approaches**
- A zipper of discrete states is another valid option. If we can store the model as bytes, it can store
diffs instead of typed Edits. This way, we avoid the complexity and narrowness of a DSL. We can have
a "describe" field for the client to tell their intentions. This solution seems more extensible and flexible,
especially once we have outdated clients in the wild.
- I have a hunch that yjs has the primitives we need. Then we don't need to make our DIY eventual
persistence. ...google... and yep: `YUndoManager` in [`ygleam`](https://github.com/weedonandscott/ygleam)

### SSG and hydration

Each