// supabase.js
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

export const SUPABASE_URL = 'https://hvragkwwgqlhxqsrrdly.supabase.co';
export const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2cmFna3d3Z3FsaHhxc3JyZGx5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwMjMyNjEsImV4cCI6MjA3MDU5OTI2MX0.yDBY2Kp0H71aJe8jRjwKAzLhqEghpCOZw3PsjXqvIP8';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Utility: get current authenticated user
export async function getCurrentUser() {
  const { data } = await supabase.auth.getUser();
  return data.user;
}
