import { create } from 'zustand'

type State = {
  isLogin: boolean;
  setIsLogin: (isLogin: boolean) => void; 

  isLoginForm: boolean; 
  setIsLoginForm: (isLoginForm: boolean) => void;
}

const useStore = create<State>((set) => ({
  isLogin: false,
  isLoginForm: true,
  
  setIsLogin: (isLogin: boolean) => set({ isLogin: isLogin }),
  setIsLoginForm: (isLoginForm: boolean) => set({ isLoginForm: isLoginForm }),
}))

export default useStore