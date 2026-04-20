<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paiements - Coopérative de Transport</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

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
            gap: 15px;
        }

        .header h1 {
            font-size: 1.8em;
        }

        .header p {
            opacity: 0.8;
            margin-top: 5px;
        }

        .date-box {
            background: rgba(255,255,255,0.2);
            padding: 10px 20px;
            border-radius: 10px;
            text-align: center;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
            cursor: pointer;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card .icon {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .stat-card .value {
            font-size: 2em;
            font-weight: bold;
            color: #1a1a2e;
        }

        .stat-card .label {
            color: #666;
            margin-top: 5px;
        }

        .stat-card.total {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .stat-card.total .value { color: white; }
        .stat-card.total .label { color: rgba(255,255,255,0.9); }

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

        .filter-group {
            flex: 1;
            min-width: 180px;
        }

        .filter-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }

        .filter-group select, .filter-group input {
            width: 100%;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }

        .btn {
            padding: 10px 25px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow-x: auto;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #1a1a2e;
            color: white;
            padding: 15px;
            text-align: left;
        }

        td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-paid { background: #28a745; color: white; }
        .badge-partial { background: #ffc107; color: #333; }
        .badge-pending { background: #dc3545; color: white; }

        .btn-small {
            padding: 5px 12px;
            font-size: 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-small:hover {
            background: #5a67d8;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
        }

        .modal-content {
            background: white;
            margin: 5% auto;
            padding: 30px;
            border-radius: 15px;
            width: 90%;
            max-width: 500px;
            position: relative;
        }

        .close {
            position: absolute;
            right: 20px;
            top: 15px;
            font-size: 24px;
            cursor: pointer;
        }

        .recu {
            font-family: monospace;
            line-height: 1.6;
        }

        .recu-header {
            text-align: center;
            border-bottom: 2px dashed #333;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }

        .recu-footer {
            text-align: center;
            border-top: 1px dashed #ccc;
            padding-top: 15px;
            margin-top: 15px;
            font-size: 12px;
        }

        .info-text {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }

        @media print {
            .modal-content { margin: 0; width: 100%; box-shadow: none; }
            .close, .btn-print, .btn-close { display: none; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div>
            <h1>💰 Gestion des Paiements</h1>
            <p>Suivi des avances, restes à payer et recettes</p>
        </div>
        <div class="date-box">
            <div id="currentDate"></div>
            <a href="index.jsp" style="color: white;">🏠 Retour à l'accueil</a>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card total">
            <div class="icon">💰</div>
            <div class="value" id="recetteTotale">0 Ar</div>
            <div class="label">Recette totale (encaissée)</div>
        </div>
        <div class="stat-card">
            <div class="icon">✅</div>
            <div class="value" id="nbToutPaye">0</div>
            <div class="label">Tout payé</div>
        </div>
        <div class="stat-card">
            <div class="icon">💵</div>
            <div class="value" id="nbAvecAvance">0</div>
            <div class="label">Avec avance</div>
        </div>
        <div class="stat-card">
            <div class="icon">⏳</div>
            <div class="value" id="nbSansAvance">0</div>
            <div class="label">Sans avance</div>
        </div>
    </div>

    <div class="filters">
        <div class="filter-group">
            <label>🚗 Filtrer par voiture</label>
            <select id="filtreVoiture">
                <option value="">Toutes les voitures</option>
                <!-- Liste vide - à remplir depuis la base de données -->
            </select>
        </div>
        <div class="filter-group">
            <label>📊 Statut de paiement</label>
            <select id="filtreStatut">
                <option value="">Tous</option>
                <option value="tout paye">Tout payé</option>
                <option value="avec avance">Avec avance</option>
                <option value="sans avance">Sans avance</option>
            </select>
        </div>
        <div class="filter-group">
            <button class="btn btn-primary" onclick="chargerPaiements()">🔍 Appliquer les filtres</button>
        </div>
    </div>

    <div class="table-container">
        <table id="tablePaiements">
            <thead>
            <tr>
                <th>N° Réservation</th>
                <th>Client</th>
                <th>Contact</th>
                <th>Voiture</th>
                <th>Place</th>
                <th>Date voyage</th>
                <th>Frais</th>
                <th>Paiement</th>
                <th>Avance versée</th>
                <th>Reste à payer</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody id="paiementsBody">
            <tr><td colspan="11" class="info-text">📋 Aucune donnée de paiement disponible</td></tr>
            </tbody>
        </table>
    </div>
</div>

<div id="modalRecu" class="modal">
    <div class="modal-content">
        <span class="close" onclick="fermerModal()">&times;</span>
        <div id="recuContent"></div>
        <div style="text-align:center; margin-top:20px;">
            <button class="btn btn-primary btn-print" onclick="imprimerRecu()">🖨️ Imprimer</button>
            <button class="btn btn-close" onclick="fermerModal()">Fermer</button>
        </div>
    </div>
</div>

<script>
    // Tableau vide - données à charger depuis le backend
    let reservationsData = [];

    function updateDate() {
        const now = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        document.getElementById('currentDate').innerHTML = now.toLocaleDateString('fr-FR', options);
    }

    function getBadgePaiement(payement) {
        if (payement == 'tout paye') return '<span class="badge badge-paid">✓ Tout payé</span>';
        if (payement == 'avec avance') return '<span class="badge badge-partial">💵 Avec avance</span>';
        return '<span class="badge badge-pending">⏳ Sans avance</span>';
    }

    function chargerPaiements() {
        const idvoit = document.getElementById('filtreVoiture').value;
        const statut = document.getElementById('filtreStatut').value;

        let filtered = [...reservationsData];

        if (idvoit) {
            filtered = filtered.filter(r => r.idvoit == idvoit);
        }
        if (statut) {
            filtered = filtered.filter(r => r.payement == statut);
        }

        // Calcul des statistiques
        const recetteTotale = filtered.reduce((sum, r) => sum + r.montantAvance, 0);
        const nbToutPaye = filtered.filter(r => r.payement == 'tout paye').length;
        const nbAvecAvance = filtered.filter(r => r.payement == 'avec avance').length;
        const nbSansAvance = filtered.filter(r => r.payement == 'sans avance').length;

        document.getElementById('recetteTotale').innerHTML = (recetteTotale ? recetteTotale.toLocaleString('fr-FR') + ' Ar' : '0 Ar');
        document.getElementById('nbToutPaye').innerHTML = nbToutPaye;
        document.getElementById('nbAvecAvance').innerHTML = nbAvecAvance;
        document.getElementById('nbSansAvance').innerHTML = nbSansAvance;

        const tbody = document.getElementById('paiementsBody');
        if (filtered.length == 0) {
            tbody.innerHTML = '<tr><td colspan="11" class="info-text">📋 Aucune réservation trouvée</td></tr>';
            return;
        }

        tbody.innerHTML = filtered.map(p => `
            <tr>
                <td><strong>${p.idreserv}</strong></td>
                <td>${p.nomClient}</td>
                <td>${p.numtel}</td>
                <td>${p.idvoit} - ${p.designVoiture}</td>
                <td>${p.place}</td>
                <td>${p.dateVoyage}</td>
                <td>${p.frais.toLocaleString('fr-FR')} Ar</td>
                <td>${getBadgePaiement(p.payement)}</td>
                <td>${p.montantAvance.toLocaleString('fr-FR')} Ar</td>
                <td><strong>${p.resteAPayer.toLocaleString('fr-FR')} Ar</strong></td>
                <td><button class="btn-small" onclick="afficherRecu('${p.idreserv}')">📄 Reçu</button></td>
            </tr>
        `).join('');
    }

    function afficherRecu(idreserv) {
        const reservation = reservationsData.find(r => r.idreserv == idreserv);
        if (reservation) {
            const now = new Date();
            let libellePaiement = '';
            if (reservation.payement == 'tout paye') {
                libellePaiement = 'Tout payé';
            } else if (reservation.payement == 'avec avance') {
                libellePaiement = 'Avec avance';
            } else {
                libellePaiement = 'Sans avance';
            }

            const recuHtml = `
            <div class="recu">
                <div class="recu-header">
                    <h2>🏢 Coopérative de Transport</h2>
                    <h3>REÇU DE PAIEMENT</h3>
                    <p>N° ${reservation.idreserv}</p>
                </div>
                <div style="margin: 15px 0;">
                    <p><strong>📅 Date réservation :</strong> ${now.toLocaleDateString('fr-FR')}</p>
                    <p><strong>🚌 Date voyage :</strong> ${reservation.dateVoyage}</p>
                    <p><strong>👤 Client :</strong> ${reservation.nomClient} / ${reservation.numtel}</p>
                    <p><strong>🚗 Voiture :</strong> ${reservation.idvoit} / Place : ${reservation.place}</p>
                    <p><strong>💰 Frais :</strong> ${reservation.frais.toLocaleString('fr-FR')} Ar</p>
                    <p><strong>💳 Paiement :</strong> ${libellePaiement}</p>
                    <p><strong>💵 Montant avance :</strong> ${reservation.montantAvance.toLocaleString('fr-FR')} Ar</p>
                    <p><strong>📌 Reste à payer :</strong> ${reservation.resteAPayer.toLocaleString('fr-FR')} Ar</p>
                </div>
                <div class="recu-footer">
                    <p>Merci de votre confiance !</p>
                    <p>Date d'édition : ${now.toLocaleDateString('fr-FR')}</p>
                </div>
            </div>
        `;
            document.getElementById('recuContent').innerHTML = recuHtml;
            document.getElementById('modalRecu').style.display = 'block';
        }
    }

    function fermerModal() {
        document.getElementById('modalRecu').style.display = 'none';
    }

    function imprimerRecu() {
        const recuContent = document.getElementById('recuContent').innerHTML;
        const printWindow = window.open('', '_blank');
        printWindow.document.write(`
            <html><head><title>Impression Reçu</title>
            <style>
                body { font-family: monospace; padding: 20px; }
                .recu-header { text-align: center; border-bottom: 2px dashed #333; padding-bottom: 15px; }
                .recu-footer { text-align: center; border-top: 1px dashed #ccc; padding-top: 15px; margin-top: 15px; }
            </style>
            </head><body>${recuContent}</body></html>
        `);
        printWindow.document.close();
        printWindow.print();
    }

    // Fonction pour charger les données depuis le backend
    function chargerDonneesBackend() {
        // À implémenter : appel AJAX vers le serveur pour charger les réservations
        // Exemple avec fetch :
        /*
        fetch('api/paiements')
            .then(response => response.json())
            .then(data => {
                reservationsData = data;
                chargerPaiements();
            })
            .catch(error => console.error('Erreur:', error));
        */

        // Pour l'instant, on garde le tableau vide
        chargerPaiements();
    }

    updateDate();
    chargerDonneesBackend();
    setInterval(updateDate, 1000);
</script>
</body>
</html>