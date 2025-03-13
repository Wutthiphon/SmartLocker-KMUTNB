import React from "react";
import { useState } from "react";
import  Swal from "sweetalert2";
import Navbar from "../components/Navbar";
import Foot from "../components/Foot";
import { FaChair } from "react-icons/fa";
import { useEffect } from "react";
import { IoTicketOutline } from "react-icons/io5";

function Flowchart() {
   const [email, setEmail] = useState("");
   const [ticket, setTicket] = useState("");
   const [loading, setLoading] = useState(false);
   const [seats, setSeats] = useState([]);






   useEffect(() => {
       const fetchData = async () => {
         try {
           setLoading(true);
           Swal.fire({
             title: "กำลังโหลดข้อมูล",
             didOpen: () => Swal.showLoading(),
             allowOutsideClick: false,
           });
   
           const response = await fetch("https://52.62.242.78/api/eventmap", {
             method: "GET",
             headers: {
               "Content-Type": "application/json",
             },
           });
   
           if (!response.ok) {
             throw new Error(`HTTP Error: ${response.status}`);
           }
   
           const data = await response.json();
   
           data.sort((a, b) =>
             a.seat_number.localeCompare(b.seat_number, "en", { numeric: true })
           );
           setSeats(data);
   
           Swal.close();
         } catch (error) {
           Swal.fire({
             icon: "error",
             title: "ข้อผิดพลาด",
             text: error.message || "ไม่สามารถโหลดข้อมูลได้",
           });
         } finally {
           setLoading(false);
         }
       };
   
       fetchData();
     }, []);


  


  return (
    <div>
      <Navbar />
      <div className="bg-neutral-200 min-h-screen">
        <div className="py-10">
          <div className="container mx-auto px-4 sm:px-6 lg:px-10">
            <div className="bg-white p-6 rounded-lg shadow-lg">
              <div className="flex flex-col items-center">
                {/* Logo */}
                <img src="https://iili.io/2DAMRoJ.png" alt="logo" className="w-72 h-72"/>              {/* Event Title */}
                <div className="text-center text-lg text-orange-800 mt-4">
                  <h1 className="text-2xl font-bold mt-4">
                      ผังงานพาแลง ครั้งที่ 45
                  </h1>
                </div>

                {/* Event Description */}
                <div className="text-center text-lg text-gray-900 mt-4">
                  งานพาแลง ครั้งที่ 45 จัดโดยชมรมอีสาน
                  มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ
                </div>


                  
                          
                         
                            
                            <div className="flex flex-col items-end mb-4 sm:mb-6">
                              <span className="text-lg sm:text-xl font-semibold mb-2 sm:mb-4">
                                 วันที่ 22 กุมพาพันธ์ 2568
                              </span>
                              </div>
                
                
                
                            {loading ? (
                              <div className="flex justify-center items-center">
                                <div className="spinner-border text-primary" role="status">
                                  <span className="sr-only">Loading...</span>
                                </div>
                              </div>
                            ) : (
                              <div className="grid gap-2 sm:gap-5 grid-cols-4 sm:grid-cols-7">
                                {seats.map((seat) => (
                                <div
                                key={seat.seat_id}
                                className={`bg-white shadow-lg p-3 sm:p-4 rounded-lg w-16 h-16 sm:w-24 sm:h-24 flex flex-col items-center justify-center text-black font-bold border border-gray-300 ${
                                  seat.seat_status === "Available" ? "bg-green-100" : "bg-red-100"
                                }`}
                              >
                                    <FaChair className="text-lg sm:text-2xl mb-1" />
                                    <span>{seat.seat_number}</span>
                                    <span>
                                      {seat.seat_status === "approve" ? (
                                        <span className="text-green-500 text-xs">ซื้อเเล้ว</span>
                                      ) : (
                                        <span className="text-red-600 text-xs">ว่าง</span>
                                      )}
                                    </span>
                                  </div>
                                ))}
                              </div>
                            )}
                          

                

              

              </div> 
            </div>
          </div>
          <Foot />
        </div>
      </div>

    </div>
  );
}

export default Flowchart;

            
