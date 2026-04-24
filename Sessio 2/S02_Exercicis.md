# Sessió 2 — Exercicis: JdbcTemplate SELECT

> 🎯 Objectiu: Practicar queries SELECT amb JdbcTemplate, RowMapper i paràmetres segurs.

---

## Exercici 1 — Buscar productes per categoria

### Tasca

Afegeix al `ProductRepository` un mètode que retorni tots els productes d'una categoria donada.

```java
public List<Product> findByCategory(String category) {
    // TODO: Escriu el SQL i fes servir productMapper
}
```

Afegeix l'endpoint corresponent al Controller:
- **Ruta:** `GET /api/products/category/{category}`
- Fes servir `@PathVariable`

### Prova

```http
### Productes de la categoria Fruita
GET http://localhost:8080/api/products/category/Fruita
Accept: application/json

### Productes de la categoria Lactis
GET http://localhost:8080/api/products/category/Lactis
Accept: application/json
```

<details>
<summary>💡 Solució</summary>

```java
public List<Product> findByCategory(String category) {
    String sql = "SELECT * FROM products WHERE category = ?";
    return jdbc.query(sql, productMapper, category);
}
```

</details>

---

## Exercici 2 — Productes ordenats per preu

### Tasca

Crea un mètode `findAllOrderByPrice(String direction)` que retorni tots els productes ordenats per preu ascendent o descendent segons el paràmetre rebut.

> ⚠️ **Atenció:** No pots posar `ORDER BY ?` amb un paràmetre `?` perquè `?` és per a **valors**, no per a clàusules SQL. Hauràs de construir el SQL de forma controlada.

### Codi de partida

```java
public List<Product> findAllOrderByPrice(String direction) {
    // direction pot ser "ASC" o "DESC"
    // TODO: Com ho fas sense concatenar directament l'input de l'usuari?
}
```

### Prova

```http
### Ordenats per preu ascendent
GET http://localhost:8080/api/products/sorted?dir=ASC

### Ordenats per preu descendent
GET http://localhost:8080/api/products/sorted?dir=DESC
```

<details>
<summary>💡 Pista</summary>

Fes una validació prèvia del valor de `direction`:

```java
String order = "ASC".equalsIgnoreCase(direction) ? "ASC" : "DESC";
String sql = "SELECT * FROM products ORDER BY price " + order;
```

Això és segur perquè el valor de `order` és controlat per tu (només pot ser "ASC" o "DESC"), no per l'usuari.

</details>

---

## Exercici 3 — Estadístiques amb queryForObject

### Tasca

Afegeix els següents mètodes al repositori i crea un endpoint que retorni totes les estadístiques en un sol JSON.

```java
// Nombre total de productes
public int count() { /* TODO */ }

// Preu mitjà
public Double averagePrice() { /* TODO */ }

// Producte més car (preu)
public Double maxPrice() { /* TODO */ }

// Producte més barat (preu)
public Double minPrice() { /* TODO */ }

// Stock total
public int totalStock() { /* TODO */ }
```

### L'endpoint hauria de retornar:

```json
{
    "totalProducts": 20,
    "averagePrice": 2.67,
    "maxPrice": 8.50,
    "minPrice": 0.35,
    "totalStock": 3215
}
```

<details>
<summary>💡 Pista</summary>

Pots crear una classe `ProductStats` o retornar un `Map<String, Object>`:

```java
@GetMapping("/stats")
public Map<String, Object> getStats() {
    Map<String, Object> stats = new HashMap<>();
    stats.put("totalProducts", productService.count());
    stats.put("averagePrice", productService.averagePrice());
    // ...
    return stats;
}
```

</details>

---

## Exercici 4 — Buscar amb múltiples criteris

### Tasca

Crea un mètode que busqui productes filtrant per nom (parcial), categoria i preu màxim. Tots els paràmetres són opcionals: si no s'informen, no es filtren.

### Endpoint

```
GET /api/products/search?name=po&category=Fruita&maxPrice=2.0
GET /api/products/search?category=Lactis
GET /api/products/search?maxPrice=1.0
GET /api/products/search
```

<details>
<summary>💡 Pista: SQL dinàmic</summary>

Pots construir el SQL dinàmicament amb una llista de condicions:

```java
public List<Product> search(String name, String category, Double maxPrice) {
    StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
    List<Object> params = new ArrayList<>();

    if (name != null) {
        sql.append(" AND name LIKE ?");
        params.add("%" + name + "%");
    }
    if (category != null) {
        sql.append(" AND category = ?");
        params.add(category);
    }
    if (maxPrice != null) {
        sql.append(" AND price <= ?");
        params.add(maxPrice);
    }

    return jdbc.query(sql.toString(), productMapper, params.toArray());
}
```

El truc de `WHERE 1=1` permet afegir totes les condicions amb `AND` sense preocupar-te de si és la primera condició o no.

</details>

---

## Exercici 5 — Comptar per categoria

### Tasca

Crea un endpoint `GET /api/products/count-by-category` que retorni quants productes hi ha per cada categoria.

### Resultat esperat

```json
[
    { "category": "Fruita", "count": 2 },
    { "category": "Verdura", "count": 2 },
    { "category": "Lactis", "count": 3 },
    ...
]
```

<details>
<summary>💡 Pista</summary>

SQL: `SELECT category, COUNT(*) as total FROM products GROUP BY category`

Pots crear una classe `CategoryCount` amb dos camps (`category`, `count`) i un RowMapper nou per a ella, o retornar una `List<Map<String, Object>>` amb `jdbc.queryForList()`.

```java
public List<Map<String, Object>> countByCategory() {
    String sql = "SELECT category, COUNT(*) as total FROM products GROUP BY category";
    return jdbc.queryForList(sql);
}
```

</details>
