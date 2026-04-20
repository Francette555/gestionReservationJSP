<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <a href="index.jsp">🏠 Retour à l'accueil</a>
    <title>Gestion des Voitures - Parc Automobile</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .main-header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            text-align: center;
        }

        .main-header h1 {
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .main-header p {
            color: #666;
            font-size: 1.1em;
        }

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
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .card-header {
            border-bottom: 3px solid #43cea2;
            padding-bottom: 15px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-header h2 {
            color: #333;
            font-size: 1.5em;
            margin: 0;
        }

        .card-header .icon {
            font-size: 1.8em;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 0.95em;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #43cea2;
        }

        .form-group small {
            display: block;
            margin-top: 5px;
            color: #999;
            font-size: 0.85em;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            margin-right: 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 206, 162, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-warning {
            background: #ffc107;
            color: #333;
        }

        .btn-sm {
            padding: 5px 12px;
            font-size: 12px;
            margin: 0 3px;
        }

        .table-responsive {
            overflow-x: auto;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }

        thead {
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            color: white;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
        }

        tbody tr {
            border-bottom: 1px solid #e0e0e0;
            transition: background-color 0.3s ease;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-simple { background: #17a2b8; color: white; }
        .badge-premium { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; }
        .badge-vip { background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); color: #333; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .stat-card h3 {
            font-size: 2.5em;
            margin-bottom: 5px;
        }

        .stat-card p {
            color: #666;
            font-size: 0.9em;
        }

        .stat-card.primary {
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            color: white;
        }
        .stat-card.primary p { color: rgba(255,255,255,0.9); }

        .full-width {
            grid-column: 1 / -1;
        }

        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            padding: 15px;
            border-radius: 8px;
        }

        .info-text {
            text-align: center;
            padding: 20px;
            color: #666;
            font-style: italic;
        }

        .actions {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }

        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; }
            .main-header h1 { font-size: 1.8em; }
            .stats-grid { grid-template-columns: 1fr; }
            .btn-sm { width: 100%; margin: 2px 0; text-align: center; }
        }

        .card { animation: fadeIn 0.5s ease-out; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="main-header">
        <h1>🚗 Gestion des Voitures</h1>
        <p>Gérez votre parc automobile et les tarifs associés</p>
    </div>

    <!-- Statistiques (initialisées à zéro) -->
    <div class="stats-grid">
        <div class="stat-card primary">
            <h3>0</h3>
            <p>🚗 Total Voitures</p>
        </div>
        <div class="stat-card">
            <h3>0</h3>
            <p>💺 Total Places</p>
        </div>
        <div class="stat-card">
            <h3>0 Ar</h3>
            <p>💰 Valeur du parc</p>
        </div>
        <div class="stat-card">
            <h3>0</h3>
            <p>🏷️ Types différents</p>
        </div>
    </div>

    <div class="grid">
        <!-- SECTION 1: AJOUTER UNE VOITURE -->
        <div class="card">
            <div class="card-header">
                <span class="icon">➕</span>
                <h2>Ajouter une Voiture</h2>
            </div>
            <form action="#" method="post" onsubmit="alert('Fonctionnalité à connecter au backend'); return false;">
                <div class="form-group">
                    <label>🆔 ID Voiture *</label>
                    <input type="text" name="idvoit" id="idvoit" placeholder="Ex: V001, BUS001" required pattern="[A-Za-z0-9]{3,10}">
                    <small>Format: 3 à 10 caractères alphanumériques</small>
                </div>
                <div class="form-group">
                    <label>📝 Design / Modèle *</label>
                    <input type="text" name="design" id="design" placeholder="Ex: Mercedes Sprinter, Toyota Hiace" required>
                </div>
                <div class="form-group">
                    <label>🏷️ Type *</label>
                    <select name="type" id="type" required>
                        <option value="">Sélectionner un type</option>
                        <option value="simple">🚌 Simple - Standard</option>
                        <option value="premium">✨ Premium - Confort</option>
                        <option value="VIP">👑 VIP - Luxe</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>💺 Nombre de places *</label>
                    <input type="number" name="nbrplace" id="nbrplace" placeholder="Ex: 15, 30, 50" required min="1" max="100">
                </div>
                <div class="form-group">
                    <label>💰 Frais (Ar) *</label>
                    <input type="number" name="frais" id="frais" placeholder="Ex: 25000" required min="0" step="1000">
                </div>
                <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                <button type="reset" class="btn btn-secondary">🗑️ Réinitialiser</button>
            </form>
        </div>

        <!-- SECTION 2: MODIFIER UNE VOITURE -->
        <div class="card">
            <div class="card-header">
                <span class="icon">✏️</span>
                <h2>Modifier une Voiture</h2>
            </div>
            <div class="alert-info">
                ℹ️ Sélectionnez une voiture dans la liste pour la modifier
            </div>
        </div>
    </div>

    <!-- SECTION 3: LISTE DES VOITURES -->
    <div class="card full-width">
        <div class="card-header">
            <span class="icon">📊</span>
            <h2>Liste des Voitures</h2>
        </div>

        <div style="margin-bottom: 20px; display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="#" class="btn btn-primary" onclick="alert('Formulaire d\'ajout ci-dessus'); return false;">➕ Ajouter une voiture</a>
            <a href="../index.jsp" class="btn btn-secondary">🏠 Retour à l'accueil</a>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                <tr>
                    <th>🆔 ID</th>
                    <th>📝 Design / Modèle</th>
                    <th>🏷️ Type</th>
                    <th>💺 Places</th>
                    <th>💰 Frais (Ar)</th>
                    <th>📊 Occupation</th>
                    <th>⚙️ Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td colspan="7" class="info-text">
                        📋 Aucune voiture enregistrée pour le moment
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- SECTION 4: RÉCAPITULATIF PAR TYPE -->
    <div class="card full-width">
        <div class="card-header">
            <span class="icon">📈</span>
            <h2>Récapitulatif par Type de Voiture</h2>
        </div>
        <div class="stats-grid">
            <div class="stat-card">
                <h3>0</h3>
                <p>🚌 Voitures Simple</p>
                <small>0 places</small>
            </div>
            <div class="stat-card">
                <h3>0</h3>
                <p>✨ Voitures Premium</p>
                <small>0 places</small>
            </div>
            <div class="stat-card">
                <h3>0</h3>
                <p>👑 Voitures VIP</p>
                <small>0 places</small>
            </div>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        var idvoit = document.getElementById("idvoit");
        var design = document.getElementById("design");
        var nbrplace = document.getElementById("nbrplace");
        var frais = document.getElementById("frais");

        if (idvoit && idvoit.value.trim() === "") {
            alert("Veuillez saisir l'ID de la voiture");
            idvoit.focus();
            return false;
        }
        if (design && design.value.trim() === "") {
            alert("Veuillez saisir le design/modèle de la voiture");
            design.focus();
            return false;
        }
        if (nbrplace && (nbrplace.value < 1 || nbrplace.value > 100)) {
            alert("Le nombre de places doit être compris entre 1 et 100");
            nbrplace.focus();
            return false;
        }
        if (frais && frais.value < 0) {
            alert("Le frais doit être un nombre positif");
            frais.focus();
            return false;
        }
        return true;
    }
</script>
</body>
</html>