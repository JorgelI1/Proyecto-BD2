-- TABLA PACIENTE
CREATE TABLE paciente (
    id_paciente               NUMBER,
    primer_nombre_paciente    VARCHAR2(50) NOT NULL,
    segundo_nombre_paciente   VARCHAR2(50),
    primer_apellido_paciente  VARCHAR2(50) NOT NULL,
    segundo_apellido_paciente VARCHAR2(50),
    cedula                    VARCHAR2(20) NOT NULL,
    fecha_nacimiento          DATE NOT NULL,
    provincia                 VARCHAR2(50) NOT NULL,
    distrito                  VARCHAR2(50) NOT NULL,
    corregimiento             VARCHAR2(50) NOT NULL,
    sexo                      CHAR(1) NOT NULL,
    sede                      VARCHAR2(50) NOT NULL,
    discapacidad              VARCHAR2(100),
    correo_utp                VARCHAR2(100) NOT NULL,
    rol_paciente              VARCHAR2(50) NOT NULL,
    asegurado                 VARCHAR2(2) NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente),
    CONSTRAINT uk_paciente_cedula UNIQUE (cedula),
    CONSTRAINT ck_paciente_sexo CHECK (sexo IN ('M', 'F')),
    CONSTRAINT ck_paciente_asegurado CHECK (asegurado IN ('SI', 'NO'))
);

-- TABLA TIPO_TELEFONO
CREATE TABLE tipo_telefono (
    id_tipotel           NUMBER,
    descripcion_telefono VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_tipo_telefono PRIMARY KEY (id_tipotel)
);


-- TABLA TELEFONO
CREATE TABLE telefono (
    telefono    NUMBER NOT NULL,
    id_paciente NUMBER NOT NULL,
    id_tipotel  NUMBER NOT NULL,
    CONSTRAINT pk_telefono PRIMARY KEY (telefono, id_paciente, id_tipotel),
    CONSTRAINT fk_telefono_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES paciente(id_paciente),
    CONSTRAINT fk_telefono_tipotel
        FOREIGN KEY (id_tipotel)
        REFERENCES tipo_telefono(id_tipotel)
);


-- TABLA PSICOLOGO
CREATE TABLE psicologo (
    id_psicologo               NUMBER,
    primer_nombre_psicologo    VARCHAR2(50) NOT NULL,
    primer_apellido_psicologo  VARCHAR2(50) NOT NULL,
    cedula_psicologo           VARCHAR2(20) NOT NULL,
    cargo                      VARCHAR2(50) DEFAULT 'PSICOLOGO' NOT NULL,
    correo_utp                 VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_psicologo PRIMARY KEY (id_psicologo),
    CONSTRAINT uk_psicologo_cedula UNIQUE (cedula_psicologo)
);


-- TABLA PROGRAMAS
CREATE TABLE programas (
    id_programa          NUMBER,
    nombre_programa      VARCHAR2(100) NOT NULL,
    descripcion_programa VARCHAR2(250) NOT NULL,
    poblacion_objetivo   VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_programas PRIMARY KEY (id_programa),
    CONSTRAINT uk_programas_nombre UNIQUE (nombre_programa)
);

-- TABLA CITA
CREATE TABLE cita (
    id_cita         NUMBER,
    fecha_cita      DATE NOT NULL,
    hora_inicio     DATE NOT NULL,
    hora_fin        DATE NOT NULL,
    estado_cita     VARCHAR2(20) DEFAULT 'PENDIENTE' NOT NULL,
    motivo_cita     VARCHAR2(250) NOT NULL,
    fecha_solicitud DATE NOT NULL,
    id_paciente     NUMBER NOT NULL,
    id_psicologo    NUMBER NOT NULL,
    CONSTRAINT pk_cita PRIMARY KEY (id_cita),
    CONSTRAINT ck_estado_cita
        CHECK (estado_cita IN ('APROBADA', 'PENDIENTE', 'RECHAZADA')),
    CONSTRAINT fk_cita_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES paciente(id_paciente),
    CONSTRAINT fk_cita_psicologo
        FOREIGN KEY (id_psicologo)
        REFERENCES psicologo(id_psicologo)
);


-- TABLA REGISTRO_MEDICO
CREATE TABLE registro_medico (
    id_registro     NUMBER,
    numero_registro NUMBER NOT NULL,
    fecha_atencion  DATE NOT NULL,
    estado_clinico  VARCHAR2(100) NOT NULL,
    diagnostico     VARCHAR2(250) NOT NULL,
    observaciones   VARCHAR2(250) NOT NULL,
    id_psicologo    NUMBER NOT NULL,
    id_paciente     NUMBER NOT NULL,
    id_cita         NUMBER NOT NULL,
    CONSTRAINT pk_registro_medico PRIMARY KEY (id_registro),
    CONSTRAINT fk_registro_psicologo
        FOREIGN KEY (id_psicologo)
        REFERENCES psicologo(id_psicologo),
    CONSTRAINT fk_registro_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES paciente(id_paciente),
    CONSTRAINT fk_registro_cita
        FOREIGN KEY (id_cita)
        REFERENCES cita(id_cita)
);

