<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Clients - Application CRM</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

        .main-header h1 { color: #667eea; font-size: 2.5em; margin-bottom: 10px; }
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
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }
        .form-group input:focus { outline: none; border-color: #667eea; }
        .form-group small { display: block; margin-top: 5px; color: #999; font-size: 0.85em; }

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
            animation: slideDown 0.5s ease-out;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            animation: slideDown 0.5s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .info-text { text-align: center; padding: 20px; color: #666; font-style: italic; }
        .badge { display: inline-block; padding: 3px 8px; border-radius: 20px; font-size: 11px; font-weight: 600; background: #e0e0e0; color: #666; }
        .actions { display: flex; gap: 5px; flex-wrap: wrap; }
        .full-width { grid-column: 1 / -1; }

        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; }
            .main-header h1 { font-size: 1.8em; }
            .btn-sm { width: 100%; margin: 2px 0; text-align: center; }
        }

        .card { animation: fadeIn 0.5s ease-out; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Auto-hide messages after 3 seconds */
        .alert-success, .alert-error {
            cursor: pointer;
            transition: opacity 0.5s;
        }
    </style>
    <script>
        // Auto-hide messages after 3 seconds
        setTimeout(function() {
            var successMsg = document.querySelector('.alert-success');
            var errorMsg = document.querySelector('.alert-error');

            if (successMsg) {
                setTimeout(function() {
                    successMsg.style.opacity = '0';
                    setTimeout(function() {
                        if (successMsg) successMsg.style.display = 'none';
                    }, 500);
                }, 3000);
            }

            if (errorMsg) {
                setTimeout(function() {
                    errorMsg.style.opacity = '0';
                    setTimeout(function() {
                        if (errorMsg) errorMsg.style.display = 'none';
                    }, 500);
                }, 3000);
            }
        }, 100);

        // Fonction pour effacer les messages au clic
        function clearMessage(element) {
            element.style.opacity = '0';
            setTimeout(function() {
                element.style.display = 'none';
            }, 500);
        }
    </script>
</head>
<body>
<div class="container">
    <div class="main-header">
        <h1>📋 Gestion des Clients</h1>
        <p>Application complète de gestion de votre portefeuille clients</p>
    </div>

    <!-- Affichage des messages de succès/erreur -->
    <c:if test="${not empty success}">
        <c:choose>
            <c:when test="${success == 'added'}">
                <div class="alert-success" onclick="clearMessage(this)">
                    ✅ Client ajouté avec succès ! (Cliquez pour fermer)
                </div>
            </c:when>
            <c:when test="${success == 'updated'}">
                <div class="alert-success" onclick="clearMessage(this)">
                    ✏️ Client modifié avec succès ! (Cliquez pour fermer)
                </div>
            </c:when>
            <c:when test="${success == 'deleted'}">
                <div class="alert-success" onclick="clearMessage(this)">
                    🗑️ Client supprimé avec succès ! (Cliquez pour fermer)
                </div>
            </c:when>
        </c:choose>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert-error" onclick="clearMessage(this)">
            ❌ ${error} (Cliquez pour fermer)
        </div>
    </c:if>

    <div class="grid">
        <!-- SECTION 1: AJOUTER UN CLIENT -->
        <div class="card">
            <div class="card-header">
                <span class="icon">➕</span>
                <h2>Ajouter un Client</h2>
            </div>
            <form action="${pageContext.request.contextPath}/client" method="post">
                <input type="hidden" name="action" value="insert">
                <div class="form-group">
                    <label>👤 Nom complet *</label>
                    <input type="text" name="nom" placeholder="Entrez le nom complet" required>
                </div>
                <div class="form-group">
                    <label>📞 Numéro de téléphone *</label>
                    <input type="tel" name="numtel" placeholder="Ex: 0343388812" required pattern="(03|05|06|07)[0-9]{8}">
                    <small>Format: 03XXXXXXXX, 05XXXXXXXX, 06XXXXXXXX, 07XXXXXXXX</small>
                </div>
                <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                <button type="reset" class="btn btn-secondary">🗑️ Réinitialiser</button>
            </form>
        </div>

        <!-- SECTION 2: MODIFIER UN CLIENT -->
        <div class="card">
            <div class="card-header">
                <span class="icon">✏️</span>
                <h2>Modifier un Client</h2>
            </div>
            <div class="alert-info">
                ℹ️ Cliquez sur le bouton "Modifier" dans la liste pour modifier un client
            </div>

            <!-- Formulaire de modification (affiché quand un client est sélectionné) -->
            <c:if test="${not empty client}">
                <form action="${pageContext.request.contextPath}/client" method="post" style="margin-top: 20px;">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="idclt" value="${client.idclt}">
                    <div class="form-group">
                        <label>👤 Nom complet *</label>
                        <input type="text" name="nom" value="${client.nom}" required>
                    </div>
                    <div class="form-group">
                        <label>📞 Numéro de téléphone *</label>
                        <input type="tel" name="numtel" value="${client.numtel}" required pattern="(03|05|06|07)[0-9]{8}">
                    </div>
                    <button type="submit" class="btn btn-primary">💾 Mettre à jour</button>
                    <a href="${pageContext.request.contextPath}/client" class="btn btn-secondary">Annuler</a>
                </form>
            </c:if>
        </div>
    </div>

    <!-- SECTION 3: LISTE DES CLIENTS -->
    <div class="card full-width">
        <div class="card-header">
            <span class="icon">📊</span>
            <h2>Liste des Clients</h2>
        </div>

        <div style="margin-bottom: 20px; display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/client" class="btn btn-primary">🔄 Rafraîchir</a>
            <a href="../index.jsp" class="btn btn-secondary">🏠 Retour à l'accueil</a>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                <tr>
                    <th>🆔 ID</th>
                    <th>👤 Nom complet</th>
                    <th>📞 Téléphone</th>
                    <th>⚙️ Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty clients}">
                        <c:forEach var="clientItem" items="${clients}">
                            <tr>
                                <td><span class="badge">#${clientItem.idclt}</span></td>
                                <td><strong>${clientItem.nom}</strong></td>
                                <td>${clientItem.numtel}</td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/client?action=edit&id=${clientItem.idclt}" class="btn btn-warning btn-sm">✏️ Modifier</a>
                                    <a href="${pageContext.request.contextPath}/client?action=delete&id=${clientItem.idclt}"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce client ?')">🗑️ Supprimer</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4" class="info-text">
                                📋 Aucun client enregistré pour le moment
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- SECTION 4: RECHERCHE DE CLIENT -->
    <div class="card full-width">
        <div class="card-header">
            <span class="icon">🔍</span>
            <h2>Recherche de Client</h2>
        </div>

        <form action="${pageContext.request.contextPath}/client" method="get" style="margin-bottom: 25px;">
            <input type="hidden" name="action" value="search">
            <div class="form-group">
                <label>🔎 Rechercher par nom ou numéro de téléphone</label>
                <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                    <input type="text" name="keyword" placeholder="Saisissez un nom ou un numéro..." style="flex: 1;" value="${param.keyword}">
                    <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                    <c:if test="${not empty param.keyword}">
                        <a href="${pageContext.request.contextPath}/client" class="btn btn-secondary">🔄 Afficher tout</a>
                    </c:if>
                </div>
            </div>
        </form>

        <c:if test="${not empty param.keyword}">
            <div class="alert-info">
                ℹ️ Résultats pour la recherche : "<strong>${param.keyword}</strong>"
            </div>
        </c:if>

        <div class="table-responsive">
            <table>
                <thead>
                <tr>
                    <th>🆔 ID</th>
                    <th>👤 Nom complet</th>
                    <th>📞 Téléphone</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty searchResults}">
                        <c:forEach var="searchClient" items="${searchResults}">
                            <tr>
                                <td><span class="badge">#${searchClient.idclt}</span></td>
                                <td><strong>${searchClient.nom}</strong></td>
                                <td>${searchClient.numtel}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${not empty param.keyword}">
                            <tr>
                                <td colspan="3" class="info-text">
                                    📋 Aucun résultat trouvé pour "${param.keyword}"
                                </td>
                            </tr>
                        </c:if>
                        <c:if test="${empty param.keyword}">
                            <tr>
                                <td colspan="3" class="info-text">
                                    📋 Utilisez le champ ci-dessus pour rechercher des clients
                                </td>
                            </tr>
                        </c:if>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>