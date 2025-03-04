--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Homebrew)
-- Dumped by pg_dump version 17.4 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: batches; Type: TABLE; Schema: public; Owner: chinmayvivek
--

CREATE TABLE public.batches (
    batch_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    course_id uuid NOT NULL,
    batch_name character varying(100) NOT NULL,
    instructor_id uuid NOT NULL,
    start_date date,
    end_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.batches OWNER TO chinmayvivek;

--
-- Name: class_recordings; Type: TABLE; Schema: public; Owner: chinmayvivek
--

CREATE TABLE public.class_recordings (
    recording_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    class_id uuid NOT NULL,
    recording_url text,
    recorded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.class_recordings OWNER TO chinmayvivek;

--
-- Name: classes; Type: TABLE; Schema: public; Owner: chinmayvivek
--

CREATE TABLE public.classes (
    class_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    batch_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    scheduled_at timestamp without time zone,
    live_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.classes OWNER TO chinmayvivek;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: chinmayvivek
--

CREATE TABLE public.courses (
    course_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.courses OWNER TO chinmayvivek;

--
-- Name: instructors; Type: TABLE; Schema: public; Owner: chinmayvivek
--

CREATE TABLE public.instructors (
    instructor_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100),
    email character varying(150) NOT NULL,
    phone_number character varying(15),
    password_hash text,
    sso_provider character varying(50),
    sso_provider_id character varying(255),
    profile_picture_url text,
    bio text,
    date_of_birth date,
    address text,
    gender character varying(20),
    social_media_handles jsonb,
    qualifications text,
    years_of_experience integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.instructors OWNER TO chinmayvivek;

--
-- Name: notes; Type: TABLE; Schema: public; Owner: chinmayvivek
--

CREATE TABLE public.notes (
    note_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    class_id uuid NOT NULL,
    user_id uuid NOT NULL,
    note_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notes OWNER TO chinmayvivek;

--
-- Name: students; Type: TABLE; Schema: public; Owner: chinmayvivek
--

CREATE TABLE public.students (
    student_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100),
    email character varying(150) NOT NULL,
    phone_number character varying(20),
    password_hash text,
    sso_provider character varying(50),
    sso_provider_id character varying(255),
    profile_picture_url text,
    bio text,
    date_of_birth date,
    address text,
    gender character varying(20),
    social_media_handles jsonb,
    nationality character varying(50),
    preferred_language character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.students OWNER TO chinmayvivek;

--
-- Name: students_enrolled; Type: TABLE; Schema: public; Owner: chinmayvivek
--

CREATE TABLE public.students_enrolled (
    enrollment_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    enrollment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.students_enrolled OWNER TO chinmayvivek;

--
-- Data for Name: batches; Type: TABLE DATA; Schema: public; Owner: chinmayvivek
--

COPY public.batches (batch_id, course_id, batch_name, instructor_id, start_date, end_date, created_at) FROM stdin;
16803052-76df-47f5-b20f-3dc6a5f1da8e	a0e8f6a9-8cb2-4cb2-bbc4-133fcce4418e	DSA Batch 1	111d7c66-0541-4712-967f-3f586834ca80	2025-03-10	2025-06-10	2025-03-04 15:31:18.864173
eff2f223-48e8-4a45-87d7-7757859ccd11	bfc774d9-ad68-439b-b61b-399a319e29a8	Hindustani Classical Vocal Batch 1	a264b4d1-2090-47df-8678-62a3b7275f91	2025-04-01	2025-07-01	2025-03-04 15:31:18.864173
d6d6ce87-0094-48d1-beb9-2a7b774b6772	d81d4bf6-b6cc-45b2-9c80-d3dfe0b0408f	Vedic Astrology Batch 1	55d31bd8-3f21-48de-9688-87fc9e81bada	2025-03-15	2025-06-15	2025-03-04 15:31:18.864173
ccc5850c-5b95-48e8-b6d9-00f36805aef9	7da5aed3-23b4-438a-a296-8c4e70f48bcb	Web Development Batch 1	ae365955-0bcf-4766-96ec-65b15ebe2464	2025-03-20	2025-06-20	2025-03-04 15:31:18.864173
fd70a9a1-334d-4924-9ca1-62ee2153ee10	72e35ada-ae9e-4d49-a869-d6a538a8fae7	Machine Learning Batch 1	69abd674-83bd-48ac-9836-35c82e87aa4a	2025-03-25	2025-06-25	2025-03-04 15:31:18.864173
8f45e16d-0856-46e9-8bf7-2e7405adb6b9	09f85481-2596-4ca2-a942-ed4a1d610868	Photography Basics Batch 1	8e26af9f-6f97-41c2-aac3-d482af993449	2025-04-05	2025-07-05	2025-03-04 15:31:18.864173
bda99212-4b3c-4cd8-ba19-da9f5d384359	987c94d2-efa9-46dc-90ae-835f4e0be0d2	Creative Writing Batch 1	57f92096-3a7b-440b-899a-5ea811699888	2025-03-30	2025-06-30	2025-03-04 15:31:18.864173
e6f6d1a6-872d-4516-be03-e5749e34380a	8692643e-ae1e-47c8-99be-3df0bc5fc549	Personal Finance Batch 1	933a7e90-4873-4d9c-a480-ffeb02480af5	2025-03-18	2025-06-18	2025-03-04 15:31:18.864173
9e90077e-d666-4cda-848b-3d3011767fd8	42e52d6d-d010-441b-b1b8-6fbfb65e732c	Public Speaking Batch 1	2bd2f411-c397-4d20-a734-32c0432bdb68	2025-04-10	2025-07-10	2025-03-04 15:31:18.864173
7c0724ea-5c3f-44cf-b31b-8aa925ae6f93	38fd7790-3886-40e1-911b-fc8b7ed0f15f	Fitness and Weight Loss Batch 1	fdfa098a-8812-4096-b62f-2c86bccf7436	2025-04-01	2025-06-01	2025-03-04 15:31:18.864173
51ad8e8a-14d0-4aba-81e8-ae466b21e87d	071e82d5-fcf7-4d31-9f2c-ac5f02fa4a2a	Yoga for Beginners Batch 1	111d7c66-0541-4712-967f-3f586834ca80	2025-04-15	2025-07-15	2025-03-04 15:31:18.864173
8a35c338-90ae-4962-ae4a-84c556ec8943	e2dfd6dc-6c55-41fd-a258-263adb97755f	Entrepreneurship and Startups Batch 1	a264b4d1-2090-47df-8678-62a3b7275f91	2025-03-05	2025-06-05	2025-03-04 15:31:18.864173
388ddfcc-2e58-4c95-b3c6-6034ef2e3df9	1268c870-784d-4560-afec-0d0e1d1de4bb	Meditation and Mindfulness Batch 1	55d31bd8-3f21-48de-9688-87fc9e81bada	2025-03-22	2025-06-22	2025-03-04 15:31:18.864173
d292e265-1be8-4f1b-a677-21963c8e5bb9	c3fd5628-21d1-4e48-89c8-c7c4fc8b5735	Culinary Arts Batch 1	69abd674-83bd-48ac-9836-35c82e87aa4a	2025-04-20	2025-07-20	2025-03-04 15:31:18.864173
797f60bb-f93b-4229-a864-cdc6db5e7057	a7fbc32f-40f2-401f-8438-69a092f434d9	Graphic Design Batch 1	8e26af9f-6f97-41c2-aac3-d482af993449	2025-03-28	2025-06-28	2025-03-04 15:31:18.864173
fb0a1103-88be-4b62-a9ba-b9eb917fda08	6d792c1b-6fc0-4681-9f9e-f87ddac71a81	Advanced Excel Batch 1	57f92096-3a7b-440b-899a-5ea811699888	2025-03-12	2025-06-12	2025-03-04 15:31:18.864173
0bef73ed-14cf-47c2-b324-7d0eb85d303b	b3db5b7d-8e97-457f-89f7-fbf85f410241	Music Theory and Composition Batch 1	933a7e90-4873-4d9c-a480-ffeb02480af5	2025-03-17	2025-06-17	2025-03-04 15:31:18.864173
ef5b13f9-c8c0-4d1a-9059-c58004351e66	8258c893-173e-48cc-8b71-a5f73bd7cf65	Film Making and Video Production Batch 1	2bd2f411-c397-4d20-a734-32c0432bdb68	2025-04-08	2025-07-08	2025-03-04 15:31:18.864173
2a2d45ad-2756-4284-a788-30749f5be965	3c47155d-8b3f-44cc-8087-f3a836d7636a	Artificial Intelligence Batch 1	fdfa098a-8812-4096-b62f-2c86bccf7436	2025-04-02	2025-07-02	2025-03-04 15:31:18.864173
8e0fd4f4-7103-4718-af7a-7822b05cb770	eac68131-7cbe-4eaa-9918-cc99b8f55196	Digital Marketing Batch 1	111d7c66-0541-4712-967f-3f586834ca80	2025-04-18	2025-07-18	2025-03-04 15:31:18.864173
\.


--
-- Data for Name: class_recordings; Type: TABLE DATA; Schema: public; Owner: chinmayvivek
--

COPY public.class_recordings (recording_id, class_id, recording_url, recorded_at) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: chinmayvivek
--

COPY public.classes (class_id, batch_id, title, scheduled_at, live_url, created_at) FROM stdin;
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: chinmayvivek
--

COPY public.courses (course_id, title, description, created_at) FROM stdin;
a0e8f6a9-8cb2-4cb2-bbc4-133fcce4418e	Data Structures and Algorithms (DSA)	Learn the fundamentals of DSA, including arrays, trees, graphs, sorting algorithms, and more.	2025-03-04 12:03:44.975693
bfc774d9-ad68-439b-b61b-399a319e29a8	Hindustani Classical Vocal	An in-depth course focusing on ragas, classical techniques, and the history of Hindustani vocal music.	2025-03-04 12:03:44.975693
d81d4bf6-b6cc-45b2-9c80-d3dfe0b0408f	Falit Jyotish (Vedic Astrology)	Explore the ancient science of astrology, learn how to interpret horoscopes, and understand planetary influences.	2025-03-04 12:03:44.975693
7da5aed3-23b4-438a-a296-8c4e70f48bcb	Web Development with HTML, CSS, and JavaScript	A beginner-friendly course to learn the basics of web development including front-end technologies.	2025-03-04 12:03:44.975693
72e35ada-ae9e-4d49-a869-d6a538a8fae7	Introduction to Machine Learning	Dive into machine learning concepts, algorithms, and techniques for data prediction and analysis.	2025-03-04 12:03:44.975693
09f85481-2596-4ca2-a942-ed4a1d610868	Photography Basics	Learn the principles of photography, camera settings, lighting techniques, and editing.	2025-03-04 12:03:44.975693
987c94d2-efa9-46dc-90ae-835f4e0be0d2	Creative Writing	Enhance your writing skills, explore various styles, and develop your voice as a writer.	2025-03-04 12:03:44.975693
8692643e-ae1e-47c8-99be-3df0bc5fc549	Personal Finance and Investment Strategies	Learn how to manage personal finances, save, and make informed investment decisions.	2025-03-04 12:03:44.975693
42e52d6d-d010-441b-b1b8-6fbfb65e732c	Public Speaking and Communication Skills	Improve your public speaking, presentation techniques, and interpersonal communication skills.	2025-03-04 12:03:44.975693
38fd7790-3886-40e1-911b-fc8b7ed0f15f	Fitness and Weight Loss	A comprehensive guide to fitness routines, nutrition, and effective weight loss strategies.	2025-03-04 12:03:44.975693
071e82d5-fcf7-4d31-9f2c-ac5f02fa4a2a	Yoga for Beginners	Understand the basics of yoga, including poses, breathing exercises, and relaxation techniques.	2025-03-04 12:03:44.975693
e2dfd6dc-6c55-41fd-a258-263adb97755f	Entrepreneurship and Business Startups	Gain insights into launching and running a successful startup, including business plans, marketing, and operations.	2025-03-04 12:03:44.975693
1268c870-784d-4560-afec-0d0e1d1de4bb	Art of Meditation and Mindfulness	Learn various meditation techniques, mindfulness practices, and how they benefit mental health.	2025-03-04 12:03:44.975693
c3fd5628-21d1-4e48-89c8-c7c4fc8b5735	Culinary Arts: Basics of Cooking	Learn the fundamental techniques of cooking, knife skills, and how to prepare meals from scratch.	2025-03-04 12:03:44.975693
a7fbc32f-40f2-401f-8438-69a092f434d9	Introduction to Graphic Design	Learn the basics of graphic design, including design principles, tools, and typography.	2025-03-04 12:03:44.975693
6d792c1b-6fc0-4681-9f9e-f87ddac71a81	Advanced Excel for Data Analysis	Take your Excel skills to the next level, focusing on data analysis, pivot tables, and complex formulas.	2025-03-04 12:03:44.975693
b3db5b7d-8e97-457f-89f7-fbf85f410241	Music Theory and Composition	Understand the foundational principles of music theory, including scales, chords, and how to compose music.	2025-03-04 12:03:44.975693
8258c893-173e-48cc-8b71-a5f73bd7cf65	Film Making and Video Production	Explore the world of filmmaking, from scripting to shooting, editing, and post-production techniques.	2025-03-04 12:03:44.975693
3c47155d-8b3f-44cc-8087-f3a836d7636a	Artificial Intelligence for Beginners	Get started with AI, covering fundamental concepts like neural networks, deep learning, and natural language processing.	2025-03-04 12:03:44.975693
eac68131-7cbe-4eaa-9918-cc99b8f55196	Digital Marketing and Social Media Strategies	Learn how to use digital platforms, social media, and SEO techniques to grow businesses and brands online.	2025-03-04 12:03:44.975693
\.


--
-- Data for Name: instructors; Type: TABLE DATA; Schema: public; Owner: chinmayvivek
--

COPY public.instructors (instructor_id, first_name, last_name, email, phone_number, password_hash, sso_provider, sso_provider_id, profile_picture_url, bio, date_of_birth, address, gender, social_media_handles, qualifications, years_of_experience, created_at, updated_at) FROM stdin;
111d7c66-0541-4712-967f-3f586834ca80	Olen	Aufderhar	Jermey.Kihn58@hotmail.com	2178212016	\N	\N	\N	\N	venture lover  🤢	1977-04-08	816 Mireille Trafficway, Faroe Islands	male	{}	\N	7	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
a264b4d1-2090-47df-8678-62a3b7275f91	Terrell	Ratke	Brenden.Jerde58@gmail.com	3485162506	\N	\N	\N	\N	grad	1983-07-20	335 Etha Fort, Iceland	male	{}	\N	1	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
55d31bd8-3f21-48de-9688-87fc9e81bada	Ardith	Stehr	Alycia_Murazik@gmail.com	3178833752	\N	\N	\N	\N	streamer, foodie	1963-08-27	28816 Laurie Village, Isle of Man	female	{}	\N	9	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
ae365955-0bcf-4766-96ec-65b15ebe2464	Flavio	McGlynn	Reyes.Friesen@gmail.com	17536005310	\N	\N	\N	\N	cousin advocate, developer	1972-01-22	3261 Kristopher Bypass, Cyprus	male	{}	\N	8	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
69abd674-83bd-48ac-9836-35c82e87aa4a	Kaylie	Ledner	Shad_Johnson@hotmail.com	3564235003	\N	\N	\N	\N	minor-league enthusiast  🍰	1963-06-13	13983 Kunze Loaf, Virgin Islands, U.S.	female	{}	\N	1	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
8e26af9f-6f97-41c2-aac3-d482af993449	Ike	Hamill	Robyn85@yahoo.com	2346717557	\N	\N	\N	\N	entrepreneur	1975-11-27	1651 Amber Estate, Ghana	male	{}	\N	8	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
57f92096-3a7b-440b-899a-5ea811699888	Bernadette	Daugherty	Jessyca21@yahoo.com	8219724759	\N	\N	\N	\N	scientist, designer	1988-09-25	2052 Littel Radial, Curacao	female	{}	\N	9	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
933a7e90-4873-4d9c-a480-ffeb02480af5	Georgiana	Walker	Ewell53@yahoo.com	12794557150	\N	\N	\N	\N	smith junkie, scientist 🔉	1954-05-12	4761 Harrison Knoll, Cyprus	female	{}	\N	1	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
2bd2f411-c397-4d20-a734-32c0432bdb68	Maddison	Runolfsdottir	Reece_Borer56@gmail.com	6813432609	\N	\N	\N	\N	restoration advocate  🏙️	1969-04-06	2089 Ebert Shore, Mexico	female	{}	\N	8	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
fdfa098a-8812-4096-b62f-2c86bccf7436	Kristian	Feest	Osvaldo87@yahoo.com	9115050418	\N	\N	\N	\N	exterior lover, foodie	1973-10-09	4017 Nettie Cliffs, Guyana	male	{}	\N	7	2025-03-04 03:23:44.667142	2025-03-04 03:23:44.667142
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: chinmayvivek
--

COPY public.notes (note_id, class_id, user_id, note_url, created_at) FROM stdin;
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: chinmayvivek
--

COPY public.students (student_id, first_name, last_name, email, phone_number, password_hash, sso_provider, sso_provider_id, profile_picture_url, bio, date_of_birth, address, gender, social_media_handles, nationality, preferred_language, created_at, updated_at) FROM stdin;
7cf84eee-4155-495f-a0c7-a20335f89feb	Hayley	Reichel-Watsica	Aaliyah23@hotmail.com	5134639584	\N	\N	\N	\N	patriot, grad, developer	1972-12-08	305 Volkman Junction	Female	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
d6845c76-4866-4de3-877a-374e013b5d6f	Jacques	Keeling	Brooke_Donnelly96@hotmail.com	4066888808	\N	\N	\N	\N	boulder junkie  🦞	2005-05-05	5162 Bryce Ports	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
01e97943-24e2-424a-b379-a5823befa1de	Otis	Jerde	Aida_Rohan74@yahoo.com	4473104490	\N	\N	\N	\N	coach	1978-01-23	16929 Eliezer Lock	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
245dfbc8-63ed-44b2-808d-ab96cee358f2	Kurt	Mann	Kiley.Corkery@hotmail.com	3155964450	\N	\N	\N	\N	grad, public speaker	2004-07-03	68951 Broderick Tunnel	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
c6929acd-8108-4bc4-ba22-3da4dd05e6a3	Rafael	Jacobi	Kaley.OHara@hotmail.com	8673866673	\N	\N	\N	\N	riot enthusiast, student 🏴	1986-10-17	6017 Bergnaum Lake	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
18890d51-344f-4544-b2b6-849cc5f8775c	Finn	Weissnat	Hailey_Ferry57@hotmail.com	2763355087	\N	\N	\N	\N	ownership fan, activist	1961-12-12	865 Bernier Curve	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
69032098-ade8-46e8-97d0-fb533db6972f	Jaquan	Roberts	Torey23@yahoo.com	6729075110	\N	\N	\N	\N	business owner, streamer	1963-03-11	3598 Bradley Falls	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
ba404079-2809-413c-b6c8-c1d4a2f7a472	Duncan	McGlynn	Keyon81@yahoo.com	4278634877	\N	\N	\N	\N	creator	1952-08-24	191 Fahey Pass	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
1c54d620-144a-4603-bb1a-daddcdafb889	Meta	Macejkovic	Madelyn96@gmail.com	6222217119	\N	\N	\N	\N	singer	1991-09-05	34269 Trantow Crest	Female	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
def18a96-3c33-4e68-adca-503093f2abd1	Noble	O'Conner	Anthony_Kuhlman@hotmail.com	5359151355	\N	\N	\N	\N	educator, coach, author 🎞️	1958-05-28	1207 Annabell Harbor	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
90223bb8-a019-4dfc-adf1-e98e20f0d898	Devante	Schneider	Buck_Waters@yahoo.com	9624077577	\N	\N	\N	\N	dreamer, person, musician 🧻	1970-01-18	952 Adams Pines	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
8fa18847-2eac-48bb-8e9b-16e5cc495551	Tierra	Grimes	Jeanie.Mitchell@gmail.com	1893569013	\N	\N	\N	\N	friend	2004-09-18	830 Charlene Common	Female	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
bef57a27-d040-499d-880f-a25af4eb6b3c	Esperanza	Christiansen	Sheila94@yahoo.com	6883809944	\N	\N	\N	\N	dud advocate	1975-11-20	630 Medhurst Extension	Female	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
e7333421-b669-49db-bb46-918d0f1176b4	Hortense	Schoen	Salvador_Feil54@hotmail.com	3756000406	\N	\N	\N	\N	teacher, leader, activist 🔺	1994-07-11	3906 Rhoda Estates	Female	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
c0b5dc21-0924-433d-a8e5-51fd310a3d31	Kimberly	Murphy	Fannie_Prohaska7@yahoo.com	2777980326	\N	\N	\N	\N	activist, foodie, grad 🐆	1984-03-06	4194 Paucek Drives	Female	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
82940495-be7b-4542-8dbb-8627205ed819	Doris	Altenwerth	Everardo_Schmeler90@gmail.com	7522228558	\N	\N	\N	\N	grad	1972-12-16	150 Randi Greens	Female	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
4320492e-e725-4012-bdef-e751fe4f8082	Louie	Rutherford	Gayle.Block18@gmail.com	8882665115	\N	\N	\N	\N	dreamer, singer, model ♑	1953-10-11	594 Dagmar Corner	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
685c792f-9e1d-4f84-80e4-7f886e6f79cd	Ike	Kshlerin	Jesus50@gmail.com	7805166231	\N	\N	\N	\N	lip lover, gamer 🙋🏿‍♀️	1957-08-13	7516 Considine Ways	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
b978131d-5694-43a4-aa79-98b93e9ee342	Newell	Fadel	Amalia.Tromp31@hotmail.com	5808350869	\N	\N	\N	\N	excuse advocate, artist	1986-01-11	776 Piper Ranch	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
26699616-9291-4921-9936-eefe2a47dd81	Alexzander	Russel	Wade25@gmail.com	7638754670	\N	\N	\N	\N	icing enthusiast, veteran 👉🏾	2001-10-11	5499 Doyle Well	Male	\N	\N	\N	2025-03-04 03:03:33.070419	2025-03-04 03:03:33.070419
e5fe5cc8-6bbd-4711-bd27-00b590ab12f3	Vito	Lockman	Celine_Steuber-Rau21@yahoo.com	9207294670	\N	\N	\N	\N	leader, streamer	1967-10-10	613 Schulist Avenue	Male	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
b1eb4175-89bd-48ea-be5a-31d1ea1d1cbd	Lera	Gleichner	Alva.Will@hotmail.com	2798414006	\N	\N	\N	\N	teacher, grad, streamer 🇸🇹	1977-11-12	10125 Judge Dam	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
869b8929-0db4-4854-88d3-bb7c92b84890	Lowell	Jacobs	Dayne_Hirthe@yahoo.com	8116335463	\N	\N	\N	\N	blogger, inventor, educator	1984-05-14	99326 Dicki Court	Male	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
469b7e31-16e7-447c-a426-f2246660b33d	Jesse	Deckow	Marlin83@yahoo.com	5694493358	\N	\N	\N	\N	birdbath advocate  🌋	1960-06-19	72885 Leif Causeway	Male	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
55725929-db53-4fe0-ba2d-e1b444841b44	Aniyah	Lindgren	Carson.McLaughlin36@yahoo.com	2052368595	\N	\N	\N	\N	prestige fan, nerd	2003-05-19	721 Franz Via	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
d3c4569e-8026-44f4-8de3-01d05184aadc	Samir	Heller	Candelario39@yahoo.com	6544214140	\N	\N	\N	\N	bin supporter, philosopher 🕧	1992-02-02	530 Jaleel Parkways	Male	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
a49a2e8d-8854-4782-8928-8c9f54a82bf1	Burnice	Hagenes	Noe_Schimmel@hotmail.com	9109145707	\N	\N	\N	\N	parent	1946-01-04	5709 Armstrong Mews	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
57678847-a44f-4a09-8095-0adf6537b9b5	Sophie	Labadie	Ilene.Goldner72@gmail.com	2409692444	\N	\N	\N	\N	kingdom lover, streamer 🌥️	1956-05-27	47759 Bins Gardens	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
b2d3cd1b-0c5c-47fc-a82f-1bdc997c619b	Brian	Robel	Durward82@gmail.com	8767334932	\N	\N	\N	\N	traveler, streamer, teacher ❄️	1962-09-03	707 Mary Motorway	Male	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
c75c4275-9c18-46a3-a81c-5ae8f15cd16d	Ivy	Kuhic	Shaylee.Nienow15@hotmail.com	3939203110	\N	\N	\N	\N	inventor, foodie	2004-07-31	506 Leopoldo Hollow	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
54d81c1c-b3de-4fa7-bdd6-459c4df54591	Torrey	Rice	Jammie_Zboncak8@yahoo.com	6417339828	\N	\N	\N	\N	creator, veteran, dreamer 🙂	1962-12-21	334 Hermann Fords	Male	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
c3cc83b9-286e-469f-b9e7-387c0f1c35d1	Nicole	Friesen	Jacques_Feil@yahoo.com	2519532910	\N	\N	\N	\N	inventor	1950-09-17	5929 Johnny Via	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
43239cc2-f601-4999-91bd-f476d9e9674d	Noe	Wolf	Lucile_Bradtke@hotmail.com	5865114587	\N	\N	\N	\N	grad	1959-08-11	2021 Jacinthe Bypass	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
060aed65-757d-4f97-afec-3708ecd934c1	Fay	Deckow	Guillermo.Mante@yahoo.com	4073996134	\N	\N	\N	\N	surname advocate	1981-10-22	1582 Kiel Crossroad	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
503b721f-dba5-496d-85e7-57c2b3533674	Greyson	Schmeler	Laurence.Bashirian@gmail.com	9245817055	\N	\N	\N	\N	developer, musician	1972-10-03	78073 Marlon View	Male	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
31fa39a7-67db-4137-9a70-be82ec8a7d7a	Dejah	Hickle	Dillon_Thompson24@yahoo.com	5875510624	\N	\N	\N	\N	crayon lover, veteran 🤛🏻	2002-03-01	703 Renner Highway	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
e5ce6744-bd11-4257-ad94-d044a63f6ef1	Jarrell	MacGyver	Amara.Dietrich49@gmail.com	9067236429	\N	\N	\N	\N	film lover, foodie, grad	1980-12-26	25733 Buckridge Expressway	Male	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
b9024243-1834-4c13-a4a8-336506ee2350	Melba	Larkin	Rosalind_Frami81@yahoo.com	4644941015	\N	\N	\N	\N	traveler	1951-05-02	70684 Jacobi Lock	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
7844e880-08ec-438c-bdd2-28284c93e5b6	Hollie	Stroman	Sylvan_Rice16@yahoo.com	8945265287	\N	\N	\N	\N	inventor, blogger, environmentalist 👱🏼‍♀️	1962-12-23	72925 Fritsch Alley	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
1838aa07-a82c-4688-bcff-74bcde9c58eb	Mayra	Corkery-Strosin	Angeline.OConnell-Lebsack12@yahoo.com	9426196075	\N	\N	\N	\N	key advocate	1984-05-19	874 Marquardt Hills	Female	\N	\N	\N	2025-03-04 03:03:44.93745	2025-03-04 03:03:44.93745
056c8219-e7dc-4b03-b2a4-22c6db909c91	Ladarius	Treutel	Vena.Wilderman@hotmail.com	1793750681	\N	\N	\N	\N	jaw lover, streamer	1993-11-02	19107 Fisher Light	male	\N	Equatorial Guinea	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
a05db27b-28ee-4f90-9ad7-73d25337f87f	Ruthie	Wiegand	Xander77@gmail.com	5464884243	\N	\N	\N	\N	disposal devotee, author	1997-08-05	744 Ashtyn Mall	female	\N	Egypt	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
eccada38-0b14-4171-ba0d-2a3989d96372	Hazle	Runolfsdottir	Litzy67@gmail.com	1227671253	\N	\N	\N	\N	futon enthusiast 💘	1966-09-20	971 Wisoky Plaza	male	\N	Niger	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
9e872591-4b92-4136-a989-9d16ae533f10	Darby	Cronin	Jonathon84@hotmail.com	5658347362	\N	\N	\N	\N	musician, film lover, traveler 🟧	1948-01-09	731 Wisoky Meadow	male	\N	North Macedonia	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
547adb2c-8092-469c-89f1-23f7914a9d93	Ralph	Grimes	Lenore_Beahan29@hotmail.com	3836139729	\N	\N	\N	\N	robotics supporter, singer	1958-04-14	91887 Hudson Via	transgender	\N	Micronesia	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
352e9a17-9d7b-4618-8394-e2e162673b98	Charles	Konopelski	Henderson_Shanahan@yahoo.com	9465082333	\N	\N	\N	\N	author, parent, business owner 🤛🏻	1990-07-07	34961 Rae Port	transgender	\N	Sierra Leone	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
0a9dc1ec-8668-4eeb-b0b0-b0b040308af5	Arturo	Renner-Stokes	Zena30@hotmail.com	7759390524	\N	\N	\N	\N	call lover 🕡	1969-11-09	5927 Gerhold Pines	transgender	\N	Dominican Republic	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
4cf693ed-56f5-40e1-971e-52dd98a18750	Rosamond	Adams	Pat79@hotmail.com	7987201279	\N	\N	\N	\N	engineer	1976-07-24	2637 Walker Wall	transgender	\N	Azerbaijan	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
c69d0f6f-e72c-4a47-a36c-e0944cfbe767	Jennifer	Champlin-Jones	Joanne61@gmail.com	9864506299	\N	\N	\N	\N	divider fan, veteran	1957-10-09	2486 Pollich Shores	transgender	\N	Gibraltar	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
b83e1eab-0a2e-4b9f-a740-0c79902a4bac	Lon	Witting	Angel.Kohler84@yahoo.com	5002014803	\N	\N	\N	\N	public speaker	1961-06-29	184 Erich Tunnel	transgender	\N	United States Minor Outlying Islands	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
b40e9119-91c8-4c20-80d3-22e775c3a899	Alan	Hudson	Opal.Johns@gmail.com	1397829364	\N	\N	\N	\N	nerd, foodie	2002-02-28	508 Zieme Parkways	transgender	\N	Micronesia	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
bf5b7144-22aa-4041-925d-be4c0b14e409	Elenor	Fritsch	Clementine_Schaden53@yahoo.com	8295290183	\N	\N	\N	\N	philosopher, author, scientist	1958-04-30	9429 Elmer Key	transgender	\N	Nauru	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
89015efc-3379-48c6-b5b8-441e36880842	Sage	Donnelly	Veronica_Corwin47@hotmail.com	8268190897	\N	\N	\N	\N	info supporter 🎂	1997-11-12	524 Hoeger Hollow	transgender	\N	Tonga	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
6e71d7d8-7e01-4a11-8730-c38dfc65dbb5	Macy	Dach	Jenifer80@yahoo.com	4526491417	\N	\N	\N	\N	parent, model, photographer	1976-04-03	926 Breanne Gateway	female	\N	Mauritius	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
0dcc07c0-f8ef-421d-a1f5-615c74f0ead2	Craig	Bauch	Sylvia.Zemlak@hotmail.com	1439791617	\N	\N	\N	\N	dreamer, philosopher, entrepreneur	1982-04-30	163 Larson Branch	transgender	\N	Saint Pierre and Miquelon	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
284c8215-1cc5-4499-866a-7faba96e2878	Elliott	Windler	Alta4@gmail.com	4989552860	\N	\N	\N	\N	philosopher	1956-02-11	99297 Lehner Ramp	male	\N	Mexico	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
9ffaa267-12a9-4377-8788-9fc76c0a3d13	Maryse	Kreiger	Zoie.Beahan@gmail.com	1860429252	\N	\N	\N	\N	opportunist fan 🐸	1964-11-22	688 Johnson Plaza	female	\N	Mauritius	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
e6ffe927-0ece-4164-8534-4454a8600752	Shayna	Strosin	Berry.Parisian@yahoo.com	7412009586	\N	\N	\N	\N	filmmaker, streamer	1952-12-05	82900 Waters Drive	transgender	\N	Pakistan	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
20b8bac1-c4a7-4302-8e61-4921e0379837	Rhiannon	Olson	Haskell94@yahoo.com	1451813540	\N	\N	\N	\N	coach, leader, parent 🎤	2006-03-12	767 Gus Bypass	female	\N	Zimbabwe	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
c3c4113e-998b-4c40-8ada-725f77c506d7	Imelda	Wiegand	Jason.Schaefer95@gmail.com	7407914786	\N	\N	\N	\N	convention enthusiast, traveler	2003-02-03	147 Rodrigo Valley	male	\N	India	\N	2025-03-04 03:11:55.644589	2025-03-04 03:11:55.644589
\.


--
-- Data for Name: students_enrolled; Type: TABLE DATA; Schema: public; Owner: chinmayvivek
--

COPY public.students_enrolled (enrollment_id, student_id, batch_id, enrollment_date) FROM stdin;
f43500e8-2590-4d8d-948e-24db73db046f	7cf84eee-4155-495f-a0c7-a20335f89feb	16803052-76df-47f5-b20f-3dc6a5f1da8e	2025-03-04 15:35:16.844629
4e25d530-f41f-479b-8b27-9ea668702f45	d6845c76-4866-4de3-877a-374e013b5d6f	16803052-76df-47f5-b20f-3dc6a5f1da8e	2025-03-04 15:35:16.844629
6915788e-9849-446a-8856-0be789bbf86c	01e97943-24e2-424a-b379-a5823befa1de	16803052-76df-47f5-b20f-3dc6a5f1da8e	2025-03-04 15:35:16.844629
4ebeb61c-1e5b-47d2-9adf-8ae2a4f76143	245dfbc8-63ed-44b2-808d-ab96cee358f2	16803052-76df-47f5-b20f-3dc6a5f1da8e	2025-03-04 15:35:16.844629
6b5f4a25-19f4-4907-a67e-da3c43080900	c6929acd-8108-4bc4-ba22-3da4dd05e6a3	16803052-76df-47f5-b20f-3dc6a5f1da8e	2025-03-04 15:35:16.844629
57d88e04-6d21-4e1c-8a6d-ce47021f881c	18890d51-344f-4544-b2b6-849cc5f8775c	eff2f223-48e8-4a45-87d7-7757859ccd11	2025-03-04 15:35:16.844629
45863967-06b0-40d0-a0ee-23a9165fb6aa	69032098-ade8-46e8-97d0-fb533db6972f	eff2f223-48e8-4a45-87d7-7757859ccd11	2025-03-04 15:35:16.844629
6801f97b-3744-4621-b139-f43bb7d827f4	ba404079-2809-413c-b6c8-c1d4a2f7a472	eff2f223-48e8-4a45-87d7-7757859ccd11	2025-03-04 15:35:16.844629
8dd3be6a-e3c6-4027-89f0-32f0c9575221	1c54d620-144a-4603-bb1a-daddcdafb889	eff2f223-48e8-4a45-87d7-7757859ccd11	2025-03-04 15:35:16.844629
d43ab8da-081c-493b-bc1c-7ac8dcbe2702	def18a96-3c33-4e68-adca-503093f2abd1	eff2f223-48e8-4a45-87d7-7757859ccd11	2025-03-04 15:35:16.844629
f843cbfa-0f91-4370-aa16-a7f1a4a9d734	90223bb8-a019-4dfc-adf1-e98e20f0d898	d6d6ce87-0094-48d1-beb9-2a7b774b6772	2025-03-04 15:35:16.844629
07c32b5c-e9be-4a73-81cd-7eb01fedef9d	8fa18847-2eac-48bb-8e9b-16e5cc495551	d6d6ce87-0094-48d1-beb9-2a7b774b6772	2025-03-04 15:35:16.844629
51005126-883b-4962-8d56-c6ddad2a7d38	bef57a27-d040-499d-880f-a25af4eb6b3c	d6d6ce87-0094-48d1-beb9-2a7b774b6772	2025-03-04 15:35:16.844629
f1eb79c9-820f-4391-b56f-6ef268d14942	e7333421-b669-49db-bb46-918d0f1176b4	d6d6ce87-0094-48d1-beb9-2a7b774b6772	2025-03-04 15:35:16.844629
bac4ddad-e920-4401-975b-0159d0b4eb82	c0b5dc21-0924-433d-a8e5-51fd310a3d31	d6d6ce87-0094-48d1-beb9-2a7b774b6772	2025-03-04 15:35:16.844629
71d13f7b-cfa5-44f4-9e03-dd633e8866b4	82940495-be7b-4542-8dbb-8627205ed819	ccc5850c-5b95-48e8-b6d9-00f36805aef9	2025-03-04 15:35:16.844629
c6c98ec3-b3e5-46af-b694-16143e47bd92	4320492e-e725-4012-bdef-e751fe4f8082	ccc5850c-5b95-48e8-b6d9-00f36805aef9	2025-03-04 15:35:16.844629
e1e03648-4317-4bb8-b3c8-95540c887aad	685c792f-9e1d-4f84-80e4-7f886e6f79cd	ccc5850c-5b95-48e8-b6d9-00f36805aef9	2025-03-04 15:35:16.844629
38c4de35-b8c0-448f-bddc-37b9c4614f7a	b978131d-5694-43a4-aa79-98b93e9ee342	ccc5850c-5b95-48e8-b6d9-00f36805aef9	2025-03-04 15:35:16.844629
10561ab9-4bf7-4cac-9955-9a4a9954ae4d	26699616-9291-4921-9936-eefe2a47dd81	ccc5850c-5b95-48e8-b6d9-00f36805aef9	2025-03-04 15:35:16.844629
24abcea7-db58-476a-88da-88ec66a58dff	e5fe5cc8-6bbd-4711-bd27-00b590ab12f3	fd70a9a1-334d-4924-9ca1-62ee2153ee10	2025-03-04 15:35:16.844629
ec7da61c-fed6-4de2-9897-f47c32d515aa	b1eb4175-89bd-48ea-be5a-31d1ea1d1cbd	fd70a9a1-334d-4924-9ca1-62ee2153ee10	2025-03-04 15:35:16.844629
3297a978-166a-46dd-8bc0-91b5ac440371	869b8929-0db4-4854-88d3-bb7c92b84890	fd70a9a1-334d-4924-9ca1-62ee2153ee10	2025-03-04 15:35:16.844629
8caa01bb-662b-405a-a265-bba3c22ecb4e	469b7e31-16e7-447c-a426-f2246660b33d	fd70a9a1-334d-4924-9ca1-62ee2153ee10	2025-03-04 15:35:16.844629
57dc8376-405f-49f7-b669-54ff58561e73	55725929-db53-4fe0-ba2d-e1b444841b44	fd70a9a1-334d-4924-9ca1-62ee2153ee10	2025-03-04 15:35:16.844629
3a582b48-d087-4687-8633-243bb3dc55d1	d3c4569e-8026-44f4-8de3-01d05184aadc	8f45e16d-0856-46e9-8bf7-2e7405adb6b9	2025-03-04 15:35:16.844629
08af0530-c7b2-4a10-af6e-34be57dbefbd	a49a2e8d-8854-4782-8928-8c9f54a82bf1	8f45e16d-0856-46e9-8bf7-2e7405adb6b9	2025-03-04 15:35:16.844629
575028d1-744a-4cf2-9ee8-30597cc0e69c	57678847-a44f-4a09-8095-0adf6537b9b5	8f45e16d-0856-46e9-8bf7-2e7405adb6b9	2025-03-04 15:35:16.844629
53af19b6-4881-4968-973b-c1dd453e09d2	b2d3cd1b-0c5c-47fc-a82f-1bdc997c619b	8f45e16d-0856-46e9-8bf7-2e7405adb6b9	2025-03-04 15:35:16.844629
56073e6f-b944-4e5e-9dd8-8289f345717b	c75c4275-9c18-46a3-a81c-5ae8f15cd16d	8f45e16d-0856-46e9-8bf7-2e7405adb6b9	2025-03-04 15:35:16.844629
0880a3a7-79fb-49a6-8f48-0a003a889fd4	54d81c1c-b3de-4fa7-bdd6-459c4df54591	bda99212-4b3c-4cd8-ba19-da9f5d384359	2025-03-04 15:35:16.844629
e1c4debf-9523-45e6-a288-b2987d22d242	c3cc83b9-286e-469f-b9e7-387c0f1c35d1	bda99212-4b3c-4cd8-ba19-da9f5d384359	2025-03-04 15:35:16.844629
5561aea8-0cd4-406a-87e2-58aceecae509	43239cc2-f601-4999-91bd-f476d9e9674d	bda99212-4b3c-4cd8-ba19-da9f5d384359	2025-03-04 15:35:16.844629
63f800e1-2343-4f3a-8e87-a893b2664731	060aed65-757d-4f97-afec-3708ecd934c1	bda99212-4b3c-4cd8-ba19-da9f5d384359	2025-03-04 15:35:16.844629
19feb52c-655c-4f4b-8b1e-cc29a18a5321	503b721f-dba5-496d-85e7-57c2b3533674	bda99212-4b3c-4cd8-ba19-da9f5d384359	2025-03-04 15:35:16.844629
07040530-e53b-444f-8122-f7103d67b041	31fa39a7-67db-4137-9a70-be82ec8a7d7a	e6f6d1a6-872d-4516-be03-e5749e34380a	2025-03-04 15:35:16.844629
fddcebc1-c8cb-4bfd-a483-2654cffcfd92	e5ce6744-bd11-4257-ad94-d044a63f6ef1	e6f6d1a6-872d-4516-be03-e5749e34380a	2025-03-04 15:35:16.844629
7cdab41a-e122-4ea1-8a91-db1875c84d55	b9024243-1834-4c13-a4a8-336506ee2350	e6f6d1a6-872d-4516-be03-e5749e34380a	2025-03-04 15:35:16.844629
27b8dedd-4ffc-495f-9055-1b69f89f9dc9	7844e880-08ec-438c-bdd2-28284c93e5b6	e6f6d1a6-872d-4516-be03-e5749e34380a	2025-03-04 15:35:16.844629
2f6e449b-b5d4-4f20-8861-7f364774541e	1838aa07-a82c-4688-bcff-74bcde9c58eb	e6f6d1a6-872d-4516-be03-e5749e34380a	2025-03-04 15:35:16.844629
bd81123c-7a69-4f49-849e-a614234d7793	056c8219-e7dc-4b03-b2a4-22c6db909c91	9e90077e-d666-4cda-848b-3d3011767fd8	2025-03-04 15:35:16.844629
cf0f8428-54fa-4192-95ab-e16df1e38f1c	a05db27b-28ee-4f90-9ad7-73d25337f87f	9e90077e-d666-4cda-848b-3d3011767fd8	2025-03-04 15:35:16.844629
62cf6acf-bdbb-4888-a965-86c56a3792f2	eccada38-0b14-4171-ba0d-2a3989d96372	9e90077e-d666-4cda-848b-3d3011767fd8	2025-03-04 15:35:16.844629
d4655cc1-94ed-4222-a460-9eaf494d7338	9e872591-4b92-4136-a989-9d16ae533f10	9e90077e-d666-4cda-848b-3d3011767fd8	2025-03-04 15:35:16.844629
08ded734-8aca-4ab0-be31-0af017c4d0f2	547adb2c-8092-469c-89f1-23f7914a9d93	9e90077e-d666-4cda-848b-3d3011767fd8	2025-03-04 15:35:16.844629
\.


--
-- Name: batches batches_pkey; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT batches_pkey PRIMARY KEY (batch_id);


--
-- Name: class_recordings class_recordings_pkey; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.class_recordings
    ADD CONSTRAINT class_recordings_pkey PRIMARY KEY (recording_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: instructors fk_instructors_email; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT fk_instructors_email UNIQUE (email);


--
-- Name: students fk_students_email; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_email UNIQUE (email);


--
-- Name: instructors instructors_pkey; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT instructors_pkey PRIMARY KEY (instructor_id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (note_id);


--
-- Name: students_enrolled students_enrolled_pkey; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.students_enrolled
    ADD CONSTRAINT students_enrolled_pkey PRIMARY KEY (enrollment_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: idx_batches_created_at; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_batches_created_at ON public.batches USING btree (created_at);


--
-- Name: idx_class_recordings_class_id; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_class_recordings_class_id ON public.class_recordings USING btree (class_id);


--
-- Name: idx_class_recordings_recorded_at; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_class_recordings_recorded_at ON public.class_recordings USING btree (recorded_at);


--
-- Name: idx_classes_batch_id; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_classes_batch_id ON public.classes USING btree (batch_id);


--
-- Name: idx_classes_scheduled_at; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_classes_scheduled_at ON public.classes USING btree (scheduled_at);


--
-- Name: idx_enrollments_batch_id; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_enrollments_batch_id ON public.students_enrolled USING btree (batch_id);


--
-- Name: idx_enrollments_student_id; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_enrollments_student_id ON public.students_enrolled USING btree (student_id);


--
-- Name: idx_instructors_email; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_instructors_email ON public.instructors USING btree (email);


--
-- Name: idx_notes_class_id; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_notes_class_id ON public.notes USING btree (class_id);


--
-- Name: idx_notes_user_id; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_notes_user_id ON public.notes USING btree (user_id);


--
-- Name: idx_students_email; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_students_email ON public.students USING btree (email);


--
-- Name: idx_students_enrolled_date; Type: INDEX; Schema: public; Owner: chinmayvivek
--

CREATE INDEX idx_students_enrolled_date ON public.students_enrolled USING btree (enrollment_date);


--
-- Name: batches fk_batches_course; Type: FK CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT fk_batches_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: batches fk_batches_instructor; Type: FK CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT fk_batches_instructor FOREIGN KEY (instructor_id) REFERENCES public.instructors(instructor_id) ON DELETE SET NULL;


--
-- Name: classes fk_classes_batch; Type: FK CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT fk_classes_batch FOREIGN KEY (batch_id) REFERENCES public.batches(batch_id) ON DELETE CASCADE;


--
-- Name: students_enrolled fk_enrollments_batch; Type: FK CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.students_enrolled
    ADD CONSTRAINT fk_enrollments_batch FOREIGN KEY (batch_id) REFERENCES public.batches(batch_id) ON DELETE CASCADE;


--
-- Name: students_enrolled fk_enrollments_student; Type: FK CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.students_enrolled
    ADD CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: notes fk_notes_class; Type: FK CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_notes_class FOREIGN KEY (class_id) REFERENCES public.classes(class_id) ON DELETE CASCADE;


--
-- Name: notes fk_notes_user; Type: FK CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_notes_user FOREIGN KEY (user_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: class_recordings fk_recordings_class; Type: FK CONSTRAINT; Schema: public; Owner: chinmayvivek
--

ALTER TABLE ONLY public.class_recordings
    ADD CONSTRAINT fk_recordings_class FOREIGN KEY (class_id) REFERENCES public.classes(class_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

