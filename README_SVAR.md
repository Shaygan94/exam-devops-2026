# exam-devops-2026

# OPPGAVE 1A
For å bygge og starte containeren slik at den lytter på 'localhost:9999' kjør dette i bash:
docker run -p 9999:8080 


# Oppgave 1B 
Tagging-strategi:
Brukte commit-SHA (git rev-parse --short HEAD) og latest for image tagging. 
Commit-Sha:Sørger for full sporbarhet og revisjonskontroll ved at docker-imaget i ECR er knyttet til en spesifikk commit i kildekoden.
Latest: Brukes for enkel referanse til den nyeste versjonen av applikasjonen

Lenke etil grønn kjøring Github Actions: https://github.com/Shaygan94/exam-devops-2026/actions/runs/41092765216

# Oppgave 2c
Det er fornufting at terraform kjører etter at containeren er builda, fordi infrastrukturen trenger den nye Docker-imagetaggen for å vite hvilken versjon av applikasjonen som skal rulles ut. Hvis terraform hadde kjørt før eller parallelt, ville ikke imaget finnes enda. 

#Oppgave 3a

Timer-metrikker
- app.rekognition.duration måler responstid for rekognition-kallet 
- app.bedrock.duration måler responstid for Bedrock-kallet

Business-metrikker
- app.gifts.suggested.total (counter). Totalt antall giftforslag generert. Sier noe om faktisk bruksvolum(ikke bare antall kall).
- app.gifts.suggestion.per.analysis (distributionsummary). Antall forslag per analyse. i AI prompten er det "inntil 5" i en tekstinstruksjon uten en hard grense. Metrikken vil avdekke om AI'en faktisk følger dette. Dette kan vi bruke som alarm i 3B.
