# Sessió 3 — Exercicis: JdbcTemplate INSERT, UPDATE, DELETE

> 🎯 Objectiu: Practicar operacions d'escriptura amb JdbcTemplate i transaccions.

---

## Exercici 1 — CRUD complet al repositori

### Tasca

Implementa els mètodes que falten al `ProductRepository` per tenir un CRUD complet:

```java
// INSERT: Crear un producte nou (retornant l'objecte amb id assignat)
public Product save(Product product) {
    // TODO: Fer servir jdbc.update() amb KeyHolder
    // TODO: Assignar l'id generat al producte i retornar-lo
}

// UPDATE: Actualitzar un producte existent
public int update(Long id, Product product) {
    // TODO: Actualitzar tots els camps (name, price, description, category, stock)
    // TODO: Retornar files afectades
}

// DELETE: Eliminar per id
public int deleteById(Long id) {
    // TODO
}
```

### Prova

```http
### Crear producte
POST http://localhost:8080/api/products
Content-Type: application/json

{
  "name": "Nous",
  "price": 7.50,
  "description": "Nous pelades 250g",
  "category": "Snacks",
  "stock": 60
}

### Actualitzar producte 1
PUT http://localhost:8080/api/products/1
Content-Type: application/json

{
  "name": "Poma Golden ECO",
  "price": 1.80,
  "description": "Poma ecològica",
  "category": "Fruita",
  "stock": 100
}

### Eliminar producte 5
DELETE http://localhost:8080/api/products/5
```

<details>
<summary>💡 Solució (save amb KeyHolder)</summary>

```java
public Product save(Product product) {
    String sql = "INSERT INTO products (name, price, description, category, stock) " +
                 "VALUES (?, ?, ?, ?, ?)";
    
    KeyHolder keyHolder = new GeneratedKeyHolder();
    
    jdbc.update(connection -> {
        PreparedStatement ps = connection.prepareStatement(sql,
            Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, product.getName());
        ps.setDouble(2, product.getPrice());
        ps.setString(3, product.getDescription());
        ps.setString(4, product.getCategory());
        ps.setInt(5, product.getStock());
        return ps;
    }, keyHolder);
    
    product.setId(keyHolder.getKey().longValue());
    return product;
}
```

</details>

---

## Exercici 2 — Actualització massiva de preus

### Tasca

Crea un endpoint que apliqui un descompte percentual a tots els productes d'una categoria.

- **Ruta:** `PUT /api/products/discount?category=Fruita&percent=10`
- El SQL hauria de ser: `UPDATE products SET price = price * (1 - ?/100) WHERE category = ?`

1. Implementa el mètode al repositori
2. Implementa el mètode al service (amb `@Transactional`)
3. Crea l'endpoint al controller
4. Retorna quants productes s'han actualitzat

### Prova

```http
### Aplicar 10% de descompte a Fruita
PUT http://localhost:8080/api/products/discount?category=Fruita&percent=10
Accept: application/json

### Verificar preus actualitzats
GET http://localhost:8080/api/products/category/Fruita
Accept: application/json
```

<details>
<summary>💡 Solució (Repository)</summary>

```java
public int applyDiscount(String category, Double percent) {
    String sql = "UPDATE products SET price = price * (1 - ? / 100) WHERE category = ?";
    return jdbc.update(sql, percent, category);
}
```

</details>

---

## Exercici 3 — Operació transaccional: compra de producte

### Tasca

Simula una compra: quan un client compra `n` unitats d'un producte, cal:
1. Reduir el stock del producte (`stock - n`, sempre que hi hagi prou stock)
2. Registrar la venda en una taula `sales` (crea-la primer)

```sql
CREATE TABLE sales (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id  BIGINT NOT NULL,
    quantity    INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    sale_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Les dues operacions han de ser **transaccionals**: si no hi ha prou stock, no es registra la venda.

### Codi de partida (Service)

```java
@Transactional
public void purchaseProduct(Long productId, int quantity) {
    // 1. Obtenir el producte per calcular el preu total
    // 2. Reduir stock (si stock < quantity, llençar RuntimeException)
    // 3. Registrar venda a la taula sales
}
```

### Prova

```http
### Comprar 5 unitats del producte 1
POST http://localhost:8080/api/products/purchase?productId=1&quantity=5

### Intentar comprar més stock del que hi ha (hauria de fallar)
POST http://localhost:8080/api/products/purchase?productId=12&quantity=999
```

<details>
<summary>💡 Pista</summary>

Al repositori, el reduceStock pot ser:
```java
public int reduceStock(Long id, int units) {
    return jdbc.update(
        "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?",
        units, id, units
    );
}
```

La condició `stock >= ?` evita stocks negatius a nivell de SQL. Si retorna 0, no hi havia prou stock.

</details>

---

## Exercici 4 — Eliminar productes sense stock

### Tasca

Crea un endpoint que elimini tots els productes amb stock = 0.

- **Ruta:** `DELETE /api/products/out-of-stock`
- Ha de retornar quants productes s'han eliminat
- Ha de ser `@Transactional`

```http
### Primer, posem algun producte a stock 0
PUT http://localhost:8080/api/products/3
Content-Type: application/json

{
  "name": "Enciam Iceberg",
  "price": 0.75,
  "description": "Enciam fresc",
  "category": "Verdura",
  "stock": 0
}

### Eliminar productes sense stock
DELETE http://localhost:8080/api/products/out-of-stock
```

<details>
<summary>💡 Solució (Repository)</summary>

```java
public int deleteOutOfStock() {
    return jdbc.update("DELETE FROM products WHERE stock = 0");
}
```

</details>

---

## Exercici 5 — Reflexió: per què necessitem JPA?

### Pregunta oberta (sense codi)

Observa el `ProductRepository` que has construït al llarg de les sessions 2 i 3. Ara imagina que has d'afegir les taules: `categories`, `providers`, `customers`, `orders`, `order_items`.

1. Quantes línies de codi aproximadament necessitaries per fer un CRUD complet de cada taula amb JdbcTemplate?

2. Quines parts del codi sont pràcticament idèntiques entre taules?

3. Creus que es podria **automatitzar** la generació d'aquest codi? Com?

> Apunta les teves reflexions. A la Sessió 4 veurem la resposta de la indústria a aquestes preguntes: **Spring Data JPA**.
