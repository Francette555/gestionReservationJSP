# 🚐 Gestion de Réservation des Places d’une Coopérative

## 📌 Description
Ce projet est une application web développée en **Java JSP/Servlet** permettant de gérer les réservations de places dans une coopérative de transport.

L'application permet de :
- Gérer les voitures
- Gérer les clients
- Réserver des places
- Suivre les paiements
- Générer des reçus

---

## 🛠️ Technologies utilisées

- Java (JSP / Servlet)
- Apache Tomcat
- MySQL
- JDBC
- HTML / CSS / Bootstrap

---

## 🗂️ Structure de la base de données

### 🚗 Table VOITURE
| Champ     | Type    | Description |
|----------|--------|-------------|
| idvoit   | String | Identifiant voiture |
| design   | String | Désignation |
| type     | String | simple / premium / VIP |
| nbrplace | int    | Nombre de places |
| frais    | int    | Tarif |

---

### 💺 Table PLACE
| Champ      | Type    | Description |
|-----------|--------|-------------|
| idvoit    | String | Référence voiture |
| place     | int    | Numéro de place |
| occupation| String | oui / non |

---

### 👤 Table CLIENT
| Champ  | Type    | Description |
|-------|--------|-------------|
| idclt | int    | Identifiant client |
| nom   | String | Nom |
| numtel| String | Téléphone |

---

### 📅 Table RESERVER
| Champ        | Type     | Description |
|-------------|---------|-------------|
| idreserv    | String  | Identifiant réservation |
| idvoit      | String  | Voiture |
| idclt       | int     | Client |
| place       | int     | Numéro de place |
| date_reserv | datetime| Date réservation |
| date_voyage | date    | Date voyage |
| payment     | String  | Mode paiement |
| montant_avance | int  | Montant payé |

---

## ⚙️ Fonctionnalités principales

### ✅ Gestion des voitures
- Ajouter une voiture
- Modifier une voiture
- Supprimer une voiture
- Lister les voitures

---

### ✅ Gestion des clients
- Ajouter un client
- Modifier un client
- Supprimer un client
- Rechercher un client (LIKE)

---

### ✅ Gestion des réservations
- Réserver une place
- Modifier une réservation
- Supprimer une réservation
- Lister les réservations

---

### ✅ Gestion des places
- Afficher les places disponibles
- Mettre à jour l’occupation (oui/non)

---

### 💰 Gestion des paiements
- Sans avance
- Avec avance
- Paiement complet

---

### 📄 Génération de reçu
- Nom client
- Voiture
- Place
- Montant payé
- Reste à payer

---

### 📊 Statistiques
- Liste des voyageurs :
  - avec avance
  - non payé
  - totalement payé
- Recette totale de la coopérative

---

## 🚀 Installation et exécution

### 1️⃣ Cloner le projet
```bash
git clone https://github.com/Francette555/gestionReservationJSP.git
