# Snapper
Snapper är ett verktyg för att hantera Btrfs-snapshots (främst på openSUSE, men fungerar på andra distributioner med Btrfs). Det skapar automatiskt tidsbaserade snapshots (timeline snapshots) – t.ex. timvis, dagvis, veckovis – och kan också rensa dem automatiskt enligt regler du sätter.

För att få kontinuerlig, automatisk rensning av dessa automatiskt skapade snapshots gör du så här:

### 1. Kontrollera nuvarande konfiguration
De flesta system (särskilt openSUSE) har redan en standardkonfig för root-filsystemet.

Kör:
```bash
sudo snapper list-configs
```
Vanligast är konfigurationen `root`. (Om du har andra, t.ex. `home`, upprepar du stegen för dem.)

Sedan:
```bash
sudo snapper -c root get-config
```
Leta efter dessa nycklar:
- `TIMELINE_CREATE="yes"` – skapar automatiska timeline-snapshots.
- `TIMELINE_CLEANUP="yes"` – aktiverar automatisk rensning av timeline-snapshots.
- `TIMELINE_MIN_AGE="1800"` – minsta ålder (i sekunder) innan en snapshot får rensas.
- `TIMELINE_LIMIT_HOURLY="10"` – hur många timvisa snapshots som behålls.
- `TIMELINE_LIMIT_DAILY="10"` – dagvisa.
- `TIMELINE_LIMIT_WEEKLY="0"` – veckovisa (ofta 0 som standard).
- `TIMELINE_LIMIT_MONTHLY="10"` – månadvisa.
- `TIMELINE_LIMIT_YEARLY="10"` – årsvisa.

### 2. Aktivera och konfigurera automatisk rensning
Om `TIMELINE_CLEANUP` inte är "yes", eller om du vill ändra gränserna:

```bash
sudo snapper -c root set-config TIMELINE_CLEANUP=yes
sudo snapper -c root set-config TIMELINE_CREATE=yes  # om du vill ha automatisk skapelse också

# Exempel på rimliga gränser (anpassa efter hur mycket plats du har):
sudo snapper -c root set-config TIMELINE_LIMIT_HOURLY="5-10"
sudo snapper -c root set-config TIMELINE_LIMIT_DAILY="7-14"
sudo snapper -c root set-config TIMELINE_LIMIT_WEEKLY="4"
sudo snapper -c root set-config TIMELINE_LIMIT_MONTHLY="12"
sudo snapper -c root set-config TIMELINE_LIMIT_YEARLY="2"
```

Du kan sätta intervall, t.ex. `"5-10"` betyder behåll minst 5, max 10.

### 3. Se till att systemd-timers körs (kontinuerlig drift)
Snapper använder två systemd-timers för att detta ska ske automatiskt:

- `snapper-timeline.timer` – skapar nya timeline-snapshots (varje timme som standard).
- `snapper-cleanup.timer` – kör rensning dagligen (kollar alla cleanup-regler).

Kontrollera status:
```bash
systemctl status snapper-timeline.timer
systemctl status snapper-cleanup.timer
```

Aktivera dem om de inte redan är aktiva (på openSUSE är de oftast det):
```bash
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

### 4. Extra cleanup-typer (valfritt)
Förutom timeline finns:
- `number` – rensar gamla pre/post-snapshots från t.ex. zypper/yum/dnf-transaktioner.
- `empty-pre-post` – rensar tomma pre/post-par.

Aktivera dem om du vill:
```bash
sudo snapper -c root set-config NUMBER_CLEANUP=yes
sudo snapper -c root set-config EMPTY_PRE_POST_CLEANUP=yes
sudo snapper -c root set-config NUMBER_LIMIT="2-10"  # t.ex. behåll 2–10 äldsta pre/post-par
```

### 5. Testa manuellt
Du kan köra rensning direkt för att se vad som händer (det är säkert, snapper visar först vad den tänker radera):
```bash
sudo snapper cleanup timeline    # bara timeline
sudo snapper cleanup number      # bara pre/post
sudo snapper cleanup all         # allt
```

### Sammanfattning
När `TIMELINE_CLEANUP=yes`, lämpliga `LIMIT`-värden är satta och `snapper-cleanup.timer` är aktiv så rensas automatiskt skapade timeline-snapshots kontinuerligt (dagligen). Systemet behåller bara det antal du anger och tar bort äldre än gränserna.

Detta frigör plats automatiskt utan att du behöver ingripa manuellt. Kolla platsanvändning med `sudo btrfs filesystem df /` eller `snapper list` för att se snapshots.

Om du har en annan distribution eller specialkonfig – säg till så kan jag förfina råden!
