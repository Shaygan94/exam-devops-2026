# exam-devops-2026

# OPPGAVE 1A
For å bygge og starte containeren slik at den lytter på 'localhost:9999' kjør dette i bash:
docker run -p 9999:8080 


# Oppgave 1B 
Tagging-strategi:
Underveis senere i oppgaven oppdaget jeg at ECS ikke plukket opp nytt image ved push, til tross
for at både commit-SHA og latest ble pushet til ECR. Årsaken var at Terraform
ikke sendte SHA-taggen videre til task definition. Løst ved å sende commit-SHA
eksplisitt som Terraform-variabel slik at task definition endres ved hver deploy.

Lenke til grønn kjøring: https://github.com/Shaygan94/exam-devops-2026/actions/runs/42371750609

# Oppgave 2a
 Offentlig URL til tjenesten: https://wi-40b646c1b32242618c04acfba1c6bc89.ecs.eu-west-1.on.aws

# Oppgave 2b
Terraform state lagres i S3 med nøkkel: wishifai/13/terraform.tfstate. Dette gjøres i backend.tf 
Backend-konfigurasjon i Terraform støtter ikke variabler og derfor hardkodet jeg appnavn og kandidatnr. 

# Oppgave 2c
Det er fornufting at terraform kjører etter at containeren er builda, fordi infrastrukturen trenger den nye Docker-imagetaggen for å vite hvilken versjon av applikasjonen som skal deployes til ECS. Hvis terraform hadde kjørt før eller parallelt, ville ikke imaget eksistert enda. 

Lenke til grønn kjøring: https://github.com/Shaygan94/exam-devops-2026/actions/runs/41517134852

# Oppgave 3a

Timer-metrikker
- app.rekognition.duration måler responstid for rekognition-kallet 
- app.bedrock.duration måler responstid for Bedrock-kallet

Business-metrikker
- app.gifts.suggested.total (counter). Totalt antall giftforslag generert. Sier noe om faktisk bruksvolum (ikke bare antall kall).

- app.gifts.suggestion.per.analysis (distributionsummary). Antall forslag per analyse. i AI prompten er det "inntil 5" i en tekstinstruksjon uten en hard grense. Metrikken vil avdekke om AI'en faktisk følger dette. Dette kan vi bruke som alarm i 3B.

# Oppgave 3b

Dashboard heter `wishifai-13`
Datagrunnlaget er 40 curl-kall mot tjenesten (20 per bilde).

![CloudWatch-skjermbilde](media/cloudwatchImg.png)

#Rekognition and Bedrock latency
Viser maksimal responstid per min. Bedrock bruker ca 16-19 sek og Rekognition bruker under 1 sek. Bedrock er den klare flaskehalsen og forklarer grunderens bekymring om treg tjeneste. 

#Gift reccomondation per analysis
Viser gjennomsnittlig gaveforslag returnert per analyse. Prompten instruerer Bedrock om "inntil 5 gaver", og grafen bekrefter at modellen returnerer nøyaktig 5. 

#ECS CPU and Memory
Viser maksimal CPU og minnebruk for ECS-tjenesten. Memory ligger stabilt på 50% gjennom hele perioden. CPU viste en spike til 100% som virket uventet for Rekognition- og Bedrock-kall. For å undersøke kjørte jeg en ny test med 40 curl-kall uten deployment, og da holdt CPU seg lav og jevn gjennom hele testen. Dette bekrefter at spiken skyldtes redeployment, ikke Rekognition- og Bedrock-kallene.
Bildet under illustrerer CPU/Memory ved 40 curl-kall uten redeployment prosessen:
![CPU Memory Cloud](media/cpumemorycloud.png)
Det er greit å ha dette i bakhodet når man skal feks ha alarmer mot cpu bruk - å ta i betrakning at deployments vil bruke mye cpu, slik at alarmer ikke utløses på det. 

# Total sum gifts genereated
Viser totalt antall gavefroslag generert. Gir innsikt i bruksvolum og aktivitetsmønstre over tid. 

# HTTP Request Latency
Viser gjennomsnittlig responstid for POST /api/analyze-endepunktet, hentet fra Spring Boot Actuator.
![actuator](media/all5widgets.png)

# Alarm
`wishifai-13-gifts-over-5` varsler hvis Bedrock returnerer flere enn 5
gaveforslag i en analyse. Prompten sier "inntil 5", men siden dette er en
tekstinstruksjon uten hard kode-grense ønsket jeg å verifisere at alarmen
fungerte som forventet.

Første test bekreftet at modellen konsekvent returnerte nøyaktig 5 forslag
og alarmen forble grønn. For å utløse alarmen endret jeg prompten til
"nøyaktig 6 gaver". Bedrock fulgte instruksjonen og returnerte 6 forslag,
og alarmen gikk av som forventet.
![Alarm utløst](media/alarmProof.png)
![Nøyaktig 6 gaver](media/aipromptproof.png)


