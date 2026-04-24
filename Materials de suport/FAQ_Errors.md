# FAQ — Errors Freqüents

> Document viu. S'actualitzarà durant el curs amb errors reals de l'aula.

---

## Errors de Connexió

### ❌ `Access denied for user 'root'@'localhost' (using password: YES)`

**Causa:** El password de MySQL a `application.properties` no coincideix amb el real.

**Solució:**
1. Verifica el password: `mysql -u root -p` al terminal
2. Corregeix `spring.datasource.password` a `application.properties`

---

### ❌ `Communications link failure` / `Connection refused`

**Causa:** MySQL no està arrencat.

**Solució:**
- macOS: `brew services start mysql` o obrir MySQL des de Preferències del Sistema
- Windows: Obrir "Services" i arrencar MySQL
- Verifica amb: `mysql -u root -p`

---

### ❌ `Unknown database 'products_db'`

**Causa:** La base de dades no existeix.

**Solució:** Executa `CREATE DATABASE products_db;` a MySQL Workbench o terminal.

---

## Errors de Spring / Beans

### ❌ `Consider defining a bean of type 'X' in your configuration`

**Causa:** Una classe necessita ser injectada (`@Autowired`) però Spring no la coneix.

**Solució:** Verifica que la classe té `@Service`, `@Repository`, `@RestController` o `@Component`.

---

### ❌ `No qualifying bean of type 'X' available`

**Causa:** Igual que l'anterior, o bé la classe està en un package que Spring no escaneja.

**Solució:** Les classes han d'estar al **mateix package o sub-packages** de la classe amb `@SpringBootApplication`.

```
com.curs.products/
├── ProductsApplication.java    ← @SpringBootApplication aquí
├── controller/                 ← ✅ sub-package, es detecta
├── service/                    ← ✅ sub-package, es detecta
└── repository/                 ← ✅ sub-package, es detecta

com.curs.altre/                 ← ❌ NO es detecta!
```

---

### ❌ `Field X required a bean of type 'JdbcTemplate' that could not be found`

**Causa:** Falta la dependència `spring-boot-starter-jdbc` al `pom.xml`, o falta la configuració de `spring.datasource.*`.

**Solució:** Afegeix la dependència i configura `application.properties`.

---

## Errors de JPA / Hibernate

### ❌ `Table 'nom_db.nom_taula' doesn't exist`

**Causa:** Amb `ddl-auto=none` o `validate`, Hibernate no crea la taula.

**Solució:** Executa el `.sql` manualment, o canvia a `ddl-auto=update`.

---

### ❌ `No property 'X' found for type 'Product'`

**Causa:** El nom d'un derived query method no coincideix amb un camp de l'entitat.

**Solució:** Revisa el nom del mètode. `findByNom` falla si el camp es diu `name`.

---

### ❌ `detached entity passed to persist`

**Causa:** Estàs fent `save()` d'una entitat amb un `id` que JPA no reconeix com a existent.

**Solució:** No assignis `id` manualment per a productes nous. Deixa que `@GeneratedValue` ho faci.

---

### ❌ `could not execute statement; SQL [n/a]` + `Duplicate entry 'X' for key`

**Causa:** Estàs inserint un registre amb un valor que viola una restricció `UNIQUE`.

**Solució:** Verifica que no estàs inserint duplicats.

---

### ❌ `Not-null property references a null value`

**Causa:** Un camp anotat amb `@Column(nullable = false)` rep un valor `null`.

**Solució:** Assegura't d'enviar tots els camps obligatoris al JSON del POST/PUT.

---

## Errors de Controller / REST

### ❌ `Could not find acceptable representation`

**Causa:** Spring intenta convertir l'objecte Java a JSON però no pot. Normalment perquè falten **getters**.

**Solució:** Afegeix getters a tots els camps de l'entitat. Jackson (el serialitzador JSON) els necessita.

---

### ❌ `Resolved [HttpMessageNotReadableException: Required request body is missing]`

**Causa:** Has fet un POST/PUT sense enviar el cos JSON.

**Solució:** Afegeix `Content-Type: application/json` i el cos JSON a la petició.

---

### ❌ `Ambiguous handler methods mapped for '/api/products/count'`

**Causa:** `@GetMapping("/{id}")` captura "count" com a id. Spring no sap quin endpoint usar.

**Solució:** Posa endpoints específics (`/count`, `/search`) **abans** de `/{id}` al Controller.

---

## Errors de Maven

### ❌ `Could not find artifact org.springframework.boot:spring-boot-starter-...`

**Causa:** Maven no pot descarregar la dependència (connexió a internet, proxy, repositori).

**Solució:**
1. Verifica la connexió a internet
2. A IntelliJ: clic dret al `pom.xml` → Maven → Reload Project
3. Terminal: `mvn clean install -U`

---

### ❌ `java: error: release version X not supported`

**Causa:** La versió de Java configurada al `pom.xml` no coincideix amb la instal·lada.

**Solució:** Verifica que tens JDK 17+ amb `java -version`. A IntelliJ: File → Project Structure → SDK.

---

## Errors comuns al fitxer .http

### La petició no s'executa

**Causa:** No hi ha separador `###` entre peticions, o el servidor no està arrencat.

**Solució:** Cada petició ha de començar amb `###`. Verifica que l'app està running (logs: `Started ProductsApplication`).

---

### El POST/PUT no envia dades

**Causa:** Falta la línia `Content-Type: application/json` o hi ha una línia en blanc entre la capçalera i el cos.

**Format correcte:**
```http
### Crear producte
POST http://localhost:8080/api/products
Content-Type: application/json

{
  "name": "Exemple",
  "price": 1.0
}
```

> ⚠️ Ha d'haver-hi exactament **una línia en blanc** entre les capçaleres i el cos JSON.
