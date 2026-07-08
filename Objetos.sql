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