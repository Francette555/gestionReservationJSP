<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques - Coopérative de Transport</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            padding: 20px;
        }
        .container { max-width: 1400px; margin: 0 auto; }

        .header {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        .header h1 { font-size: 1.8em; }
        .date-box { background: rgba(255,255,255,0.2); padding: 10px 20px; border-radius: 10px; }
        .date-box a { color: white; text-decoration: none; }
        .header a { color: white; text-decoration: none; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            transition: transform 0.3s;
            cursor: pointer;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card .icon { font-size: 2.5em; margin-bottom: 10px; }
        .stat-card .value { font-size: 2.2em; font-weight: bold; color: #1a1a2e; }
        .stat-card .label { color: #666; margin-top: 5px; }
        .stat-card.primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .stat-card.primary .value { color: white; }
        .stat-card.primary .label { color: rgba(255,255,255,0.9); }

        .filters {
            background: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 25px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: flex-end;
        }
        .filter-group { flex: 1; min-width: 200px; }
        .filter-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #555; }
        .filter-group select {
            width: 100%; padding: 10px; border: 2px solid #e0e0e0; border-radius: 8px;
        }
        .btn {
            padding: 10px 25px; border: none; border-radius: 8px; font-weight: 600;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; cursor: pointer;
        }
        .btn:hover { transform: translateY(-2px); }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow-x: auto;
            margin-bottom: 25px;
        }
        table { width: 100%; border-collapse: collapse; }
        th { background: #1a1a2e; color: white; padding: 15px; text-align: left; }
        td { padding: 12px 15px; border-bottom: 1px solid #e0e0e0; }
        tr:hover { background: #f8f9fa; }

        .badge {
            display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
        }
        .badge-paid { background: #28a745; color: white; }
        .badge-partial { background: #ffc107; color: #333; }
        .badge-pending { background: #dc3545; color: white; }

        .section-title {
            font-size: 1.4em; margin: 20px 0 15px 0; padding-bottom: 10px;
            border-bottom: 3px solid #667eea; display: inline-block;
        }

        .info-text {
            text-align: center; padding: 40px; color: #666; font-style: italic;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div>
            <h1>📊 Tableau de bord statistique</h1>
            <p>Analyse des réservations, paiements et occupation</p>
        </div>
        <div class="date-box" id="currentDate"></div>
        <a href="index.jsp">🏠 Retour à l'accueil</a>
    </div>

    <div class="stats-grid">
        <div class="stat-card primary">
            <div class="icon">💰</div>
            <div class="value" id="recetteTotale">0 Ar</div>
            <div class="label">Recette totale encaissée</div>
        </div>
        <div class="stat-card">
            <div class="icon">🚗</div>
            <div class="value" id="nbVoitures">0</div>
            <div class="label">Voitures en parc</div>
        </div>
        <div class="stat-card">
            <div class="icon">📅</div>
            <div class="value" id="nbReservations">0</div>
            <div class="label">Réservations totales</div>
        </div>
        <div class="stat-card">
            <div class="icon">👥</div>
            <div class="value" id="nbClients">0</div>
            <div class="label">Clients enregistrés</div>
        </div>
    </div>

    <div class="filters">
        <div class="filter-group">
            <label>🚗 Sélectionner une voiture</label>
            <select id="selectVoiture" onchange="chargerStats()">
                <option value="">Toutes les voitures</option>
                <!-- Liste vide - à remplir depuis la base de données -->
            </select>
        </div>
        <div class="filter-group">
            <button class="btn" onclick="chargerStats()">🔍 Afficher les statistiques</button>
        </div>
    </div>

    <div id="section-voiture">
        <h2 class="section-title">🚗 Détail par voiture</h2>
        <div class="table-container">
            <table id="tableStatsVoiture">
                <thead>
                <tr><th>Voiture</th><th>Design</th><th>Type</th><th>Places totales</th><th>Places libres</th><th>Places occupées</th><th>Taux occupation</th><th>Réservations</th><th>Recette</th></tr>
                </thead>
                <tbody id="statsVoitureBody">
                <tr><td colspan="9" class="info-text">📋 Aucune donnée disponible</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <div id="section-paiement">
        <h2 class="section-title">💰 Récapitulatif des paiements par voiture</h2>
        <div class="table-container">
            <table id="tableStatsPaiement">
                <thead><tr><th>Voiture</th><th>Tout payé</th><th>Avec avance</th><th>Sans avance</th><th>Montant total avances</th><th>Reste total à payer</th></tr></thead>
                <tbody id="statsPaiementBody">
                <tr><td colspan="6" class="info-text">📋 Aucune donnée disponible</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <div id="section-clients">
        <h2 class="section-title">🏆 Top clients (par nombre de réservations)</h2>
        <div class="table-container">
            <table id="tableTopClients">
                <thead><tr><th>Client</th><th>Contact</th><th>Nombre de réservations</th><th>Total payé</th></tr></thead>
                <tbody id="topClientsBody">
                <tr><td colspan="4" class="info-text">📋 Aucune donnée disponible</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // Tableaux vides - données à charger depuis le backend
    let voituresData = [];
    let paiementsData = [];
    let topClientsData = [];

    function updateDate() {
        const now = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        document.getElementById('currentDate').innerHTML = now.toLocaleDateString('fr-FR', options);
    }

    function getBadgeType(type) {
        if (type === 'VIP') return '<span class="badge badge-paid">👑 VIP</span>';
        if (type === 'premium') return '<span class="badge badge-partial">✨ Premium</span>';
        return '<span class="badge badge-pending">🚌 Simple</span>';
    }

    function chargerStats() {
        const idvoit = document.getElementById('selectVoiture').value;

        let voituresFiltrees = [...voituresData];
        let paiementsFiltres = [...paiementsData];

        if (idvoit) {
            voituresFiltrees = voituresFiltrees.filter(v => v.idvoit === idvoit);
            paiementsFiltres = paiementsFiltres.filter(p => p.idvoit === idvoit);
        }

        // Stats globales
        const recetteTotale = voituresFiltrees.reduce((sum, v) => sum + (v.recette || 0), 0);
        const nbVoitures = voituresFiltrees.length;
        const nbReservations = voituresFiltrees.reduce((sum, v) => sum + (v.nbReservations || 0), 0);
        const nbClients = topClientsData.reduce((sum, c) => sum + (c.nbReservations || 0), 0);

        document.getElementById('recetteTotale').innerHTML = (recetteTotale ? recetteTotale.toLocaleString('fr-FR') + ' Ar' : '0 Ar');
        document.getElementById('nbVoitures').innerHTML = nbVoitures || '0';
        document.getElementById('nbReservations').innerHTML = nbReservations || '0';
        document.getElementById('nbClients').innerHTML = topClientsData.length || '0';

        // Tableau stats voiture
        const tbody = document.getElementById('statsVoitureBody');
        if (voituresFiltrees.length === 0) {
            tbody.innerHTML = '<tr><td colspan="9" class="info-text">📋 Aucune donnée disponible</td></tr>';
        } else {
            tbody.innerHTML = voituresFiltrees.map(v => `
                <tr>
                    <td><strong>${v.idvoit}</strong></td>
                    <td>${v.design}</td>
                    <td>${getBadgeType(v.type)}</td>
                    <td>${v.nbrplace}</td>
                    <td>${v.placesLibres}</td>
                    <td>${v.placesOccupees}</td>
                    <td>${Math.round(v.placesOccupees / v.nbrplace * 100)}%</td>
                    <td>${v.nbReservations}</td>
                    <td>${v.recette.toLocaleString('fr-FR')} Ar</td>
                </tr>
            `).join('');
        }

        // Tableau stats paiement
        const tbodyPaiement = document.getElementById('statsPaiementBody');
        if (paiementsFiltres.length === 0) {
            tbodyPaiement.innerHTML = '<tr><td colspan="6" class="info-text">📋 Aucune donnée disponible</td></tr>';
        } else {
            tbodyPaiement.innerHTML = paiementsFiltres.map(p => `
                <tr>
                    <td><strong>${p.idvoit}</strong></td>
                    <td>${p.toutPaye}</td>
                    <td>${p.avecAvance}</td>
                    <td>${p.sansAvance}</td>
                    <td>${p.totalAvances.toLocaleString('fr-FR')} Ar</td>
                    <td>${p.resteTotal.toLocaleString('fr-FR')} Ar</td>
                </tr>
            `).join('');
        }

        // Top clients
        const tbodyClients = document.getElementById('topClientsBody');
        if (topClientsData.length === 0) {
            tbodyClients.innerHTML = '<tr><td colspan="4" class="info-text">📋 Aucune donnée disponible</td></tr>';
        } else {
            tbodyClients.innerHTML = topClientsData.map(c => `
                <tr>
                    <td>${c.nom}</td>
                    <td>${c.numtel}</td>
                    <td>${c.nbReservations}</td>
                    <td>${c.totalPaye.toLocaleString('fr-FR')} Ar</td>
                </tr>
            `).join('');
        }
    }

    // Fonction pour charger les données depuis le backend
    function chargerDonneesBackend() {
        // À implémenter : appel AJAX vers le serveur pour charger les statistiques
        // Exemple avec fetch :
        /*
        Promise.all([
            fetch('api/statistiques/voitures').then(r => r.json()),
            fetch('api/statistiques/paiements').then(r => r.json()),
            fetch('api/statistiques/top-clients').then(r => r.json())
        ]).then(([voitures, paiements, clients]) => {
            voituresData = voitures;
            paiementsData = paiements;
            topClientsData = clients;
            chargerStats();
        }).catch(error => console.error('Erreur:', error));
        */

        // Pour l'instant, on garde les tableaux vides
        chargerStats();
    }

    updateDate();
    chargerDonneesBackend();
    setInterval(updateDate, 1000);
</script>
</body>
</html>