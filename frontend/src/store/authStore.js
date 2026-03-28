import { create } from 'zustand';
import { getSession, getProfile, onAuthStateChange, signOut as supabaseSignOut } from '../services/supabase';

export const useAuthStore = create((set, get) => ({
  user: null,
  profile: null,
  loading: true,
  initialized: false,

  setUser: (user) => set({ user }),
  setProfile: (profile) => set({ profile }),
  setLoading: (loading) => set({ loading }),
  setDemoUser: () => {
    const mockUser = { id: '00000000-0000-0000-0000-000000000001', email: 'demo@learninghub.app' };
    const mockProfile = { id: mockUser.id, full_name: 'Demo User', role: 'learner', avatar_url: null };
    set({ user: mockUser, profile: mockProfile });
  },

  initialize: async () => {
    set({ loading: true });
    try {
      const { data: { session } } = await getSession();
      if (session?.user) {
        set({ user: session.user });
        const { data: profile } = await getProfile(session.user.id);
        set({ profile });
      } else {
        set({ user: null, profile: null });
      }
    } catch (err) {
      console.error('Auth init error:', err);
    } finally {
      set({ loading: false, initialized: true });
    }

    // Listen for auth changes
    onAuthStateChange(async (_event, session) => {
      if (session?.user) {
        set({ user: session.user });
        const { data: profile } = await getProfile(session.user.id);
        set({ profile, loading: false, initialized: true });
      } else {
        // Only clear if not demo mode
        const currentUser = get().user;
        if (currentUser?.id !== '00000000-0000-0000-0000-000000000001') {
          set({ user: null, profile: null, loading: false, initialized: true });
        }
      }
    });
  },

  logout: async () => {
    await supabaseSignOut();
    set({ user: null, profile: null });
  },
}));
