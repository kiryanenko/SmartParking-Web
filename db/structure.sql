SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: parking_places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parking_places (
    id bigint NOT NULL,
    place_id smallint NOT NULL,
    sensor_id bigint NOT NULL,
    parking_id bigint NOT NULL,
    title character varying NOT NULL,
    coord public.geography(Point,4326) NOT NULL,
    for_disabled boolean DEFAULT false NOT NULL,
    booked boolean DEFAULT false NOT NULL,
    free boolean DEFAULT false NOT NULL,
    connected boolean DEFAULT false NOT NULL,
    can_book boolean DEFAULT false NOT NULL,
    changed_state boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: parking_places_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.parking_places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parking_places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.parking_places_id_seq OWNED BY public.parking_places.id;


--
-- Name: parking_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parking_states (
    id bigint NOT NULL,
    parking_place_id bigint,
    booked boolean,
    free boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: parking_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.parking_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parking_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.parking_states_id_seq OWNED BY public.parking_states.id;


--
-- Name: parkings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parkings (
    id bigint NOT NULL,
    title character varying NOT NULL,
    description text NOT NULL,
    cost double precision DEFAULT 0.0 NOT NULL,
    user_id bigint NOT NULL,
    area public.geography(Polygon,4326) NOT NULL,
    start_time time without time zone,
    end_time time without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: parkings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.parkings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parkings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.parkings_id_seq OWNED BY public.parkings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sensors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sensors (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    sampling_period smallint DEFAULT 0 NOT NULL,
    sending_period smallint DEFAULT 0 NOT NULL,
    day_cost smallint DEFAULT 0 NOT NULL,
    night_cost smallint DEFAULT 0 NOT NULL,
    day_start_time smallint DEFAULT 0 NOT NULL,
    night_start_time smallint DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sensors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sensors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sensors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sensors_id_seq OWNED BY public.sensors.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    full_name character varying NOT NULL,
    phone character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parking_places ALTER COLUMN id SET DEFAULT nextval('public.parking_places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parking_states ALTER COLUMN id SET DEFAULT nextval('public.parking_states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parkings ALTER COLUMN id SET DEFAULT nextval('public.parkings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensors ALTER COLUMN id SET DEFAULT nextval('public.sensors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: parking_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parking_places
    ADD CONSTRAINT parking_places_pkey PRIMARY KEY (id);


--
-- Name: parking_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parking_states
    ADD CONSTRAINT parking_states_pkey PRIMARY KEY (id);


--
-- Name: parkings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parkings
    ADD CONSTRAINT parkings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sensors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensors
    ADD CONSTRAINT sensors_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_parking_places_on_booked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_booked ON public.parking_places USING btree (booked);


--
-- Name: index_parking_places_on_can_book; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_can_book ON public.parking_places USING btree (can_book);


--
-- Name: index_parking_places_on_changed_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_changed_state ON public.parking_places USING btree (changed_state);


--
-- Name: index_parking_places_on_connected; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_connected ON public.parking_places USING btree (connected);


--
-- Name: index_parking_places_on_coord; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_coord ON public.parking_places USING gist (coord);


--
-- Name: index_parking_places_on_for_disabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_for_disabled ON public.parking_places USING btree (for_disabled);


--
-- Name: index_parking_places_on_free; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_free ON public.parking_places USING btree (free);


--
-- Name: index_parking_places_on_parking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_parking_id ON public.parking_places USING btree (parking_id);


--
-- Name: index_parking_places_on_place_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_place_id ON public.parking_places USING btree (place_id);


--
-- Name: index_parking_places_on_place_id_and_sensor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_parking_places_on_place_id_and_sensor_id ON public.parking_places USING btree (place_id, sensor_id);


--
-- Name: index_parking_places_on_sensor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_sensor_id ON public.parking_places USING btree (sensor_id);


--
-- Name: index_parking_places_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_places_on_updated_at ON public.parking_places USING btree (updated_at);


--
-- Name: index_parking_states_on_parking_place_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parking_states_on_parking_place_id ON public.parking_states USING btree (parking_place_id);


--
-- Name: index_parkings_on_area; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parkings_on_area ON public.parkings USING gist (area);


--
-- Name: index_parkings_on_cost; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parkings_on_cost ON public.parkings USING btree (cost);


--
-- Name: index_parkings_on_end_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parkings_on_end_time ON public.parkings USING btree (end_time);


--
-- Name: index_parkings_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parkings_on_start_time ON public.parkings USING btree (start_time);


--
-- Name: index_parkings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parkings_on_user_id ON public.parkings USING btree (user_id);


--
-- Name: index_sensors_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sensors_on_user_id ON public.sensors USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: fk_rails_02ebe657e2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parking_places
    ADD CONSTRAINT fk_rails_02ebe657e2 FOREIGN KEY (sensor_id) REFERENCES public.sensors(id);


--
-- Name: fk_rails_06db3ee339; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensors
    ADD CONSTRAINT fk_rails_06db3ee339 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_2db515d6e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parking_places
    ADD CONSTRAINT fk_rails_2db515d6e8 FOREIGN KEY (parking_id) REFERENCES public.parkings(id);


--
-- Name: fk_rails_85c5a6cc67; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parking_states
    ADD CONSTRAINT fk_rails_85c5a6cc67 FOREIGN KEY (parking_place_id) REFERENCES public.parking_places(id);


--
-- Name: fk_rails_89c657275d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parkings
    ADD CONSTRAINT fk_rails_89c657275d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180216002008'),
('20180216002009'),
('20180222120630'),
('20180302102037'),
('20180304115555'),
('20180324084246');


