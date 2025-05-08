◤ [Community experience patterns](./CommunityExperience.md)
◤ [UX pattern "A bundle of stories unfolding around me"](./StoryBundle.md)

# Composing pattern sequences in(to) a pattern language

◢ [Prototype for testing](./Purrvey.md)

 In their [book _A pattern language: Towns, Buildings, Construction_, 1974](https://www.burg-halle.de/id-neuwerk/wp-content/uploads/2018/07/A_Pattern_Language.pdf), architects Christopher Alexander, Sara Ishikawa and Murray Silverstein provided the building blocks for redesigning mid-century England in a romantic vision. Their algorithm has been successfully applied in other fields: Cunningham and Beck identified [_Design patterns_ within the object-oriented paradigm in computer programming (1987)](https://c2.com/doc/oopsla87.html). In the 2010s, Silke Helfrich, David Bollier, Ward Cunningham and Jon Richter gathered a [_Pattern language of commoning_](http://makecommoningwork.fed.wiki) and published it on [Cunningham's _Federated wiki_](http://makecommoningwork.fed.wiki/view/federated-wiki) which arranges nodes in linear sequences.

 Pattern languages are gathered by researchers who identify, understand, and articulate composable community practices. An abstract description of a practice within the context of where it works is called a _pattern_. As patterns are linked to each other, they form a network that is called a _pattern language_. Communities can then use such a language to formulate designs by sequencing individual patterns according to some algorithm.

 > In short, no pattern is an isolated entity. Each pattern can exist in the world, only ot the extent that is supported by other patterns: the larger patterns in which it is embedded, the patterns of the same size that surround it, and the smaller patterns which are embedded in it.
 >
 > — _A Pattern Language_, 15

 Shifting from "intended outcome" to "situated process", [Alexander has since renamed pattern to _unfolding_](#unfoldings). In this text, I will use both words interchangably when describing formal structures. _Tarot_ is another special case of a pattern language, where each sequence is valid, usually found by chance, and often of length 3.

 How does a pattern language unfold when we see it as the implicit totality of distinct, sensible sequences? Focusing on a community of co-authors, how would they navigate and evolve their language? And how can we model and test such a setup as a collaborative user experience?

<!--toc:start-->
[[ComposingPatterns#Scope]]
[[ComposingPatterns#Patterns]]
[[ComposingPatterns#Relations]]
[[ComposingPatterns#Pattern languages]]
[[ComposingPatterns#Unfoldings]]
<!--toc:end-->

 ## Scope

 I am designing a simple data type and user experience pattern **for communities and groups** to **collectively traverse and compose** sets of **sensible, distinct, interconnected sequences** that implicitly outline **an evolving, extensible pattern language**.

 1. Formalize a sequence of patterns within a pattern language, with additional constraints
   - Under which conditions do sequences make sense?
   - Under which conditions are formally different sequences practically different?
 2. Sketch out an interface where the user is positioned within a set of stories, looking around, instead of above it (bird's-eye-view)
 3. Implement the corresponding collaborative (multi-cursor) datatype with a CRDT such as `yjs` and perform user tests to answer the research questions

 ### Modelling pattern language as the set of its stories (1)

 We tend to model pattern languages as an acyclic, ordered, directed graphs. But we rarely describe additional constraints on forming sequences of patterns. Which sequences of patterns actually makes sense? When is one sequence practically different from another?

 From here onwards, I will call such a distinct, sensible sequence within a pattern language a "story".

 Alexander et al. give an algorithm for generating sequences within an existing graph of patterns, describe some of these constraints. Can we formalize the constraints? For example, are all stories interrelated, or is the graph disconnected?

 Their algorithm helps identify good sequences within the language. Can we turn this around and let a language be the implicit totality of its explicit sequences?

 ### Centering the co-authors (2)

 Traditionally (and probably owing to the available media at the time), sets of patterns were created before they would be sequenced.

 TODO

 ### User research (3)

 TODO

 ## Patterns

 TODO: What is a pattern? What is not a pattern? What is the inner structure of a pattern? Etc.

 ## Relations

 TODO

 ## Pattern languages

 > A pattern language has the structure of a **network**. [...] However, when we use the network of a language, we always use it as a **sequence**, going through the patterns, moving always from the larger patterns to the smaller [...].
 Since the language is in truth a network, there is no one sequence which perfectly captures it. But the sequence which follows, captures the broad sweep of the full network; in doing so, it follows a line, dips down, dips up again, and follows an irregular course, a little like a **needle** following a tapestry.

 The structure and interface of the patterns Alexander et al. collected can be formalized as:

 - **A total order** (from general to specific) of patterns as nodes in **a directed, connected, acyclic graph**.

 > Alexander has shown that nontrivial languages can be organized without cycles in their influence and that this allows the design process to proceed without any need for reversing prior decisions.
 >
 > — _Oopsla87_

 - **Evolving throughout the time axis**: "[The patterns are] all free to evolve under the impact of new experience and observation.
 - **DIY** - Main purpose of presenting a pattern language is to inspire readers to "embark on the construction and development of [their] own language -- perhaps taking the language printed in this book, as a point of departure."
 - **Constant core, variable periphery** - "a part of the language we have presented here, is the archetypal core
 of all possible pattern languages"
 - **Poetry**: The meanings of several patterns should overlap within a sequence. "You may think of this process of compressing patterns, as a way to make the cheapest possible building which has the necessary patterns in it. It is, also, the only way of using a pattern language to make buildings which are poems."

 ## Unfoldings

 In his later work, Alexander transitions from patterns to what he calls _unfoldings_. While writing the 1974 book, his team decided to focus on static, atomic patterns instead of unfoldings to make it more digestible for contemporary architects who were unaccustomed to process-centric language. [In his later project _Living neighborhoods_, Alexander revises this decision:](https://www.livingneighborhoods.org/ht-0/whatisanunfolding.htm)

 > Unfoldings, which are dynamic in nature **embrace feeling**, and show us the world unfolding and becoming [...].

 ![Diagram of a typical angiosperm (flowering plant) unfolding, linked from the same website](https://www.livingneighborhoods.org/images/unfolding-angiosperm.jpg)

 *Diagram of a typical angiosperm (flowering plant) unfolding, linked from [https://www.livingneighborhoods.org/images/unfolding-angiosperm.jpg](https://www.livingneighborhoods.org/images/unfolding-angiosperm.jpg)*
