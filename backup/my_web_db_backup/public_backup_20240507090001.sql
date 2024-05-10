--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Debian 15.1-1.pgdg110+1)
-- Dumped by pg_dump version 15.6 (Ubuntu 15.6-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: aerich; Type: TABLE; Schema: public; Owner: hello_fastapi
--

CREATE TABLE public.aerich (
    id integer NOT NULL,
    version character varying(255) NOT NULL,
    app character varying(100) NOT NULL,
    content jsonb NOT NULL
);


ALTER TABLE public.aerich OWNER TO hello_fastapi;

--
-- Name: aerich_id_seq; Type: SEQUENCE; Schema: public; Owner: hello_fastapi
--

CREATE SEQUENCE public.aerich_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.aerich_id_seq OWNER TO hello_fastapi;

--
-- Name: aerich_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hello_fastapi
--

ALTER SEQUENCE public.aerich_id_seq OWNED BY public.aerich.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: hello_fastapi
--

CREATE TABLE public.notes (
    id integer NOT NULL,
    title character varying(225) NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    author_id integer NOT NULL
);


ALTER TABLE public.notes OWNER TO hello_fastapi;

--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: hello_fastapi
--

CREATE SEQUENCE public.notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notes_id_seq OWNER TO hello_fastapi;

--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hello_fastapi
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: hello_fastapi
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(20) NOT NULL,
    full_name character varying(50),
    password character varying(128),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO hello_fastapi;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: hello_fastapi
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO hello_fastapi;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hello_fastapi
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: aerich id; Type: DEFAULT; Schema: public; Owner: hello_fastapi
--

ALTER TABLE ONLY public.aerich ALTER COLUMN id SET DEFAULT nextval('public.aerich_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: hello_fastapi
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: hello_fastapi
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: aerich; Type: TABLE DATA; Schema: public; Owner: hello_fastapi
--

COPY public.aerich (id, version, app, content) FROM stdin;
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: hello_fastapi
--

COPY public.notes (id, title, content, created_at, modified_at, author_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: hello_fastapi
--

COPY public.users (id, username, full_name, password, created_at, modified_at) FROM stdin;
2	test	test	$2b$12$vyn5IReAYuMTbjeD5Mj7A.VtVGzAiKBUiQJqVUQp82zpAPcLO14iq	2024-05-04 12:07:44.112106+00	2024-05-04 12:07:44.112131+00
100	testuser	Test User	$2b$12$v8L2rpFaQvhQNgyVUiVLsucjvCIp39DdDwOdNh3RBUIe/E67s4SwC	2024-05-05 07:26:15.690754+00	2024-05-05 07:26:15.690776+00
\.


--
-- Name: aerich_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hello_fastapi
--

SELECT pg_catalog.setval('public.aerich_id_seq', 1, false);


--
-- Name: notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hello_fastapi
--

SELECT pg_catalog.setval('public.notes_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hello_fastapi
--

SELECT pg_catalog.setval('public.users_id_seq', 100, true);


--
-- Name: aerich aerich_pkey; Type: CONSTRAINT; Schema: public; Owner: hello_fastapi
--

ALTER TABLE ONLY public.aerich
    ADD CONSTRAINT aerich_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: hello_fastapi
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: hello_fastapi
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: hello_fastapi
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: notes notes_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hello_fastapi
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

