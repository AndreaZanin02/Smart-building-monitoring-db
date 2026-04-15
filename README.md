# Smart Building & Construction Monitoring Database

Questo repository contiene il progetto finale per il corso di Basi di Dati (Università di Pisa, A.A. 2021/2022). Il progetto consiste nella progettazione concettuale, logica e nell'implementazione fisica di un database relazionale in MySQL per la gestione e il monitoraggio di cantieri ed edifici.

## Dominio Applicativo
Il sistema è progettato per gestire le informazioni relative a complessi edilizi, con un forte focus sulla sicurezza e sull'analisi dei dati. Le macro-aree coperte dal database sono:
* **Area Costruzione:** Gestione dei progetti edilizi, stati di avanzamento, fasi di lavoro e logistica dei materiali.
* **Area Lavoratori:** Tracciamento del personale (capicantiere, operai generici), turni, orari e compensi.
* **Area Sensori:** Mappatura di sensori (accelerometri, giroscopi, sensori di umidità/temperatura) installati nei vani degli edifici per il monitoraggio continuo.
* **Area Rischi & Analytics:** Rilevazione di anomalie strutturali, classificazione degli alert, e calcolo di coefficienti di rischio (sismico e idrogeologico) su base geografica.

## Struttura del Repository

- `docs/`: Contiene la documentazione completa del progetto.
  - `documentazione.pdf`: Analisi dei requisiti, dizionario dei dati, tavola dei volumi e scelte progettuali.
  - `diagramma_ER_non_ristrutturato.pdf`: Modello concettuale iniziale.
  - `diagramma_ER_ristrutturato.pdf`: Modello logico finale post-eliminazione di generalizzazioni e attributi multivalore.
- `sql/`: Script per la creazione e la simulazione dell'ambiente.
  - `1_script.sql`: DDL per la creazione dello schema, delle tabelle e dei vincoli d'integrità.
  - `2_popolamento.sql`: DML con un dataset simulato per i test.
  - `3_operazioni.sql`: Stored procedure e trigger per le operazioni di routine (es. controlli di magazzino, inserimento turni).
  - `4_procedure_di_back-end.sql`: Query avanzate per la classificazione dei punti critici dell'edificio.
  - `5_area_analytics.sql`: Procedure complesse per la reportistica e la stima dei danni basata sullo storico degli eventi calamitosi e l'aggregazione dei dati dei sensori.

## Tecnologie Utilizzate
* **RDBMS:** MySQL
* **Linguaggio:** SQL (DDL, DML, Stored Procedures, Triggers, Views)
* **Progettazione:** Modello Entità-Relazione (ER)

## Come avviare il progetto
1. Clonare il repository: `git clone https://github.com/AndreaZanin02/Smart-building-monitoring-db.git`
2. Aprire un client database (es. MySQL Workbench, DBeaver).
3. Eseguire gli script presenti nella cartella `sql/` seguendo rigorosamente l'ordine numerico (prima la creazione dello schema, poi il popolamento, infine le procedure).

## Autori
* **Andrea Zanin** ([@AndreaZanin02](https://github.com/AndreaZanin02))
* **Filippo Gambelli** ([@FilippoGambelli](https://github.com/FilippoGambelli))

