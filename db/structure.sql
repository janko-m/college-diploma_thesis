--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

--
-- Name: croatian; Type: TEXT SEARCH DICTIONARY; Schema: public; Owner: -
--

CREATE TEXT SEARCH DICTIONARY croatian (
    TEMPLATE = pg_catalog.ispell,
    dictfile = 'croatian', stopwords = 'croatian', afffile = 'croatian' );


--
-- Name: croatian; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: -
--

CREATE TEXT SEARCH CONFIGURATION croatian (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR asciiword WITH croatian, simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR word WITH croatian, simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR hword_part WITH croatian, simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR hword_asciipart WITH croatian, simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR asciihword WITH croatian, simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR hword WITH croatian, simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION croatian
    ADD MAPPING FOR uint WITH simple;


--
-- Name: default_bib; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: -
--

CREATE TEXT SEARCH CONFIGURATION default_bib (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION default_bib
    ADD MAPPING FOR uint WITH simple;


SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: casopis; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE casopis (
    id integer,
    autori character varying(5000),
    naslov character varying(700),
    title character varying(700),
    casopis character varying(160),
    issn character varying(15),
    volumen character varying(40),
    broj character varying(40),
    godina character varying(80),
    stranica_prva character varying(100),
    sc_indeks character varying(2) DEFAULT 'NE'::character varying,
    cc_indeks character varying(2) DEFAULT 'NE'::character varying,
    kljucne_rijeci character varying(500),
    key_words character varying(500),
    sazetak text,
    jezik character varying(80),
    datoteka character varying(100),
    drugi_indeksi character varying(400),
    nn_casopis character varying(2),
    kategorija character varying(30),
    vrsta_rada character varying(50),
    lock character varying(2) DEFAULT 'NE'::character varying,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    medij_tiskani character varying(3) DEFAULT 'da'::character varying,
    medij_cdrom character varying(3),
    medij_url character varying(3),
    datoteka_datum timestamp without time zone,
    stranica_zadnja character varying(50),
    doi character varying(200),
    openurl character varying(200),
    ecasopis character varying(2) DEFAULT 'NE'::character varying,
    fti_os tsvector,
    fti_pr tsvector,
    fti_au tsvector
);


--
-- Name: disertacija; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE disertacija (
    id integer,
    autori character varying(500),
    naslov character varying(700),
    title character varying(700),
    fakultet character varying(100),
    mjesto character varying(100),
    datum character varying(120),
    stranica character varying(100),
    mentor character varying(100),
    vrsta_disertacije character varying(30),
    kljucne_rijeci character varying(500),
    key_words character varying(500),
    sazetak text,
    jezik character varying(80),
    datoteka character varying(100),
    sveuciliste character varying(100),
    godina character varying(80),
    neposredni_voditelj character varying(100),
    lock character varying(2) DEFAULT 'NE'::character varying,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    medij_tiskani character varying(3) DEFAULT 'da'::character varying,
    medij_cdrom character varying(3),
    medij_url character varying(3),
    datoteka_datum timestamp without time zone,
    fti_os tsvector,
    fti_pr tsvector,
    fti_au tsvector
);


--
-- Name: knjiga; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE knjiga (
    id integer,
    autori character varying(1000),
    naslov character varying(700),
    title character varying(700),
    grad character varying(70),
    godina character varying(80),
    serija character varying(100),
    stranica character varying(100),
    urednik character varying(300),
    nakladnik character varying(300),
    kljucne_rijeci character varying(500),
    key_words character varying(500),
    sazetak text,
    jezik character varying(80),
    datoteka character varying(100),
    mjesto character varying(200),
    isbn character varying(20),
    kategorija character varying(30),
    vrsta_knjige character varying(50),
    formalni_urednik character varying(300),
    prevodilac character varying(300),
    lock character varying(2) DEFAULT 'NE'::character varying,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    medij_tiskani character varying(3) DEFAULT 'da'::character varying,
    medij_cdrom character varying(3),
    medij_url character varying(3),
    datoteka_datum timestamp without time zone,
    fti_os tsvector,
    fti_pr tsvector,
    fti_au tsvector
);


--
-- Name: koja_tablica; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE koja_tablica (
    id integer NOT NULL,
    tabela character varying(40),
    ooid integer
);


--
-- Name: log; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE log (
    id integer NOT NULL,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    ip_broj inet,
    host character varying(100),
    radnja character varying(100),
    korisnik character varying(100),
    mail character varying(100),
    cn character varying(100)
);


--
-- Name: ostalo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ostalo (
    id integer,
    autori character varying(500),
    naslov character varying(700),
    title character varying(700),
    izvornik character varying(500),
    vrsta_rada character varying(100),
    kljucne_rijeci character varying(500),
    key_words character varying(500),
    sazetak text,
    jezik character varying(80),
    datoteka character varying(100),
    godina character varying(80),
    lock character varying(2) DEFAULT 'NE'::character varying,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    medij_tiskani character varying(3) DEFAULT 'da'::character varying,
    medij_cdrom character varying(3),
    medij_url character varying(3),
    datoteka_datum timestamp without time zone,
    fti_au tsvector,
    fti_pr tsvector,
    fti_os tsvector
);


--
-- Name: patent; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE patent (
    id integer,
    autori character varying(500),
    naslov character varying(700),
    title character varying(700),
    grad character varying(50),
    drzava character varying(5),
    podnositelj character varying(100),
    broj_prijave character varying(100),
    datum_prijave character varying(30),
    hpg_vol character varying(5),
    hpg_stranica character varying(5),
    godina character varying(5),
    broj_patenta character varying(20),
    datum_patenta character varying(30),
    mkp_klasifikacija character varying(20),
    naziv_druge_klasifikacije character varying(100),
    oznaka_druga_klasifikacije character varying(200),
    ime_nositelja_prava character varying(100),
    grad_nositelja_prava character varying(50),
    drzava_nositelja_prava character varying(5),
    kljucne_rijeci character varying(500),
    key_words character varying(500),
    sazetak text,
    jezik character varying(80),
    datoteka character varying(100),
    lock character varying(2) DEFAULT 'NE'::character varying,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    medij_tiskani character varying(3) DEFAULT 'da'::character varying,
    medij_cdrom character varying(3),
    medij_url character varying(3),
    datoteka_datum timestamp without time zone,
    fti_au tsvector,
    fti_pr tsvector,
    fti_os tsvector
);


--
-- Name: preprint; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE preprint (
    id integer,
    autori character varying(1500),
    naslov character varying(700),
    title character varying(700),
    casopis character varying(160),
    godina character varying(80),
    kljucne_rijeci character varying(500),
    key_words character varying(500),
    sazetak text,
    jezik character varying(80),
    datoteka character varying(100),
    kategorija character varying(30),
    status_rada character varying(50),
    lock character varying(2) DEFAULT 'NE'::character varying,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    medij_tiskani character varying(3) DEFAULT 'da'::character varying,
    medij_cdrom character varying(3),
    medij_url character varying(3),
    datoteka_datum timestamp without time zone,
    issn character varying(15),
    cc_indeks character varying(2) DEFAULT 'NE'::character varying,
    ecasopis character varying(2) DEFAULT 'NE'::character varying,
    fti_au tsvector,
    fti_pr tsvector,
    fti_os tsvector
);


--
-- Name: url; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE url (
    id integer,
    url character varying(1000) NOT NULL
);


--
-- Name: preprint_url; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW preprint_url AS
 SELECT preprint_1.id,
    preprint_1.autori,
    preprint_1.naslov,
    preprint_1.title,
    preprint_1.casopis,
    preprint_1.godina,
    preprint_1.kljucne_rijeci,
    preprint_1.key_words,
    preprint_1.sazetak,
    preprint_1.jezik,
    preprint_1.datoteka,
    preprint_1.kategorija,
    preprint_1.status_rada,
    preprint_1.lock,
    preprint_1.time_date,
    preprint_1.medij_tiskani,
    preprint_1.medij_cdrom,
    preprint_1.medij_url,
    preprint_1.fti_au,
    preprint_1.fti_pr,
    preprint_1.fti_os,
    preprint_1.datoteka_datum,
    preprint_1.issn,
    preprint_1.cc_indeks,
    preprint_1.url
   FROM (preprint
     LEFT JOIN ( SELECT DISTINCT ON (url_1.id) url_1.id,
            url_1.url
           FROM url url_1
          ORDER BY url_1.id) url USING (id)) preprint;


--
-- Name: projekt_skupina; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projekt_skupina (
    projekt character varying(20) NOT NULL,
    skupina character varying(5)
);


--
-- Name: rad_adm; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_adm (
    id integer,
    komentar text
);


--
-- Name: rad_autor; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_autor (
    id integer NOT NULL,
    maticni_broj integer NOT NULL
);


--
-- Name: rad_godina; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_godina (
    id integer NOT NULL,
    datum date NOT NULL
);


--
-- Name: rad_napomena; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_napomena (
    id integer,
    napomena text
);


--
-- Name: rad_podrucje; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_podrucje (
    id integer NOT NULL,
    sifra character varying(5) NOT NULL
);


--
-- Name: rad_prevodilac; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_prevodilac (
    id integer NOT NULL,
    maticni_broj integer NOT NULL
);


--
-- Name: rad_projekt; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_projekt (
    id integer NOT NULL,
    projekt character varying(100) NOT NULL
);


--
-- Name: rad_ustanova; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_ustanova (
    id integer NOT NULL,
    sifra integer NOT NULL
);


--
-- Name: rad_vlasnik; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_vlasnik (
    id integer NOT NULL,
    uid character varying(100) NOT NULL
);


--
-- Name: rad_voditelj; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rad_voditelj (
    id integer NOT NULL,
    maticni_broj integer NOT NULL
);


--
-- Name: rknjiga; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rknjiga (
    id integer,
    autori character varying(500),
    naslov character varying(700),
    title character varying(700),
    stranica_prva character varying(100),
    knjiga character varying(600),
    grad character varying(70),
    godina character varying(80),
    serija character varying(200),
    urednik character varying(300),
    nakladnik character varying(300),
    kljucne_rijeci character varying(500),
    key_words character varying(500),
    sazetak text,
    jezik character varying(80),
    datoteka character varying(100),
    mjesto character varying(200),
    isbn character varying(20),
    kategorija character varying(30),
    lock character varying(2) DEFAULT 'NE'::character varying,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    medij_tiskani character varying(3) DEFAULT 'da'::character varying,
    medij_cdrom character varying(3),
    medij_url character varying(3),
    datoteka_datum timestamp without time zone,
    ukupno_stranica character varying(100),
    stranica_zadnja character varying(50),
    fti_au tsvector,
    fti_pr tsvector,
    fti_os tsvector
);


SET default_with_oids = false;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: serial; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE serial
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_with_oids = true;

--
-- Name: skripta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skripta (
    id integer,
    autori character varying(1000),
    naslov character varying(700),
    title character varying(700),
    grad character varying(70),
    godina character varying(80),
    serija character varying(100),
    stranica character varying(100),
    urednik character varying(300),
    nakladnik character varying(300),
    kljucne_rijeci character varying(500),
    key_words character varying(500),
    sazetak text,
    jezik character varying(80),
    datoteka character varying(100),
    mjesto character varying(200),
    isbn character varying(20),
    lock character varying(2) DEFAULT 'NE'::character varying,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    medij_tiskani character varying(3) DEFAULT 'da'::character varying,
    medij_cdrom character varying(3),
    medij_url character varying(3),
    datoteka_datum timestamp without time zone,
    fti_au tsvector,
    fti_pr tsvector,
    fti_os tsvector
);


--
-- Name: tkojetko; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tkojetko (
    id integer NOT NULL,
    mb integer NOT NULL
);


--
-- Name: tmp; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tmp (
    id integer NOT NULL,
    broj integer,
    dbase character varying(40)[],
    sql text[],
    ins_time timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone
);


--
-- Name: zbornik; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE zbornik (
    id integer,
    autori character varying(5000),
    naslov character varying(700),
    title character varying(700),
    stranica_prva character varying(100),
    zbornik character varying(700),
    grad character varying(70),
    godina character varying(80),
    urednik character varying(300),
    nakladnik character varying(300),
    skup character varying(400),
    mjesto character varying(200),
    datum character varying(120),
    kljucne_rijeci character varying(500),
    key_words character varying(500),
    sazetak text,
    jezik character varying(80),
    datoteka character varying(100),
    vrst_sudjelovanja character varying(40),
    vrst_rada character varying(40),
    vrst_recenzije character varying(40),
    kategorija character varying(30),
    dio_cc_casopisa character varying(2) DEFAULT 'NE'::character varying,
    lock character varying(2) DEFAULT 'NE'::character varying,
    time_date timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    medij_tiskani character varying(3) DEFAULT 'da'::character varying,
    medij_cdrom character varying(3),
    medij_url character varying(3),
    isbn character varying(20),
    issn character varying(15),
    datoteka_datum timestamp without time zone,
    stranica_zadnja character varying(50),
    fti_au tsvector,
    fti_pr tsvector,
    fti_os tsvector
);


--
-- Name: koja_tablica_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY koja_tablica
    ADD CONSTRAINT koja_tablica_pkey PRIMARY KEY (id);


--
-- Name: projekt_skupina_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projekt_skupina
    ADD CONSTRAINT projekt_skupina_pkey PRIMARY KEY (projekt);


--
-- Name: rad_autor_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rad_autor
    ADD CONSTRAINT rad_autor_pkey PRIMARY KEY (id, maticni_broj);


--
-- Name: rad_godina_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rad_godina
    ADD CONSTRAINT rad_godina_pkey PRIMARY KEY (id);


--
-- Name: rad_podrucje_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rad_podrucje
    ADD CONSTRAINT rad_podrucje_pkey PRIMARY KEY (id, sifra);


--
-- Name: rad_prevodilac_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rad_prevodilac
    ADD CONSTRAINT rad_prevodilac_pkey PRIMARY KEY (id, maticni_broj);


--
-- Name: rad_projekt_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rad_projekt
    ADD CONSTRAINT rad_projekt_pkey PRIMARY KEY (id, projekt);


--
-- Name: rad_ustanova_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rad_ustanova
    ADD CONSTRAINT rad_ustanova_pkey PRIMARY KEY (id, sifra);


--
-- Name: rad_vlasnik_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rad_vlasnik
    ADD CONSTRAINT rad_vlasnik_pkey PRIMARY KEY (id, uid);


--
-- Name: rad_voditelj_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rad_voditelj
    ADD CONSTRAINT rad_voditelj_pkey PRIMARY KEY (id, maticni_broj);


--
-- Name: koja_tablica_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX koja_tablica_idx ON koja_tablica USING btree (id);


--
-- Name: log_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX log_idx ON log USING btree (id, time_date);


--
-- Name: ostalo_autori_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ostalo_autori_idx ON ostalo USING btree (autori);


--
-- Name: ostalo_fti_au_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ostalo_fti_au_idx ON ostalo USING gin (fti_au);


--
-- Name: ostalo_fti_os_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ostalo_fti_os_idx ON ostalo USING gin (fti_os);


--
-- Name: ostalo_fti_pr_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ostalo_fti_pr_idx ON ostalo USING gin (fti_pr);


--
-- Name: ostalo_godina_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ostalo_godina_idx ON ostalo USING btree (godina);


--
-- Name: ostalo_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX ostalo_idx ON ostalo USING btree (id);


--
-- Name: ostalo_key_words_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ostalo_key_words_idx ON ostalo USING btree (key_words);


--
-- Name: ostalo_kljucne_rijeci_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ostalo_kljucne_rijeci_idx ON ostalo USING btree (kljucne_rijeci);


--
-- Name: ostalo_naslov_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ostalo_naslov_idx ON ostalo USING btree (naslov);


--
-- Name: ostalo_title_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ostalo_title_idx ON ostalo USING btree (title);


--
-- Name: patent_autori_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX patent_autori_idx ON patent USING btree (autori);


--
-- Name: patent_fti_au_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX patent_fti_au_idx ON patent USING gin (fti_au);


--
-- Name: patent_fti_os_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX patent_fti_os_idx ON patent USING gin (fti_os);


--
-- Name: patent_fti_pr_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX patent_fti_pr_idx ON patent USING gin (fti_pr);


--
-- Name: patent_godina_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX patent_godina_idx ON patent USING btree (godina);


--
-- Name: patent_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX patent_idx ON patent USING btree (id);


--
-- Name: patent_key_words_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX patent_key_words_idx ON patent USING btree (key_words);


--
-- Name: patent_kljucne_rijeci_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX patent_kljucne_rijeci_idx ON patent USING btree (kljucne_rijeci);


--
-- Name: patent_naslov_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX patent_naslov_idx ON patent USING btree (naslov);


--
-- Name: patent_title_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX patent_title_idx ON patent USING btree (title);


--
-- Name: preprint_autori_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX preprint_autori_idx ON preprint USING btree (autori);


--
-- Name: preprint_fti_au_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX preprint_fti_au_idx ON preprint USING gin (fti_au);


--
-- Name: preprint_fti_os_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX preprint_fti_os_idx ON preprint USING gin (fti_os);


--
-- Name: preprint_fti_pr_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX preprint_fti_pr_idx ON preprint USING gin (fti_pr);


--
-- Name: preprint_godina_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX preprint_godina_idx ON preprint USING btree (godina);


--
-- Name: preprint_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX preprint_idx ON preprint USING btree (id);


--
-- Name: preprint_key_words_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX preprint_key_words_idx ON preprint USING btree (key_words);


--
-- Name: preprint_kljucne_rijeci_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX preprint_kljucne_rijeci_idx ON preprint USING btree (kljucne_rijeci);


--
-- Name: preprint_naslov_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX preprint_naslov_idx ON preprint USING btree (naslov);


--
-- Name: preprint_title_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX preprint_title_idx ON preprint USING btree (title);


--
-- Name: projekt_skupina_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX projekt_skupina_idx ON projekt_skupina USING btree (projekt);


--
-- Name: projekt_skupina_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX projekt_skupina_idx2 ON projekt_skupina USING btree (skupina);


--
-- Name: rad_adm_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_adm_idx ON rad_adm USING btree (id);


--
-- Name: rad_autor_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_autor_idx ON rad_autor USING btree (id);


--
-- Name: rad_autor_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_autor_idx2 ON rad_autor USING btree (maticni_broj);


--
-- Name: rad_godina_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_godina_idx ON rad_godina USING btree (id);


--
-- Name: rad_godina_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_godina_idx2 ON rad_godina USING btree (datum);


--
-- Name: rad_napomena_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_napomena_idx ON rad_napomena USING btree (id);


--
-- Name: rad_podrucje_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_podrucje_idx ON rad_podrucje USING btree (id);


--
-- Name: rad_podrucje_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_podrucje_idx2 ON rad_podrucje USING btree (sifra);


--
-- Name: rad_prevodilac_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_prevodilac_idx ON rad_prevodilac USING btree (id);


--
-- Name: rad_prevodilac_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_prevodilac_idx2 ON rad_prevodilac USING btree (maticni_broj);


--
-- Name: rad_projekt_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_projekt_idx ON rad_projekt USING btree (id);


--
-- Name: rad_projekt_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_projekt_idx2 ON rad_projekt USING btree (projekt);


--
-- Name: rad_ustanova_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_ustanova_idx ON rad_ustanova USING btree (id);


--
-- Name: rad_ustanova_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_ustanova_idx2 ON rad_ustanova USING btree (sifra);


--
-- Name: rad_voditelj_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_voditelj_idx ON rad_voditelj USING btree (id);


--
-- Name: rad_voditelj_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rad_voditelj_idx2 ON rad_voditelj USING btree (maticni_broj);


--
-- Name: rknjiga_autori_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_autori_idx ON rknjiga USING btree (autori);


--
-- Name: rknjiga_fti_au_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_fti_au_idx ON rknjiga USING gin (fti_au);


--
-- Name: rknjiga_fti_os_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_fti_os_idx ON rknjiga USING gin (fti_os);


--
-- Name: rknjiga_fti_pr_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_fti_pr_idx ON rknjiga USING gin (fti_pr);


--
-- Name: rknjiga_godina_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_godina_idx ON rknjiga USING btree (godina);


--
-- Name: rknjiga_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX rknjiga_idx ON rknjiga USING btree (id);


--
-- Name: rknjiga_isbn_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_isbn_idx ON rknjiga USING btree (isbn);


--
-- Name: rknjiga_key_words_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_key_words_idx ON rknjiga USING btree (key_words);


--
-- Name: rknjiga_kljucne_rijeci_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_kljucne_rijeci_idx ON rknjiga USING btree (kljucne_rijeci);


--
-- Name: rknjiga_naslov_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_naslov_idx ON rknjiga USING btree (naslov);


--
-- Name: rknjiga_title_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_title_idx ON rknjiga USING btree (title);


--
-- Name: rknjiga_urednik_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rknjiga_urednik_idx ON rknjiga USING btree (urednik);


--
-- Name: skripta_autori_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_autori_idx ON skripta USING btree (autori);


--
-- Name: skripta_fti_au_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_fti_au_idx ON skripta USING gin (fti_au);


--
-- Name: skripta_fti_os_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_fti_os_idx ON skripta USING gin (fti_os);


--
-- Name: skripta_fti_pr_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_fti_pr_idx ON skripta USING gin (fti_pr);


--
-- Name: skripta_godina_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_godina_idx ON skripta USING btree (godina);


--
-- Name: skripta_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX skripta_idx ON skripta USING btree (id);


--
-- Name: skripta_isbn_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_isbn_idx ON skripta USING btree (isbn);


--
-- Name: skripta_key_words_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_key_words_idx ON skripta USING btree (key_words);


--
-- Name: skripta_kljucne_rijeci_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_kljucne_rijeci_idx ON skripta USING btree (kljucne_rijeci);


--
-- Name: skripta_naslov_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_naslov_idx ON skripta USING btree (naslov);


--
-- Name: skripta_title_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_title_idx ON skripta USING btree (title);


--
-- Name: skripta_urednik_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skripta_urednik_idx ON skripta USING btree (urednik);


--
-- Name: tmp_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX tmp_idx ON tmp USING btree (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: url_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX url_idx ON url USING btree (id);


--
-- Name: zbornik_autori_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_autori_idx ON zbornik USING btree (autori);


--
-- Name: zbornik_fti_au_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_fti_au_idx ON zbornik USING gin (fti_au);


--
-- Name: zbornik_fti_os_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_fti_os_idx ON zbornik USING gin (fti_os);


--
-- Name: zbornik_fti_pr_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_fti_pr_idx ON zbornik USING gin (fti_pr);


--
-- Name: zbornik_godina_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_godina_idx ON zbornik USING btree (godina);


--
-- Name: zbornik_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX zbornik_idx ON zbornik USING btree (id);


--
-- Name: zbornik_isbn_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_isbn_idx ON zbornik USING btree (isbn);


--
-- Name: zbornik_issn_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_issn_idx ON zbornik USING btree (issn);


--
-- Name: zbornik_key_words_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_key_words_idx ON zbornik USING btree (key_words);


--
-- Name: zbornik_kljucne_rijeci_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_kljucne_rijeci_idx ON zbornik USING btree (kljucne_rijeci);


--
-- Name: zbornik_naslov_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_naslov_idx ON zbornik USING btree (naslov);


--
-- Name: zbornik_recenzija_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_recenzija_idx ON zbornik USING btree (vrst_recenzije);


--
-- Name: zbornik_sudjelovanje_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_sudjelovanje_idx ON zbornik USING btree (vrst_sudjelovanja);


--
-- Name: zbornik_title_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_title_idx ON zbornik USING btree (title);


--
-- Name: zbornik_urednik_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_urednik_idx ON zbornik USING btree (urednik);


--
-- Name: zbornik_vrst_rada_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX zbornik_vrst_rada_idx ON zbornik USING btree (vrst_rada);


--
-- Name: fti_au_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_au_update BEFORE INSERT OR UPDATE ON ostalo FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_au', 'public.default_bib', 'autori');


--
-- Name: fti_au_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_au_update BEFORE INSERT OR UPDATE ON patent FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_au', 'public.default_bib', 'autori');


--
-- Name: fti_au_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_au_update BEFORE INSERT OR UPDATE ON preprint FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_au', 'public.default_bib', 'autori');


--
-- Name: fti_au_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_au_update BEFORE INSERT OR UPDATE ON rknjiga FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_au', 'public.default_bib', 'autori');


--
-- Name: fti_au_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_au_update BEFORE INSERT OR UPDATE ON skripta FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_au', 'public.default_bib', 'autori');


--
-- Name: fti_au_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_au_update BEFORE INSERT OR UPDATE ON zbornik FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_au', 'public.default_bib', 'autori');


--
-- Name: fti_os_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_os_update BEFORE INSERT OR UPDATE ON ostalo FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_os', 'public.default_bib', 'autori');


--
-- Name: fti_os_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_os_update BEFORE INSERT OR UPDATE ON patent FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_os', 'public.default_bib', 'autori');


--
-- Name: fti_os_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_os_update BEFORE INSERT OR UPDATE ON preprint FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_os', 'public.default_bib', 'autori');


--
-- Name: fti_os_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_os_update BEFORE INSERT OR UPDATE ON rknjiga FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_os', 'public.default_bib', 'autori', 'urednik');


--
-- Name: fti_os_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_os_update BEFORE INSERT OR UPDATE ON skripta FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_os', 'public.default_bib', 'autori', 'urednik');


--
-- Name: fti_os_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_os_update BEFORE INSERT OR UPDATE ON zbornik FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_os', 'public.default_bib', 'autori');


--
-- Name: fti_pr_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_pr_update BEFORE INSERT OR UPDATE ON ostalo FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_pr', 'public.default_bib', 'naslov', 'title', 'sazetak', 'kljucne_rijeci', 'key_words');


--
-- Name: fti_pr_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_pr_update BEFORE INSERT OR UPDATE ON patent FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_pr', 'public.default_bib', 'naslov', 'title', 'sazetak', 'kljucne_rijeci', 'key_words');


--
-- Name: fti_pr_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_pr_update BEFORE INSERT OR UPDATE ON preprint FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_pr', 'public.default_bib', 'naslov', 'title', 'sazetak', 'kljucne_rijeci', 'key_words');


--
-- Name: fti_pr_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_pr_update BEFORE INSERT OR UPDATE ON rknjiga FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_pr', 'public.default_bib', 'naslov', 'title', 'sazetak', 'kljucne_rijeci', 'key_words', 'knjiga');


--
-- Name: fti_pr_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_pr_update BEFORE INSERT OR UPDATE ON skripta FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_pr', 'public.default_bib', 'naslov', 'title', 'sazetak', 'kljucne_rijeci', 'key_words');


--
-- Name: fti_pr_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fti_pr_update BEFORE INSERT OR UPDATE ON zbornik FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fti_pr', 'public.default_bib', 'naslov', 'title', 'sazetak', 'kljucne_rijeci', 'key_words', 'zbornik');


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY casopis
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY disertacija
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY knjiga
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ostalo
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patent
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY preprint
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rknjiga
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skripta
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zbornik
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_autor
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_prevodilac
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_voditelj
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_godina
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_podrucje
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_projekt
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_ustanova
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_napomena
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY url
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_vlasnik
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rad_adm
    ADD CONSTRAINT "$1" FOREIGN KEY (id) REFERENCES koja_tablica(id) ON DELETE CASCADE;


--
-- Name: casopis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY casopis
    ADD CONSTRAINT casopis_id_fkey FOREIGN KEY (id) REFERENCES koja_tablica(id);


--
-- Name: disertacija_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY disertacija
    ADD CONSTRAINT disertacija_id_fkey FOREIGN KEY (id) REFERENCES koja_tablica(id);


--
-- Name: knjiga_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY knjiga
    ADD CONSTRAINT knjiga_id_fkey FOREIGN KEY (id) REFERENCES koja_tablica(id);


--
-- Name: ostalo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ostalo
    ADD CONSTRAINT ostalo_id_fkey FOREIGN KEY (id) REFERENCES koja_tablica(id);


--
-- Name: patent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patent
    ADD CONSTRAINT patent_id_fkey FOREIGN KEY (id) REFERENCES koja_tablica(id);


--
-- Name: preprint_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY preprint
    ADD CONSTRAINT preprint_id_fkey FOREIGN KEY (id) REFERENCES koja_tablica(id);


--
-- Name: skripta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skripta
    ADD CONSTRAINT skripta_id_fkey FOREIGN KEY (id) REFERENCES koja_tablica(id);


--
-- Name: zbornik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zbornik
    ADD CONSTRAINT zbornik_id_fkey FOREIGN KEY (id) REFERENCES koja_tablica(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('1');

