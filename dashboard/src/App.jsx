import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Reg from "./page/Reg";




function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Reg />} />
   
      </Routes>
    </BrowserRouter>
  );
}

export default App;