-- TABLA ACTIVIDAD_GRUPAL
CREATE TABLE actividad_grupal (
    id_actividad           NUMBER,
    nombre_actividad       VARCHAR2(100) NOT NULL,
    descripcion_actividad  VARCHAR2(250) NOT NULL,
    fecha_actividad        DATE NOT NULL,
    lugar_actividad        VARCHAR2(100) NOT NULL,
    hr_inicio_actividad    DATE NOT NULL,
    hr_fin_actividad       DATE NOT NULL,
    cantidad_participantes NUMBER NOT NULL,
    estado_actividad       VARCHAR2(50) DEFAULT 'PENDIENTE' NOT NULL,
    id_psicologo           NUMBER NOT NULL,
    id_programa            NUMBER NOT NULL,
    CONSTRAINT pk_actividad_grupal PRIMARY KEY (id_actividad),
    CONSTRAINT ck_cantidad_participantes
        CHECK (cantidad_participantes > 0),
    CONSTRAINT fk_actividad_psicologo
        FOREIGN KEY (id_psicologo)
        REFERENCES psicologo(id_psicologo),
    CONSTRAINT fk_actividad_programa
        FOREIGN KEY (id_programa)
        REFERENCES programas(id_programa)
);

-- Creacion de tabla auditoria 
CREATE TABLE auditoria_estado_cita (
    id_transaccion   NUMBER(10) PRIMARY KEY,
    tabla            VARCHAR2(25),
    id_cita          NUMBER(10),
    id_paciente      NUMBER(10),
    id_psicologo     NUMBER(10),
    tipo_transaccion VARCHAR2(25),
    estado_cita      VARCHAR2(20),
    usuario          VARCHAR2(20),
    fecha            DATE
);

--Creacion del trigger
CREATE OR REPLACE TRIGGER trg_auditoria_cita
AFTER INSERT OR UPDATE OR DELETE ON cita FOR EACH ROW
BEGIN
    IF INSERTING THEN
        -- Cuando se crea esta pendiente la cita
        INSERT INTO auditoria_estado_cita (
            id_transaccion, 
            tabla, 
            id_cita, 
            id_paciente, 
            id_psicologo, 
            tipo_transaccion, 
            estado_cita, 
            usuario, 
            fecha
        )
        VALUES (
            seq_auditoria_cita.NEXTVAL, 
            'CITA', 
            :NEW.id_cita, 
            :NEW.id_paciente, 
            :NEW.id_psicologo, 
            'INSERT', 
            :NEW.estado_cita,
            USER, 
            SYSDATE
        );

    ELSIF UPDATING THEN
        -- La tabla de auditoria se enfoca en si el estado de la cita cambio o no, si se modifica por algun motivo la fecha por ejemplo no se tomará en cuenta
        IF :OLD.estado_cita != :NEW.estado_cita THEN
            INSERT INTO auditoria_estado_cita (
                id_transaccion, 
                tabla, 
                id_cita, 
                id_paciente, 
                id_psicologo, 
                tipo_transaccion, 
                estado_cita, 
                usuario, 
                fecha
            ) 
            VALUES (
                seq_auditoria_cita.NEXTVAL, 
                'CITA', 
                :NEW.id_cita, 
                :NEW.id_paciente, 
                :NEW.id_psicologo, 
                'ACTUALIZACION ESTADO', 
                :NEW.estado_cita, 
                USER, 
                SYSDATE
            );
        END IF;

    ELSIF DELETING THEN
        -- Se audita si la cita se elimina del sistema
        INSERT INTO auditoria_estado_cita (
            id_transaccion, 
            tabla, 
            id_cita, 
            id_paciente, 
            id_psicologo, 
            tipo_transaccion, 
            estado_cita, 
            usuario, 
            fecha
        ) 
        VALUES (
            seq_auditoria_cita.NEXTVAL, 
            'CITA', 
            :OLD.id_cita, 
            :OLD.id_paciente, 
            :OLD.id_psicologo, 
            'DELETE', 
            :OLD.estado_cita, 
            USER, 
            SYSDATE
        );
    END IF;
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Valor inválido.');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Registro duplicado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


CREATE SEQUENCE seq_paciente
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_psicologo
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_tipotel
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_programa
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_cita
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_registro
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_actividad
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_auditoria_cita
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

