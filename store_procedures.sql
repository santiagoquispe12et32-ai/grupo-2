create database if not exists SpaceSurvivors;
use SpaceSurvivors;

set foreign_key_checks = 0;

drop table if exists Jugadores;
drop table if exists Sesiones;
drop table if exists Enemigos;
drop table if exists TipoEnemigos;
drop table if exists TipoProyectil;
drop table if exists Efectos;
drop table if exists ProyectilEfectos;
drop table if exists PowerUps;
drop table if exists PowerUp_Efectos;
drop table if exists Eventos;

create table Jugadores (
    id_jugador int auto_increment primary key,
    nombre varchar(100),
    email varchar(150),
    fecha_registro date,
    contrasenia varchar(255),
    admin boolean
);

create table Sesiones (
    id_sesion int auto_increment primary key,
    id_jugador int,
    fecha_inicio datetime,
    fecha_fin datetime,
    puntuacion_final int,
    tiempo_final int,
    foreign key (id_jugador) references Jugadores(id_jugador)
);

create table Enemigos (
    id_enemigo int auto_increment primary key,
    nombre varchar(100),
    vida_base int,
    velocidad decimal(8,2),
    punt int,
    id_tipoEN int,
    foreign key (id_tipoEN) references TipoEnemigos(id_tipoEN)
);

create table TipoEnemigos (
    id_tipoEN int auto_increment primary key,
    nombre varchar(100),
    descripcion varchar(255)
);

create table TipoProyectil (
    id_proyectil int auto_increment primary key,
    nombre varchar(100),
    daño int
);

create table Efectos (
    id_efecto int auto_increment primary key,
    nombre varchar(100),
    descripcion varchar(255),
    duracion int,
    daño int,
    tick_intervalo int
);

create table ProyectilEfectos (
    id_proyectilefecto int auto_increment primary key,
    id_efecto int,
    id_proyectil int,
    foreign key (id_efecto) references Efectos(id_efecto),
    foreign key (id_proyectil) references TipoProyectil(id_proyectil)
);

create table PowerUps (
    id_powerup int auto_increment primary key,
    nombre varchar(100),
    duracion int
);

create table PowerUp_Efectos (
    id_powerupEfecto int auto_increment primary key,
    id_efecto int,
    id_powerup int,
    foreign key (id_efecto) references Efectos(id_efecto),
    foreign key (id_powerup) references PowerUps(id_powerup)
);

create table Eventos (
    id_evento int auto_increment primary key,
    nombre varchar(100),
    duracion int,
    multiJG int
);

insert into Jugadores (nombre, email, fecha_registro, contrasenia, admin) values
('juan', 'juanperez@gmail.com', '2026-01-10', 'jnpz333', false),
('pedro', 'pedrogutierrez@gmail.com', '2026-01-12', 'pogz542', false),
('laura', 'lauragonzalez@gmail.com', '2026-01-15', 'lagz667', true);

insert into Sesiones (id_jugador, fecha_inicio, fecha_fin, puntuacion_final, tiempo_final) values
(1, '2026-02-01 10:00:00', '2026-02-01 10:15:00', 1500, 900),
(2, '2026-02-02 11:00:00', '2026-02-02 11:20:00', 2000, 1200),
(3, '2026-02-03 12:00:00', '2026-02-03 12:10:00', 1000, 600);

insert into TipoEnemigos (nombre, descripcion) values
('basico', 'enemigo comun'),
('rapido', 'enemigo de alta velocidad'),
('fuerte', 'enemigo con mucha resistencia');

insert into Enemigos (nombre, vida_base, velocidad, punt, id_tipoEN) values
('alienigena', 100, 2.50, 100, 1),
('dron de combate', 70, 5.00, 150, 2),
('bestia mutante', 300, 10.00, 300, 3);

insert into TipoProyectil (nombre, daño) values
('laser', 10),
('plasma', 20),
('explosivo', 35);

insert into Efectos (nombre, descripcion, duracion, daño, tick_intervalo) values
('quemadura', 'causa dano por tiempo', 5, 10, 1),
('congelacion', 'reduce la velocidad', 4, 0, 1),
('veneno', 'causa dano progresivo', 8, 5, 2);

insert into ProyectilEfectos (id_efecto, id_proyectil) values
(1, 2),
(2, 1),
(3, 3);

insert into PowerUps (nombre, duracion) values
('escudo', 10),
('velocidad', 15),
('doble_puntuacion', 20);

insert into PowerUp_Efectos (id_efecto, id_powerup) values
(1, 1),
(2, 2),
(3, 3);

insert into Eventos (nombre, duracion, multiJG) values
('invasion', 60, true),
('supervivencia', 120, false),
('lluvia de meteoros', 90, true);

DELIMITER //
CREATE PROCEDURE registrar_jugador(
    IN p_nombre VARCHAR(100),
    IN p_email VARCHAR(150),
    IN p_contrasenia VARCHAR(255)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Jugadores WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email ya registrado';
    ELSE
        INSERT INTO Jugadores (nombre, email, fecha_registro, contrasenia, admin)
        VALUES (p_nombre, p_email, CURDATE(), p_contrasenia, false);
        SELECT LAST_INSERT_ID() AS id_jugador;
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE iniciar_sesion(IN p_id_jugador INT)
BEGIN
    INSERT INTO Sesiones (id_jugador, fecha_inicio)
    VALUES (p_id_jugador, NOW());
    SELECT LAST_INSERT_ID() AS id_sesion;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE finalizar_sesion(
    IN p_id_sesion INT,
    IN p_puntuacion INT
)
BEGIN
    UPDATE Sesiones
    SET fecha_fin = NOW(),
        puntuacion_final = p_puntuacion,
        tiempo_final = TIMESTAMPDIFF(SECOND, fecha_inicio, NOW())
    WHERE id_sesion = p_id_sesion;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE top_jugadores(IN p_limite INT)
BEGIN
    SELECT j.nombre, MAX(s.puntuacion_final) AS mejor_puntuacion
    FROM Sesiones s
    JOIN Jugadores j ON j.id_jugador = s.id_jugador
    GROUP BY j.id_jugador, j.nombre
    ORDER BY mejor_puntuacion DESC
    LIMIT p_limite;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE historial_jugador(IN p_id_jugador INT)
BEGIN
    SELECT id_sesion, fecha_inicio, fecha_fin, puntuacion_final, tiempo_final
    FROM Sesiones
    WHERE id_jugador = p_id_jugador
    ORDER BY fecha_inicio DESC;
END //
DELIMITER ;


CALL sp_registrar_jugador('carlos', 'carlosdiaz@gmail.com', 'hash_aqui');

CALL sp_iniciar_sesion(1);

CALL sp_finalizar_sesion(4, 2500);

CALL sp_top_jugadores(5);

CALL sp_historial_jugador(1);
