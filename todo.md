# TODO

## Login
- Zowel bij API als bij ELO inloggen
### Error handling:
- Verkeerde email [x]
- Verkeerde wachtwoord [x]


## Login flow
1. invoeren gegevens
2. laat spinner / loading zien
3. Probeer in te loggen bij de api
4. Als er niet ingelogd kan worden dan wordt de error getoond
5. Als er wel ingelogd kan worden sla de gebruikersnaam + wachtwoord op in sharedprefs
6. Stop de api token in de auth_helper en log in op de ELO om cookie op te halen
7. Stel de auth_helper in zodat de rest van de app weet dat er is ingelogd

## Onboarding
Zodra login flow klaar is kan de onboarding beginnen
Hierbij worden de API settings opgehaald en kan de gebruiker kiezen of hij/zij deze wil aanpassen


Settings die opgehaald worden zijn:
```
- de ingestelde klascodes
- Kleur van elke klascode (Hoe zit de mapping?)
- Of de klascode zichtbaar is?
```

1. Toon alle ingestelde klascodes
2. Laat de gebruiker ze aanpassen/nieuwe toevoegen


