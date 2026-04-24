# Cheat Sheet · Spring Boot + BBDD

> Referència ràpida per a consulta durant exercicis i pràctiques.

---

## Anotacions de Components

| Anotació | On | Què fa |
|---|---|---|
| `@SpringBootApplication` | Classe principal | Punt d'entrada de l'app |
| `@RestController` | Controller | Rep i respon peticions HTTP (JSON) |
| `@Service` | Lògica de negoci | Capa intermèdia |
| `@Repository` | Accés a dades | Capa de BBDD |
| `@Autowired` | Atribut o constructor | Injecció de dependències |

## Anotacions HTTP (Controller)

| Anotació | HTTP | Ús |
|---|---|---|
| `@GetMapping("/path")` | GET | Obtenir dades |
| `@PostMapping("/path")` | POST | Crear recurs |
| `@PutMapping("/path")` | PUT | Actualitzar recurs |
| `@DeleteMapping("/path")` | DELETE | Eliminar recurs |

## Paràmetres (Controller)

| Anotació | Font | Exemple |
|---|---|---|
| `@PathVariable` | URL | `/products/{id}` → `id` |
| `@RequestBody` | Cos JSON | `{"name":"x"}` → objecte |
| `@RequestParam` | Query string | `?name=x` → `name` |

## JdbcTemplate

```java
// SELECT → llista d'objectes
jdbc.query("SELECT * FROM t WHERE col = ?", rowMapper, valor);

// SELECT → un sol valor
jdbc.queryForObject("SELECT COUNT(*) FROM t", Integer.class);

// INSERT / UPDATE / DELETE → files afectades
jdbc.update("INSERT INTO t (col) VALUES (?)", valor);
```

## JPA — Entitat

```java
@Entity
@Table(name = "nom_taula")
public class Entitat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nom;
    // constructor buit obligatori + getters/setters
}
```

## JPA — Repositori

```java
public interface XRepository extends JpaRepository<Entitat, Long> { }
```

**Mètodes heretats:** `findAll()`, `findById(id)`, `save(entity)`, `deleteById(id)`, `count()`, `existsById(id)`

## JPA — Derived Query Methods

| Paraula clau | SQL | Exemple |
|---|---|---|
| `findBy` | `WHERE` | `findByName(n)` |
| `And` / `Or` | `AND` / `OR` | `findByNameAndCategory(n,c)` |
| `LessThan` | `<` | `findByPriceLessThan(p)` |
| `GreaterThan` | `>` | `findByPriceGreaterThan(p)` |
| `Between` | `BETWEEN` | `findByPriceBetween(a,b)` |
| `Containing` | `LIKE '%x%'` | `findByNameContaining(k)` |
| `OrderBy...Asc` | `ORDER BY` | `findAllByOrderByPriceAsc()` |
| `countBy` | `COUNT` | `countByCategory(c)` |
| `existsBy` | `EXISTS` | `existsByName(n)` |

## JPA — @Query

```java
// JPQL (entitats)
@Query("SELECT p FROM Product p WHERE p.price > :min")
List<Product> find(@Param("min") Double min);

// SQL natiu
@Query(value = "SELECT * FROM products LIMIT :n", nativeQuery = true)
List<Product> findTop(@Param("n") int n);

// UPDATE/DELETE
@Modifying @Transactional
@Query("UPDATE Product p SET p.stock = 0")
int resetStock();
```

## application.properties

```properties
# Connexió
spring.datasource.url=jdbc:mysql://localhost:3306/nom_db
spring.datasource.username=root
spring.datasource.password=1234

# JPA
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.hibernate.ddl-auto=update
```

## Codis HTTP habituals

| Codi | Significat | Quan |
|---|---|---|
| 200 | OK | GET/PUT exitós |
| 201 | Created | POST exitós |
| 204 | No Content | DELETE exitós |
| 404 | Not Found | Recurs no trobat |
| 500 | Internal Server Error | Error al servidor |
