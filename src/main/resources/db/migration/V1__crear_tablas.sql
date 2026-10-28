-- Modelo inicial de GymTrack (ver docs/modelo.dbml)

CREATE TABLE usuario (
    id          BIGSERIAL PRIMARY KEY,
    usuario     VARCHAR(50) NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE rutina (
    id             BIGSERIAL PRIMARY KEY,
    id_usuario     BIGINT NOT NULL REFERENCES usuario (id) ON DELETE CASCADE,
    nombre_rutina  VARCHAR(100) NOT NULL,
    publica        BOOLEAN NOT NULL DEFAULT false,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE ejercicio (
    id            BIGSERIAL PRIMARY KEY,
    id_rutina     BIGINT NOT NULL REFERENCES rutina (id) ON DELETE CASCADE,
    nombre        VARCHAR(100) NOT NULL,
    repeticiones  INT NOT NULL CHECK (repeticiones > 0),
    series        INT NOT NULL CHECK (series > 0)
);

CREATE TABLE sesion (
    id          BIGSERIAL PRIMARY KEY,
    id_rutina   BIGINT NOT NULL REFERENCES rutina (id) ON DELETE CASCADE,
    estado      VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE'
                CHECK (estado IN ('PENDIENTE', 'REALIZADO')),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE registro (
    id                       BIGSERIAL PRIMARY KEY,
    id_sesion                BIGINT NOT NULL REFERENCES sesion (id) ON DELETE CASCADE,
    id_ejercicio             BIGINT NOT NULL REFERENCES ejercicio (id) ON DELETE CASCADE,
    numero_serie             INT NOT NULL CHECK (numero_serie > 0),
    peso                     NUMERIC(6,2) NOT NULL CHECK (peso >= 0),
    repeticiones_realizadas  INT NOT NULL CHECK (repeticiones_realizadas >= 0),
    UNIQUE (id_sesion, id_ejercicio, numero_serie)
);
