-- Create tasks table
CREATE TABLE public.tasks (
    id uuid default gen_random_uuid() primary key,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    user_id uuid references auth.users(id) not null,
    title text not null,
    date text not null,
    completed boolean default false not null
);

-- Create course_materials table
CREATE TABLE public.course_materials (
    id uuid default gen_random_uuid() primary key,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    user_id uuid references auth.users(id) not null,
    title text not null,
    content text,
    subject text not null,
    file_url text
);

-- Create sessions_history table
CREATE TABLE public.sessions_history (
    id uuid default gen_random_uuid() primary key,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    user_id uuid references auth.users(id) not null,
    role text not null,
    class_code text not null
);

-- Set up Row Level Security (RLS)
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sessions_history ENABLE ROW LEVEL SECURITY;

-- Policies for tasks
CREATE POLICY "Users can manage their own tasks"
ON public.tasks FOR ALL
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Policies for course_materials
CREATE POLICY "Users can manage their own materials"
ON public.course_materials FOR ALL
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Policies for sessions_history
CREATE POLICY "Users can manage their own sessions"
ON public.sessions_history FOR ALL
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Create Storage Buckets
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true);
INSERT INTO storage.buckets (id, name, public) VALUES ('materials_files', 'materials_files', true);

-- Storage bucket policies (Avatars)
CREATE POLICY "Avatars are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

CREATE POLICY "Users can upload their own avatars"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'avatars' AND auth.role() = 'authenticated');

CREATE POLICY "Users can update their own avatars"
ON storage.objects FOR UPDATE
USING (bucket_id = 'avatars' AND auth.role() = 'authenticated');

CREATE POLICY "Users can delete their own avatars"
ON storage.objects FOR DELETE
USING (bucket_id = 'avatars' AND auth.role() = 'authenticated');

-- Storage bucket policies (Materials)
CREATE POLICY "Materials are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'materials_files');

CREATE POLICY "Users can upload their own materials"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'materials_files' AND auth.role() = 'authenticated');

CREATE POLICY "Users can update their own materials"
ON storage.objects FOR UPDATE
USING (bucket_id = 'materials_files' AND auth.role() = 'authenticated');

CREATE POLICY "Users can delete their own materials"
ON storage.objects FOR DELETE
USING (bucket_id = 'materials_files' AND auth.role() = 'authenticated');
