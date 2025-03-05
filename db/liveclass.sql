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
-- Name: batches; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.batches OWNER TO postgres;

--
-- Name: class_recordings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class_recordings (
    recording_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    class_id uuid NOT NULL,
    recording_url text,
    recorded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.class_recordings OWNER TO postgres;

--
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    class_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    batch_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    scheduled_at timestamp without time zone,
    live_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- Name: course_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_types (
    type_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    type_name character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.course_types OWNER TO postgres;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    course_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    image character varying(255) DEFAULT 'default_image_path.jpg'::character varying NOT NULL,
    is_active boolean DEFAULT false,
    sequence_no integer DEFAULT 0,
    course_price character varying DEFAULT 0,
    course_level character varying(50) DEFAULT 'beginner'::character varying NOT NULL,
    course_type_id uuid,
    CONSTRAINT courses_course_level_check CHECK (((course_level)::text = ANY ((ARRAY['beginner'::character varying, 'intermediate'::character varying, 'advanced'::character varying])::text[])))
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: instructors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructors (
    instructor_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    qualifications text,
    years_of_experience integer
);


ALTER TABLE public.instructors OWNER TO postgres;

--
-- Name: notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notes (
    note_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    class_id uuid NOT NULL,
    user_id uuid NOT NULL,
    note_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notes OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_name character varying(50) NOT NULL,
    description text
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: students_enrolled; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students_enrolled (
    enrollment_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    enrollment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.students_enrolled OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
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
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT users_gender_check CHECK (((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying, 'other'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.batches (batch_id, course_id, batch_name, instructor_id, start_date, end_date, created_at) FROM stdin;
\.


--
-- Data for Name: class_recordings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.class_recordings (recording_id, class_id, recording_url, recorded_at) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (class_id, batch_id, title, scheduled_at, live_url, created_at) FROM stdin;
\.


--
-- Data for Name: course_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_types (type_id, type_name, description) FROM stdin;
bfbe9aa7-3329-4749-ae68-206dacb58901	Technical	Courses focused on technical skills like programming, data science, and engineering.
e8b28ce5-1c30-49c2-98ac-9c2dc3fe1039	Music	Courses dedicated to music theory, instruments, and performance skills.
437817d3-a279-42eb-bd81-516fbe8f422c	History	Courses on historical events, ancient civilizations, and world history.
14840f11-e038-4f3b-910b-3263cddf4510	Arts	Courses exploring different forms of visual and performing arts.
58a530fb-e16f-422e-9161-f9db87b2d4c6	Literature	Courses related to reading, analyzing, and interpreting literature across various genres.
055f7e8a-3658-44c4-ad64-7acee6c39b80	Business	Courses that cover business management, entrepreneurship, and organizational behavior.
0b898119-8736-40a5-8a53-63950787084c	Psychology	Courses related to human behavior, mental processes, and psychological theories.
c89d164c-e2c9-48df-96f3-ccbdffd6d3a8	Health & Fitness	Courses aimed at promoting physical health, fitness, and well-being.
5e033d99-00c5-4e47-8e1d-fa07cdc536dc	Environmental Studies	Courses focusing on environmental science, sustainability, and climate change.
0fe8c8d3-7ccf-44cc-ab42-2e98a5574dcf	Social Sciences	Courses covering sociology, anthropology, economics, and political science.
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (course_id, title, description, created_at, image, is_active, sequence_no, course_price, course_level, course_type_id) FROM stdin;
8bea988b-ed1b-4cbb-8604-db5e59295f51	Falit Jyotish	Study the ancient Indian science of astrology, focusing on predictive astrology and charts.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	2	3000	beginner	437817d3-a279-42eb-bd81-516fbe8f422c
733a1948-ed6a-49b5-8893-4c4e96d22b34	Singing	Explore the basics of singing, voice techniques, and song interpretation across different genres.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	3	3000	beginner	e8b28ce5-1c30-49c2-98ac-9c2dc3fe1039
05d4aa8f-c53c-4923-86e0-9a0e7dfc3dba	DSA	Learn Data Structures and Algorithms, key concepts in computer science for solving complex problems efficiently.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	4	3000	intermediate	bfbe9aa7-3329-4749-ae68-206dacb58901
e126fdf5-3b26-467f-a6fd-a62663e23bbc	Web Development	Introduction to web development covering front-end and back-end technologies like HTML, CSS, JavaScript, and server-side scripting.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	5	3000	intermediate	bfbe9aa7-3329-4749-ae68-206dacb58901
594231b6-4647-4473-b01b-a28e43e2f9f2	Golang	Master the Go programming language, focusing on concurrency, performance, and building scalable applications.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	6	3000	intermediate	bfbe9aa7-3329-4749-ae68-206dacb58901
31d3e002-7294-4a9c-9db3-0e19f003ac22	Rust	Learn Rust, a systems programming language known for memory safety and high performance.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	7	3000	intermediate	bfbe9aa7-3329-4749-ae68-206dacb58901
006a2540-87bf-4f94-91ab-1df6d90e54dc	Ancient Indian History	Explore the rich history of ancient India, focusing on its kingdoms, cultures, and contributions to world heritage.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	8	3000	beginner	437817d3-a279-42eb-bd81-516fbe8f422c
7d9ca2e5-e0ef-415e-9a20-47b970725983	Environmental Studies	Study the key concepts of ecology, conservation, and the impact of human activities on the environment.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	9	3000	beginner	5e033d99-00c5-4e47-8e1d-fa07cdc536dc
4042935f-51fa-4992-aeb6-e25c51b4182e	Social Psychology	Study how individuals are influenced by their social environment and how attitudes, beliefs, and behaviors are shaped by society.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	10	3000	beginner	0b898119-8736-40a5-8a53-63950787084c
a8c725f9-d37d-4c97-8f2f-a1b1c2e2f96f	World War II: A Historical Perspective	An in-depth study of the causes, events, and aftermath of World War II and its impact on the world.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	11	3000	beginner	437817d3-a279-42eb-bd81-516fbe8f422c
a29823e8-19c8-4bf0-b76d-567a82ebf2d0	Environmental Sustainability	Learn about sustainable practices and how they help protect ecosystems and biodiversity for future generations.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	12	3000	intermediate	5e033d99-00c5-4e47-8e1d-fa07cdc536dc
01cef7a7-2c73-4194-aed1-71a69a3968c5	Modern Political Philosophy	Examine key political ideologies and philosophies from the Enlightenment to contemporary thought.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	13	3000	intermediate	0fe8c8d3-7ccf-44cc-ab42-2e98a5574dcf
b8f48151-9bcc-4fd8-a8e4-fb7a055d0582	Ancient Greek Philosophy	Study the foundational ideas of Greek philosophers like Socrates, Plato, and Aristotle and their lasting impact on Western thought.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	14	3000	beginner	437817d3-a279-42eb-bd81-516fbe8f422c
ec2cf1c9-749f-42d2-b3fa-9b515e69d11f	Social Media and Society	Explore the role of social media in shaping modern society, culture, and individual behavior.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	15	3000	intermediate	0fe8c8d3-7ccf-44cc-ab42-2e98a5574dcf
963104dc-f335-4eac-9058-0c0e83f2e359	History of the Roman Empire	Learn about the rise and fall of the Roman Empire and its influence on Western civilization.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	16	3000	beginner	437817d3-a279-42eb-bd81-516fbe8f422c
0f0f9143-5f0e-4cf6-93d9-81af2d9f16ac	Gender Studies	Study the social and cultural aspects of gender, identity, and equality in different societies throughout history.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	17	3000	beginner	0fe8c8d3-7ccf-44cc-ab42-2e98a5574dcf
3b00453f-ac46-4d6b-9695-012a589763d6	Climate Change and Policy	Understand the science of climate change and the policies aimed at mitigating its effects on a global scale.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	18	3000	intermediate	5e033d99-00c5-4e47-8e1d-fa07cdc536dc
979b4d21-1bbd-4a18-b584-db81a60af976	Ancient Civilizations	Explore the history of ancient civilizations like Mesopotamia, Egypt, the Indus Valley, and China.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	19	3000	beginner	437817d3-a279-42eb-bd81-516fbe8f422c
5155e545-d80b-4f07-a7af-816152c7d0d7	Public Health and Society	Study the intersections between public health, society, and policy, focusing on issues like disease prevention and health education.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	20	3000	intermediate	c89d164c-e2c9-48df-96f3-ccbdffd6d3a8
daddb2a2-d79a-4273-801b-e4b26c883da3	Hindustani Vocal	Learn the art of Hindustani classical vocal music, including ragas, taals, and improvisation techniques.	2025-03-05 22:05:42.213396	https://pixabay.com/get/gdd343508bd703a3814dbf38946910389e706f16069ced5cb56301af37a68829f89290b3a071d6d8d6ec828c448d4a1c5e3bae58fe87e4bad4287d65cf3c0d4e8_640.png	t	1	3000	beginner	e8b28ce5-1c30-49c2-98ac-9c2dc3fe1039
\.


--
-- Data for Name: instructors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructors (instructor_id, user_id, qualifications, years_of_experience) FROM stdin;
045f845a-74fe-4cbc-bc21-46333b9ff57c	276f780a-bfd0-4472-97e9-1962f0bf7e66	MSc Computer Science	5
5873325c-3d76-431b-a78b-c782a6d54279	7ad6c580-33bc-48f7-9a47-43d4d9214449	PhD in Mathematics	10
fd48a0b0-374d-494b-8dc2-bc9d1499523f	029a2bba-dd50-4485-897c-c890fb3eec02	MBA, BBA	7
ef976fc0-0f9a-411f-9bbd-96018dc9d24a	4abad104-843a-4ad7-992b-7217e6b434db	B.Tech in Electrical Engineering	3
32abd01a-774b-4faf-874f-db951fdb09bc	1a3baa80-11ea-49e5-b88c-4a83a47fee17	MSc Chemistry	8
be9fcabe-4248-410e-9918-fa5eb78b6db8	491d7f3e-a927-41f4-ae5a-a177e0ca7f04	M.A. in History	12
652ebfdd-0a93-4de0-88d4-926558a79cf7	7e97574d-2b02-43fe-9456-c79900e15722	BCA	2
ecd55895-0166-4313-89a7-36886d51bdf0	ad050e44-70d1-4786-b902-9abfde66e1d8	MBA in Marketing	6
4937d25a-2b25-486c-874e-d354fbe4aead	caf7215c-93a5-4594-9f31-36ca06ae86be	B.Tech in Mechanical Engineering	9
c4ace339-91b1-4c90-8a14-b8057e00a31f	d522ef17-c837-4a1f-93b5-082040fee391	PhD in Physics	15
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notes (note_id, class_id, user_id, note_url, created_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name, description) FROM stdin;
44fd7635-c193-4246-8869-18ad463e13be	student	A user role representing a student in the system.
41ab7d5f-d889-4e89-a510-2e3c928a304e	instructor	A user role representing an instructor or teacher in the system.
c8aac6be-511a-44a5-a41a-e484f7300506	manager	A user role with managerial privileges, managing batches, courses, and students.
9afa13c9-023f-4d84-ac74-70978842b412	admin	A user role with full administrative privileges to manage all aspects of the system.
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, user_id) FROM stdin;
a5a18e46-1e7d-492f-af1b-3adf65e84e9d	bcf77305-f749-430c-861e-380af125f29e
d6dbc3ee-2c75-4011-82c3-366e6a1a70ec	3a523e55-bdb7-49ca-95e3-df594bb83570
99c1f750-0717-4b0c-b44a-fa7c2eca2aeb	7b6c25b6-3be7-4000-8ba7-3f7458bdd81b
361ce53c-7592-4e09-be69-bd9f9925b41f	fb2ba136-52c7-4697-abf7-285546b083cd
cd034875-e8c2-4047-a5c5-98017aee8f36	969f5295-d52d-4a42-8109-fdd4df9a6108
5f293855-1d14-436f-9e3f-d136b8517f9a	9f088dc0-cf25-45e6-b017-b77a8be5fb68
734c1fb6-33d2-4f0e-8630-fb6e8b506e79	ffd7fa35-e727-4a8d-a75d-7aeedfc46078
acdbeb69-11f5-4889-a18c-a9746cdc9815	510e86b8-aa97-4199-82ac-37b9d33f9d71
952f42e7-14cb-4b4c-a198-3488528db4d2	58e6251b-0c72-4049-877b-0c71e415a56f
f67f9ee7-aaf1-4cae-b410-09b1a963837a	efd59086-b6bc-4104-a07f-cef6304d47d4
69e99029-89ce-4819-8031-583f96b0027b	f98a6d29-bb55-41be-b101-d5cb9a918261
12c26f68-4b0d-446d-9842-e5a46fe6ff24	f6cbfe7c-80b3-4e25-836b-4b4321734b42
f24ae88a-322f-41f8-9bdd-1e8042548d4d	ccc747c0-5e38-4463-997d-9a1b0e8dd585
b3f120ff-92fb-4bbf-91bb-5937b3a50bbe	230bc85c-7b80-4ae7-8eed-4186e06c69b7
a498c361-1c6e-4722-9a40-cfe906d2030d	9481094d-0ee9-4435-8cb5-b99edba6f60f
5f438149-1333-4733-a7f9-f96c76eed501	e63dd0bf-e77b-4300-899e-157276ef5159
5fae243f-26f9-47da-b513-09024db47c50	8211ed29-b33a-4290-a422-a552c842f946
3ac33896-6e24-4bf2-9d80-9df4888cfb1e	e6049452-8673-4362-833e-01432733fb8a
091e6ea1-a0a3-4849-9558-d5379d746abc	411ed73b-ceef-4012-b050-2d847c3f92b4
2b64085f-abe5-4a1c-b5ed-3443364a2f09	6ef6c94f-54e5-49d0-a6b4-e8e0bff3870e
\.


--
-- Data for Name: students_enrolled; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students_enrolled (enrollment_id, student_id, batch_id, enrollment_date) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_id, role_id) FROM stdin;
bcf77305-f749-430c-861e-380af125f29e	44fd7635-c193-4246-8869-18ad463e13be
3a523e55-bdb7-49ca-95e3-df594bb83570	44fd7635-c193-4246-8869-18ad463e13be
7b6c25b6-3be7-4000-8ba7-3f7458bdd81b	44fd7635-c193-4246-8869-18ad463e13be
fb2ba136-52c7-4697-abf7-285546b083cd	44fd7635-c193-4246-8869-18ad463e13be
969f5295-d52d-4a42-8109-fdd4df9a6108	44fd7635-c193-4246-8869-18ad463e13be
9f088dc0-cf25-45e6-b017-b77a8be5fb68	44fd7635-c193-4246-8869-18ad463e13be
ffd7fa35-e727-4a8d-a75d-7aeedfc46078	44fd7635-c193-4246-8869-18ad463e13be
510e86b8-aa97-4199-82ac-37b9d33f9d71	44fd7635-c193-4246-8869-18ad463e13be
58e6251b-0c72-4049-877b-0c71e415a56f	44fd7635-c193-4246-8869-18ad463e13be
efd59086-b6bc-4104-a07f-cef6304d47d4	44fd7635-c193-4246-8869-18ad463e13be
f98a6d29-bb55-41be-b101-d5cb9a918261	44fd7635-c193-4246-8869-18ad463e13be
f6cbfe7c-80b3-4e25-836b-4b4321734b42	44fd7635-c193-4246-8869-18ad463e13be
ccc747c0-5e38-4463-997d-9a1b0e8dd585	44fd7635-c193-4246-8869-18ad463e13be
230bc85c-7b80-4ae7-8eed-4186e06c69b7	44fd7635-c193-4246-8869-18ad463e13be
9481094d-0ee9-4435-8cb5-b99edba6f60f	44fd7635-c193-4246-8869-18ad463e13be
e63dd0bf-e77b-4300-899e-157276ef5159	44fd7635-c193-4246-8869-18ad463e13be
8211ed29-b33a-4290-a422-a552c842f946	44fd7635-c193-4246-8869-18ad463e13be
e6049452-8673-4362-833e-01432733fb8a	44fd7635-c193-4246-8869-18ad463e13be
411ed73b-ceef-4012-b050-2d847c3f92b4	44fd7635-c193-4246-8869-18ad463e13be
6ef6c94f-54e5-49d0-a6b4-e8e0bff3870e	44fd7635-c193-4246-8869-18ad463e13be
276f780a-bfd0-4472-97e9-1962f0bf7e66	41ab7d5f-d889-4e89-a510-2e3c928a304e
7ad6c580-33bc-48f7-9a47-43d4d9214449	41ab7d5f-d889-4e89-a510-2e3c928a304e
029a2bba-dd50-4485-897c-c890fb3eec02	41ab7d5f-d889-4e89-a510-2e3c928a304e
4abad104-843a-4ad7-992b-7217e6b434db	41ab7d5f-d889-4e89-a510-2e3c928a304e
1a3baa80-11ea-49e5-b88c-4a83a47fee17	41ab7d5f-d889-4e89-a510-2e3c928a304e
491d7f3e-a927-41f4-ae5a-a177e0ca7f04	41ab7d5f-d889-4e89-a510-2e3c928a304e
7e97574d-2b02-43fe-9456-c79900e15722	41ab7d5f-d889-4e89-a510-2e3c928a304e
ad050e44-70d1-4786-b902-9abfde66e1d8	41ab7d5f-d889-4e89-a510-2e3c928a304e
caf7215c-93a5-4594-9f31-36ca06ae86be	41ab7d5f-d889-4e89-a510-2e3c928a304e
d522ef17-c837-4a1f-93b5-082040fee391	41ab7d5f-d889-4e89-a510-2e3c928a304e
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, first_name, last_name, email, phone_number, password_hash, sso_provider, sso_provider_id, profile_picture_url, bio, date_of_birth, address, gender, social_media_handles, nationality, preferred_language, created_at, updated_at) FROM stdin;
276f780a-bfd0-4472-97e9-1962f0bf7e66	John	Doe	john.doe1@example.com	+91 7000123456	hashed_password_1	google	google_id_1	https://randomuser.me/api/portraits/men/1.jpg	Bio: John Doe	1990-01-15	123 Main St, Springfield, USA	male	{"twitter": "http://twitter.com/johndoe", "facebook": "http://facebook.com/johndoe"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
7ad6c580-33bc-48f7-9a47-43d4d9214449	Jane	Smith	jane.smith2@example.com	+91 7000234567	hashed_password_2	facebook	facebook_id_2	https://randomuser.me/api/portraits/women/2.jpg	Bio: Jane Smith	1985-02-20	456 Oak St, London, UK	female	{"twitter": "http://twitter.com/janesmith", "facebook": "http://facebook.com/janesmith"}	UK	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
029a2bba-dd50-4485-897c-c890fb3eec02	Alice	Johnson	alice.johnson3@example.com	+91 7000345678	hashed_password_3	google	google_id_3	https://randomuser.me/api/portraits/women/3.jpg	Bio: Alice Johnson	1995-03-25	789 Elm St, New Delhi, India	female	{"twitter": "http://twitter.com/alicejohnson", "facebook": "http://facebook.com/alicejohnson"}	India	Hindi, English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
4abad104-843a-4ad7-992b-7217e6b434db	Bob	Brown	bob.brown4@example.com	+91 7000456789	hashed_password_4	facebook	facebook_id_4	https://randomuser.me/api/portraits/men/4.jpg	Bio: Bob Brown	1987-04-30	101 Pine St, Moscow, Russia	male	{"twitter": "http://twitter.com/bobbrown", "facebook": "http://facebook.com/bobbrown"}	Russia	Russian	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
1a3baa80-11ea-49e5-b88c-4a83a47fee17	Charlie	Davis	charlie.davis5@example.com	+91 7000567890	hashed_password_5	google	google_id_5	https://randomuser.me/api/portraits/men/5.jpg	Bio: Charlie Davis	1992-05-05	202 Maple St, Berlin, Germany	male	{"twitter": "http://twitter.com/charliedavis", "facebook": "http://facebook.com/charliedavis"}	Germany	German	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
491d7f3e-a927-41f4-ae5a-a177e0ca7f04	David	Martinez	david.martinez6@example.com	+91 7000678901	hashed_password_6	facebook	facebook_id_6	https://randomuser.me/api/portraits/men/6.jpg	Bio: David Martinez	1988-06-10	303 Birch St, New York, USA	male	{"twitter": "http://twitter.com/davidmartinez", "facebook": "http://facebook.com/davidmartinez"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
7e97574d-2b02-43fe-9456-c79900e15722	Eva	Miller	eva.miller7@example.com	+91 7000789012	hashed_password_7	google	google_id_7	https://randomuser.me/api/portraits/women/7.jpg	Bio: Eva Miller	1993-07-15	404 Cedar St, London, UK	female	{"twitter": "http://twitter.com/evamiller", "facebook": "http://facebook.com/evamiller"}	UK	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
ad050e44-70d1-4786-b902-9abfde66e1d8	Frank	Wilson	frank.wilson8@example.com	+91 7000890123	hashed_password_8	facebook	facebook_id_8	https://randomuser.me/api/portraits/men/8.jpg	Bio: Frank Wilson	1991-08-20	505 Willow St, Mumbai, India	male	{"twitter": "http://twitter.com/frankwilson", "facebook": "http://facebook.com/frankwilson"}	India	Hindi, English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
caf7215c-93a5-4594-9f31-36ca06ae86be	Grace	Moore	grace.moore9@example.com	+91 7000901234	hashed_password_9	google	google_id_9	https://randomuser.me/api/portraits/women/9.jpg	Bio: Grace Moore	1994-09-25	606 Oak St, Berlin, Germany	female	{"twitter": "http://twitter.com/gracemoore", "facebook": "http://facebook.com/gracemoore"}	Germany	German	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
d522ef17-c837-4a1f-93b5-082040fee391	Henry	Taylor	henry.taylor10@example.com	+91 7000123457	hashed_password_10	facebook	facebook_id_10	https://randomuser.me/api/portraits/men/10.jpg	Bio: Henry Taylor	1986-10-30	707 Pine St, Moscow, Russia	male	{"twitter": "http://twitter.com/henrytaylor", "facebook": "http://facebook.com/henrytaylor"}	Russia	Russian	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
458c5e02-8d54-4f93-8fdf-9b004c5b01fa	Ivy	Anderson	ivy.anderson11@example.com	+91 7000234568	hashed_password_11	google	google_id_11	https://randomuser.me/api/portraits/women/11.jpg	Bio: Ivy Anderson	1990-11-10	808 Birch St, New York, USA	female	{"twitter": "http://twitter.com/ivyanderson", "facebook": "http://facebook.com/ivyanderson"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
92f109fc-9584-4f46-b66b-a5ea634996ec	Jack	Thomas	jack.thomas12@example.com	+91 7000345679	hashed_password_12	facebook	facebook_id_12	https://randomuser.me/api/portraits/men/12.jpg	Bio: Jack Thomas	1989-12-15	909 Maple St, London, UK	male	{"twitter": "http://twitter.com/jackthomas", "facebook": "http://facebook.com/jackthomas"}	UK	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
e24564aa-7907-41f7-a948-fbaef41595bf	Kathy	Jackson	kathy.jackson13@example.com	+91 7000456790	hashed_password_13	google	google_id_13	https://randomuser.me/api/portraits/women/13.jpg	Bio: Kathy Jackson	1992-01-20	1010 Elm St, New Delhi, India	female	{"twitter": "http://twitter.com/kathyjackson", "facebook": "http://facebook.com/kathyjackson"}	India	Hindi, English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
7665384e-455d-4099-ad90-6cdaad1d6719	Louis	White	louis.white14@example.com	+91 7000567901	hashed_password_14	facebook	facebook_id_14	https://randomuser.me/api/portraits/men/14.jpg	Bio: Louis White	1994-02-25	1111 Cedar St, Moscow, Russia	male	{"twitter": "http://twitter.com/louiswhite", "facebook": "http://facebook.com/louiswhite"}	Russia	Russian	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
c77adc2c-9455-44f5-b03d-97327246452c	Mona	Harris	mona.harris15@example.com	+91 7000679012	hashed_password_15	google	google_id_15	https://randomuser.me/api/portraits/women/15.jpg	Bio: Mona Harris	1991-03-30	1212 Willow St, New York, USA	female	{"twitter": "http://twitter.com/monaharris", "facebook": "http://facebook.com/monaharris"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
dae2570f-b966-4b19-8948-41e78601a440	Nathan	Clark	nathan.clark16@example.com	+91 7000789123	hashed_password_16	facebook	facebook_id_16	https://randomuser.me/api/portraits/men/16.jpg	Bio: Nathan Clark	1987-04-10	1313 Pine St, London, UK	male	{"twitter": "http://twitter.com/nathanclark", "facebook": "http://facebook.com/nathanclark"}	UK	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
8f2e6acc-350b-410d-a2a3-037758f44585	Olivia	Lewis	olivia.lewis17@example.com	+91 7000890234	hashed_password_17	google	google_id_17	https://randomuser.me/api/portraits/women/17.jpg	Bio: Olivia Lewis	1993-05-05	1414 Birch St, New Delhi, India	female	{"twitter": "http://twitter.com/olivialeis", "facebook": "http://facebook.com/olivialeis"}	India	Hindi, English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
a5e344da-807a-4977-bd58-fee2af9fe72a	Paul	Walker	paul.walker18@example.com	+91 7000901345	hashed_password_18	facebook	facebook_id_18	https://randomuser.me/api/portraits/men/18.jpg	Bio: Paul Walker	1995-06-15	1515 Oak St, Berlin, Germany	male	{"twitter": "http://twitter.com/paulwalker", "facebook": "http://facebook.com/paulwalker"}	Germany	German	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
72f3566e-606b-43f1-bc04-8512e7aa1314	Quincy	Young	quincy.young19@example.com	+91 7000123458	hashed_password_19	google	google_id_19	https://randomuser.me/api/portraits/men/19.jpg	Bio: Quincy Young	1984-07-20	1616 Cedar St, Moscow, Russia	male	{"twitter": "http://twitter.com/quincyyoung", "facebook": "http://facebook.com/quincyyoung"}	Russia	Russian	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
e004bed6-1396-4f36-9466-c633878e526f	Rachel	King	rachel.king20@example.com	+91 7000234569	hashed_password_20	facebook	facebook_id_20	https://randomuser.me/api/portraits/women/20.jpg	Bio: Rachel King	1990-08-25	1717 Willow St, New York, USA	female	{"twitter": "http://twitter.com/rachelking", "facebook": "http://facebook.com/rachelking"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
c4e2fe24-6e6a-4031-9df5-3f016c1ff729	Tom	Scott	tom.scott21@example.com	+91 7000123459	hashed_password_21	google	google_id_21	https://randomuser.me/api/portraits/men/1.jpg	Bio: Tom Scott	1989-09-10	1818 Oak St, Moscow, Russia	male	{"twitter": "http://twitter.com/tomscott", "facebook": "http://facebook.com/tomscott"}	Russia	Russian	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
165004dd-9dc4-4381-bff1-b99c5930b9cc	Emily	Green	emily.green22@example.com	+91 7000234570	hashed_password_22	facebook	facebook_id_22	https://randomuser.me/api/portraits/women/2.jpg	Bio: Emily Green	1994-10-12	1919 Maple St, Berlin, Germany	female	{"twitter": "http://twitter.com/emilygreen", "facebook": "http://facebook.com/emilygreen"}	Germany	German	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
dc86fc8c-f6dc-42e3-bb58-4bbdd5b6bbd2	Sam	Adams	sam.adams23@example.com	+91 7000345680	hashed_password_23	google	google_id_23	https://randomuser.me/api/portraits/men/3.jpg	Bio: Sam Adams	1986-11-15	2020 Birch St, New Delhi, India	male	{"twitter": "http://twitter.com/samadams", "facebook": "http://facebook.com/samadams"}	India	Hindi, English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
8d472144-940a-444a-9d92-480feaf6cbb1	Sophia	Baker	sophia.baker24@example.com	+91 7000456801	hashed_password_24	facebook	facebook_id_24	https://randomuser.me/api/portraits/women/4.jpg	Bio: Sophia Baker	1992-12-20	2121 Pine St, New York, USA	female	{"twitter": "http://twitter.com/sophiabaker", "facebook": "http://facebook.com/sophiabaker"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
f1389a9f-2731-4b5a-8b6e-4d4c5f1fe5d1	Lucas	Carter	lucas.carter25@example.com	+91 7000567912	hashed_password_25	google	google_id_25	https://randomuser.me/api/portraits/men/5.jpg	Bio: Lucas Carter	1991-01-05	2222 Willow St, London, UK	male	{"twitter": "http://twitter.com/lucascarter", "facebook": "http://facebook.com/lucascarter"}	UK	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
65b2f0b1-447f-47d0-af73-4a557f4d6489	Isabella	Martinez	isabella.martinez26@example.com	+91 7000679023	hashed_password_26	facebook	facebook_id_26	https://randomuser.me/api/portraits/women/6.jpg	Bio: Isabella Martinez	1995-02-10	2323 Oak St, New Delhi, India	female	{"twitter": "http://twitter.com/isabellamartinez", "facebook": "http://facebook.com/isabellamartinez"}	India	Hindi, English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
adb8c968-181d-4773-a4dc-6746e1e79763	James	Wilson	james.wilson27@example.com	+91 7000789134	hashed_password_27	google	google_id_27	https://randomuser.me/api/portraits/men/7.jpg	Bio: James Wilson	1987-03-15	2424 Cedar St, Moscow, Russia	male	{"twitter": "http://twitter.com/jameswilson", "facebook": "http://facebook.com/jameswilson"}	Russia	Russian	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
06d1aa4c-9120-495f-bca8-ce27c843bc67	Charlotte	Allen	charlotte.allen28@example.com	+91 7000890245	hashed_password_28	facebook	facebook_id_28	https://randomuser.me/api/portraits/women/8.jpg	Bio: Charlotte Allen	1993-04-20	2525 Pine St, London, UK	female	{"twitter": "http://twitter.com/charlotteallen", "facebook": "http://facebook.com/charlotteallen"}	UK	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
fec0979c-4a6a-4ec9-9c5d-de4b6b644349	Ethan	King	ethan.king29@example.com	+91 7000901356	hashed_password_29	google	google_id_29	https://randomuser.me/api/portraits/men/9.jpg	Bio: Ethan King	1990-05-25	2626 Birch St, New York, USA	male	{"twitter": "http://twitter.com/ethanking", "facebook": "http://facebook.com/ethanking"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
94604f52-f234-4ab2-9fab-32fd26e21a91	Ava	Lopez	ava.lopez30@example.com	+91 7000123457	hashed_password_30	facebook	facebook_id_30	https://randomuser.me/api/portraits/women/10.jpg	Bio: Ava Lopez	1988-06-30	2727 Cedar St, New York, USA	female	{"twitter": "http://twitter.com/avalopez", "facebook": "http://facebook.com/avalopez"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
86b584a7-d001-4a94-99fd-a363e6689502	Mason	Gonzalez	mason.gonzalez31@example.com	+91 7000234578	hashed_password_31	google	google_id_31	https://randomuser.me/api/portraits/men/11.jpg	Bio: Mason Gonzalez	1992-07-05	2828 Cedar St, New Delhi, India	male	{"twitter": "http://twitter.com/masongonzalez", "facebook": "http://facebook.com/masongonzalez"}	India	Hindi, English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
a9911c35-2cef-4514-829c-5fe22b6d31f2	Amelia	Taylor	amelia.taylor32@example.com	+91 7000345689	hashed_password_32	facebook	facebook_id_32	https://randomuser.me/api/portraits/women/12.jpg	Bio: Amelia Taylor	1987-08-10	2929 Willow St, Moscow, Russia	female	{"twitter": "http://twitter.com/ameliataylor", "facebook": "http://facebook.com/ameliataylor"}	Russia	Russian	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
adf26c5c-947e-4d79-9a2d-353e6ca0f97e	Liam	Harris	liam.harris33@example.com	+91 7000456790	hashed_password_33	google	google_id_33	https://randomuser.me/api/portraits/men/13.jpg	Bio: Liam Harris	1995-09-15	3030 Birch St, Berlin, Germany	male	{"twitter": "http://twitter.com/liamharris", "facebook": "http://facebook.com/liamharris"}	Germany	German	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
40f75e06-7455-47d6-9222-4c34b412eca4	Zoe	Cunningham	zoe.cunningham34@example.com	+91 7000567901	hashed_password_34	facebook	facebook_id_34	https://randomuser.me/api/portraits/women/14.jpg	Bio: Zoe Cunningham	1991-10-20	3131 Pine St, London, UK	female	{"twitter": "http://twitter.com/zoecunningham", "facebook": "http://facebook.com/zoecunningham"}	UK	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
b164a96f-8659-455c-b66f-9e52a5783605	Megan	Wright	megan.wright35@example.com	+91 7000679012	hashed_password_35	google	google_id_35	https://randomuser.me/api/portraits/women/15.jpg	Bio: Megan Wright	1990-11-25	3232 Oak St, New York, USA	female	{"twitter": "http://twitter.com/meganwright", "facebook": "http://facebook.com/meganwright"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
aaf04ebf-f9d5-4ecf-af56-721c44b85862	Daniel	Martin	daniel.martin36@example.com	+91 7000789123	hashed_password_36	facebook	facebook_id_36	https://randomuser.me/api/portraits/men/16.jpg	Bio: Daniel Martin	1989-12-30	3333 Cedar St, New Delhi, India	male	{"twitter": "http://twitter.com/danielmartin", "facebook": "http://facebook.com/danielmartin"}	India	Hindi, English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
22a68ffc-13b0-4308-9f1c-541f3f0cc977	Ethan	Davis	ethan.davis37@example.com	+91 7000890234	hashed_password_37	google	google_id_37	https://randomuser.me/api/portraits/men/17.jpg	Bio: Ethan Davis	1992-01-10	3434 Pine St, Moscow, Russia	male	{"twitter": "http://twitter.com/ethandavis", "facebook": "http://facebook.com/ethandavis"}	Russia	Russian	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
e29dd2e8-37d5-482b-a7ca-ba77d1a70221	Lily	Taylor	lily.taylor38@example.com	+91 7000901345	hashed_password_38	facebook	facebook_id_38	https://randomuser.me/api/portraits/women/18.jpg	Bio: Lily Taylor	1993-02-14	3535 Birch St, Berlin, Germany	female	{"twitter": "http://twitter.com/lilytaylor", "facebook": "http://facebook.com/lilytaylor"}	Germany	German	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
a29604f9-3edd-4f74-a1de-cc7780ff0669	Chloe	Hernandez	chloe.hernandez39@example.com	+91 7000123456	hashed_password_39	google	google_id_39	https://randomuser.me/api/portraits/women/19.jpg	Bio: Chloe Hernandez	1994-03-20	3636 Cedar St, New York, USA	female	{"twitter": "http://twitter.com/chloehernandez", "facebook": "http://facebook.com/chloehernandez"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
bd64836b-bb50-4252-bde4-bdb447441632	Joshua	Young	joshua.young40@example.com	+91 7000234567	hashed_password_40	facebook	facebook_id_40	https://randomuser.me/api/portraits/men/20.jpg	Bio: Joshua Young	1988-04-25	3737 Willow St, London, UK	male	{"twitter": "http://twitter.com/joshuayoung", "facebook": "http://facebook.com/joshuayoung"}	UK	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
c16cb17f-2356-4dc7-a64a-ca68eeee2457	Michael	Scott	michael.scott21@example.com	+91 7000123460	hashed_password_21	google	google_id_21	https://randomuser.me/api/portraits/men/21.jpg	Bio: Michael Scott	1980-01-12	123 Office St, Scranton, USA	male	{"twitter": "http://twitter.com/michaelscott", "facebook": "http://facebook.com/michaelscott"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
b2e21438-7dc3-47a9-b430-9aff63c31747	Pam	Beesly	pam.beesly22@example.com	+91 7000234570	hashed_password_22	facebook	facebook_id_22	https://randomuser.me/api/portraits/women/22.jpg	Bio: Pam Beesly	1983-02-15	456 Art St, Scranton, USA	female	{"twitter": "http://twitter.com/pambeesly", "facebook": "http://facebook.com/pambeesly"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
b9599e73-c169-48d3-849c-7087f401bcf9	Jim	Halpert	jim.halpert23@example.com	+91 7000345680	hashed_password_23	google	google_id_23	https://randomuser.me/api/portraits/men/23.jpg	Bio: Jim Halpert	1985-03-10	789 Paper St, Scranton, USA	male	{"twitter": "http://twitter.com/jimhalpert", "facebook": "http://facebook.com/jimhalpert"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
02f76d88-8250-4e12-80b8-26cd0f195191	Angela	Martin	angela.martin24@example.com	+91 7000456791	hashed_password_24	facebook	facebook_id_24	https://randomuser.me/api/portraits/women/24.jpg	Bio: Angela Martin	1982-04-22	101 Oak St, Scranton, USA	female	{"twitter": "http://twitter.com/angelamartin", "facebook": "http://facebook.com/angelamartin"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
9f724380-3faa-4f29-9de4-71c3eb762a6a	Dwight	Schrute	dwight.schrute25@example.com	+91 7000567902	hashed_password_25	google	google_id_25	https://randomuser.me/api/portraits/men/25.jpg	Bio: Dwight Schrute	1978-05-05	202 Beet St, Scranton, USA	male	{"twitter": "http://twitter.com/dwightschrute", "facebook": "http://facebook.com/dwightschrute"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
e60a6f47-0b2d-4cef-9b63-f670aecb49af	Ryan	Howard	ryan.howard26@example.com	+91 7000679013	hashed_password_26	facebook	facebook_id_26	https://randomuser.me/api/portraits/men/26.jpg	Bio: Ryan Howard	1986-06-18	303 Technology St, Scranton, USA	male	{"twitter": "http://twitter.com/ryanhoward", "facebook": "http://facebook.com/ryanhoward"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
f545547e-97b9-45c5-9704-e0016d2bf086	Kelly	Kapoor	kelly.kapoor27@example.com	+91 7000789124	hashed_password_27	google	google_id_27	https://randomuser.me/api/portraits/women/27.jpg	Bio: Kelly Kapoor	1987-07-30	404 Fashion St, Scranton, USA	female	{"twitter": "http://twitter.com/kellykapoor", "facebook": "http://facebook.com/kellykapoor"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
9e635874-ed5c-43ce-9922-254b54629d6d	Stanley	Hudson	stanley.hudson28@example.com	+91 7000890235	hashed_password_28	facebook	facebook_id_28	https://randomuser.me/api/portraits/men/28.jpg	Bio: Stanley Hudson	1950-08-15	505 Calm St, Scranton, USA	male	{"twitter": "http://twitter.com/stanleyhudson", "facebook": "http://facebook.com/stanleyhudson"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
55846efb-4b3d-4cdd-a39a-bda315d3f3e2	Phyllis	Vance	phyllis.vance29@example.com	+91 7000901346	hashed_password_29	google	google_id_29	https://randomuser.me/api/portraits/women/29.jpg	Bio: Phyllis Vance	1960-09-01	606 Cozy St, Scranton, USA	female	{"twitter": "http://twitter.com/phyllisvance", "facebook": "http://facebook.com/phyllisvance"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
c7bdd038-0454-428c-abaa-ff538ad4f4b3	Creed	Bratton	creed.bratton30@example.com	+91 7000123461	hashed_password_30	facebook	facebook_id_30	https://randomuser.me/api/portraits/men/30.jpg	Bio: Creed Bratton	1945-10-10	707 Mysterious St, Scranton, USA	male	{"twitter": "http://twitter.com/creedbratton", "facebook": "http://facebook.com/creedbratton"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
573acc68-521c-4fe2-b048-69b89adb72c1	Oscar	Martinez	oscar.martinez31@example.com	+91 7000234571	hashed_password_31	google	google_id_31	https://randomuser.me/api/portraits/men/31.jpg	Bio: Oscar Martinez	1980-11-06	808 Accountant St, Scranton, USA	male	{"twitter": "http://twitter.com/oscarmartinez", "facebook": "http://facebook.com/oscarmartinez"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
ad537af1-0fbb-4396-8981-5a1f3845345e	Toby	Flenderson	toby.flenderson32@example.com	+91 7000345681	hashed_password_32	facebook	facebook_id_32	https://randomuser.me/api/portraits/men/32.jpg	Bio: Toby Flenderson	1970-12-24	909 Human Resources St, Scranton, USA	male	{"twitter": "http://twitter.com/tobyflenderson", "facebook": "http://facebook.com/tobyflenderson"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
f0dd99a0-eba4-4321-9ecc-04a737534f07	Meredith	Palmer	meredith.palmer33@example.com	+91 7000456792	hashed_password_33	google	google_id_33	https://randomuser.me/api/portraits/women/33.jpg	Bio: Meredith Palmer	1965-01-18	101 Party St, Scranton, USA	female	{"twitter": "http://twitter.com/meredithpalmer", "facebook": "http://facebook.com/meredithpalmer"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
cbeb99eb-29e8-41e4-b14e-c97820e73daf	Jan	Levinson	jan.levinson34@example.com	+91 7000567903	hashed_password_34	facebook	facebook_id_34	https://randomuser.me/api/portraits/women/34.jpg	Bio: Jan Levinson	1975-02-22	202 Boss St, Scranton, USA	female	{"twitter": "http://twitter.com/janlevinson", "facebook": "http://facebook.com/janlevinson"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
237a66cd-e81b-4125-ae24-0c1b5ba97d73	Karen	Filippelli	karen.filippelli35@example.com	+91 7000679014	hashed_password_35	google	google_id_35	https://randomuser.me/api/portraits/women/35.jpg	Bio: Karen Filippelli	1985-03-14	303 Sales St, Scranton, USA	female	{"twitter": "http://twitter.com/karenfilippelli", "facebook": "http://facebook.com/karenfilippelli"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
6c2b3114-b3c2-455f-8453-530d6efd4ffa	Holly	Flax	holly.flax36@example.com	+91 7000789125	hashed_password_36	facebook	facebook_id_36	https://randomuser.me/api/portraits/women/36.jpg	Bio: Holly Flax	1984-04-01	404 HR St, Scranton, USA	female	{"twitter": "http://twitter.com/hollyflax", "facebook": "http://facebook.com/hollyflax"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
bc66bc7b-5ece-4d2b-a463-d8bada701a4c	Darryl	Philbin	darryl.philbin37@example.com	+91 7000890236	hashed_password_37	google	google_id_37	https://randomuser.me/api/portraits/men/37.jpg	Bio: Darryl Philbin	1971-05-12	505 Warehouse St, Scranton, USA	male	{"twitter": "http://twitter.com/darrylphilbin", "facebook": "http://facebook.com/darrylphilbin"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
ecd6910c-989c-49e4-9689-35aa7a735373	Ryan	Gosling	ryan.gosling38@example.com	+91 7000901347	hashed_password_38	facebook	facebook_id_38	https://randomuser.me/api/portraits/men/38.jpg	Bio: Ryan Gosling	1980-06-14	606 Hollywood St, Los Angeles, USA	male	{"twitter": "http://twitter.com/ryangosling", "facebook": "http://facebook.com/ryangosling"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
5baeba14-0027-4569-8e9d-4d7ad1c53754	Emma	Stone	emma.stone39@example.com	+91 7000123462	hashed_password_39	google	google_id_39	https://randomuser.me/api/portraits/women/39.jpg	Bio: Emma Stone	1988-07-10	707 Sunset St, Los Angeles, USA	female	{"twitter": "http://twitter.com/emmastone", "facebook": "http://facebook.com/emmastone"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
1fd500a0-7539-4614-9d01-57662450e9f9	Ryan	Reynolds	ryan.reynolds40@example.com	+91 7000234572	hashed_password_40	facebook	facebook_id_40	https://randomuser.me/api/portraits/men/40.jpg	Bio: Ryan Reynolds	1976-10-23	808 Broadway St, New York, USA	male	{"twitter": "http://twitter.com/ryanreynolds", "facebook": "http://facebook.com/ryanreynolds"}	USA	English	2025-03-05 12:04:01.576676	2025-03-05 12:04:01.576676
bcf77305-f749-430c-861e-380af125f29e	Aarav	Sharma	aarav.sharma1@example.com	+91 7000123463	hashed_password_1	google	google_id_1	https://randomuser.me/api/portraits/men/1.jpg	Bio: Aarav Sharma	1990-01-15	123 MG Road, New Delhi, India	male	{"twitter": "http://twitter.com/aaravsharma", "facebook": "http://facebook.com/aaravsharma"}	India	Hindi, English	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
3a523e55-bdb7-49ca-95e3-df594bb83570	Priya	Patel	priya.patel2@example.com	+91 7000234573	hashed_password_2	facebook	facebook_id_2	https://randomuser.me/api/portraits/women/2.jpg	Bio: Priya Patel	1987-02-20	456 Oak St, Mumbai, India	female	{"twitter": "http://twitter.com/priyapatel", "facebook": "http://facebook.com/priyapatel"}	India	Hindi, Gujarati	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
7b6c25b6-3be7-4000-8ba7-3f7458bdd81b	Ravi	Verma	ravi.verma3@example.com	+91 7000345682	hashed_password_3	google	google_id_3	https://randomuser.me/api/portraits/men/3.jpg	Bio: Ravi Verma	1992-03-25	789 Park Lane, Bangalore, India	male	{"twitter": "http://twitter.com/raviverma", "facebook": "http://facebook.com/raviverma"}	India	Kannada, English	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
fb2ba136-52c7-4697-abf7-285546b083cd	Ananya	Singh	ananya.singh4@example.com	+91 7000456794	hashed_password_4	facebook	facebook_id_4	https://randomuser.me/api/portraits/women/4.jpg	Bio: Ananya Singh	1995-04-30	101 Palm St, Chennai, India	female	{"twitter": "http://twitter.com/ananyasingh", "facebook": "http://facebook.com/ananyasingh"}	India	Tamil, English	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
969f5295-d52d-4a42-8109-fdd4df9a6108	Amit	Kumar	amit.kumar5@example.com	+91 7000567904	hashed_password_5	google	google_id_5	https://randomuser.me/api/portraits/men/5.jpg	Bio: Amit Kumar	1986-05-10	202 Rose St, Pune, India	male	{"twitter": "http://twitter.com/amitkumar", "facebook": "http://facebook.com/amitkumar"}	India	Hindi, Marathi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
9f088dc0-cf25-45e6-b017-b77a8be5fb68	Sanya	Mehta	sanya.mehta6@example.com	+91 7000679015	hashed_password_6	facebook	facebook_id_6	https://randomuser.me/api/portraits/women/6.jpg	Bio: Sanya Mehta	1993-06-15	303 Maple St, Ahmedabad, India	female	{"twitter": "http://twitter.com/sanyamehta", "facebook": "http://facebook.com/sanyamehta"}	India	Gujarati, Hindi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
ffd7fa35-e727-4a8d-a75d-7aeedfc46078	Vikram	Yadav	vikram.yadav7@example.com	+91 7000789126	hashed_password_7	google	google_id_7	https://randomuser.me/api/portraits/men/7.jpg	Bio: Vikram Yadav	1985-07-20	404 Shakti St, Jaipur, India	male	{"twitter": "http://twitter.com/vikramyadav", "facebook": "http://facebook.com/vikramyadav"}	India	Hindi, Rajasthani	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
510e86b8-aa97-4199-82ac-37b9d33f9d71	Sneha	Iyer	sneha.iyer8@example.com	+91 7000890237	hashed_password_8	facebook	facebook_id_8	https://randomuser.me/api/portraits/women/8.jpg	Bio: Sneha Iyer	1990-08-25	505 Coconut St, Mumbai, India	female	{"twitter": "http://twitter.com/snehaayer", "facebook": "http://facebook.com/snehaayer"}	India	Marathi, Hindi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
58e6251b-0c72-4049-877b-0c71e415a56f	Karan	Joshi	karan.joshi9@example.com	+91 7000901348	hashed_password_9	google	google_id_9	https://randomuser.me/api/portraits/men/9.jpg	Bio: Karan Joshi	1992-09-30	606 Blue St, Bangalore, India	male	{"twitter": "http://twitter.com/karanjoshi", "facebook": "http://facebook.com/karanjoshi"}	India	Kannada, Hindi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
efd59086-b6bc-4104-a07f-cef6304d47d4	Ritu	Sharma	ritu.sharma10@example.com	+91 7000123464	hashed_password_10	facebook	facebook_id_10	https://randomuser.me/api/portraits/women/10.jpg	Bio: Ritu Sharma	1988-10-05	707 Sunset St, Delhi, India	female	{"twitter": "http://twitter.com/ritusharma", "facebook": "http://facebook.com/ritusharma"}	India	Hindi, Punjabi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
f98a6d29-bb55-41be-b101-d5cb9a918261	Anil	Reddy	anil.reddy11@example.com	+91 7000234574	hashed_password_11	google	google_id_11	https://randomuser.me/api/portraits/men/11.jpg	Bio: Anil Reddy	1990-11-15	808 Sapphire St, Hyderabad, India	male	{"twitter": "http://twitter.com/anilreddy", "facebook": "http://facebook.com/anilreddy"}	India	Telugu, English	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
f6cbfe7c-80b3-4e25-836b-4b4321734b42	Divya	Nair	divya.nair12@example.com	+91 7000345683	hashed_password_12	facebook	facebook_id_12	https://randomuser.me/api/portraits/women/12.jpg	Bio: Divya Nair	1993-12-20	909 Green St, Kochi, India	female	{"twitter": "http://twitter.com/divyanair", "facebook": "http://facebook.com/divyanair"}	India	Malayalam, English	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
ccc747c0-5e38-4463-997d-9a1b0e8dd585	Harish	Mishra	harish.mishra13@example.com	+91 7000456795	hashed_password_13	google	google_id_13	https://randomuser.me/api/portraits/men/13.jpg	Bio: Harish Mishra	1982-01-25	101 West St, Lucknow, India	male	{"twitter": "http://twitter.com/harishmishra", "facebook": "http://facebook.com/harishmishra"}	India	Hindi, Bhojpuri	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
230bc85c-7b80-4ae7-8eed-4186e06c69b7	Neha	Gupta	neha.gupta14@example.com	+91 7000567905	hashed_password_14	facebook	facebook_id_14	https://randomuser.me/api/portraits/women/14.jpg	Bio: Neha Gupta	1994-02-10	1111 Valley St, Kanpur, India	female	{"twitter": "http://twitter.com/nehagupta", "facebook": "http://facebook.com/nehagupta"}	India	Hindi, English	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
9481094d-0ee9-4435-8cb5-b99edba6f60f	Manish	Singh	manish.singh15@example.com	+91 7000679016	hashed_password_15	google	google_id_15	https://randomuser.me/api/portraits/men/15.jpg	Bio: Manish Singh	1985-03-12	1212 City Center, Gurgaon, India	male	{"twitter": "http://twitter.com/manishsingh", "facebook": "http://facebook.com/manishsingh"}	India	Hindi, Haryanvi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
e63dd0bf-e77b-4300-899e-157276ef5159	Komal	Chawla	komal.chawla16@example.com	+91 7000789127	hashed_password_16	facebook	facebook_id_16	https://randomuser.me/api/portraits/women/16.jpg	Bio: Komal Chawla	1991-04-28	1313 Blue Ridge, Chandigarh, India	female	{"twitter": "http://twitter.com/komalchawla", "facebook": "http://facebook.com/komalchawla"}	India	Punjabi, Hindi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
8211ed29-b33a-4290-a422-a552c842f946	Pankaj	Gupta	pankaj.gupta17@example.com	+91 7000890238	hashed_password_17	google	google_id_17	https://randomuser.me/api/portraits/men/17.jpg	Bio: Pankaj Gupta	1989-05-18	1414 Red St, Kolkata, India	male	{"twitter": "http://twitter.com/pankajgupta", "facebook": "http://facebook.com/pankajgupta"}	India	Bengali, Hindi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
e6049452-8673-4362-833e-01432733fb8a	Sweta	Patel	sweta.patel18@example.com	+91 7000901349	hashed_password_18	facebook	facebook_id_18	https://randomuser.me/api/portraits/women/18.jpg	Bio: Sweta Patel	1990-06-21	1515 Tulip St, Surat, India	female	{"twitter": "http://twitter.com/swetapatel", "facebook": "http://facebook.com/swetapatel"}	India	Gujarati, Hindi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
411ed73b-ceef-4012-b050-2d847c3f92b4	Sandeep	Kaur	sandeep.kaur19@example.com	+91 7000123465	hashed_password_19	google	google_id_19	https://randomuser.me/api/portraits/men/19.jpg	Bio: Sandeep Kaur	1987-07-08	1616 Orchard St, Patiala, India	male	{"twitter": "http://twitter.com/sandeepkaur", "facebook": "http://facebook.com/sandeepkaur"}	India	Punjabi, Hindi	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
6ef6c94f-54e5-49d0-a6b4-e8e0bff3870e	Tanya	Kumar	tanya.kumar20@example.com	+91 7000234575	hashed_password_20	facebook	facebook_id_20	https://randomuser.me/api/portraits/women/20.jpg	Bio: Tanya Kumar	1994-08-22	1717 Riverside St, Noida, India	female	{"twitter": "http://twitter.com/tanyakumar", "facebook": "http://facebook.com/tanyakumar"}	India	Hindi, English	2025-03-05 12:07:05.503144	2025-03-05 12:07:05.503144
\.


--
-- Name: batches batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT batches_pkey PRIMARY KEY (batch_id);


--
-- Name: class_recordings class_recordings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_recordings
    ADD CONSTRAINT class_recordings_pkey PRIMARY KEY (recording_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_id);


--
-- Name: course_types course_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_types
    ADD CONSTRAINT course_types_pkey PRIMARY KEY (type_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: users fk_users_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_email UNIQUE (email);


--
-- Name: instructors instructors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT instructors_pkey PRIMARY KEY (instructor_id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (note_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: students_enrolled students_enrolled_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students_enrolled
    ADD CONSTRAINT students_enrolled_pkey PRIMARY KEY (enrollment_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: idx_batches_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_batches_created_at ON public.batches USING btree (created_at);


--
-- Name: idx_class_recordings_class_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_class_recordings_class_id ON public.class_recordings USING btree (class_id);


--
-- Name: idx_class_recordings_recorded_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_class_recordings_recorded_at ON public.class_recordings USING btree (recorded_at);


--
-- Name: idx_classes_batch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_classes_batch_id ON public.classes USING btree (batch_id);


--
-- Name: idx_classes_scheduled_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_classes_scheduled_at ON public.classes USING btree (scheduled_at);


--
-- Name: idx_enrollments_batch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_enrollments_batch_id ON public.students_enrolled USING btree (batch_id);


--
-- Name: idx_enrollments_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_enrollments_student_id ON public.students_enrolled USING btree (student_id);


--
-- Name: idx_notes_class_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notes_class_id ON public.notes USING btree (class_id);


--
-- Name: idx_notes_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notes_user_id ON public.notes USING btree (user_id);


--
-- Name: idx_students_enrolled_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_students_enrolled_date ON public.students_enrolled USING btree (enrollment_date);


--
-- Name: idx_user_roles_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_roles_role_id ON public.user_roles USING btree (role_id);


--
-- Name: idx_user_roles_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_roles_user_id ON public.user_roles USING btree (user_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: batches fk_batches_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT fk_batches_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: batches fk_batches_instructor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT fk_batches_instructor FOREIGN KEY (instructor_id) REFERENCES public.instructors(instructor_id) ON DELETE SET NULL;


--
-- Name: classes fk_classes_batch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT fk_classes_batch FOREIGN KEY (batch_id) REFERENCES public.batches(batch_id) ON DELETE CASCADE;


--
-- Name: courses fk_course_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT fk_course_type FOREIGN KEY (course_type_id) REFERENCES public.course_types(type_id);


--
-- Name: students_enrolled fk_enrollments_batch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students_enrolled
    ADD CONSTRAINT fk_enrollments_batch FOREIGN KEY (batch_id) REFERENCES public.batches(batch_id) ON DELETE CASCADE;


--
-- Name: students_enrolled fk_enrollments_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students_enrolled
    ADD CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: instructors fk_instructors_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT fk_instructors_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: notes fk_notes_class; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_notes_class FOREIGN KEY (class_id) REFERENCES public.classes(class_id) ON DELETE CASCADE;


--
-- Name: notes fk_notes_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_notes_user FOREIGN KEY (user_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: class_recordings fk_recordings_class; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_recordings
    ADD CONSTRAINT fk_recordings_class FOREIGN KEY (class_id) REFERENCES public.classes(class_id) ON DELETE CASCADE;


--
-- Name: students fk_students_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: user_roles fk_user_roles_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: user_roles fk_user_roles_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

