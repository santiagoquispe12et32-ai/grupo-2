-- no me acordaba si la ñ la leia o no asi que
use SpaceSurvivors;

drop procedure if exists RegistrarJugador;
drop procedure if exists IniciarSesion;
drop procedure if exists FinalizarSesion;
drop procedure if exists RegistrarEvento;
drop procedure if exists CrearEnemigo;
drop procedure if exists DanarEnemigo;
drop procedure if exists CrearPowerUp;
drop procedure if exists RecolectarPowerUp;
drop procedure if exists AsignarArma;
drop procedure if exists DispararArma;
drop procedure if exists RecargarArma;
drop procedure if exists VerRanking;

delimiter //


create procedure RegistrarJugador(in p_nombre varchar(50), in p_email varchar(100))
begin
    insert into Jugadores (nombre, email, fecha_registro)
    values (p_nombre, p_email, curdate());
end //


create procedure IniciarSesion(in p_id_jugador int, in p_dificultad varchar(20))
begin
    insert into Sesiones (id_jugador, fecha_inicio, dificultad, puntaje_final)
    values (p_id_jugador, curdate(), p_dificultad, 0);
end //


create procedure FinalizarSesion(in p_id_sesion int, in p_puntaje int)
begin
    update Sesiones
    set fecha_fin = curdate(),
        puntaje_final = p_puntaje
    where id_sesion = p_id_sesion;
end //

create procedure RegistrarEvento(
    in p_id_sesion int,
    in p_id_tipo_evento int,
    in p_frame int,
    in p_dano float,
    in p_puntos int)
begin
    insert into RegistrosCombates (id_sesion, id_tipo_evento, frame, dano, puntos)
    values (p_id_sesion, p_id_tipo_evento, p_frame, p_dano, p_puntos);
end //

create procedure CrearEnemigo(
    in p_id_sesion int,
    in p_id_tipo_enemigo int,
    in p_x float,
    in p_y float)
begin
    insert into EnemigosInstancias (id_sesion, id_tipo_enemigo, coor_x, coor_y, vida_actual)
    select p_id_sesion, id_tipo_enemigo, p_x, p_y, vida_base
    from TiposEnemigos
    where id_tipo_enemigo = p_id_tipo_enemigo;
end //


create procedure DanarEnemigo(in p_id_enemigo_instancia int, in p_dano float)
begin
    update EnemigosInstancias
    set vida_actual = greatest(vida_actual - p_dano, 0)
    where id_enemigo_instancia = p_id_enemigo_instancia;
end //

create procedure CrearPowerUp(
    in p_id_sesion int,
    in p_id_tipo_powerup int,
    in p_x float,
    in p_y float)
begin
    insert into PowerUpsInstancias (id_sesion, id_tipo_powerup, coor_x, coor_y, recolectado)
    values (p_id_sesion, p_id_tipo_powerup, p_x, p_y, false);
end //

create procedure RecolectarPowerUp(in p_id_powerup_instancia int)
begin
    update PowerUpsInstancias
    set recolectado = true
    where id_powerup_instancia = p_id_powerup_instancia;
end //

create procedure AsignarArma(in p_id_sesion int, in p_id_arma int)
begin
    insert into InventarioMunicion (id_sesion, id_arma, cantidad_actual)
    select p_id_sesion, id_arma, municion_max
    from Armas
    where id_arma = p_id_arma;
end //

create procedure DispararArma(in p_id_sesion int, in p_id_arma int)
begin
    update InventarioMunicion
    set cantidad_actual = cantidad_actual - 1
    where id_sesion = p_id_sesion
      and id_arma = p_id_arma
      and cantidad_actual > 0;
end //

create procedure RecargarArma(in p_id_sesion int, in p_id_arma int)
begin
    update InventarioMunicion im
    join Armas a on a.id_arma = im.id_arma
    set im.cantidad_actual = a.municion_max
    where im.id_sesion = p_id_sesion
      and im.id_arma = p_id_arma;
end //

create procedure VerRanking()
begin
    select j.nombre, s.puntaje_final, s.dificultad
    from Sesiones s
    join Jugadores j on j.id_jugador = s.id_jugador
    order by s.puntaje_final desc
    limit 10;
end //

delimiter ;
