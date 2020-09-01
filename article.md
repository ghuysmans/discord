L'interpréteur fait deux choses :
1. Il gère l'asynchrone et ressemble fort à une monade d'IO.
   Le contexte est sauvegardé automatiquement dans la fermeture ("fonction").
   L'inconvénient, c'est qu'on ne peut pas stocker ça sur disque.
     Pas vraiment en fait, Marshal accepte une option pour les closures.
2. Il distingue les utilisateurs.
   Je prends des paramètres la première fois en ajoutant le terme start ?
   C'est un genre d'input non interactif (donc run a besoin de l'info).

Le projet en contient plusieurs implémentations :
- le vrai bot Discord (l'objectif initial)
- une interface texte (testable localement, hors connexion)
- un testeur qui permettrait d'écrire naturellement des tests

Pour y arriver, il faut modéliser les interactions avec le serveur : plutôt que
d'utiliser des actions opaques (dont le résultat est une promesse), elles
doivent être prévues par la monade de dialogue. Certaines actions peuvent être
négligées, comme des accès réseaux (effectués normalement). Cela permet d'avoir
des tests qui vérifient que les rôles sont modifiés comme demandé, par exemple.

Le système décrit ici est indépendant de l'implémentation du serveur. Il serait
intéressant de regarder comment le généraliser d'autres backends : ce serait
bien de pouvoir écrire un programme de manière portable et de pouvoir utiliser
un genre de `map` pour simplifier la monade jusqu'à ce qu'elle soit compatible
avec une certaine implémentation concrète de serveur.

Il n'est pas toujours possible d'intercepter les messages : même sur IRC, un
bot n'est qu'un client, donc lorsqu'il reçoit un message, il est presque déjà
trop tard pour réagir. Si on pense au jeu du loup-garou, on n'a pas envie que
tout le monde entende le loup-garou désigner sa victime. Il faut donc envisager
deux mécanismes :
1. Le bot lit ce qui se passe dans un canal.
2. Le bot dialogue par messages privés.

Est-ce qu'on peut se contenter d'ajouter à la monade la distinction entre les
messages lus sur un canal et ceux reçus par messages privés ? Il serait
intéressant de voir comment implémenter une gestion de jeu de plateau
par-dessus la monade existante.
