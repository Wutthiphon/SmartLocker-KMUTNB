import React, { useState, useEffect } from "react";
import { Navigate } from "react-router-dom";
import Cookies from "js-cookie";

const ProtectedRoute = ({ children }) => {
  const [loading, setLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = Cookies.get("accessToken");

      if (token) {
         setIsAuthenticated(true);
      }
      setLoading(false);



  }, []);

 

  return isAuthenticated ? children : loading ? null : <Navigate to="/login" />;
};

export default ProtectedRoute;
