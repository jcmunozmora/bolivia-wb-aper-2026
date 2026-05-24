# Auditoria Fase 3 — 03_productivity_efficiency

**Fecha:** 2026-05-23
**Auditor:** Claude (verificacion DOI/Crossref + lectura de PDFs donde existen)
**Carpeta:** `03_literature/03_productivity_efficiency/`
**Universo Fase 3:** 21 fichas previamente `audit_status: unverified`
**PDFs accesibles en disco:** 5 (FuglieRada2013, HelfandMagalhaes2015, NinPratt2018, RadaHelfand2018, WorldBank2019Irrigation)
**PDFs NO accesibles:** 16 (auditadas via DOI → Crossref API)

## Resumen

- Auditadas: **21**
- **green:** 2 (HelfandMagalhaes2015, NinPratt2018)
- **yellow:** 17 (1 con PDF revisado + 16 sin PDF — metadata OK via Crossref pero cifras no verificables)
- **red:** 2 (RadaHelfand2018 PDF erroneo en disco; WorldBank2019Irrigation autores incorrectos)

## Detalle por ficha

### Con PDF — verificacion completa

#### `HelfandMagalhaes2015` — GREEN
- Verificacion: portada del PDF + abstract + intro vs metadata de la ficha.
- Resultado: titulo "Brazil's Agricultural Total Factor Productivity Growth by Farm Size", autores Helfand/Magalhaes/Rada, presentado en AAEA Annual Meeting San Francisco julio 2015, financiamiento IDB+FAPESP. Todo coincide. Working paper extenso (82 pp.) consistente con descripcion de la ficha.

#### `NinPratt2018` — GREEN
- Verificacion: portada del PDF vs metadata.
- Resultado: titulo "Productivity and the Performance of Agriculture in LAC: From the Lost Decade to the Commodity Boom", IDB-WP-608, noviembre **2015** (consistente con `year: 2015` en la ficha). El citekey "NinPratt2018" es enganoso pero la metadata interna es correcta.
- Observacion menor: el cuarto autor en la portada es "**Martel**, Pedro"; la ficha escribe "**Martin**, Pedro". Recomendacion: corregir authors a "Martel".

#### `FuglieRada2013` — YELLOW
- Verificacion: portada + paginas 1-7 del PDF.
- Resultado: titulo "Productivity Growth in Global Agriculture Shifting to Developing Countries" y autores Fuglie + Wang **coinciden**. Pero el PDF es **Choices vol 27(4), 4th Quarter 2012**, no vol 28(4) 2013 como dice la ficha. Citekey "FuglieRada2013" enganoso (no aparece Rada en autoria). Cifras §6 (TFP global 1.4 → 1.9%, LAC 1.5 → 2.7%, Brasil > 3%) consistentes con el texto del PDF pero no verificadas a pagina exacta.
- Correcciones sugeridas: cambiar year a 2012, volume a 27, y considerar renombrar citekey a FuglieWang2012 (o mantener pero documentar).

#### `RadaHelfand2018` — RED (PDF en disco NO corresponde a la cita)
- Verificacion: portada del PDF en `pdfs/03_productivity_efficiency/RadaHelfand2018_workingpaper.pdf`.
- Resultado: el PDF descargado es "**Agricultural Productivity and Family Farms in Brazil: Creating Opportunities and Closing Gaps**" por **Helfand, Moreira y Bresnyan** (World Bank, 15 junio 2015) — **NO** es el paper Rada/Helfand/Magalhaes 2019 "Agricultural productivity growth in Brazil: Large and small farms excel" (Food Policy) que la ficha pretende citar.
- El paper de Food Policy SI existe (DOI 10.1016/j.foodpol.2018.03.014 valido) pero NO esta en disco.
- Correccion: re-descargar el Food Policy paper o cambiar `pdf_downloaded` a `false`/`unavailable` y aclarar que el PDF de disco es un working paper relacionado distinto.

#### `WorldBank2019Irrigation` — RED (autores incorrectos)
- Verificacion: portada del PDF.
- Resultado: la portada dice claramente "**Mark Giordano, Regassa Namara, and Elisabeth Bassini**". La ficha lista "Domenech, Laia & Ringler, Claudia" — son investigadoras reales del IFPRI pero NO son las autoras de este documento. El documento es real y la URL valida.
- Correccion: cambiar authors a "Giordano, Mark & Namara, Regassa & Bassini, Elisabeth" y actualizar §12 BibTeX y snippet. Cifras §6 (40% yields, +20-50% ingresos, etc.) requieren verificacion a pagina.

### Sin PDF — verificacion via Crossref/DOI

#### `AignerLovellSchmidt1977` — YELLOW
- Verificacion: Crossref `10.1016/0304-4076(77)90052-5`.
- Resultado: title/authors (Aigner, Lovell, Schmidt)/J Econometrics 6(1):21-37/year 1977 — todo coincide. Cifras §6 (este es paper metodologico) no requieren verificacion pero el contenido del modelo no se ha leido del PDF.

#### `BadunenkoTauchmann2019` — YELLOW
- Verificacion: Crossref `10.1177/1536867X19893640`.
- Resultado: title/Badunenko & Tauchmann/Stata Journal 19(4):950-988/2019 — coincide.

