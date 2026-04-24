# Rúbrica d'Avaluació — Pràctica Final

> Puntuació màxima: 10 punts

---

## R1 — Entitat JPA (1.5 punts)

| Criteri | Punts | Indicadors |
|---|---|---|
| `@Entity` i `@Table` correctes | 0.3 | La classe està correctament anotada |
| `@Id` i `@GeneratedValue` | 0.3 | Clau primària autogenerada |
| `@Column` on necessari | 0.3 | `nullable`, `length` aplicats correctament |
| Constructor buit | 0.3 | Existeix i és funcional |
| Getters/Setters complets | 0.3 | Tots els camps accessibles |

---

## R2 — CRUD REST complet (2.5 punts)

| Criteri | Punts | Indicadors |
|---|---|---|
| GET /api/movies | 0.5 | Retorna la llista completa |
| GET /api/movies/{id} | 0.5 | Retorna 200+objecte si existeix, 404 si no |
| POST /api/movies | 0.5 | Crea correctament, retorna 201 amb objecte i id |
| PUT /api/movies/{id} | 0.5 | Actualitza correctament, gestiona 404 |
| DELETE /api/movies/{id} | 0.5 | Elimina correctament, gestiona 404 |

---

## R3 — Derived Query Methods (2.0 punts)

| Criteri | Punts | Indicadors |
|---|---|---|
| Mínim 3 mètodes implementats | 1.0 | Noms correctes, funcionals |
| Endpoints REST corresponents | 0.5 | Accessibles i funcionals |
| Varietat de paraules clau | 0.5 | Usa almenys 2 paraules clau diferents (Between, Containing, GreaterThan, etc.) |

**Bonus:** +0.5 si implementa més de 4 mètodes derivats funcionals.

---

## R4 — @Query personalitzada (1.5 punts)

| Criteri | Punts | Indicadors |
|---|---|---|
| Mínim 1 @Query funcional | 0.5 | La query s'executa correctament |
| Query ben escrita (JPQL o native) | 0.5 | Sintaxi correcta, ús de @Param |
| Endpoint REST funcional | 0.5 | Accessible i retorna dades correctes |

**Bonus:** +0.5 si implementa queries dels dos tipus (JPQL + native).

---

## R5 — @Transactional (1.0 punt)

| Criteri | Punts | Indicadors |
|---|---|---|
| Operació amb sentit lògic | 0.3 | El cas d'ús requereix atomicitat |
| `@Transactional` correctament aplicat | 0.4 | Al Service, mètode public |
| Rollback funcional | 0.3 | Si falla una part, tot es desfà (explicat a la memòria o demostrat) |

---

## R6 — Fitxers .http (1.0 punt)

| Criteri | Punts | Indicadors |
|---|---|---|
| Cobreix tots els endpoints CRUD | 0.4 | GET, POST, PUT, DELETE |
| Cobreix derived methods i @Query | 0.3 | Almenys 1 petició per cada endpoint personalitzat |
| Comentaris descriptius (###) | 0.15 | Cada petició documentada |
| Casos de prova negatius (404) | 0.15 | Almenys 1 petició que prova un cas d'error |

---

## R7 — Qualitat del codi (0.5 punts)

| Criteri | Punts | Indicadors |
|---|---|---|
| Separació correcta de capes | 0.2 | Controller → Service → Repository |
| Noms clars i consistents | 0.15 | Variables, mètodes, classes amb noms descriptius |
| Codi net | 0.15 | Sense codi comentat, imports no usats, etc. |

---

## Resum

| Requisit | Pes | Màxim |
|---|---|---|
| R1 — Entitat JPA | 15% | 1.5 |
| R2 — CRUD REST | 25% | 2.5 |
| R3 — Derived Methods | 20% | 2.0 |
| R4 — @Query | 15% | 1.5 |
| R5 — @Transactional | 10% | 1.0 |
| R6 — Fitxers .http | 10% | 1.0 |
| R7 — Qualitat | 5% | 0.5 |
| **Total** | **100%** | **10.0** |
| **Bonus possibles** | | +1.0 |

---

## Notes

- La pràctica que no compili o no arrenqui tindrà un **màxim de 3 punts** (només es valorarà codi i estructura).
- La còpia entre alumnes comporta un **0 per ambdues parts**.
- La memòria és obligatòria. Sense memòria: penalització de -1 punt.
