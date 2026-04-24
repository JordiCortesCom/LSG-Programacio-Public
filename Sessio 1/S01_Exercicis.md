# Sessió 1 — Exercicis: Introducció a Spring Boot

> 🎯 Objectiu: Consolidar la creació d'endpoints REST, el flux Controller → Service, i la comprensió d'IoC/DI.

---

## Exercici 1 — Afegir un endpoint PUT (Update)

El controller actual té `GET`, `POST` i `DELETE`, però li falta l'`UPDATE`.

### Tasca

1. Afegeix un mètode `update(Long id, Product product)` a `ProductService` que:
   - Busqui el producte per `id`
   - Si existeix, actualitzi els camps (`name`, `price`, `description`, `category`)
   - Retorni un `Optional<Product>` (buit si no el troba)

2. Afegeix un endpoint `@PutMapping("/{id}")` a `ProductController` que:
   - Rebi l'`id` per URL i el producte actualitzat per `@RequestBody`
   - Retorni `200 OK` amb el producte actualitzat si existeix
   - Retorni `404 Not Found` si no existeix

### Codi de partida (Service)

```java
public Optional<Product> update(Long id, Product updatedProduct) {
    // TODO: Buscar el producte per id
    // TODO: Si existeix, actualitzar els camps
    // TODO: Retornar Optional amb el producte actualitzat o buit
}
```

### Codi de partida (Controller)

```java
// TODO: Afegir l'anotació de mapeig HTTP correcta
public ResponseEntity<Product> update(/* TODO: paràmetres */) {
    // TODO: Cridar el service i retornar la resposta adequada
}
```

### Prova amb HTTP Client

```http
### Actualitzar un producte
PUT http://localhost:8080/api/products/1
Content-Type: application/json

{
  "name": "Poma Golden Premium",
  "price": 1.50,
  "description": "Poma dolça premium d'origen espanyol",
  "category": "Fruita"
}
```

<details>
<summary>💡 Pista</summary>

Al Service, pots fer servir `getById(id)` per buscar, i després usar els setters per actualitzar cada camp.

Al Controller, el patró és igual que el `getById` però amb `@PutMapping`.

</details>

---

## Exercici 2 — Afegir nous camps al model

### Tasca

Modifica `Product.java` per afegir els camps:
- `stock` (Integer) — unitats disponibles
- `category` ja existeix, verifica que funciona correctament

Un cop afegits:
1. Actualitza el constructor i els getters/setters
2. Actualitza les dades inicials del `ProductService`
3. Prova que el `GET /api/products` retorna tots els camps al JSON

### Pregunta de reflexió

> Quan fas `GET /api/products`, Spring converteix l'objecte Java a JSON automàticament. Quina llibreria utilitza per fer-ho? (No cal que la instal·lis, ja ve amb Spring Web).

<details>
<summary>💡 Resposta</summary>

**Jackson**. Spring Web inclou Jackson per defecte. Jackson utilitza els *getters* de la classe per generar el JSON. Per això, si no tens getter d'un camp, no apareixerà al JSON.

</details>

---

## Exercici 3 — Retornar el nombre total de productes

### Tasca

Crea un nou endpoint:
- **Ruta:** `GET /api/products/count`
- **Resposta:** Un número enter amb el total de productes

### Consideració important

❗ L'ordre de les anotacions `@GetMapping` importa! Si tens:
```java
@GetMapping("/{id}")    // Captura qualsevol cosa: /1, /count, /abc...
@GetMapping("/count")   // Mai s'executarà!
```

Posa `"/count"` **abans** de `"/{id}"` al controlador, o bé Spring interpretarà "count" com un `id`.

<details>
<summary>💡 Pista</summary>

Al Service: `products.size()`

Al Controller: `@GetMapping("/count")` que retorni un `int` o `long`.

</details>

---

## Exercici 4 — Entendre IoC (teòric)

### Preguntes

Respon les següents preguntes **sense executar codi**:

1. Si crees una classe `PromotionService` amb l'anotació `@Service`, però cap altre classe la demana amb `@Autowired`, **Spring la crea igualment?**

2. Si tens dues classes anotades amb `@Service` que implementen la mateixa interfície, i un Controller fa `@Autowired` d'aquesta interfície, **què passarà?**

3. Quina diferència funcional hi ha entre `@Component`, `@Service` i `@Repository`? 

<details>
<summary>💡 Respostes</summary>

1. **Sí.** Spring escaneja totes les classes anotades i en crea instàncies (Beans) a l'arrencada, independentment de si algú les utilitza.

2. **Error a l'arrencada.** Spring no sabrà quina de les dues injectar. Solució: `@Primary` o `@Qualifier("nomBean")`.

3. **Funcionalment, cap.** Totes tres marquen la classe com a Bean de Spring. La diferència és **semàntica**: `@Service` indica lògica de negoci, `@Repository` indica accés a dades (i afegeix traducció d'excepcions de BBDD).

</details>

---

## Exercici 5 — Buscar per rang de preu

### Tasca

Crea un endpoint que retorni productes dins d'un rang de preu:

- **Ruta:** `GET /api/products/price?min=1.0&max=3.0`
- **Paràmetres:** `min` i `max` com a `@RequestParam`

### Codi de partida (Service)

```java
public List<Product> getByPriceRange(Double min, Double max) {
    // TODO: Filtrar productes amb price >= min i price <= max
}
```

### Codi de partida (Controller)

```java
@GetMapping("/price")
public List<Product> getByPriceRange(
        /* TODO: dos @RequestParam */) {
    // TODO: cridar el service
}
```

### Prova amb HTTP Client

```http
### Productes entre 1€ i 3€
GET http://localhost:8080/api/products/price?min=1.0&max=3.0
Accept: application/json

### Productes barats (menys d'1€)
GET http://localhost:8080/api/products/price?min=0&max=1.0
Accept: application/json
```

<details>
<summary>💡 Solució (Controller)</summary>

```java
@GetMapping("/price")
public List<Product> getByPriceRange(
        @RequestParam Double min,
        @RequestParam Double max) {
    return productService.getByPriceRange(min, max);
}
```

</details>
