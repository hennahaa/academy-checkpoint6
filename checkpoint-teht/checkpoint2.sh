#!/bin/bash

PROJECT_ID="PROJECT-ID"
BUCKET="BUCKET-ID"

#kloonataan repo
git clone https://github.com/hennahaa/academy-checkpoint6.git

#kopioidaan kuva .-kansioon
cp academy-checkpoint6/kuva.jpg ./kuva.jpg

#poistetaan kloonattu repo
rm -rf academy-checkpoint6

#kopioidaan kuva buckettiin
gsutil cp ./kuva.jpg gs://$BUCKET

#luo Pipsa
gcloud iam service-accounts create pipsa-possu --display-name "Pipsa Possu"

#Anna Pipsalle luvat
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:pipsa-possu@${PROJECT_ID}.iam.gserviceaccount.com --role roles/viewer

#Luo Pipsan key
gcloud iam service-accounts keys create key.json --iam-account pipsa-possu@${PROJECT_ID}.iam.gserviceaccount.com

#asennetaan kirjastoja salaisuuksia varten
sudo apt-get -y install build-essential libssl-dev libffi-dev \
  python3-dev cargo

sudo apt-get -y install python3-openssl

#luodaan signed url ja tallennetaan se tiedostoon
gsutil signurl -d 10m key.json gs://$BUCKET/kuva.jpg > salaisuus.txt

#luodaan secret
gcloud secrets create pipsa \
    --replication-policy="automatic"

gcloud secrets versions add pipsa --data-file="salaisuus.txt"

#poistetaan salaisuus
rm salaisuus.txt