/*
VW_CITAS_PSICOLOGICAS	Consultar citas
VW_HISTORIAL_CLINICO	Consultar historiales
VW_ACTIVIDADES_GRUPALES	Consultar actividades
VW_REPORTE_PACIENTES	Reporte de pacientes
VW_ESTADISTICAS_PACIENTES	Estadísticas
VW_REPORTE_ACTIVIDADES	Reporte consolidado
VW_RESUMEN_DNOP
*/


CREATE OR REPLACE VIEW VW_CITAS_PSICOLOGICAS AS
SELECT
    C.ID_CITA,
    P.PRIMER_NOMBRE_PACIENTE || ' ' || P.PRIMER_APELLIDO_PACIENTE AS PACIENTE,
    PS.PRIMER_NOMBRE_PSICOLOGO || ' ' || PS.PRIMER_APELLIDO_PSICOLOGO AS PSICOLOGO,
    C.FECHA_CITA,
    TO_CHAR(C.HORA_INICIO,'HH24:MI') AS HORA_INICIO,
    TO_CHAR(C.HORA_FIN,'HH24:MI') AS HORA_FIN,
    C.ESTADO_CITA,
    C.MOTIVO_CITA
FROM CITA C
JOIN PACIENTE P
ON C.ID_PACIENTE=P.ID_PACIENTE
JOIN PSICOLOGO PS
ON C.ID_PSICOLOGO=PS.ID_PSICOLOGO;

CREATE OR REPLACE VIEW VW_HISTORIAL_CLINICO AS
SELECT
R.NUMERO_REGISTRO,
P.PRIMER_NOMBRE_PACIENTE||' '||
P.PRIMER_APELLIDO_PACIENTE PACIENTE,
PS.PRIMER_NOMBRE_PSICOLOGO||' '||
PS.PRIMER_APELLIDO_PSICOLOGO PSICOLOGO,
R.FECHA_ATENCION,
R.ESTADO_CLINICO,
R.DIAGNOSTICO,
R.OBSERVACIONES
FROM REGISTRO_MEDICO R
JOIN PACIENTE P
ON R.ID_PACIENTE=P.ID_PACIENTE
JOIN PSICOLOGO PS
ON R.ID_PSICOLOGO=PS.ID_PSICOLOGO;


CREATE OR REPLACE VIEW VW_ACTIVIDADES_GRUPALES AS
SELECT
A.ID_ACTIVIDAD,
A.NOMBRE_ACTIVIDAD,
PR.NOMBRE_PROGRAMA,
PS.PRIMER_NOMBRE_PSICOLOGO||' '||
PS.PRIMER_APELLIDO_PSICOLOGO PSICOLOGO,
A.FECHA_ACTIVIDAD,
A.LUGAR_ACTIVIDAD,
A.CANTIDAD_PARTICIPANTES,
A.ESTADO_ACTIVIDAD
FROM ACTIVIDAD_GRUPAL A
JOIN PROGRAMAS PR
ON A.ID_PROGRAMA=PR.ID_PROGRAMA
JOIN PSICOLOGO PS
ON A.ID_PSICOLOGO=PS.ID_PSICOLOGO;


CREATE OR REPLACE VIEW VW_REPORTE_PACIENTES AS
SELECT
ID_PACIENTE,
PRIMER_NOMBRE_PACIENTE||' '||
PRIMER_APELLIDO_PACIENTE PACIENTE,
SEXO,
SEDE,
ROL_PACIENTE,
ASEGURADO
FROM PACIENTE;

CREATE OR REPLACE VIEW VW_ESTADISTICAS_PACIENTES AS
SELECT
SEDE,
SEXO,
COUNT(*) TOTAL_PACIENTES
FROM PACIENTE
GROUP BY
SEDE,
SEXO;


CREATE OR REPLACE VIEW VW_REPORTE_ACTIVIDADES AS
SELECT
PR.NOMBRE_PROGRAMA,
COUNT(A.ID_ACTIVIDAD) TOTAL_ACTIVIDADES,
SUM(A.CANTIDAD_PARTICIPANTES) TOTAL_PARTICIPANTES
FROM PROGRAMAS PR
LEFT JOIN ACTIVIDAD_GRUPAL A
ON PR.ID_PROGRAMA=A.ID_PROGRAMA
GROUP BY PR.NOMBRE_PROGRAMA;


CREATE OR REPLACE VIEW VW_RESUMEN_DNOP AS
SELECT
(SELECT COUNT(*) FROM PACIENTE) TOTAL_PACIENTES,
(SELECT COUNT(*) FROM PSICOLOGO) TOTAL_PSICOLOGOS,
(SELECT COUNT(*) FROM CITA) TOTAL_CITAS,
(SELECT COUNT(*) FROM REGISTRO_MEDICO) TOTAL_REGISTROS,
(SELECT COUNT(*) FROM ACTIVIDAD_GRUPAL) TOTAL_ACTIVIDADES
FROM DUAL;