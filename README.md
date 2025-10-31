# Projet-mise-en-place-formation

Le but de ce projet est de mettre en place un service Web qui permettra de déployer une instance afin de permettre la prise en main d'une machine distante pour créer plusieurs machines pour les étudiants en formations : 

Le schéma de la structure pour le moment ressemblera a ça 

[Création de VM]

https://github.com/Shadowlicium/Laser-formation/issues/new?template=deploy.yml

Nécessite la Clé gpg publique : 

```
gpg --full-generate-key

gpg --list-keys

#exemple

#pub   rsa4096 2025-10-28 [SC] [expires: 2027-10-28]
#      1234ABCD5678EF90AABBCCDDEEFF001122334455
#uid           [ultimate] Shadowlicium <shadow@example.com>
#sub   rsa4096 2025-10-28 [E]

gpg --armor --export nom_utiliser > public.asc

cat public.asc

#On copie ensuite tout le contenu de public.asc et on le transmet dans le formulaire de demande
```
Il faudra ensuite attendre quelques minutes puis actualiser la page pour voir le liens a la VM demander

---------------------------

## Processus de déploiement

Le processus se déroule comme suit :

Le runner GitHub est relié aux Issues, notamment à celle de la demande de VM, grâce à un tag commun entre les deux.
Les variables du nom d’utilisateur et de la clé GPG sont ensuite enregistrées dans les variables d’environnement du worker, qui lance alors le workflow.

Ce workflow définit la configuration de la machine virtuelle via OpenTofu et Cloud-Init, puis transfère le fichier généré sur Proxmox via une connexion SSH sécurisée.
Proxmox se charge ensuite d’héberger la machine.

La clé SSH de la VM ainsi que son nom sont ensuite renvoyés en réponse à la demande initiale.
La clé privée est chiffrée avec la clé PGP que vous avez fournie, puis déchiffrable uniquement grâce à votre propre fichier de clé GPG, vous permettant ainsi de vous connecter en toute sécurité à votre VM.