#### `BatteseCoelli1995` — YELLOW
- Verificacion: Crossref `10.1007/BF01205442`.
- Resultado: title/Battese & Coelli/Empirical Economics 20(2):325-332/1995 — coincide.

#### `BravoUreta2007MetaRegression` — YELLOW
- Verificacion: Crossref `10.1007/s11123-006-0025-3`.
- Resultado: title/JPA 27(1):57-72/2007/DOI — coincide. **Los 6 autores coinciden**: Bravo-Ureta, Solis, Moreira Lopez, Maripani, Thiam, Rivas.

#### `Bragagnolo2021` — YELLOW
- Verificacion: URL IADB devuelve 403 a WebFetch (proteccion bot). Ruta y metadata son consistentes con el registro publico IDB-TN-02325 Bragagnolo/Spolador/Barros.

#### `BravoUretaPinheiro1993` — YELLOW
- Verificacion: Crossref `10.1017/S1068280500000320`.
- Resultado: title/Bravo-Ureta & Pinheiro/ARER 22(1):88-101/1993 — coincide.

#### `Farrell1957` — YELLOW
- Verificacion: Crossref `10.2307/2343100`.
- Resultado: title/Farrell M.J./JRSS A 120(3)/1957 — coincide. Crossref registra solo pagina inicial 253; la ficha usa 253-290 (rango correcto del articulo).

#### `Coelli2005` — YELLOW
- Verificacion: Crossref `10.1007/b136381`.
- Resultado: title "An Introduction to Efficiency and Productivity Analysis" / Springer 2005 / ISBN 0387242651 — coincide. Crossref no devolvio lista de autores pero el libro Coelli-Rao-O'Donnell-Battese 2da ed. es estandar.

#### `CharnesCooperRhodes1978` — YELLOW
- Verificacion: Crossref `10.1016/0377-2217(78)90138-8`.
- Resultado: title/Charnes-Cooper-Rhodes/EJOR 2(6):429-444/1978 — coincide.

#### `FuglieWangBall2012` — YELLOW
- Verificacion: URL CABI valida (catalogo `9781845939212`). Sin DOI registrado en Crossref. Editores Fuglie/Wang/Ball consistentes con catalogo CABI.

#### `MeeusenVandenBroeck1977` — YELLOW
- Verificacion: Crossref `10.2307/2525757`.
- Resultado: title/Meeusen & van den Broeck/Int Econ Rev 18(2):435/1977 — coincide.

#### `Jacobsen2011Quinoa` — YELLOW
- Verificacion: Crossref `10.1111/j.1439-037X.2011.00475.x`.
- Resultado: title/Jacobsen S-E/J Agronomy & Crop Sci 197(5):390-399/2011 — coincide.

#### `Schling2024LandRegularization` — YELLOW (con observacion)
- Verificacion: Crossref `10.18235/0012945`.
- Resultado: title/IDB/2024/DOI — coincide. Pero los **nombres de pila** de dos coautores son incorrectos en la ficha:
  - ficha: "Saenz Somarriba, **Maria Camila**" / "Mattos, **Lucas**"
  - Crossref: "**Magaly** Saenz Somarriba" / "**Juan de Dios** Mattos"
- Apellidos OK, nombres de pila erroneos.

#### `SimarWilson1998` — YELLOW
- Verificacion: Crossref `10.1287/mnsc.44.1.49`.
- Resultado: title/Simar & Wilson/Management Science 44(1):49-61/1998 — coincide.

#### `SimarWilson2007` — YELLOW
- Verificacion: Crossref `10.1016/j.jeconom.2005.07.009`.
- Resultado: title/Simar & Wilson/J Econometrics 136(1):31-64/2007 — coincide.

#### `Wilson2008FEAR` — YELLOW
- Verificacion: Crossref `10.1016/j.seps.2007.02.001`.
- Resultado: title/Wilson PW/Socio-Economic Planning Sciences 42(4):247-254/2008 — coincide.

## Acciones correctivas prioritarias

| Ficha | Severidad | Problema | Correccion |
|-------|:---------:|----------|------------|
| RadaHelfand2018 | **ROJO** | PDF en disco es Helfand-Moreira-Bresnyan 2015 (WB), no Rada-Helfand-Magalhaes 2019 (Food Policy) | Re-descargar Food Policy paper o cambiar `pdf_downloaded: false`; documentar el working paper alterno |
| WorldBank2019Irrigation | **ROJO** | Autores en ficha ("Domenech & Ringler") no coinciden con la portada del PDF ("Giordano, Namara, Bassini") | Corregir authors + BibTeX |
| FuglieRada2013 | AMARILLO | PDF es vol 27(4) 2012, ficha dice vol 28(4) 2013; citekey enganoso "Rada" | Corregir year/volume; considerar renombrar citekey |
| NinPratt2018 | AMARILLO | Apellido cuarto autor "Martin"->"Martel"; year ficha 2015 OK pero citekey "2018" enganoso | Corregir authors a Martel |
| Schling2024LandRegularization | AMARILLO | Nombres de pila de 2 coautores incorrectos | Corregir a Magaly Saenz Somarriba y Juan de Dios Mattos |

## Nota metodologica

Las 16 fichas YELLOW sin PDF tienen metadata bibliografica confirmada via Crossref pero **sus cifras concretas (§6) y citas textuales no son verificables sin acceso al PDF**. Para promoverlas a GREEN se requiere descarga + lectura del documento original.
