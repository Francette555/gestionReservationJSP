<!--<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Voitures - Parc Automobile</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container { max-width: 1400px; margin: 0 auto; }
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
            border-bottom: 3px solid #43cea2;
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
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #43cea2; }
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
        .btn-primary { background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: #333; }
        .btn-sm { padding: 5px 12px; font-size: 12px; margin: 0 3px; }
        .table-responsive { overflow-x: auto; margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        thead { background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%); color: white; }
        th, td { padding: 12px 15px; text-align: left; }
        tbody tr { border-bottom: 1px solid #e0e0e0; }
        tbody tr:hover { background-color: #f8f9fa; }
        .badge-simple { background: #17a2b8; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .badge-premium { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .badge-vip { background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); color: #333; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; border-radius: 15px; padding: 20px; text-align: center; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .stat-card h3 { font-size: 2.5em; margin-bottom: 5px; }
        .stat-card p { color: #666; font-size: 0.9em; }
        .stat-card.primary { background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%); color: white; }
        .stat-card.primary p { color: rgba(255,255,255,0.9); }
        .full-width { grid-column: 1 / -1; }
        .alert-info { background-color: #d1ecf1; color: #0c5460; padding: 15px; border-radius: 8px; }
        .alert-success { background-color: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 15px; }
        .alert-error { background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-bottom: 15px; }
        .info-text { text-align: center; padding: 20px; color: #666; font-style: italic; }
        .actions { display: flex; gap: 5px; flex-wrap: wrap; }
        .debug-info { background: #f0f0f0; border-left: 4px solid #43cea2; padding: 10px; margin-bottom: 15px; font-size: 12px; color: #666; }
        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; }
            .btn-sm { width: 100%; margin: 2px 0; text-align: center; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="main-header">
        <h1>🚗 Gestion des Voitures</h1>
        <p>Gérez votre parc automobile et les tarifs associés</p>
    </div>


    <c:if test="${not empty success}">
        <c:choose>
            <c:when test="${success == 'added'}"><div class="alert-success">✅ Voiture ajoutée avec succès !</div></c:when>
            <c:when test="${success == 'updated'}"><div class="alert-success">✏️ Voiture modifiée avec succès !</div></c:when>
            <c:when test="${success == 'deleted'}"><div class="alert-success">🗑️ Voiture supprimée avec succès !</div></c:when>
        </c:choose>
    </c:if>
    <c:if test="${not empty error}"><div class="alert-error">❌ ${error}</div></c:if>


    <div class="debug-info">
        📊 <strong>Info technique :</strong> ${voitures.size()} voiture(s) chargée(s) depuis la base de données
    </div>


    <div class="stats-grid">
        <div class="stat-card primary"><h3>${voitures.size()}</h3><p>🚗 Total Voitures</p></div>
        <div class="stat-card">
            <h3>
                <c:set var="totalPlaces" value="0"/>
                <c:forEach var="v" items="${voitures}"><c:set var="totalPlaces" value="${totalPlaces + v.nbrplace}"/></c:forEach>
                ${totalPlaces}
            </h3>
            <p>💺 Total Places</p>
        </div>
        <div class="stat-card">
            <h3>
                <c:set var="totalValeur" value="0"/>
                <c:forEach var="v" items="${voitures}"><c:set var="totalValeur" value="${totalValeur + (v.frais * v.nbrplace)}"/></c:forEach>
                ${totalValeur} Ar
            </h3>
            <p>💰 Valeur du parc</p>
        </div>
    </div>

    <div class="grid">

        <div class="card">
            <div class="card-header"><span class="icon">➕</span><h2>Ajouter une Voiture</h2></div>
            <form action="${pageContext.request.contextPath}/VoitureServlet" method="post">
                <input type="hidden" name="action" value="insert">
                <div class="form-group"><label>🆔 ID Voiture *</label><input type="text" name="idvoit" required></div>
                <div class="form-group"><label>📝 Design *</label><input type="text" name="design" required></div>
                <div class="form-group">
                    <label>🏷️ Type *</label>
                    <select name="type" required>
                        <option value="">Sélectionner</option>
                        <option value="simple">🚌 Simple</option>
                        <option value="premium">✨ Premium</option>
                        <option value="VIP">👑 VIP</option>
                    </select>
                </div>
                <div class="form-group"><label>💺 Nombre de places *</label><input type="number" name="nbrplace" required min="1"></div>
                <div class="form-group"><label>💰 Frais (Ar) *</label><input type="number" name="frais" required min="0"></div>
                <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                <button type="reset" class="btn btn-secondary">🗑️ Réinitialiser</button>
            </form>
        </div>


        <div class="card">
            <div class="card-header"><span class="icon">✏️</span><h2>Modifier une Voiture</h2></div>
            <c:if test="${not empty voitureToEdit}">
                <form action="${pageContext.request.contextPath}/VoitureServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="idvoit" value="${voitureToEdit.idvoit}">
                    <div class="form-group"><label>📝 Design *</label><input type="text" name="design" value="${voitureToEdit.design}" required></div>
                    <div class="form-group">
                        <label>🏷️ Type *</label>
                        <select name="type" required>
                            <option value="simple" ${voitureToEdit.type == 'simple' ? 'selected' : ''}>🚌 Simple</option>
                            <option value="premium" ${voitureToEdit.type == 'premium' ? 'selected' : ''}>✨ Premium</option>
                            <option value="VIP" ${voitureToEdit.type == 'VIP' ? 'selected' : ''}>👑 VIP</option>
                        </select>
                    </div>
                    <div class="form-group"><label>💺 Nombre de places *</label><input type="number" name="nbrplace" value="${voitureToEdit.nbrplace}" required min="1"></div>
                    <div class="form-group"><label>💰 Frais (Ar) *</label><input type="number" name="frais" value="${voitureToEdit.frais}" required min="0"></div>
                    <button type="submit" class="btn btn-primary">💾 Mettre à jour</button>
                    <a href="${pageContext.request.contextPath}/VoitureServlet" class="btn btn-secondary">Annuler</a>
                </form>
            </c:if>
            <c:if test="${empty voitureToEdit}"><div class="alert-info">ℹ️ Cliquez sur "Modifier" dans la liste pour modifier une voiture</div></c:if>
        </div>
    </div>


    <div class="card full-width">
        <div class="card-header"><span class="icon">📊</span><h2>Liste des Voitures</h2></div>
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/VoitureServlet" class="btn btn-primary">🔄 Rafraîchir</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">🏠 Retour à l'accueil</a>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                <tr><th>🆔 ID</th><th>📝 Design</th><th>🏷️ Type</th><th>💺 Places</th><th>💰 Frais (Ar)</th><th>⚙️ Actions</th></tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty searchResults}">
                        <c:forEach var="voiture" items="${searchResults}">
                            <tr>
                                <td>${voiture.idvoit}</td>
                                <td><strong>${voiture.design}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${voiture.type == 'simple'}"><span class="badge-simple">🚌 Simple</span></c:when>
                                        <c:when test="${voiture.type == 'premium'}"><span class="badge-premium">✨ Premium</span></c:when>
                                        <c:when test="${voiture.type == 'VIP'}"><span class="badge-vip">👑 VIP</span></c:when>
                                    </c:choose>
                                </td>
                                <td>${voiture.nbrplace}</td>
                                <td>${voiture.frais} Ar</td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/VoitureServlet?action=edit&id=${voiture.idvoit}" class="btn btn-warning btn-sm">✏️ Modifier</a>
                                    <a href="${pageContext.request.contextPath}/VoitureServlet?action=delete&id=${voiture.idvoit}" class="btn btn-danger btn-sm" onclick="return confirm('Supprimer ?')">🗑️ Supprimer</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:when test="${not empty voitures}">
                        <c:forEach var="voiture" items="${voitures}">
                            <tr>
                                <td>${voiture.idvoit}</td>
                                <td><strong>${voiture.design}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${voiture.type == 'simple'}"><span class="badge-simple">🚌 Simple</span></c:when>
                                        <c:when test="${voiture.type == 'premium'}"><span class="badge-premium">✨ Premium</span></c:when>
                                        <c:when test="${voiture.type == 'VIP'}"><span class="badge-vip">👑 VIP</span></c:when>
                                    </c:choose>
                                </td>
                                <td>${voiture.nbrplace}</td>
                                <td>${voiture.frais} Ar</td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/VoitureServlet?action=edit&id=${voiture.idvoit}" class="btn btn-warning btn-sm">✏️ Modifier</a>
                                    <a href="${pageContext.request.contextPath}/VoitureServlet?action=delete&id=${voiture.idvoit}" class="btn btn-danger btn-sm" onclick="return confirm('Supprimer ?')">🗑️ Supprimer</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="6" class="info-text">📋 Aucune voiture enregistrée</td></tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>


    <div class="card full-width">
        <div class="card-header"><span class="icon">🔍</span><h2>Recherche de Voiture</h2></div>
        <form action="${pageContext.request.contextPath}/VoitureServlet" method="get" style="margin-bottom: 20px;">
            <input type="hidden" name="action" value="search">
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                <input type="text" name="keyword" placeholder="Rechercher par design..." style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 8px;">
                <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                <c:if test="${not empty param.keyword}">
                    <a href="${pageContext.request.contextPath}/VoitureServlet" class="btn btn-secondary">🔄 Afficher tout</a>
                </c:if>
            </div>
        </form>
        <c:if test="${not empty param.keyword and not empty searchResults}">
            <div class="alert-info">🔎 ${searchResults.size()} résultat(s) trouvé(s) pour "${param.keyword}"</div>
        </c:if>
        <c:if test="${not empty param.keyword and empty searchResults}">
            <div class="alert-info">🔎 Aucun résultat trouvé pour "${param.keyword}"</div>
        </c:if>
    </div>
</div>
</body>
</html>  -->


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Voitures - Parc Automobile</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            overflow-x: hidden;
        }

        /* Layout principal avec menu latéral */
        .app-container {
            display: flex;
            min-height: 100vh;
        }

        /* ========== MENU LATÉRAL ========== */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #1a1a2e 0%, #16213e 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: all 0.3s ease;
            z-index: 100;
            box-shadow: 2px 0 20px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 25px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 20px;
        }

        .sidebar-header .logo {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .sidebar-header h3 {
            font-size: 1.2em;
            font-weight: 600;
        }

        .sidebar-header p {
            font-size: 0.8em;
            opacity: 0.7;
            margin-top: 5px;
        }

        .nav-section {
            margin-bottom: 20px;
        }

        .nav-title {
            padding: 10px 20px;
            font-size: 0.75em;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: rgba(255,255,255,0.5);
            font-weight: 600;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .nav-item:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            border-left-color: #667eea;
        }

        .nav-item.active {
            background: rgba(102, 126, 234, 0.2);
            border-left-color: #667eea;
            color: white;
        }

        .nav-item .icon {
            font-size: 1.2em;
            width: 24px;
        }

        /* ========== CONTENU PRINCIPAL ========== */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 20px;
        }

        /* En-tête */
        .top-header {
            background: white;
            border-radius: 15px;
            padding: 20px 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-title {
            text-align: center;
            flex: 1;
        }

        .page-title h1 {
            color: #1a1a2e;
            font-size: 1.8em;
            margin-bottom: 5px;
        }

        .page-title p {
            color: #666;
            font-size: 0.9em;
        }

        .date-time {
            text-align: right;
            color: #667eea;
            font-weight: 500;
        }

        .date-time .date {
            font-size: 0.85em;
        }

        .date-time .time {
            font-size: 1.1em;
            font-weight: 600;
        }

        .container { max-width: 1400px; margin: 0 auto; }

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
            border-bottom: 3px solid #667eea;
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
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #667eea; }

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

        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: #333; }
        .btn-sm { padding: 5px 12px; font-size: 12px; margin: 0 3px; }

        .table-responsive { overflow-x: auto; margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        thead { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        th, td { padding: 12px 15px; text-align: left; }
        tbody tr { border-bottom: 1px solid #e0e0e0; }
        tbody tr:hover { background-color: #f8f9fa; }

        .badge-simple { background: #17a2b8; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .badge-premium { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .badge-vip { background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); color: #333; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; border-radius: 15px; padding: 20px; text-align: center; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .stat-card h3 { font-size: 2.5em; margin-bottom: 5px; }
        .stat-card p { color: #666; font-size: 0.9em; }
        .stat-card.primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .stat-card.primary p { color: rgba(255,255,255,0.9); }
        .full-width { grid-column: 1 / -1; }
        .alert-info { background-color: #d1ecf1; color: #0c5460; padding: 15px; border-radius: 8px; }
        .alert-success { background-color: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 15px; }
        .alert-error { background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-bottom: 15px; }
        .info-text { text-align: center; padding: 20px; color: #666; font-style: italic; }
        .actions { display: flex; gap: 5px; flex-wrap: wrap; }
        .debug-info { background: #f0f0f0; border-left: 4px solid #667eea; padding: 10px; margin-bottom: 15px; font-size: 12px; color: #666; }
        .footer {
            margin-top: 40px;
            text-align: center;
            padding: 20px;
            color: #666;
            background: white;
            border-radius: 12px;
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
                z-index: 1000;
            }
            .sidebar.open {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
            }
            .grid { grid-template-columns: 1fr; }
            .menu-toggle {
                display: block;
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1001;
                background: #667eea;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 8px;
                cursor: pointer;
            }
            .btn-sm { width: 100%; margin: 2px 0; text-align: center; }
        }

        @media (min-width: 769px) {
            .menu-toggle {
                display: none;
            }
        }

        .sidebar::-webkit-scrollbar {
            width: 5px;
        }
        .sidebar::-webkit-scrollbar-track {
            background: rgba(255,255,255,0.1);
        }
        .sidebar::-webkit-scrollbar-thumb {
            background: #667eea;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="app-container">
    <button class="menu-toggle" id="menuToggle">☰ Menu</button>

    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo">🚌</div>
            <h3>Coopérative Transport</h3>
            <p>Gestion de Réservation</p>
        </div>

        <div class="nav-section">
            <div class="nav-title">Menu Principal</div>
            <a href="${pageContext.request.contextPath}/" class="nav-item">
                <span class="icon">📊</span>
                <span>Accueil</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-title">Gestion</div>
            <a href="${pageContext.request.contextPath}/VoitureServlet" class="nav-item active">
                <span class="icon">🚗</span>
                <span>Gestion des Voitures</span>
            </a>
            <a href="${pageContext.request.contextPath}/ClientServlet" class="nav-item">
                <span class="icon">👥</span>
                <span>Gestion des Clients</span>
            </a>
            <a href="${pageContext.request.contextPath}/ReservationServlet" class="nav-item">
                <span class="icon">📅</span>
                <span>Gestion des Réservations</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-title">Finances</div>
            <a href="${pageContext.request.contextPath}/paiement/paiement" class="nav-item">
                <span class="icon">💰</span>
                <span>Paiements</span>
            </a>
        </div>
    </div>

    <div class="main-content">
        <div class="top-header">
            <div></div>
            <div class="page-title">
                <h1>🚗 Gestion des Voitures</h1>
                <p>Gérez votre parc automobile et les tarifs associés</p>
            </div>
            <div class="date-time">
                <div class="date" id="currentDate"></div>
                <div class="time" id="currentTime"></div>
            </div>
        </div>

        <div class="container">
            <c:if test="${not empty success}">
                <c:choose>
                    <c:when test="${success == 'added'}"><div class="alert-success">✅ Voiture ajoutée avec succès !</div></c:when>
                    <c:when test="${success == 'updated'}"><div class="alert-success">✏️ Voiture modifiée avec succès !</div></c:when>
                    <c:when test="${success == 'deleted'}"><div class="alert-success">🗑️ Voiture supprimée avec succès !</div></c:when>
                </c:choose>
            </c:if>
            <c:if test="${not empty error}"><div class="alert-error">❌ ${error}</div></c:if>

            <div class="debug-info">
                📊 <strong>Info technique :</strong> ${voitures.size()} voiture(s) chargée(s) depuis la base de données
            </div>

            <div class="stats-grid">
                <div class="stat-card primary"><h3>${voitures.size()}</h3><p>🚗 Total Voitures</p></div>
                <div class="stat-card">
                    <h3>
                        <c:set var="totalPlaces" value="0"/>
                        <c:forEach var="v" items="${voitures}"><c:set var="totalPlaces" value="${totalPlaces + v.nbrplace}"/></c:forEach>
                        ${totalPlaces}
                    </h3>
                    <p>💺 Total Places</p>
                </div>
                <div class="stat-card">
                    <h3>
                        <c:set var="totalValeur" value="0"/>
                        <c:forEach var="v" items="${voitures}"><c:set var="totalValeur" value="${totalValeur + (v.frais * v.nbrplace)}"/></c:forEach>
                        ${totalValeur} Ar
                    </h3>
                    <p>💰 Valeur du parc</p>
                </div>
            </div>

            <div class="grid">
                <div class="card">
                    <div class="card-header"><span class="icon">➕</span><h2>Ajouter une Voiture</h2></div>
                    <form action="${pageContext.request.contextPath}/VoitureServlet" method="post">
                        <input type="hidden" name="action" value="insert">
                        <div class="form-group"><label>🆔 ID Voiture *</label><input type="text" name="idvoit" required></div>
                        <div class="form-group"><label>📝 Design *</label><input type="text" name="design" required></div>
                        <div class="form-group">
                            <label>🏷️ Type *</label>
                            <select name="type" required>
                                <option value="">Sélectionner</option>
                                <option value="simple">🚌 Simple</option>
                                <option value="premium">✨ Premium</option>
                                <option value="VIP">👑 VIP</option>
                            </select>
                        </div>
                        <div class="form-group"><label>💺 Nombre de places *</label><input type="number" name="nbrplace" required min="1"></div>
                        <div class="form-group"><label>💰 Frais (Ar) *</label><input type="number" name="frais" required min="0"></div>
                        <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                        <button type="reset" class="btn btn-secondary">🗑️ Réinitialiser</button>
                    </form>
                </div>

                <div class="card">
                    <div class="card-header"><span class="icon">✏️</span><h2>Modifier une Voiture</h2></div>
                    <c:if test="${not empty voitureToEdit}">
                        <form action="${pageContext.request.contextPath}/VoitureServlet" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="idvoit" value="${voitureToEdit.idvoit}">
                            <div class="form-group"><label>📝 Design *</label><input type="text" name="design" value="${voitureToEdit.design}" required></div>
                            <div class="form-group">
                                <label>🏷️ Type *</label>
                                <select name="type" required>
                                    <option value="simple" ${voitureToEdit.type == 'simple' ? 'selected' : ''}>🚌 Simple</option>
                                    <option value="premium" ${voitureToEdit.type == 'premium' ? 'selected' : ''}>✨ Premium</option>
                                    <option value="VIP" ${voitureToEdit.type == 'VIP' ? 'selected' : ''}>👑 VIP</option>
                                </select>
                            </div>
                            <div class="form-group"><label>💺 Nombre de places *</label><input type="number" name="nbrplace" value="${voitureToEdit.nbrplace}" required min="1"></div>
                            <div class="form-group"><label>💰 Frais (Ar) *</label><input type="number" name="frais" value="${voitureToEdit.frais}" required min="0"></div>
                            <button type="submit" class="btn btn-primary">💾 Mettre à jour</button>
                            <a href="${pageContext.request.contextPath}/VoitureServlet" class="btn btn-secondary">Annuler</a>
                        </form>
                    </c:if>
                    <c:if test="${empty voitureToEdit}"><div class="alert-info">ℹ️ Cliquez sur "Modifier" dans la liste pour modifier une voiture</div></c:if>
                </div>
            </div>

            <div class="card full-width">
                <div class="card-header"><span class="icon">📊</span><h2>Liste des Voitures</h2></div>
                <div style="margin-bottom: 20px;">
                    <a href="${pageContext.request.contextPath}/VoitureServlet" class="btn btn-primary">🔄 Rafraîchir</a>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">🏠 Retour à l'accueil</a>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                        <tr><th>🆔 ID</th><th>📝 Design</th><th>🏷️ Type</th><th>💺 Places</th><th>💰 Frais (Ar)</th><th>⚙️ Actions</th></tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty searchResults}">
                                <c:forEach var="voiture" items="${searchResults}">
                                    <tr>
                                        <td>${voiture.idvoit}</td>
                                        <td><strong>${voiture.design}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${voiture.type == 'simple'}"><span class="badge-simple">🚌 Simple</span></c:when>
                                                <c:when test="${voiture.type == 'premium'}"><span class="badge-premium">✨ Premium</span></c:when>
                                                <c:when test="${voiture.type == 'VIP'}"><span class="badge-vip">👑 VIP</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td>${voiture.nbrplace}</td>
                                        <td>${voiture.frais} Ar</td>
                                        <td class="actions">
                                            <a href="${pageContext.request.contextPath}/VoitureServlet?action=edit&id=${voiture.idvoit}" class="btn btn-warning btn-sm">✏️ Modifier</a>
                                            <a href="${pageContext.request.contextPath}/VoitureServlet?action=delete&id=${voiture.idvoit}" class="btn btn-danger btn-sm" onclick="return confirm('Supprimer ?')">🗑️ Supprimer</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:when test="${not empty voitures}">
                                <c:forEach var="voiture" items="${voitures}">
                                    <tr>
                                        <td>${voiture.idvoit}</td>
                                        <td><strong>${voiture.design}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${voiture.type == 'simple'}"><span class="badge-simple">🚌 Simple</span></c:when>
                                                <c:when test="${voiture.type == 'premium'}"><span class="badge-premium">✨ Premium</span></c:when>
                                                <c:when test="${voiture.type == 'VIP'}"><span class="badge-vip">👑 VIP</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td>${voiture.nbrplace}</td>
                                        <td>${voiture.frais} Ar</td>
                                        <td class="actions">
                                            <a href="${pageContext.request.contextPath}/VoitureServlet?action=edit&id=${voiture.idvoit}" class="btn btn-warning btn-sm">✏️ Modifier</a>
                                            <a href="${pageContext.request.contextPath}/VoitureServlet?action=delete&id=${voiture.idvoit}" class="btn btn-danger btn-sm" onclick="return confirm('Supprimer ?')">🗑️ Supprimer</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="6" class="info-text">📋 Aucune voiture enregistrée</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="footer">
            <p>© 2026 - Coopérative de Transport | Application de Gestion de Réservation</p>
            <p>Tous droits réservés</p>
        </div>
    </div>
</div>

<script>
    function updateDateTime() {
        const now = new Date();
        const dateElement = document.getElementById('currentDate');
        const timeElement = document.getElementById('currentTime');
        if (dateElement) {
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            dateElement.textContent = now.toLocaleDateString('fr-FR', options);
        }
        if (timeElement) {
            timeElement.textContent = now.toLocaleTimeString('fr-FR');
        }
    }

    function initMobileMenu() {
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        if (menuToggle && sidebar) {
            menuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('open');
            });
            document.addEventListener('click', function(event) {
                const isClickInside = sidebar.contains(event.target) || menuToggle.contains(event.target);
                if (!isClickInside && window.innerWidth <= 768) {
                    sidebar.classList.remove('open');
                }
            });
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateDateTime();
        initMobileMenu();
        setInterval(updateDateTime, 1000);
    });
</script>
</body>
</html>