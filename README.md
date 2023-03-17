# Appli_MIAGED
## Images de l'application:

# Travail effectué
### Interface de login : Critère d’acceptance

 Au lancement de l’application, une interface de login composée d’un headerBar qui contient le nom de l’application, de deux champs et d’un bouton m’est proposée.
  - Les deux champs de saisie sont : Login et Password.
  - Le champ de saisie du password est obfusqué.
  - Le label du bouton est : Se connecter.
  - Au clic sur le bouton « Se connecter », une vérification en base est réalisée.
  - Si l’utilisateur existe, celui-ci est redirigé sur la page suivante.
  - Si celui-ci n’existe pas, à minima un log est affiché dans la console et l’application reste fonctionnelle.
  - Au clic sur le bouton « Se connecter » avec les deux champs vides, l’application doit rester fonctionnelle.

### Liste de vêtements : Critère d’acceptance

Une fois connecté, l’utilisateur arrive sur cette page composée du contenu principal et d’une BottomNavigationBar composée de trois entrées et leurs icones correspondantes :
  #### Acheter,
  #### Panier,
  #### Profil
  - La page actuelle est la page Acheter. Son icone et son texte sont d’une couleur différente des autres entrées.
  - Une liste déroulante de tous les vêtements m’est proposé à l’écran.
  - Chaque vêtement affiche les informations suivantes :
  - Une image (ne pas gérer les images dans l’application, seulement insérer des liens vers des images d’internet), un titre, une taille, un prix
  - Au clic sur une entrée de la liste, le détail est affiché.
  - Cette liste de vêtements est récupérée de la base de données.

### Détail d’un vêtement : Critère d’acceptance
  - La page de détail est composée des informations suivantes :
  - Une image, un titre, une taille, une marque, un prix
  - La page est également composée d’un bouton « Retour » pour retourner à la liste des vétements et d’un bouton « Ajouter au panier », ajoutant le vêtement dans le     panier de l’utilisateur (ajout en base).
 
 ### Le panier : Critère d’acceptance
 Au clic sur le bouton « Panier », la liste des vêtements du panier de l’utilisateur est affichée avec les informations suivantes :
  - Une image, un titre, une taille, un prix
  - Un total général est affiché à l’utilisateur (somme de tous les vêtements du panier).
  - A droite de chaque vetement, une croix permet à l’utilisateur de retirer un produit. Au clic sur celle-ci, le produit est retiré de la liste et le total général     mis à jour.
  - Aucun autre bouton d’action n’est présent sur la page (pas de paiement pour le moment).

### Profil utilisateur : Critère d’acceptance
 Au clic sur le bouton « Profil », les informations de l’utilisateur s’affichent (récupérées en base de données).
 Les informations sont :
  - Le login (readonly),
  - Le password (offusqué),
  - L’anniversaire,
  - L’adresse,
  - Le code postale (affiche le clavier numérique et n’accepte que les chiffres),
  - La ville
  - Un bouton « Valider » permet de sauvegarder les données (en base de données).
  - Un bouton « Se déconnecter » permet de revenir à la page de login.

### Filtrer sur la liste des vêtements : Critère d’acceptance
  - Sur la page « Acheter », une TabBar est présente, listant les différentes catégories de vêtements.
  - Par défaut, l’entrée « Tous » est sélectionnée et tous les vêtements sont affichés.
  - Au clic sur une des entrées, la liste est filtrée pour afficher seulement les vêtements correspondants à la catégorie sélectionnée.
