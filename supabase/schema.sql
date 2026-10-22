-- ============================================================
-- DoctorHub — Supabase PostgreSQL Migration v1.0
-- Run this in your Supabase Dashboard → SQL Editor
-- ============================================================

-- ─── Enable required extensions ──────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLE: profiles
-- Maps 1-to-1 with Supabase Auth users (auth.users)
-- ──────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id           UUID        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name         TEXT        NOT NULL DEFAULT '',
  email        TEXT        NOT NULL DEFAULT '',
  role         TEXT        NOT NULL DEFAULT 'doctor'
                           CHECK (role IN ('super_admin', 'doctor', 'clinic_manager')),
  avatar_url   TEXT,
  specialty    TEXT,
  clinic_id    UUID,
  last_login_at TIMESTAMPTZ,
  is_active    BOOLEAN     NOT NULL DEFAULT TRUE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ─── Enable RLS ───────────────────────────────────────────────────────────────
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Allow users to read their own profile
CREATE POLICY "profiles_select_own"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

-- Allow users to update their own profile (restricted columns)
CREATE POLICY "profiles_update_own"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Allow the trigger function (runs as owner) to insert a new profile on sign-up
CREATE POLICY "profiles_insert_own"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- super_admin can read all profiles
CREATE POLICY "profiles_select_admin"
  ON public.profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- ─── Auto-create profile on sign-up ──────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, email, name)
  VALUES (
    NEW.id,
    COALESCE(NEW.email, ''),
    COALESCE(NEW.raw_user_meta_data->>'name', SPLIT_PART(COALESCE(NEW.email, ''), '@', 1))
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLE: clinics
-- ──────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.clinics (
  id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  name                TEXT        NOT NULL,
  phone               TEXT        NOT NULL DEFAULT '',
  email               TEXT        NOT NULL DEFAULT '',
  address             TEXT        NOT NULL DEFAULT '',
  city                TEXT        NOT NULL DEFAULT '',
  governorate         TEXT        NOT NULL DEFAULT '',
  latitude            DOUBLE PRECISION DEFAULT 0,
  longitude           DOUBLE PRECISION DEFAULT 0,
  gallery_urls        TEXT[]      DEFAULT '{}',
  accepted_insurance  TEXT[]      DEFAULT '{}',
  working_hours       TEXT        NOT NULL DEFAULT '',
  total_doctors       INT         NOT NULL DEFAULT 0,
  rating              DOUBLE PRECISION NOT NULL DEFAULT 5.0,
  is_active           BOOLEAN     NOT NULL DEFAULT TRUE,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.clinics ENABLE ROW LEVEL SECURITY;

-- Anyone authenticated can view clinics
CREATE POLICY "clinics_select_authenticated"
  ON public.clinics FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Only super_admin or the clinic_manager for this clinic can modify
CREATE POLICY "clinics_insert_admin"
  ON public.clinics FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

CREATE POLICY "clinics_update_admin_or_manager"
  ON public.clinics FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND (p.role = 'super_admin' OR (p.role = 'clinic_manager' AND p.clinic_id = clinics.id))
    )
  );

CREATE POLICY "clinics_delete_admin"
  ON public.clinics FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLE: doctors
-- ──────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.doctors (
  id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  name                TEXT        NOT NULL,
  email               TEXT        NOT NULL DEFAULT '',
  phone               TEXT        NOT NULL DEFAULT '',
  specialty           TEXT        NOT NULL DEFAULT '',
  clinic_name         TEXT        NOT NULL DEFAULT '',
  clinic_id           UUID        REFERENCES public.clinics(id) ON DELETE SET NULL,
  rating              DOUBLE PRECISION NOT NULL DEFAULT 5.0,
  total_patients      INT         NOT NULL DEFAULT 0,
  years_of_experience INT         NOT NULL DEFAULT 0,
  bio                 TEXT        NOT NULL DEFAULT '',
  is_available        BOOLEAN     NOT NULL DEFAULT TRUE,
  working_hours       JSONB       DEFAULT '[]',
  avatar_url          TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;

-- Authenticated users can view doctors
CREATE POLICY "doctors_select_authenticated"
  ON public.doctors FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Only super_admin can insert/delete doctors
CREATE POLICY "doctors_insert_admin"
  ON public.doctors FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- Doctor can update own record, admins can update all
CREATE POLICY "doctors_update_own_or_admin"
  ON public.doctors FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND (p.role = 'super_admin' OR p.email = doctors.email)
    )
  );

