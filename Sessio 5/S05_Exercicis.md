# Sessió 5 — Exercicis: Queries Personalitzades amb JPA

> 🎯 Objectiu: Practicar derived methods, @Query JPQL i SQL natiu.

---

## Exercici 1 — Derived Query Methods

### Tasca

Afegeix els següents mètodes al `ProductRepository` (sense `@Query`, només amb el nom del mètode) i crea els endpoints corresponents:

| Mètode a escriure | Endpoint | Exemple de prova |
|---|---|---|
| Productes d'una categoria | `GET /api/products/category/{cat}` | `/category/Fruita` |
| Productes amb nom que conté... | `GET /api/products/search?name=po` | `?name=po` |
| Productes amb preu entre min i max | `GET /api/products/price-range?min=1&max=3` | `?min=1&max=3` |
| Productes amb stock = 0 | `GET /api/products/out-of-stock` | — |
| Comptar productes per categoria | `GET /api/products/count/{cat}` | `/count/Lactis` |
| Existeix un producte amb aquest nom? | `GET /api/products/exists-name?name=Poma Golden` | `?name=Poma Golden` |

### Codi de partida

```java
public interface ProductRepository extends JpaRepository<Product, Long> {

    // TODO: 6 mètodes, només amb el nom correcte
}
```

<details>
<summary>💡 Solució</summary>

```java
List<Product> findByCategory(String category);
List<Product> findByNameContaining(String keyword);
List<Product> findByPriceBetween(Double min, Double max);
List<Product> findByStock(Integer stock);  // stock = 0
long countByCategory(String category);
boolean existsByName(String name);
```

</details>

---

## Exercici 2 — @Query amb JPQL

### Tasca

Afegeix les següents queries amb `@Query` JPQL:

1. **Productes més cars que el preu mitjà** de tota la taula
2. **Les 3 categories amb més productes** (retorna nom de categoria i comptatge)
3. **Productes on la descripció conté una paraula** (case-insensitive)

### Codi de partida

```java
// 1. Productes més cars que la mitjana
@Query("SELECT p FROM Product p WHERE p.price > ???")
List<Product> findAboveAveragePrice();

// 2. Categories amb més productes
@Query("SELECT p.category, COUNT(p) as total FROM Product p GROUP BY p.category ORDER BY total DESC")
List<Object[]> findTopCategories();

// 3. Buscar per descripció (case-insensitive)
@Query("??? ")
List<Product> searchByDescription(@Param("keyword") String keyword);
```

### Crea els endpoints:

```http
### Productes per sobre de la mitjana
GET http://localhost:8080/api/products/above-average

### Top categories
GET http://localhost:8080/api/products/top-categories

### Buscar per descripció
GET http://localhost:8080/api/products/search-desc?keyword=fresc
```

<details>
<summary>💡 Solucions</summary>

```java
// 1. Subconsulta JPQL per la mitjana
@Query("SELECT p FROM Product p WHERE p.price > (SELECT AVG(p2.price) FROM Product p2)")
List<Product> findAboveAveragePrice();

// 3. LOWER per case-insensitive
@Query("SELECT p FROM Product p WHERE LOWER(p.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
List<Product> searchByDescription(@Param("keyword") String keyword);
```

</details>

---

## Exercici 3 — SQL Natiu

### Tasca

Escriu les següents queries amb `@Query(nativeQuery = true)`:

1. **Producte aleatori** (`ORDER BY RAND() LIMIT 1`)
2. **Top N productes més cars** (el N és un paràmetre)
3. **Resum estadístic per categoria**: nom, comptatge, preu mínim, preu màxim, preu mitjà

### Codi de partida

```java
// 1. Producte aleatori
@Query(value = "???", nativeQuery = true)
Optional<Product> findRandom();

// 2. Top N més cars
@Query(value = "???", nativeQuery = true)
List<Product> findTopExpensive(@Param("limit") int limit);

// 3. Resum per categoria
@Query(value = "SELECT category, COUNT(*) as total, " +
               "MIN(price) as min_price, MAX(price) as max_price, " +
               "ROUND(AVG(price), 2) as avg_price " +
               "FROM products GROUP BY category ORDER BY total DESC",
       nativeQuery = true)
List<Object[]> getCategorySummary();
```

### Prova

```http
### Producte aleatori (executar vàries vegades, hauria de canviar)
GET http://localhost:8080/api/products/random

### Top 5 més cars
GET http://localhost:8080/api/products/top-expensive?limit=5

### Resum per categoria
GET http://localhost:8080/api/products/category-summary
```

<details>
<summary>💡 Pista per al Controller del resum</summary>

Com `getCategorySummary()` retorna `List<Object[]>`, pots transformar-ho a un format més amigable:

```java
@GetMapping("/category-summary")
public List<Map<String, Object>> categorySummary() {
    return productRepository.getCategorySummary().stream()
        .map(row -> Map.of(
            "category", row[0],
            "total", row[1],
            "minPrice", row[2],
            "maxPrice", row[3],
            "avgPrice", row[4]
        ))
        .collect(Collectors.toList());
}
```

</details>

---

## Exercici 4 — @Modifying: operacions de massa

### Tasca

1. Aplica un **increment de preu del 5%** a tots els productes de la categoria "Begudes"
2. **Elimina** tots els productes amb stock inferior a 10
3. **Reseteja** l'stock de tots els productes a 100

Tots els mètodes han de tenir `@Modifying` i `@Transactional`.

### Codi de partida

```java
@Modifying
@Transactional
@Query("UPDATE Product p SET p.price = p.price * 1.05 WHERE p.category = :category")
int applyPriceIncrease(@Param("category") String category);

// TODO: els altres dos
```

### Prova

```http
### Incrementar preus de Begudes
PUT http://localhost:8080/api/products/increase-price?category=Begudes

### Verificar preus de Begudes
GET http://localhost:8080/api/products/category/Begudes

### Eliminar productes amb stock baix
DELETE http://localhost:8080/api/products/low-stock?threshold=10

### Resetar tot l'stock
PUT http://localhost:8080/api/products/reset-stock
```

---

## Exercici 5 — Tria la millor opció

### Tasca teòrica

Per a cada query, indica quina és la **millor opció** (Derived Method, @Query JPQL, o Native Query) i per què:

| Query | Opció recomanada | Per què? |
|---|---|---|
| Productes per categoria | | |
| Productes amb nom que conté "x" (case-insensitive) | | |
| Producte aleatori | | |
| Comptar productes amb preu > X | | |
| Top 5 categories per stock total | | |
| Productes amb stock entre 10 i 50, ordenats per nom | | |

<details>
<summary>💡 Respostes</summary>

| Query | Opció | Raó |
|---|---|---|
| Per categoria | **Derived** | `findByCategory()` és senzill i clar |
| Nom case-insensitive | **JPQL** | Cal `LOWER()`, massa llarg per Derived |
| Aleatori | **Native** | `RAND()` és específic de MySQL |
| Comptar amb preu > X | **Derived** | `countByPriceGreaterThan()` és directe |
| Top 5 categories per stock | **Native** | `GROUP BY + SUM + LIMIT` és complex |
| Stock entre 10 i 50, per nom | **Derived** | `findByStockBetweenOrderByNameAsc()` funciona |

</details>
