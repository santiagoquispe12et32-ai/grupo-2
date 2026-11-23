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
