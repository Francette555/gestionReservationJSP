-- Création de la base de données
CREATE DATABASE IF NOT EXISTS cooperative_reservation;
USE cooperative_reservation;

-- Table VOITURE
CREATE TABLE VOITURE (
                         idvoit VARCHAR(10) PRIMARY KEY,
                         Design VARCHAR(100) NOT NULL,
                         type ENUM('simple', 'premium', 'VIP') NOT NULL,
                         nbrplace INT NOT NULL,
                         frais INT NOT NULL
);

-- Table PLACE
/*CREATE TABLE PLACE (
                       idvoit VARCHAR(10),
                       place INT,
                       occupation ENUM('oui', 'non') DEFAULT 'non',
                       PRIMARY KEY (idvoit, place),
                       FOREIGN KEY (idvoit) REFERENCES VOITURE(idvoit) ON DELETE CASCADE
);*/

-- Table PLACE simplifiée (juste la liste des places par voiture)
CREATE TABLE PLACE (
                       idplace INT AUTO_INCREMENT PRIMARY KEY,
                       idvoit VARCHAR(20) NOT NULL,
                       place_num INT NOT NULL,
                       date_voyage DATE NOT NULL,
                       occupation VARCHAR(3) DEFAULT 'non',
                       idreserv VARCHAR(50),
                       FOREIGN KEY (idvoit) REFERENCES VOITURE(idvoit),
                       UNIQUE KEY unique_place_per_day (idvoit, place_num, date_voyage)
);

-- Table CLIENT
CREATE TABLE CLIENT (
                        idclt INT PRIMARY KEY AUTO_INCREMENT,
                        nom VARCHAR(100) NOT NULL,
                        numtel VARCHAR(20) NOT NULL
);

-- Table RESERVER
CREATE TABLE RESERVER (
                          idreserv VARCHAR(20) PRIMARY KEY,
                          idvoit VARCHAR(10),
                          idclt INT,
                          place INT,
                          date_reserv DATETIME,
                          date_voyage DATE,
                          payement ENUM('sans avance', 'avec avance', 'tout paye'),
                          montant_avance INT DEFAULT 0,
                          FOREIGN KEY (idvoit) REFERENCES VOITURE(idvoit),
                          FOREIGN KEY (idclt) REFERENCES CLIENT(idclt),
                          FOREIGN KEY (idvoit, place) REFERENCES PLACE(idvoit, place)
);

-- Insertion des données d'exemple
INSERT INTO VOITURE VALUES
                        ('V001', 'Toyota Hiace', 'premium', 15, 50000),
                        ('V002', 'Mercedes Sprinter', 'VIP', 20, 75000),
                        ('V003', 'Renault Master', 'simple', 12, 35000);

-- Création automatique des places pour chaque voiture
DELIMITER $$
CREATE PROCEDURE generate_places()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idvoit VARCHAR(10);
    DECLARE v_nbrplace INT;
    DECLARE i INT;
    DECLARE cur CURSOR FOR SELECT idvoit, nbrplace FROM VOITURE;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;
read_loop: LOOP
        FETCH cur INTO v_idvoit, v_nbrplace;
        IF done THEN
            LEAVE read_loop;
END IF;

        SET i = 1;
        WHILE i <= v_nbrplace DO
            INSERT IGNORE INTO PLACE (idvoit, place, occupation) VALUES (v_idvoit, i, 'non');
            SET i = i + 1;
END WHILE;
END LOOP;
CLOSE cur;
END$$
DELIMITER ;

CALL generate_places();

-- Insertion clients exemple
INSERT INTO CLIENT (nom, numtel) VALUES
                                     ('Rakoto Madison', '0343388812'),
                                     ('Rabe Andry', '0321456789'),
                                     ('Rasoa Marie', '0339876543');

-- Insertion réservations exemple
INSERT INTO RESERVER VALUES
                         ('RES001', 'V001', 1, 2, NOW(), '2026-05-25', 'avec avance', 20000),
                         ('RES002', 'V002', 2, 5, NOW(), '2026-05-26', 'tout paye', 75000),
                         ('RES003', 'V001', 3, 7, NOW(), '2026-05-27', 'sans avance', 0);