# Sessió 4 — Exercicis: Spring Data JPA — @Entity i JpaRepository

> 🎯 Objectiu: Practicar la creació d'entitats JPA i l'ús del CRUD automàtic de JpaRepository.

---

## Exercici 1 — La teva primera entitat

### Tasca

Transforma la classe `Product` que teníem a les sessions anteriors en una entitat JPA:

1. Afegeix les anotacions `@Entity`, `@Table`, `@Id`, `@GeneratedValue` i `@Column` corresponents
2. Assegura't que tens el **constructor buit** (obligatori per JPA)
3. Arrenca l'aplicació i observa els logs: hauries de veure SQL de Hibernate

### Verificació

Amb `show-sql=true` als logs, hauries de veure alguna cosa com:

```
Hibernate: select p1_0.id, p1_0.category, p1_0.description, p1_0.name, p1_0.price, p1_0.stock from products p1_0
```

### Preguntes

1. Per a què serveix `GenerationType.IDENTITY`? Quines altres estratègies hi ha?
2. Què passa si treus `@Column(nullable = false)` del camp `name` i intentes inserir un producte sense nom?

<details>
<summary>💡 Respostes</summary>

1. `IDENTITY` utilitza l'auto-increment de MySQL. Alternatives: `SEQUENCE` (PostgreSQL), `AUTO` (Spring decideix), `TABLE` (taula auxiliar).

2. Sense `nullable = false`, JPA no valida el camp. Serà MySQL qui rebutjarà l'INSERT si la columna té `NOT NULL`.

</details>

---

## Exercici 2 — CRUD complet amb JpaRepository

### Tasca

1. Crea la interfície `ProductRepository` estenent `JpaRepository<Product, Long>`
2. Actualitza `ProductService` per usar els mètodes heretats
3. Prova tots els endpoints del CRUD:

```http
### Llistar tots
GET http://localhost:8080/api/products

### Obtenir per ID
GET http://localhost:8080/api/products/1

### Crear
POST http://localhost:8080/api/products
Content-Type: application/json

{
  "name": "Maduixes",
  "price": 3.50,
  "description": "Maduixes del Maresme 500g",
  "category": "Fruita",
  "stock": 45
}

### Actualitzar
PUT http://localhost:8080/api/products/1
Content-Type: application/json

{
  "name": "Poma Golden ECO",
  "price": 1.80,
  "description": "Poma ecològica certificada",
  "category": "Fruita",
  "stock": 100
}

### Eliminar
DELETE http://localhost:8080/api/products/5
```

Després de cada operació, **llegeix els logs** per veure el SQL generat.

---

## Exercici 3 — Explorar mètodes heretats

### Tasca

Sense crear cap mètode nou al repositori, utilitza els mètodes que JpaRepository ja proporciona per implementar els següents endpoints:

| Endpoint | Mètode JPA |
|---|---|
| `GET /api/products/count` | `productRepository.count()` |
| `GET /api/products/{id}/exists` | `productRepository.existsById(id)` |
| `GET /api/products/sorted?by=price&dir=ASC` | `productRepository.findAll(Sort.by(...))` |

### Codi de partida (Controller)

```java
@GetMapping("/count")
public long count() {
    // TODO
}

@GetMapping("/{id}/exists")
public boolean exists(@PathVariable Long id) {
    // TODO
}

@GetMapping("/sorted")
public List<Product> sorted(@RequestParam String by,
                             @RequestParam(defaultValue = "ASC") String dir) {
    // TODO: Usar Sort.by(Sort.Direction.fromString(dir), by)
}
```

<details>
<summary>💡 Pista per al sorted</summary>

```java
Sort sort = Sort.by(Sort.Direction.fromString(dir), by);
return productRepository.findAll(sort);
```

Prova amb:
```http
GET http://localhost:8080/api/products/sorted?by=price&dir=DESC
GET http://localhost:8080/api/products/sorted?by=name&dir=ASC
```

</details>

---

## Exercici 4 — Crear una segona entitat

### Tasca

Crea una entitat `Category` amb els camps:
- `id` (Long, autogenerat)
- `name` (String, obligatori, únic)
- `description` (String)

1. Crea la classe `Category.java` amb les anotacions JPA
2. Crea `CategoryRepository` (interfície JPA)
3. Crea `CategoryService` i `CategoryController` amb CRUD bàsic
4. Arrenca l'aplicació: Hibernate hauria de crear automàticament la taula `categories`

> ⚠️ No necessitem cap relació entre `Product` i `Category`. Són entitats independents.

### Codi de partida

```java
@Entity
@Table(name = "categories")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    private String description;

    // TODO: constructor buit, constructor amb camps, getters, setters
}
```

### Prova

```http
### Crear categoria
POST http://localhost:8080/api/categories
Content-Type: application/json

{ "name": "Fruita", "description": "Fruites fresques de temporada" }

### Llistar categories
GET http://localhost:8080/api/categories
```

---

## Exercici 5 — El misteri de save()

### Tasca teòrica + pràctica

Executa les següents operacions en ordre i prediu el SQL que genera Hibernate (verifica amb els logs):

```java
// Operació 1: Crear producte nou (sense id)
Product p = new Product("Test", 1.0, "desc", "Cat", 10);
productRepository.save(p);
// Quin SQL genera? INSERT o UPDATE?

// Operació 2: Modificar el producte que acabem de crear
p.setPrice(2.0);
productRepository.save(p);
// Quin SQL genera ara? INSERT o UPDATE?

// Operació 3: Assignar un id que existeix a la BBDD
Product p2 = new Product("Sobreescrit", 99.0, "desc", "Cat", 1);
p2.setId(1L);  // L'id 1 existeix a la BBDD
productRepository.save(p2);
// Quin SQL genera? INSERT o UPDATE?
```

<details>
<summary>💡 Respostes</summary>

1. **INSERT** — l'id és null, JPA crea un registre nou
2. **UPDATE** — el producte `p` ara té un id assignat (per l'INSERT anterior), JPA actualitza
3. **UPDATE** — l'id 1 existeix, JPA actualitza el registre existent amb les noves dades

Regla: `save()` fa INSERT si l'entitat és "nova" (id null o no trobat a la BBDD), UPDATE si ja existeix.

</details>
