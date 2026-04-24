# Guia d'Instal·lació — Entorn de Desenvolupament

Aquesta guia detalla els passos necessaris per preparar el vostre ordinador per a les sessions de Spring Boot i Bases de Dades.

Està pensada pel primer dia de classe o com a tasca prèvia a casa.

---

## 1. Instal·lar Java Development Kit (JDK)

Necessitem Java 17 o superior. (Es recomana Java 21).

### Comprovació
Obre un terminal o símbol del sistema i escriu:
```bash
java -version
```
Si el resultat és una versió 17 o superior, ja ho tens! Si dóna error o és inferior a 17, continua llegint.

### Windows / macOS
Baixa i instal·la Eclipse Temurin (adoptium) des de:
[https://adoptium.net/](https://adoptium.net/)

---

## 2. Instal·lar un IDE (Entorn de Desenvolupament)

Pots triar el que prefereixis, però recomanem **IntelliJ IDEA**.

### Opció A: IntelliJ IDEA
- Baixa **IntelliJ IDEA Community Edition** (gratuït).
- Enllaç: [https://www.jetbrains.com/idea/download/](https://www.jetbrains.com/idea/download/)

### Opció B: Visual Studio Code
Si prefereixes VS Code:
1. Instal·la VS Code.
2. Afegeix l'extensió "Extension Pack for Java" (de Microsoft).
3. Afegeix l'extensió "Spring Boot Extension Pack" (de Pivotal).

---

## 3. Instal·lar MySQL i MySQL Workbench

Necessitarem un servidor de bases de dades i una interfície per consultar-lo (Workbench).

### Windows
1. Baixa el **MySQL Installer** (versió Community): [https://dev.mysql.com/downloads/installer/](https://dev.mysql.com/downloads/installer/)
2. Executa'l i tria el tipus d'instal·lació "Developer Default" (instal·la Server i Workbench a la vegada).
3. Durant la instal·lació, se't demanarà configurar un password per a l'usuari `root`. **Apunta'l bé!** A classe farem servir `1234` per simplificar, però si en poses un altre, recorda'l.

### macOS
La forma més fàcil és amb Homebrew:
```bash
brew install mysql
brew services start mysql
```
I a continuació configurar el password:
```bash
mysql_secure_installation
```
Per la interfície, pots baixar **MySQL Workbench**: [https://dev.mysql.com/downloads/workbench/](https://dev.mysql.com/downloads/workbench/) o fer servir **DBeaver**.

---

## 4. Crear la Base de Dades del Curs

Un cop tens MySQL Workbench (o similar) obert i connectat al teu servidor de MySQL (`localhost` port `3306`):

1. Obre un nou "SQL script".
2. Obre el fitxer `products_db.sql` que us ha proporcionat el professor, i copia'n tot el contingut.
3. Executa'l complet («Execute» / el símbol del llamp ⚡).
4. Actualitza els Esquemes (Schemas) al teu client i comprova que veus una base de dades anomenada `products_db` amb una taula `products`.

---

## 5. Extensions importants per a l'IDE (Fitxers `.http`)

Al llarg del curs farem servir fitxers `.http` en comptes de Postman per provar les nostres APIs de manera més ràpida.

- **A IntelliJ IDEA:** Està inclòs de sèrie (HTTP Client integrat).
- **A VS Code:** Instal·la l'extensió **REST Client** de Huachao Mao.

---

> ✅ **Tot llest!** Ara ja pots crear un nou projecte Spring Boot (veure l'altra guia).
