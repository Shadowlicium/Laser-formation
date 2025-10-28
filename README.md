# Projet-mise-en-place-formation

Le but de ce projet est de mettre en place un service Web qui permettra de déployer une instance afin de permettre la prise en main d'une machine distante pour le travail : 

le Stockage sera persistant car la machine sera supprimé après la fin d'utilisation, afin que vos données soit relié a votre nom

Le schéma de la structure pour le moment ressemblera a ça 

[Création de VM]

https://github.com/Shadowlicium/Laser-formation/issues/new?template=deploy.yml

Nécessite la Clé gpg publique : 

```
gpg --full-generate-key

gpg --list-keys

exemple

pub   rsa4096 2025-10-28 [SC] [expires: 2027-10-28]
      1234ABCD5678EF90AABBCCDDEEFF001122334455
uid           [ultimate] Shadowlicium <shadow@example.com>
sub   rsa4096 2025-10-28 [E]

gpg --armor --export shadowlicium > public.asc

On copie ensuite tout le contenu de public.asc et on le transmet dans le formulaire de demande
```
Il faudra ensuite attendre quelques minutes puis actualiser la page pour voir le liens a la VM demander