CREATE POLICY "doctors_delete_admin"
  ON public.doctors FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLE: patients
-- ──────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.patients (
  id                UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  name              TEXT        NOT NULL,
  email             TEXT        NOT NULL DEFAULT '',
  phone             TEXT        NOT NULL DEFAULT '',
  age               INT         NOT NULL DEFAULT 0,
  gender            TEXT        NOT NULL DEFAULT 'Other',
  blood_group       TEXT        NOT NULL DEFAULT 'O+',
  emergency_contact JSONB       DEFAULT '{}',
  medical_history   TEXT        NOT NULL DEFAULT '',
  allergies         TEXT        NOT NULL DEFAULT '',
  registered_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;

-- Doctors and admins can view patients
CREATE POLICY "patients_select_staff"
  ON public.patients FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor', 'clinic_manager')
    )
  );

-- Doctors and admins can create/update patients
CREATE POLICY "patients_insert_staff"
  ON public.patients FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor')
    )
  );

CREATE POLICY "patients_update_staff"
  ON public.patients FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor')
    )
  );

CREATE POLICY "patients_delete_admin"
  ON public.patients FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLE: appointments
-- ──────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.appointments (
  id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id    UUID        REFERENCES public.patients(id) ON DELETE SET NULL,
  patient_name  TEXT        NOT NULL DEFAULT '',
  doctor_id     UUID        REFERENCES public.doctors(id) ON DELETE SET NULL,
  doctor_name   TEXT        NOT NULL DEFAULT '',
  specialty     TEXT        NOT NULL DEFAULT '',
  clinic_name   TEXT        NOT NULL DEFAULT '',
  date_time     TIMESTAMPTZ NOT NULL,
  status        TEXT        NOT NULL DEFAULT 'pending'
                            CHECK (status IN ('upcoming', 'pending', 'completed', 'cancelled', 'noShow')),
  reason        TEXT        NOT NULL DEFAULT '',
  notes         TEXT        NOT NULL DEFAULT '',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

-- Doctors and admins can view all appointments; patients see their own
CREATE POLICY "appointments_select_staff"
  ON public.appointments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor', 'clinic_manager')
    )
  );

CREATE POLICY "appointments_insert_staff"
  ON public.appointments FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor', 'clinic_manager')
    )
  );

CREATE POLICY "appointments_update_staff"
  ON public.appointments FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor', 'clinic_manager')
    )
  );

CREATE POLICY "appointments_delete_admin"
  ON public.appointments FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLE: medical_records
-- ──────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.medical_records (
  id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id    UUID        NOT NULL REFERENCES public.patients(id) ON DELETE CASCADE,
  patient_name  TEXT        NOT NULL DEFAULT '',
  doctor_id     UUID        REFERENCES public.doctors(id) ON DELETE SET NULL,
  doctor_name   TEXT        NOT NULL DEFAULT '',
  clinic_name   TEXT        NOT NULL DEFAULT '',
  date          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  type          TEXT        NOT NULL DEFAULT '',
  diagnoses     TEXT,
  symptoms      TEXT,
  treatments    TEXT,
  lab_results   TEXT,
  radiology     TEXT,
  doctor_notes  TEXT,
  attachments   TEXT[]      DEFAULT '{}',
  follow_up_date TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.medical_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "medical_records_select_staff"
  ON public.medical_records FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor', 'clinic_manager')
    )
  );

CREATE POLICY "medical_records_insert_doctor"
  ON public.medical_records FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor')
    )
  );

CREATE POLICY "medical_records_update_doctor"
  ON public.medical_records FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor')
    )
  );

CREATE POLICY "medical_records_delete_admin"
  ON public.medical_records FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLE: prescriptions
