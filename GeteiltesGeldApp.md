# Geteiltes-Geld-App

_Lizenz dieses Konzepts: [CC-BY-NC-4.0](https://spdx.org/licenses/CC-BY-NC-4.0.html)_

Das Konzept: eine kleine Gruppe von Freund:innen findet sich zusammen, um Überfluss zu teilen. Wer Geld über hat, tut es in eine virtuelle Kasse. Wer Geld braucht, bedient sich daran. Erst dann wird das Geld überwiesen.

In mehreren Gruppen praktizieren wir das schon seit einigen Monaten erfolgreich. Wir haben weniger Angst vor Geldnot; wir wissen, was wir mit Geld tun, das wir nicht unmittelbar brauchen, und wir fühlen uns insgesamt weniger arm und weniger _schuldig_ (im doppelten Wortsinn).

Im Unterschied zu _gemeinsam verwaltetem Geld_ treffen alle Mitglieder der Gruppe individuell die Entscheidung, wie sie das Geld verwenden. Es gibt keine Rechtfertigungspflicht (außer sich selbst gegenüber), und keine Bedingungen.

Im Unterschied zum _Common Wallet_ braucht diese Methode kein Konto, auf dem Geld geparkt wird, sondern nur eine möglichst reibungslose Geldtransaktionsmethode. Bisher haben wir über Signal-Chatrooms kommuniziert und Geld manuell per Banktransfer, bar, oder per PayPal verschickt. _Gnu Taler_ bietet die ideale Infrastruktur, um einen minimalen Prototypen zu bauen, der folgende Funktionen bereitstellt:

- Kleine Gruppen bilden:
  - Peers zu einer Gruppe zusammenfassen
  - Peers zu einer bestehenden Gruppe einladen
  - Aus einer Gruppe aussteigen

- Meinen Beitrag anpassen:
  - Virtuelles Geld einzahlen ("Diesen Betrag habe ich gerade über")
  - Meinen Beitrag reduzieren. Ist mein Beitrag negativ, startet automatisch der Prozess "Geld senden -> Geld erhalten". Die Summe aller virtuellen Beiträge innerhalb einer Gruppe ist immer mindestens 0,-.
  
- Geld senden:
  - Benachrichtigt werden, sobald jemand in einer Gruppe, in der ich einen positiven Beitrag hinterlegt habe, etwas abhebt
  - Dem Sendeprozess zusagen (die Höhe beträgt maximal 100% meines Beitrags; wird mehr abgehoben, so werden Einlagen anderer User angebrochen) oder stattdessen die App benachrichtigen, dass ich meinen Beitrag reduzieren muss
  - Die App autorisieren, Geld von meinem Konto an das Empfängerkonto zu senden oder stattdessen die Transaktion manuell durchführen und die App davon benachrichtigen
  - Falls nötig, meine Kontodaten angeben
  
- Geld erhalten:
  - Benachrichtigt werden, sobald jemand dem Sendeprozess zugestimmt hat
  - Die App informieren, dass ich das Geld oder einen Teilbetrag erhalten habe (das kann mit Taler wahrscheinlich automatisiert werden)
  - Falls nach einigen Tagen Geld, das gesendet wurde, nicht angekommen ist, startet die App automatisch eine Untersuchung.
  - Falls nötig, meine Kontodaten angeben

Die oben aufgelisteten Features haben wir bisher in unseren Signal-Chatrooms simuliert.

Darüberhinaus möchten wir Netzwerkeffekte untersuchen und dazu folgendes Verhalten modellieren und transparent darstellen:

- Am Überschuss benachbarter Gruppen teilhaben
  - Der Gesamtüberschuss aller direkt benachbarter (also durch mindestens eine Person verbundener) Gruppen wird zu 25% als "Nachbarschaftsüberschuss" dem Gruppensaldo angerechnet, der Gesamtüberschuss von Gruppen, die einen _hop_ entfernt sind (also höchstens mit benachbarten Gruppen benachbart) zu 12,5%, bei zwei _hops_ 6,25%, etc. Für den Gesamtüberschuss zählen nur die direkten Beiträge, nicht die jeweils berechneten Nachbarschaftsüberschüsse.
  - Beim Abhebenwerden zunächst Beiträge innerhalb der Gruppe angetastet. Wenn schließlich der Überschuss benachbarter Gruppen angetastet wird, dann sinkt deren sichtbares Saldo. Die Kehrseite des geteilten Überschusses ist also, dass benachbarte Gruppen die Beiträge einer Gruppe abheben können.

# Technische Umsetzung

_Gnu Taler_ bietet Komponenten, die Kernfunktionen für die geplante App implementieren:

- Jede Gruppe hat ein Konto, das individuelle Beiträge in beliebigen Währungen abbildet. Weil ein Beitrag virtuell ist, bis eine Transaktion stattfindet, handelt es sich um virtuelle Versionen der Währungen (Virtu-EUR, Virtu-USD, Virtu-SFR etc.)
- Die pro User zum Abheben verfügbare Summe soll in der Zielwährung möglichst realistisch live dargestellt werden. Zu berücksichtigen sind Wechselkurse und möglicherweise Transaktionskosten.
- User, die bei der GLS-Bank oder anderen kompatiblen Banken _Taler_ ein Taler-Wallet haben, können die App autorisieren, Transaktionen bis zur Höhe ihres hinterlegten Virtu-Geldes zu veranlassen.

Vor allem letztere Integration wird die App sehr einfach und komfortabel machen.

# Zielgruppe

**Eine Geteiltes-Geld-Gruppe ist nur möglich, wenn die Beteiligten bereits gegenseitiges Vertrauen mitbringen und Geld nicht mehr als Belohnung sondern als gemeinsame Ressource (Allmende) verwenden wollen. Sinnvoll wird das Konzept, wenn ab und zu jemand mehr Geld als nötig hat, und alle Beteiligten zumindest manchmal gemeinsames Geld an Dritte geben wollen oder müssen. Die App wird keine Zwecke, Bedingungen oder Verträge abbilden.**

Daraus ergeben sich klare **Ausschlusskriterien**:

- In einer Gruppe herrscht **steter Mangel**? Soli-Events, Fundraising und dergleichen bieten sich an. Oder Zusammenarbeit mit passenden institutionellen Trägern. Eine Geteiltes-Geld-Gruppe ist erst dann sinnvoll, wenn es ab und zu Überschüsse gibt.
- Einer Gruppe **fehlt es an tiefem gegenseitigem Vertrauen**? Dann sind formellere Rituale zur gemeinschaftlichen finanziellen Entscheidungsfindung nötig. Misstrauen würde eine Geteiltes-Geld-Gruppe spalten.
- Eine Gruppe hat **einen klaren Zweck**? Dann können Strukturen wie openCollective Finanzen transparent modellieren und der Gruppe helfen, Geld zweckmäßig zu verwenden. Eine Geteiltes-Geld-Gruppe wird erst dann sinnvoll, wenn der Verwendungszweck von geteiltem Geld offen bleiben und völlig in der individuellen Verantwortung liegen soll.
- Eine Gruppe möchte **Geld ansparen**? Dafür bieten sich Bankkonten und andere Anlageformen an. Natürlich kann eine Gruppe etwa Geld, das in schnell verkäuflichen Anlagen liegt, in der Geteiltes-Geld-Gruppe als Guthaben abbilden. Wird dieses Guthaben angezapft, muss die betreffende Person die Anlage liquidieren. Das Sparen selbst findet dann aber individuell bzw. über separate Absprachen und Kanäle statt und wird selber nicht in der App abgebildet.
- Eine Gruppe möchte ein **bedingungsloses Grundeinkommen** im Kleinen realisieren? In der Geteiltes-Geld-Gruppe werden Transaktionen nur ausgelöst, wenn jemand Geld abhebt. Automatische Transfers sind nicht vorgesehen. 

# Hintergrund

Seit einigen Jahren engagiere ich mich im "Hologramm"-Netzwerk. Wir organisieren selbstorganisierte, dezentrale gegenseitige Sorge, aufbauend auf den Erfahrungen und Konzepten der Solidaritätskliniken in Griechenland. Vier Leute finden sich zu einer Gruppe zusammen. Drei stellen einer vierten (dem "Hologramm") Fragen zu ihrer gesundheitlichen Situation. Sie selbst können je drei Sorgende finden; so entsteht ein Netzwerk, in dem alle Sorge erhalten. In einem lokalen Projekt, "Sorgende Netze Berlin-Buch", verknüpfen wir dieses internationale Sorgenetz mit lokalen Initiativen und Communities synergetisch.

Über Geld und Armut und gegenseitige Hilfe forschen und diskutieren wir in der Hologramm-Community seit einigen Jahren. Im vergangenen Jahr gaben wir zwei Menschen die Verantwortung für die Verteilung eines Teils der Gelder, die wir durch Spenden auf openCollective eingenommen hatten. Explizit waren diese Schatzmeister:innen nur ihrem eigenen Gewissen gegenüber verantwortlich. Dahinter stand unser Wunsch, Geld ganz von Gegenleistung zu entkoppeln und auf das tiefe Vertrauen aufzubauen, das wir in den Jahren aufbauen. Auch privat haben wir uns nach und nach von Ideen des "verdienten" Geldes getrennt und verschenken jetzt Geld, das wir überhaben.

Das vorliegende Konzept entstand in diesem Umfeld. Wie möchte ich meinen Überfluss teilen und am Überfluss meiner Community teilhaben? Nach ambivalienten Erfahrungen mit Common Wallet, Vereinskonten, privaten Fundraisern, Bieterunden und ähnlichen Tools hatte ich die Idee, alle Strukturen, die Verantwortlichkeit umlegen, Kreditwürdigkeit modellieren, Geld personalisieren oder Vertrauen ersetzen, radikal aufzugeben: es bleibt nur das bedingungslose Geben und Nehmen.

Meine erste Gruppe für geteiltes Geld entstand mit Cassie und Florence, mit denen ich durch langjährige Hologramm-Communityarbeit vertraut bin. Für uns ist es einfach eine selbstorganisierte, dezentrale, nicht-diskriminierende Struktur zum Geben und Nehmen. Aber genau wie das Hologramm wächst die Resilienz durch Netzwerkeffekte. Wir bauen neue Gruppen auf und über legen uns, wie z.B. Geld von Gruppe zu Gruppe wandern kann.

Aufgrund dieses Hintergrundes interessieren uns vor allem drei Aspekte:
- **Bedingungslose gegenseitige Hilfe mit Geld:** Kann eine Gruppe für geteiltes Geld aus der Prekarität helfen, die viele von uns krank macht? Wenn ja, unter welchen Bedingungen?
- **Mangel statt Überfluss:** Wie gehen wir innerhalb von Gruppen mit Armut und Mangel um - in einer Umgebung, wo chronische Bedürftigkeit stigmatisiert ist und Geld oft über Leben und Tod entscheidet? Was wenn weniger arme Menschen eine Gruppe verlassen, in der sie nur Geld an Ärmere verlieren?
- **Netzwerkeffekte:** Wie lassen sich gruppenübergreifende Transaktionen (automatisch oder manuell) transparent und kontrollierbar in einer App abbilden? Wie fühlt es sich für User an, wenn Beitragsüberschüsse einer Gruppe automatisch zum Teil in benachbarten Gruppen zur Verfügung stehen? Welche Netzwerkeffekte ergeben sich möglicherweise? Falls in der Tat der Gesamtüberfluss größer ist als der Gesamtmangel (zumindest was Geld betrifft): welche Ausdehnung muss dann ein solches Netzwerk haben, um Armut durch Diffusion völlig zu eliminieren?


  ----


  [-> Weitere Infos, auf englisch](https://codeberg.org/upsiflu/learning-and-experimenting/src/branch/main/ATM.md)