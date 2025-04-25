import React, {createContext, useState, useEffect, ReactNode} from 'react';
import {useNavigate} from 'react-router-dom';
import {NoConnection} from "../screens/No_Connection/no_connection";
import Loader from "../components/loader/loader";
import Links from "../utils/links";

interface AuthContextType {
  user: any;  // Adjust 'any' to your user type if known
  accessToken: string | null;
  loginUser: (phone: string, password: string) => Promise<boolean | string>;
  logOutUser: () => void;
  registerUser: (e: React.FormEvent) => Promise<any>;
  purchasePlan: (e: React.MouseEvent, uuid: string) => Promise<any>;
}

let defaultContext: AuthContextType = {
  user: null,
  accessToken: null,
  loginUser: async (phone: string, password: string) => {
    return ""
  },
  logOutUser: () => {
  },
  registerUser: async (e: React.FormEvent) => {
  },
  purchasePlan: async (e: React.MouseEvent, uuid: string) => {
  },

}

const AuthContext = createContext<AuthContextType>(defaultContext);

export default AuthContext;

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({children}): JSX.Element => {
  const [user, setUser] = useState<any>(null);  // Adjust 'any' to your user type if known
  const [isLoading, setIsLoading] = useState(true);
  const [accessToken, setAccessToken] = useState<string | null>(localStorage.getItem('accessToken'));
  const [refreshToken, setRefreshToken] = useState<string | null>(localStorage.getItem('refreshToken'));
  const history = useNavigate();

  useEffect(() => {
    if (refreshToken) {
      refreshAccessToken();
    } else {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    if (accessToken && refreshToken) {
      localStorage.setItem('accessToken', accessToken);
      localStorage.setItem('refreshToken', refreshToken);
    }
    const interval = setInterval(async () => {
      if (user && accessToken) {
        await refreshAccessToken();
      }
    }, 240000); // 4 minutes

    return () => clearInterval(interval);
  }, [accessToken, refreshToken]);

  const fetchUserDetails = async (token: string): Promise<void> => {
    try {
      const response = await fetch(`${Links.server}/details`, {
        method: 'GET',
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      if (response.ok) {
        const userData = await response.json();
        setUser(userData);
        setIsLoading(false);
      } else {
        console.error('Failed to fetch user details');
      }
    } catch (error) {
      console.error('Error fetching user details:', error);
    }
  };

  const login = async (phone: string, password: string): Promise<boolean | string> => {
    let response = await fetch(`${Links.server}/token/`, {
      method: "POST",
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({"phone": phone, "password": password})
    });
    if (response.ok) {
      let responseBody = await response.json();
      localStorage.setItem('accessToken', responseBody.access);
      localStorage.setItem('refreshToken', responseBody.refresh);
      setAccessToken(responseBody.access);
      setRefreshToken(responseBody.refresh);
      fetchUserDetails(responseBody.access);
      history('/');
      return true;
    } else {
      return "اطلاعات صحیح نمیباشند!";
    }
  };

  const logout = (): void => {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    setAccessToken(null);
    setRefreshToken(null);
    setUser(null);
  };

  const refreshAccessToken = async (): Promise<void> => {
    try {
      const response = await fetch(`${Links.server}/token/refresh/`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({refresh: refreshToken}),
      });
      if (!response.ok) {
        console.log('Failed to refresh access token');
        logout();
        history('/login');
      } else {
        const data = await response.json();
        setAccessToken(data.access);
        setRefreshToken(data.refresh);
        await fetchUserDetails(data.access);
      }
    } catch (error) {
      console.error(error);
      setIsLoading(false);
      logout();
    }
  };

  const registerUser = async (e: React.FormEvent): Promise<any> => {
    e.preventDefault();
    let form = e.target as HTMLFormElement;
    let phone = form.phone.value;
    let password1 = form.password1.value;
    let password2 = form.password2.value;
    let response = await fetch(`${Links.server}/register`, {
      method: "POST",
      body: JSON.stringify({"phone": phone, "password1": password1, "password2": password2}),
      headers: {
        "Content-Type": 'application/json',
      }
    });
    if (response.ok) {
      let responseBody = await response.json();
      localStorage.setItem('accessToken', responseBody.access);
      localStorage.setItem('refreshToken', responseBody.refresh);
      setAccessToken(responseBody.access);
      setRefreshToken(responseBody.refresh);
      await fetchUserDetails(responseBody.access);
      history('/');
      return true;
    } else {
      return response.json();
    }
  };

  const purchasePlan = async (e: React.MouseEvent, uuid: string): Promise<any> => {
    e.preventDefault();
    let res = await fetch(`/plans/purchase/${uuid}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer ' + accessToken
      }
    });
    if (res.ok && accessToken != null) {
      await fetchUserDetails(accessToken);
      history('/');
      return true;
    } else {
      return res.json();
    }
  };

  let contextData = {
    user: user,
    accessToken: accessToken,
    loginUser: login,
    logOutUser: logout,
    registerUser: registerUser,
    purchasePlan: purchasePlan
  };

  return (
      <AuthContext.Provider value={contextData}>
        {isLoading ? <div className='main-loading'><Loader/></div> : children}
      </AuthContext.Provider>
  );
};