-- ──────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.prescriptions (
  id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id   UUID        NOT NULL REFERENCES public.patients(id) ON DELETE CASCADE,
  patient_name TEXT        NOT NULL DEFAULT '',
  doctor_id    UUID        REFERENCES public.doctors(id) ON DELETE SET NULL,
  doctor_name  TEXT        NOT NULL DEFAULT '',
  date         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  status       TEXT        NOT NULL DEFAULT 'active'
               CHECK (status IN ('active', 'completed', 'cancelled')),
  medicines    JSONB       NOT NULL DEFAULT '[]',
  notes        TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.prescriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "prescriptions_select_staff"
  ON public.prescriptions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor', 'clinic_manager')
    )
  );

CREATE POLICY "prescriptions_insert_doctor"
  ON public.prescriptions FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor')
    )
  );

CREATE POLICY "prescriptions_update_doctor"
  ON public.prescriptions FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor')
    )
  );

CREATE POLICY "prescriptions_delete_admin"
  ON public.prescriptions FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLE: reviews
-- ──────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.reviews (
  id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  target_id    UUID        NOT NULL,
  target_name  TEXT        NOT NULL DEFAULT '',
  target_type  TEXT        NOT NULL DEFAULT 'doctor'
               CHECK (target_type IN ('doctor', 'clinic')),
  author_name  TEXT        NOT NULL DEFAULT '',
  author_avatar TEXT       NOT NULL DEFAULT '',
  rating       DOUBLE PRECISION NOT NULL DEFAULT 5.0
               CHECK (rating >= 1.0 AND rating <= 5.0),
  comment      TEXT        NOT NULL DEFAULT '',
  reply        TEXT,
  date         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

-- All authenticated users can read reviews
CREATE POLICY "reviews_select_authenticated"
  ON public.reviews FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Admins can manage reviews
CREATE POLICY "reviews_insert_admin"
  ON public.reviews FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

CREATE POLICY "reviews_update_admin"
  ON public.reviews FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLE: notifications
-- ──────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.notifications (
  id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  title           TEXT        NOT NULL,
  body            TEXT        NOT NULL,
  type            TEXT        NOT NULL DEFAULT 'info'
                  CHECK (type IN ('info', 'warning', 'success', 'alert')),
  target_audience TEXT        NOT NULL DEFAULT 'all'
                  CHECK (target_audience IN ('all', 'doctors', 'patients', 'clinicManagers')),
  is_read         BOOLEAN     NOT NULL DEFAULT FALSE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- All authenticated users can see notifications
CREATE POLICY "notifications_select_authenticated"
  ON public.notifications FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Only admins can create notifications
CREATE POLICY "notifications_insert_admin"
  ON public.notifications FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

CREATE POLICY "notifications_update_admin"
  ON public.notifications FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

CREATE POLICY "notifications_delete_admin"
  ON public.notifications FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid() AND p.role = 'super_admin'
    )
  );

-- ──────────────────────────────────────────────────────────────────────────────
-- STORAGE BUCKETS
-- Run these individually from the Supabase Storage UI or SQL:
-- ──────────────────────────────────────────────────────────────────────────────

-- Public bucket for profile/doctor avatars
INSERT INTO storage.buckets (id, name, public)
VALUES ('doctorhub-avatars', 'doctorhub-avatars', TRUE)
ON CONFLICT DO NOTHING;

-- Public bucket for clinic gallery images
INSERT INTO storage.buckets (id, name, public)
VALUES ('doctorhub-clinic-galleries', 'doctorhub-clinic-galleries', TRUE)
ON CONFLICT DO NOTHING;

-- Private bucket for patient documents
INSERT INTO storage.buckets (id, name, public)
VALUES ('doctorhub-documents', 'doctorhub-documents', FALSE)
ON CONFLICT DO NOTHING;

-- Storage policies: avatars (public read, authenticated write own folder)
CREATE POLICY "avatars_public_read"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'doctorhub-avatars');

CREATE POLICY "avatars_upload_own"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'doctorhub-avatars'
    AND auth.uid()::TEXT = (SPLIT_PART(name, '/', 1))
  );

CREATE POLICY "avatars_update_own"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'doctorhub-avatars'
    AND auth.uid()::TEXT = (SPLIT_PART(name, '/', 1))
  );

-- Storage policies: documents (only staff)
CREATE POLICY "documents_select_staff"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'doctorhub-documents'
    AND EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor', 'clinic_manager')
    )
  );

CREATE POLICY "documents_insert_staff"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'doctorhub-documents'
    AND EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('super_admin', 'doctor')
    )
  );
