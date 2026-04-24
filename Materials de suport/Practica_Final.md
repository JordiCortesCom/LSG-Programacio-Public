# Pràctica Final — Spring Boot + Spring Data JPA

> 📅 Data de lliurament: ___________  
> 👤 Individual / Parelles (segons indicació del professor)

---

## Context

Un videoclub vol digitalitzar el seu catàleg de pel·lícules. Necessiten una API REST per gestionar-lo.

Treballareu amb un **domini diferent** del de les classes (productes), per demostrar que podeu aplicar els conceptes en qualsevol context.

---

## Schema SQL de partida

Executeu el següent SQL a MySQL abans de començar:

```sql
CREATE DATABASE IF NOT EXISTS movies_db;
USE movies_db;

DROP TABLE IF EXISTS movies;

CREATE TABLE movies (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    director    VARCHAR(100) NOT NULL,
    genre       VARCHAR(50),
    year        INT,
    rating      DECIMAL(3,1),
    duration    INT,
    available   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO movies (title, director, genre, year, rating, duration, available) VALUES
('El Padrino', 'Francis Ford Coppola', 'Drama', 1972, 9.2, 175, true),
('Pulp Fiction', 'Quentin Tarantino', 'Thriller', 1994, 8.9, 154, true),
('El Señor de los Anillos: La Comunidad del Anillo', 'Peter Jackson', 'Fantasia', 2001, 8.8, 178, false),
('Interstellar', 'Christopher Nolan', 'Ciencia Ficció', 2014, 8.6, 169, true),
('Parásitos', 'Bong Joon-ho', 'Thriller', 2019, 8.5, 132, true),
('Amelie', 'Jean-Pierre Jeunet', 'Comèdia', 2001, 8.3, 122, true),
('Matrix', 'Lana Wachowski', 'Ciencia Ficció', 1999, 8.7, 136, false),
('La La Land', 'Damien Chazelle', 'Musical', 2016, 8.0, 128, true),
('Origen', 'Christopher Nolan', 'Ciencia Ficció', 2010, 8.8, 148, true),
('El Gran Hotel Budapest', 'Wes Anderson', 'Comèdia', 2014, 8.1, 99, true),
('Gladiator', 'Ridley Scott', 'Acció', 2000, 8.5, 155, false),
('Coco', 'Lee Unkrich', 'Animació', 2017, 8.4, 105, true),
('El Pianista', 'Roman Polanski', 'Drama', 2002, 8.5, 150, true),
('Whiplash', 'Damien Chazelle', 'Drama', 2014, 8.5, 106, true),
('Blade Runner 2049', 'Denis Villeneuve', 'Ciencia Ficció', 2017, 8.0, 164, true);
```

---

## Requisits

### R1 — Entitat JPA (15%)

Crea la classe `Movie` annotada amb JPA:
- Tots els camps de la taula han d'estar mapeats
- Usa `@Entity`, `@Id`, `@GeneratedValue`, `@Column` on calgui
- Constructor buit obligatori
- Getters i Setters complets

### R2 — CRUD complet via REST (25%)

Implementa els endpoints:

| Mètode | Ruta | Descripció |
|---|---|---|
| GET | `/api/movies` | Llistar totes les pel·lícules |
| GET | `/api/movies/{id}` | Obtenir per ID (404 si no existeix) |
| POST | `/api/movies` | Crear una pel·lícula nova |
| PUT | `/api/movies/{id}` | Actualitzar una pel·lícula existent |
| DELETE | `/api/movies/{id}` | Eliminar una pel·lícula |

### R3 — Derived Query Methods (mínim 3) (20%)

Implementa com a mínim 3 dels següents (o similars):

- Buscar per gènere
- Buscar per director
- Pel·lícules amb rating superior a X
- Pel·lícules d'un any concret
- Pel·lícules disponibles (`available = true`)
- Comptar pel·lícules per gènere

### R4 — @Query personalitzada (mínim 1) (15%)

Implementa com a mínim 1 query amb `@Query` (JPQL o SQL natiu):

Suggeriments:
- Pel·lícula aleatòria disponible (native)
- Top N pel·lícules per rating (native)
- Buscar per títol case-insensitive (JPQL)
- Gèneres amb la seva valoració mitjana (JPQL o native)

### R5 — Operació @Transactional (10%)

Implementa una operació que requereixi `@Transactional`:

Suggeriment: "Llogar pel·lícula"
1. Verificar que existeix
2. Verificar que està disponible (`available = true`)
3. Marcar-la com a no disponible
4. Si qualsevol pas falla → rollback

### R6 — Fitxers .http (10%)

Lliura un fitxer `tests.http` amb peticions per provar **tots** els endpoints. Cada petició ha de tenir un comentari descriptiu (`###`).

### R7 — Qualitat del codi (5%)

- Noms clars i consistents
- Separació correcta Controller → Service → Repository
- Sense codi comentat innecessari
- Gestió d'errors bàsica (404 quan no es troba)

---

## Estructura esperada del projecte

```
movies/
├── pom.xml
├── src/main/java/com/curs/movies/
│   ├── MoviesApplication.java
│   ├── model/Movie.java
│   ├── repository/MovieRepository.java
│   ├── service/MovieService.java
│   └── controller/MovieController.java
├── src/main/resources/
│   └── application.properties
└── tests.http
```

---

## Lliurament

- **Format:** Projecte Maven complet (comprimit en `.zip`)
- **Contingut obligatori:**
  - Codi font complet
  - Fitxer `tests.http`
  - Breu memòria (1 pàgina, format lliure) explicant:
    - Quines derived methods has escollit i per què
    - Quina @Query has implementat i si és JPQL o nativa
    - Descripció de l'operació @Transactional

---

## Criteri d'avaluació

Consulta la **rúbrica d'avaluació** per conèixer els criteris exactes i la puntuació de cada apartat.
