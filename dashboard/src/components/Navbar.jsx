import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { MdStorage } from "react-icons/md";
import { FaSignOutAlt } from "react-icons/fa"; 


function Navbar() {
  const [showMenu, setShowMenu] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  
  return (
    <nav className="bg-gradient-to-r from-neutral-800 to-blue-800 text-white">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-10">
      <div className="flex justify-between h-16">
        <div className="flex-shrink-0 flex items-center">
          <Link to="/">
            <span className="ml-4 text-2xl font-normal text-white font-display m-2">
            Smart Locker  
            </span>
          </Link>
        </div>
        <div className="flex items-center justify-end sm:justify-center">
       

          <div className="flex items-center">


            <Link
              to="/"
              className="hidden sm:inline-block text-white hover:text-white px-3 py-2 rounded-md text-sm font-medium"
            >
              หน้าเเรก
            </Link>

         
 

            
            

          

           

           
           
          </div>

        

       
          
            <div className="sm:hidden flex">
              <button
                className="inline-flex items-center justify-center p-2 rounded-md text-white hover:text-white hover:bg-gradient-to-r from-blue-800 to-blue-700 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                aria-controls="mobile-menu"
                aria-expanded="false"
                onClick={() => setShowMenu(!showMenu)}
              >
                <svg
                  className={`${showMenu ? "hidden" : "block"} h-6 w-6`}
                  stroke="currentColor"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="2"
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                </svg>
                <svg
                  className={`${showMenu ? "block" : "hidden"} h-6 w-6`}
                  stroke="currentColor"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="2"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
   


      {showMenu && (
        <div className="sm:hidden">
          <div className="px-2 pt-2 pb-3">
            <Link
              to="/"
              className="block text-white hover:text-white px-3 py-2 rounded-md text-base font-medium"
            >
              หน้าเเรก
            </Link>
           

            
            
            
          </div>
        </div>
      )}
    </nav>
  );
}

export default Navbar;
