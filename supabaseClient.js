// Importa a biblioteca Supabase (versão 2.x via CDN ESM)
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// Suas credenciais do Supabase
const SUPABASE_URL = "https://hvragkwwgqlhxqsrrdly.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2cmFna3d3Z3FsaHhxc3JyZGx5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwMjMyNjEsImV4cCI6MjA3MDU5OTI2MX0.yDBY2Kp0H71aJe8jRjwKAzLhqEghpCOZw3PsjXqvIP8";

// Cria e exporta a instância do Supabase
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
