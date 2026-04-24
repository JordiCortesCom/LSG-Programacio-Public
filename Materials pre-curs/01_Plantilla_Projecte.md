# Inicialitzar un Projecte Spring Boot

La forma oficial i recomanada de crear un nou projecte Spring Boot és a través de **Spring Initializr**. Ho pots fer des de la web o directament amb eines de línia de comandes si utilitzes VS Code/IntelliJ.

## 1. Mètode Web (Spring Initializr)

1. Ves a [https://start.spring.io/](https://start.spring.io/)
2. Configura les opcions del projecte:
   * **Project**: Maven
   * **Language**: Java
   * **Spring Boot**: deixa la versió recomanada per defecte (ex: 3.2.x o la més estable).
   * **Project Metadata**:
     * Group: `com.curs`
     * Artifact: `products-api`
     * Name: `products-api`
     * Packaging: `Jar`
     * Java: `17` (o 21, si és el que tens instal·lat i configurat al terminal/IDE).
3. Fes clic a **"ADD DEPENDENCIES"** i afegeix el següent segons la fase del curs:
   * Sempre necessitem:
     * **Spring Web** (per crear la API REST, inclou Tomcat integrat)
   * A partir de la Sessió 2 (`JdbcTemplate`):
     * **JDBC API** (suport de JdbcTemplate)
     * **MySQL Driver** (el connector)
   * A partir de la Sessió 4 (`JPA`):
     * **Spring Data JPA** (es pot canviar per JDBC API a l'inici, o simplement afegir-la. JPA inclou ORM/Hibernate).
4. Fes clic a **"GENERATE"**. Es baixarà un fitxer `.zip`.
5. Descomprimeix el `.zip` en una carpeta que no tingui espais ni caràcters estranys a la ruta.

---

## 2. Obrir el projecte al teu IDE

### IntelliJ IDEA
- Importa el projecte descomprimit fent clic a `File > Open` i selecciona la carpeta principal. **No seleccionis els fitxers interns, sinó la carpeta arrel**.
- Espera que l'IDE llegeixi el `pom.xml` i baixi les dependències de Maven (hi haurà una barra de progrés o notificacions a la part inferior). Pot tardar uns minuts el primer cop.

### Visual Studio Code
- Obre la carpeta descomprimida des de `File > Open Folder`.
- Si l'entorn de Java i l'extensió de Spring Boot estan instal·lats, reconeixerà automàticament que és un projecte Java.
- Fes clic a "Yes, I trust the authors".
- Navega a `src/main/java/com/curs/.../ProductsApiApplication.java` i pots utilitzar "Run" o "Debug" per executar l'aplicació.

---

## 3. Què cal tenir en compte en arrencar-lo?

Abans d'iniciar l'aplicació (`run()`), depenent de la sessió, assegurat que:

* Configuració a `application.properties`: Si ja tens dependències de MySQL posades (com el jdbc o jpa), l'aplicació *fallarà a l'arrencada* si no li indiques a `src/main/resources/application.properties` les claus per connectar-se:
  ```properties
  spring.datasource.url=jdbc:mysql://localhost:3306/products_db
  spring.datasource.username=root
  spring.datasource.password=1234
  ```
  **(Sessió 1 només demana `Spring Web`, de manera que no caldrà BBDD fins a la S2).**
