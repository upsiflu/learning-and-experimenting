# Geteiltes-Geld-App

_Lizenz dieses Konzepts: [CC-BY-NC-4.0](https://spdx.org/licenses/CC-BY-NC-4.0.html)_

Das Konzept: eine kleine Gruppe von Freund:innen findet sich zusammen, um Überfluss zu teilen. Wer Geld über hat, tut es in eine virtuelle Kasse. Wer Geld braucht, bedient sich daran. Erst dann wird das Geld überwiesen -- ohne Bedingungen.

In mehreren Gruppen praktizieren wir das schon seit einigen Monaten erfolgreich. Wir haben weniger Angst vor Geldnot, wir wissen, was wir mit Geld tun, das wir nicht unmittelbar brauchen, und wir fühlen uns insgesamt weniger arm und weniger _schuldig_ (im doppelten Wortsinn).

Im Unterschied zu _gemeinsam verwaltetem Geld_ treffen alle Mitglieder der Gruppe allein die Entscheidung, wofür sie Geld verwenden. Es gibt keine Rechtfertigungspflicht (außer sich selbst gegenüber)

Im Unterschied zum _Common Wallet_ braucht diese Methode kein Konto, auf dem Geld geparkt wird, sondern nur eine möglichst reibungslose Geldtransaktionsmethode. Bisher haben wir über Signal-Gruppen kommuniziert und Geld manuell per Banktransfer oder PayPal verschickt. Taler wäre die ideale Infrastruktur, um kommerzielle Banken und faschistische Unternehmen ganz auszuschließen. Wir möchten einen minimalen Prototypen bauen, der folgende Funktionen bereitstellt:

- Kleine Gruppen bilden:
  - Peers zu einer Gruppe zusammenfassen
  - Peers zu einer bestehenden Gruppe einladen
  - Aus einer Gruppe aussteigen
  - Vollständig aussteigen und alle meine Daten löschen

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


  ----


  [-> Weitere Infos, auf englisch](https://codeberg.org/upsiflu/learning-and-experimenting/src/branch/main/ATM.md)