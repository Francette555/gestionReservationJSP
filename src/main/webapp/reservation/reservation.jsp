<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Réservations - Transport Voyage</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container { max-width: 1400px; margin: 0 auto; }

        .main-header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            text-align: center;
        }

        .main-header h1 { color: #ee5a24; font-size: 2.5em; margin-bottom: 10px; }
        .main-header p { color: #666; font-size: 1.1em; }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .card:hover { transform: translateY(-5px); }

        .card-header {
            border-bottom: 3px solid #ee5a24;
            padding-bottom: 15px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-header h2 { color: #333; font-size: 1.5em; }
        .card-header .icon { font-size: 1.8em; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #555; font-weight: 500; }
        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #ee5a24; }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            margin-right: 10px;
        }

        .btn-primary { background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: #333; }
        .btn-info { background: #17a2b8; color: white; }
        .btn-sm { padding: 5px 12px; font-size: 12px; margin: 0 3px; }

        .table-responsive { overflow-x: auto; margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        thead { background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%); color: white; }
        th, td { padding: 12px 15px; text-align: left; }
        tbody tr { border-bottom: 1px solid #e0e0e0; }
        tbody tr:hover { background-color: #f8f9fa; }

        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-paid { background: #28a745; color: white; }
        .badge-partial { background: #ffc107; color: #333; }
        .badge-pending { background: #dc3545; color: white; }

        .places-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(80px, 100px));
            gap: 15px;
            margin-top: 20px;
        }

        .place {
            padding: 15px;
            text-align: center;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
        }

        .place-libre {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border: 2px solid #28a745;
        }

        .place-occupee {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border: 2px solid #dc3545;
        }

        .place-info { font-size: 11px; margin-top: 8px; }

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
            margin: 10% auto;
            padding: 25px;
            border-radius: 15px;
            width: 90%;
            max-width: 500px;
        }

        .close {
            float: right;
            cursor: pointer;
            font-size: 28px;
            font-weight: bold;
        }

        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            padding: 15px;
            border-radius: 8px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .info-text { text-align: center; padding: 20px; color: #666; font-style: italic; }
        .stats { display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; }
        .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px; border-radius: 10px; flex: 1; text-align: center; }
        .stat-card h3 { font-size: 2em; margin-bottom: 5px; }
        .actions { display: flex; gap: 5px; flex-wrap: wrap; }
        .full-width { grid-column: 1 / -1; }

        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; }
            .main-header h1 { font-size: 1.8em; }
            .btn-sm { width: 100%; margin: 2px 0; text-align: center; }
            .places-grid { grid-template-columns: repeat(auto-fill, minmax(70px, 80px)); }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="main-header">
        <h1>🚐 Gestion des Réservations</h1>
        <p>Système complet de gestion des réservations de voyages</p>
    </div>

    <div class="grid">
        <!-- SECTION 1: NOUVELLE RÉSERVATION -->
        <div class="card">
            <div class="card-header">
                <span class="icon">📝</span>
                <h2>Nouvelle Réservation</h2>
            </div>
            <form action="#" method="post" onsubmit="alert('Fonctionnalité à connecter au backend'); return false;">
                <div class="form-group">
                    <label>👤 Client *</label>
                    <select name="idclt" required>
                        <option value="">Sélectionner un client</option>
                        <!-- Liste vide - à remplir depuis la base de données -->
                    </select>
                </div>
                <div class="form-group">
                    <label>🚗 Voiture *</label>
                    <select name="idvoit" id="idvoit" required onchange="updateFrais()">
                        <option value="">Sélectionner une voiture</option>
                        <!-- Liste vide - à remplir depuis la base de données -->
                    </select>
                </div>
                <div class="form-group">
                    <label>💺 Place *</label>
                    <select name="place" id="place" required>
                        <option value="">Sélectionner une place</option>
                        <!-- Liste vide - à remplir dynamiquement -->
                    </select>
                </div>
                <div class="form-group">
                    <label>📅 Date du voyage *</label>
                    <input type="date" name="date_voyage" required>
                </div>
                <div class="form-group">
                    <label>💰 Frais (Ar)</label>
                    <input type="text" id="frais" readonly disabled value="0">
                </div>
                <div class="form-group">
                    <label>💳 Type de paiement *</label>
                    <select name="payement" id="payement" required onchange="updateMontantAvance()">
                        <option value="">Sélectionner</option>
                        <option value="sans avance">Sans avance</option>
                        <option value="avec avance">Avec avance</option>
                        <option value="tout paye">Tout payé</option>
                    </select>
                </div>
                <div class="form-group" id="montantAvanceDiv" style="display:none;">
                    <label>💵 Montant de l'avance (Ar)</label>
                    <input type="number" name="montant_avance" id="montant_avance" value="0">
                </div>
                <button type="submit" class="btn btn-primary">✅ Enregistrer la réservation</button>
                <button type="reset" class="btn btn-secondary">🗑️ Réinitialiser</button>
            </form>
        </div>

        <!-- SECTION 2: MODIFIER UNE RÉSERVATION -->
        <div class="card">
            <div class="card-header">
                <span class="icon">✏️</span>
                <h2>Modifier une Réservation</h2>
            </div>
            <div class="alert-info">
                ℹ️ Sélectionnez une réservation dans la liste pour la modifier
            </div>
        </div>
    </div>

    <!-- SECTION 3: LISTE DES RÉSERVATIONS -->
    <div class="card full-width">
        <div class="card-header">
            <span class="icon">📊</span>
            <h2>Liste des Réservations</h2>
        </div>

        <div style="margin-bottom: 20px; display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="#" class="btn btn-primary" onclick="alert('Formulaire ci-dessus'); return false;">➕ Nouvelle réservation</a>
            <a href="../index.jsp" class="btn btn-secondary">🏠 Retour à l'accueil</a>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                <tr>
                    <th>🆔 N° Réservation</th>
                    <th>👤 Client</th>
                    <th>🚗 Voiture</th>
                    <th>💺 Place</th>
                    <th>📅 Date Voyage</th>
                    <th>💳 Paiement</th>
                    <th>💵 Avance</th>
                    <th>💰 Reste</th>
                    <th>⚙️ Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td colspan="9" class="info-text">
                        📋 Aucune réservation enregistrée pour le moment
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="grid">
        <!-- SECTION 4: RECHERCHE DE RÉSERVATION -->
        <div class="card">
            <div class="card-header">
                <span class="icon">🔍</span>
                <h2>Recherche de Réservation</h2>
            </div>
            <form action="#" method="post" onsubmit="alert('Fonctionnalité de recherche'); return false;">
                <div class="form-group">
                    <label>🔎 Rechercher par n° réservation ou nom client</label>
                    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <input type="text" name="keyword" placeholder="Ex: RES001 ou Rakoto" style="flex: 1;">
                        <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- SECTION 5: PLACES LIBRES -->
        <div class="card">
            <div class="card-header">
                <span class="icon">✅</span>
                <h2>Places Libres</h2>
            </div>
            <div class="alert-info">
                ℹ️ Sélectionnez une voiture pour voir les places disponibles
            </div>
            <div class="stats">
                <div class="stat-card"><h3>0</h3><p>Total places</p></div>
                <div class="stat-card" style="background: linear-gradient(135deg, #28a745, #20c997);"><h3>0</h3><p>Places libres</p></div>
            </div>
            <div class="places-grid">
                <div class="info-text">Aucune donnée disponible</div>
            </div>
        </div>
    </div>

    <!-- SECTION 6: PLACES OCCUPÉES -->
    <div class="card full-width">
        <div class="card-header">
            <span class="icon">❌</span>
            <h2>Places Occupées</h2>
        </div>
        <div class="alert-info">
            ℹ️ Sélectionnez une voiture pour voir les places occupées
        </div>
        <div class="stats">
            <div class="stat-card"><h3>0</h3><p>Total places</p></div>
            <div class="stat-card" style="background: linear-gradient(135deg, #dc3545, #c82333);"><h3>0</h3><p>Places occupées</p></div>
        </div>
        <div class="places-grid">
            <div class="info-text">Aucune donnée disponible</div>
        </div>
    </div>
</div>

<!-- Modal -->
<div id="detailsModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h3>📋 Détails de la réservation</h3>
        <div id="modalContent"></div>
    </div>
</div>

<script>
    function updateFrais() {
        var idvoit = document.getElementById("idvoit").value;
        var fraisInput = document.getElementById("frais");
        // À implémenter avec les données réelles de la base de données
        fraisInput.value = "0 Ar";
        updateMontantAvance();
    }

    function updateMontantAvance() {
        var payement = document.getElementById("payement");
        var montantDiv = document.getElementById("montantAvanceDiv");
        var montantInput = document.getElementById("montant_avance");
        var fraisInput = document.getElementById("frais");

        if (payement.value === "sans avance") {
            montantDiv.style.display = "none";
            montantInput.value = 0;
        } else if (payement.value === "tout paye") {
            montantDiv.style.display = "block";
            var frais = parseInt(fraisInput.value.replace(/[^0-9]/g, '')) || 0;
            montantInput.value = frais;
            montantInput.readOnly = true;
        } else if (payement.value === "avec avance") {
            montantDiv.style.display = "block";
            montantInput.readOnly = false;
            montantInput.value = 0;
        } else {
            montantDiv.style.display = "none";
        }
    }

    function showDetailsModal(place, client, date) {
        document.getElementById('modalContent').innerHTML = `
            <p><strong>📍 Place:</strong> ${place}</p>
            <p><strong>👤 Client:</strong> ${client}</p>
            <p><strong>📅 Date voyage:</strong> ${date}</p>
        `;
        document.getElementById('detailsModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('detailsModal').style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('detailsModal')) {
            closeModal();
        }
    }
</script>
</body>
</html>