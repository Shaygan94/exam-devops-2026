# exam-devops-2026

# OPPGAVE 1A
For å bygge og starte containeren slik at den lytter på 'localhost:9999' kjør dette i bash:
docker run -p 9999:8080 


# Oppgave 1B 
Tagging-strategi:
Brukte commit-SHA (git rev-parse --short HEAD) og latest for image tagging. 

Commit-Sha:Sørger for full sporbarhet og revisjonskontroll ved at docker-imaget i ECR er knyttet til en spesifikk commit i kildekoden.

Latest: Brukes for enkel referanse til den nyeste versjonen av app'en

Lenke etil grønn kjøring Github Actions: https://github.com/Shaygan94/exam-devops-2026/actions/runs/41092765216