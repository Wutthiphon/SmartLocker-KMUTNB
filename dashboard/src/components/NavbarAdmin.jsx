import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { FaSignOutAlt } from "react-icons/fa"; 
import Swal from "sweetalert2";
import cookie from "js-cookie";




function Navbar() {
   const [showMenu, setShowMenu] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [userName, setUserName] = useState("");

  const handleLogout = async () => {
    const result = await Swal.fire({
      title: "คุณต้องการออกจากระบบใช่หรือไม่?",
      icon: "question",
      showCancelButton: true,
      confirmButtonText: "ใช่",
      cancelButtonText: "ไม่",
    });

    if (result.isConfirmed) {
      Swal.fire({
        title: "กำลังออกจากระบบ...",
        allowOutsideClick: false,
        didOpen: () => Swal.showLoading(),
      });

      try {
        const response = await fetch("https://ssn-api-vpqc.onrender.com/api/auth/logout", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-access-token": `Bearer ${cookie.get("accessToken")}`,
          },
        });

        if (response.ok) {
          cookie.remove("accessToken");
          cookie.remove("userName");
          setIsLoggedIn(false);
          setUserName("");
          window.location.href = "/login";
        } else {
          const errorData = await response.json();
          console.error("Logout error:", errorData);

          Swal.fire({
            icon: "error",
            title: "เกิดข้อผิดพลาด",
            text: "ไม่สามารถออกจากระบบได้",
          });
        }
      } catch (error) {
        console.error("Error during logout:", error);
        Swal.fire({
          icon: "error",
          title: "เกิดข้อผิดพลาด",
          text: "ไม่สามารถติดต่อกับเซิร์ฟเวอร์ได้",
        });
      }
    }
  };
  
  return (
    <nav className="bg-gradient-to-r from-neutral-800 to-orange-800 text-white">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-10">
      <div className="flex justify-between h-16">
        <div className="flex-shrink-0 flex items-center">
          <Link to="#">
            <span className="ml-4 text-xl font-normal text-white font-display m-2">
            ชมรมอีสาน มจพ.
            </span>
          </Link>
        </div>
        <div className="flex items-center justify-end sm:justify-center">
         

          <div className="flex items-center">


            <Link
              to="/page/Dashboard"
              className="hidden sm:inline-block text-white hover:text-white px-3 py-2 rounded-md text-sm font-medium"
            >
              หน้าเเรก
            </Link>

             <Link
               to = "/page/EventMap"
               className="hidden sm:inline-block text-white hover:text-white px-3 py-2 rounded-md text-sm font-medium"
              >
                ลงทะเบียนเข้าร่วมงาน
              </Link>

              <Link
                to = "/page/TicketSales"
                className="hidden sm:inline-block text-white hover:text-white px-3 py-2 rounded-md text-sm font-medium"
              >
               ขายพาข้าว
              </Link>

              <Link
                to = "/page/Ticket/admin"
                className="hidden sm:inline-block text-white hover:text-white px-3 py-2 rounded-md text-sm font-medium"
              >
                 บัตรบุคคลธรรมดา
              </Link>

              <Link
                to = "/admin/page/Ticket"
                className="hidden sm:inline-block text-white hover:text-white px-3 py-2 rounded-md text-sm font-medium"
              >
                 ผังงาน
              </Link>



            <button
                onClick={handleLogout}
                className="ml-4 text-white hover:text-white px-3 py-2 rounded-md text-sm font-medium"
              >
                <FaSignOutAlt className="inline-block ml-1 -mt-1" /> ออกจากระบบ
              </button>
 

           

           

           
           
          </div>

        

       
          
            <div className="sm:hidden flex">
              <button
                className="inline-flex items-center justify-center p-2 rounded-md text-white hover:text-white hover:bg-gradient-to-r from-orange-800 to-orange-700 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
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
              to="/page/Dashboard"
              className="block text-white hover:text-white px-3 py-2 rounded-md text-base font-medium"
            >
              หน้าเเรก
            </Link>
            <Link
              to="/page/EventMap"
              className="block text-white hover:text-white px-3 py-2 rounded-md text-base font-medium"
            >
              Check In
            </Link>

             
             <button
                  onClick={handleLogout}
                  className="block text-white hover:text-white px-3 py-2 rounded-md text-base font-medium"
               >
                  <FaSignOutAlt className="inline-block ml-1 -mt-1" /> ออกจากระบบ
               </button>


          
          
            
            
          </div>
        </div>
      )}
    </nav>
  );
}

export default Navbar;